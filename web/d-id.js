const DID_API = {
  "key": "bG42MTNAaG90bWFpbC5jb20:5a8ObzwG1FVRztJgOZ0XY",
  "url": "https://api.d-id.com",
  "service": "talks"
}
const ABLY_API_KEY = "dUneIQ.aARKiA:9HSmVmMZm4hOh7k97hOCJJQ2vJee3Ovg-GVPYnEX_Z0";

const RTCPeerConnection = (
  window.RTCPeerConnection ||
  window.webkitRTCPeerConnection ||
  window.mozRTCPeerConnection
).bind(window);

let peerConnection;
let streamId;
let sessionId;
let sessionClientAnswer;
let statsIntervalId;
let videoIsPlaying;
let lastBytesReceived;
let agentId;
let chatId;
let ably;
let channel;

const videoElement = document.getElementById('video-element');
videoElement.setAttribute('playsinline', '');
const textArea = document.getElementById("textArea");

async function createPeerConnection(offer, iceServers) {
  if (!peerConnection) {
    peerConnection = new RTCPeerConnection({ iceServers });
    peerConnection.addEventListener('icecandidate', onIceCandidate, true);
    peerConnection.addEventListener('track', onTrack, true);
  }

  await peerConnection.setRemoteDescription(offer);
  console.log('set remote sdp OK');

  const sessionClientAnswer = await peerConnection.createAnswer();
  console.log('create local sdp OK');

  await peerConnection.setLocalDescription(sessionClientAnswer);
  console.log('set local sdp OK');


  // Data Channel creation (for dispalying the Agent's responses as text)
  let dc = await peerConnection.createDataChannel("JanusDataChannel");
  dc.onopen = () => {
    console.log("datachannel open");
  };

  // Agent Text Responses - Decoding the responses, pasting to the HTML element
  dc.onmessage = (event) => {
    let msg = event.data
    let msgType = "chat/answer:"
    if (msg.includes(msgType)) {
      msg = decodeURIComponent(msg.replace(msgType, ""))
      console.log(msg)
      channel.publish('first', msg)
    }
  };

  dc.onclose = () => {
    console.log("datachannel close");
  };

  return sessionClientAnswer;
}
function onIceCandidate(event) {
  if (event.candidate) {
    const { candidate, sdpMid, sdpMLineIndex } = event.candidate;

    // WEBRTC API CALL 3 - Submit network information
    fetch(`${DID_API.url}/${DID_API.service}/streams/${streamId}/ice`, {
      method: 'POST',
      headers: {
        Authorization: `Basic ${DID_API.key}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        candidate,
        sdpMid,
        sdpMLineIndex,
        session_id: sessionId,
      }),
    });
  }
}
function onVideoStatusChange(videoIsPlaying, stream) {
  let status;
  if (videoIsPlaying) {
    status = 'streaming';

    const remoteStream = stream;
    setVideoElement(remoteStream);
  } else {
    status = 'empty';
    playIdleVideo();
  }
}
function onTrack(event) {
  if (!event.track) return;

  statsIntervalId = setInterval(async () => {
    const stats = await peerConnection.getStats(event.track);
    stats.forEach((report) => {
     if (report.type === 'inbound-rtp' && report.kind === 'video') {

        const videoStatusChanged = videoIsPlaying !== report.bytesReceived > lastBytesReceived;

        if (videoStatusChanged) {
          videoIsPlaying = report.bytesReceived > lastBytesReceived;
          onVideoStatusChange(videoIsPlaying, event.streams[0]);
        }
        lastBytesReceived = report.bytesReceived;
      }
    });
  }, 500);
}
function setVideoElement(stream) {
  if (!stream) return;
  // Add Animation Class
  videoElement.classList.add("animated")

  // Removing browsers' autoplay's 'Mute' Requirement
  videoElement.muted = false;

  videoElement.srcObject = stream;
  videoElement.loop = false;

  // Remove Animation Class after it's completed
  setTimeout(() => {
    videoElement.classList.remove("animated")
  }, 1000);

  // safari hotfix
  if (videoElement.paused) {
    videoElement
      .play()
      .then((_) => { })
      .catch((e) => { });
  }
}
function playIdleVideo() {
  // Add Animation Class
  videoElement.classList.toggle("animated")

  videoElement.srcObject = undefined;
  videoElement.src = "https://agents-results.d-id.com/google-oauth2|115115236146534848384/agt_JdGCtniN/idle_1721805182857.mp4"; // 'emma_idle.mp4';
  videoElement.loop = true;

  // Remove Animation Class after it's completed
  setTimeout(() => {
    videoElement.classList.remove("animated")
  }, 1000);
}
function stopAllStreams() {
  if (videoElement.srcObject) {
    console.log('stopping video streams');
    videoElement.srcObject.getTracks().forEach((track) => track.stop());
    videoElement.srcObject = null;
  }
}
function closePC(pc = peerConnection) {
  if (!pc) return;
  console.log('stopping peer connection');
  pc.close();
  pc.removeEventListener('icegatheringstatechange', onIceGatheringStateChange, true);
  pc.removeEventListener('icecandidate', onIceCandidate, true);
  pc.removeEventListener('iceconnectionstatechange', onIceConnectionStateChange, true);
  pc.removeEventListener('connectionstatechange', onConnectionStateChange, true);
  pc.removeEventListener('signalingstatechange', onSignalingStateChange, true);
  pc.removeEventListener('track', onTrack, true);
  clearInterval(statsIntervalId);
  iceGatheringStatusLabel.innerText = '';
  signalingStatusLabel.innerText = '';
  iceStatusLabel.innerText = '';
  peerStatusLabel.innerText = '';
  console.log('stopped peer connection');
  if (pc === peerConnection) {
    peerConnection = null;
  }
}
const maxRetryCount = 3;
const maxDelaySec = 4;
async function fetchWithRetries(url, options, retries = 1) {
  try {
    return await fetch(url, options);
  } catch (err) {
    if (retries <= maxRetryCount) {
      const delay = Math.min(Math.pow(2, retries) / 4 + Math.random(), maxDelaySec) * 1000;

      await new Promise((resolve) => setTimeout(resolve, delay));

      console.log(`Request failed, retrying ${retries}/${maxRetryCount}. Error ${err}`);
      return fetchWithRetries(url, options, retries + 1);
    } else {
      throw new Error(`Max retries exceeded. error: ${err}`);
    }
  }
}

const connect = async () => {
  if (agentId == "" || agentId === undefined) {
    return alert("1. Click on the 'Create new Agent with Knowledge' button\n2. Open the Console and wait for the process to complete\n3. Press on the 'Connect' button\n4. Type and send a message to the chat\nNOTE: You can store the created 'agentID' and 'chatId' variables at the bottom of the JS file for future chats")
  }

  if (peerConnection && peerConnection.connectionState === 'connected') {
    return;
  }
  stopAllStreams();
  closePC();

  // WEBRTC API CALL 1 - Create a new stream
  const sessionResponse = await fetchWithRetries(`${DID_API.url}/${DID_API.service}/streams`, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${DID_API.key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      "source_url": "https://create-images-results.d-id.com/google-oauth2|115115236146534848384/upl_HJNFFUCs2NaEGsfiZ1ecN/image.jpeg", // "https://create-images-results.d-id.com/DefaultPresenters/Emma_f/v1_image.jpeg"
    }),
  });


  const { id: newStreamId, offer, ice_servers: iceServers, session_id: newSessionId } = await sessionResponse.json();
  streamId = newStreamId;
  sessionId = newSessionId;
  try {
    sessionClientAnswer = await createPeerConnection(offer, iceServers);
  } catch (e) {
    console.log('error during streaming setup', e);
    stopAllStreams();
    closePC();
    return;
  }

  // WEBRTC API CALL 2 - Start a stream
  const sdpResponse = await fetch(`${DID_API.url}/${DID_API.service}/streams/${streamId}/sdp`, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${DID_API.key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      answer: sessionClientAnswer,
      session_id: sessionId,
    }),
  });
};

const sendToChat = async (msg) => {
  // connectionState not supported in firefox
  if (peerConnection?.signalingState === 'stable' || peerConnection?.iceConnectionState === 'connected') {

    // Agents Overview - Step 3: Send a Message to a Chat session - Send a message to a Chat
    const playResponse = await fetchWithRetries(`${DID_API.url}/agents/${agentId}/chat/${chatId}`, {
      method: 'POST',
      headers: {
        'Authorization': `Basic ${DID_API.key}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        "streamId": streamId,
        "sessionId": sessionId,
        "messages": [
          {
            "role": "user",
            "content": msg,
            "created_at": new Date().toString()
          }
        ]
      }),
    });
    const playResponseData = await playResponse.json();
    if (playResponse.status === 200 && playResponseData.chatMode === 'TextOnly') {
      console.log('User is out of credit, API only return text messages');
      console.log(playResponseData.result);
    }
  }
};

const destroy = async () => {
  await fetch(`${DID_API.url}/${DID_API.service}/streams/${streamId}`, {
    method: 'DELETE',
    headers: {
      Authorization: `Basic ${DID_API.key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ session_id: sessionId }),
  });

  stopAllStreams();
  closePC();
};

// Agents API Workflow
async function agentsAPIworkflow(isNewAgent) {
  agentIdLabel.innerHTML = `<span style='color:orange'>Processing...<style='color:orange'>`
  chatIdLabel.innerHTML = `<span style='color:orange'>Processing...<style='color:orange'>`
  axios.defaults.baseURL = `${DID_API.url}`;
  axios.defaults.headers.common['Authorization'] = `Basic ${DID_API.key}`
  axios.defaults.headers.common['content-type'] = 'application/json'

  // Retry Mechanism (Polling) for this demo only - Please use Webhooks in real life applications! 
  // as described in https://docs.d-id.com/reference/knowledge-overview#%EF%B8%8F-step-2-add-documents-to-the-knowledge-base
  async function retry(url, retries = 1) {
    const maxRetryCount = 5; // Maximum number of retries
    const maxDelaySec = 10; // Maximum delay in seconds
    try {
      let response = await axios.get(`${url}`)
      if (response.data.status == "done") {
        return console.log(response.data.id + ": " + response.data.status)
      }
      else {
        throw new Error("Status is not 'done'")
      }
    } catch (err) {
      if (retries <= maxRetryCount) {
        const delay = Math.min(Math.pow(2, retries) / 4 + Math.random(), maxDelaySec) * 1000;

        await new Promise((resolve) => setTimeout(resolve, delay));

        console.log(`Retrying ${retries}/${maxRetryCount}. ${err}`);
        return retry(url, retries + 1);
      } else {
        agentIdLabel.innerHTML = `<span style='color:red'>Failed</span>`
        chatIdLabel.innerHTML = `<span style='color:red'>Failed</span>`
        throw new Error(`Max retries exceeded. error: ${err}`);
      }
    }
  }

  if (isNewAgent) {
  // Knowledge Overview - Step 1: Create a new Knowledge Base
  // https://docs.d-id.com/reference/knowledge-overview#%EF%B8%8F-step-1-create-a-new-knowledge-base
  const createKnowledge = await axios.post('/knowledge',
    {
      name: "knowledge",
      description: "D-ID Agents API"
    })
  console.log("Create Knowledge:", createKnowledge.data)

  let knowledgeId = createKnowledge.data.id
  console.log("Knowledge ID: " + knowledgeId)

  // Knowledge Overview - Step 2: Add Documents to the Knowledge Base
  // https://docs.d-id.com/reference/knowledge-overview#%EF%B8%8F-step-2-add-documents-to-the-knowledge-base

  const createDocument = await axios.post(`/knowledge/${knowledgeId}/documents`,
    {
      "documentType": "pdf",
      "source_url": "https://d-id-public-bucket.s3.us-west-2.amazonaws.com/Prompt_engineering_Wikipedia.pdf",
      "title": "Prompt Engineering Wikipedia Page PDF",
    })
  console.log("Create Document: ", createDocument.data)

  // Split the # to use in documentID
  let documentId = createDocument.data.id
  let splitArr = documentId.split("#")
  documentId = splitArr[1]
  console.log("Document ID: " + documentId)


  // Knowledge Overview - Step 3: Retrieving the Document and Knowledge status
  // https://docs.d-id.com/reference/knowledge-overview#%EF%B8%8F-step-3-retrieving-the-document-and-knowledge-status
  await retry(`/knowledge/${knowledgeId}/documents/${documentId}`)
  await retry(`/knowledge/${knowledgeId}`)

  // Agents Overview - Step 1: Create an Agent
  // https://docs.d-id.com/reference/agents-overview#%EF%B8%8F-step-1-create-an-agent
  const createAgent = await axios.post('/agents',
    {
      "knowledge": {
        "provider": "pinecone",
        "embedder": {
          "provider": "pinecone",
          "model": "ada02"
        },
        "id": knowledgeId
      },
      "presenter": {
        "type": "talk",
        "voice": {
          "type": "microsoft",
          "voice_id": "en-US-JennyMultilingualV2Neural"
        },
        "thumbnail": "https://create-images-results.d-id.com/google-oauth2|115115236146534848384/upl_HJNFFUCs2NaEGsfiZ1ecN/thumbnail.jpeg", // "https://create-images-results.d-id.com/DefaultPresenters/Emma_f/v1_image.jpeg",
        "idle_video": "https://agents-results.d-id.com/google-oauth2|115115236146534848384/agt_JdGCtniN/idle_1721805182857.mp4",
        "source_url": "https://create-images-results.d-id.com/google-oauth2|115115236146534848384/upl_HJNFFUCs2NaEGsfiZ1ecN/image.jpeg", // "https://create-images-results.d-id.com/DefaultPresenters/Emma_f/v1_image.jpeg"
      },
      "llm": {
        "type": "openai",
        "provider": "openai",
        "model": "gpt-3.5-turbo-1106",
        "instructions": "Your name is Teacher, an AI designed to assist with information about Prompt Engineering and RAG"
      },
      "preview_name": "Teacher"
    }

  )
  console.log("Create Agent: ", createAgent.data)
  let agentId = createAgent.data.id
  console.log("Agent ID: " + agentId)
  }

  // Agents Overview - Step 2: Create a new Chat session with the Agent
  // https://docs.d-id.com/reference/agents-overview#%EF%B8%8F-step-2-create-a-new-chat-session-with-the-agent
  const createChat = await axios.post(`/agents/${agentId}/chat`)
  console.log("Create Chat: ", createChat.data)
  let chatId = createChat.data.id
  console.log("Chat ID: " + chatId)

  // Agents Overview - Step 3: Send a Message to a Chat session
  // https://docs.d-id.com/reference/agents-overview#%EF%B8%8F-step-3--send-a-message-to-a-chat-session
  // The WebRTC steps are called in the functions: 'connectButton.onclick', onIceCandidate(event), 'startButton.onclick'

  console.log("Create new Agent with Knowledge - DONE!\n Press on the 'Connect' button to proceed.\n Store the created 'agentID' and 'chatId' variables at the bottom of the JS file for future chats")
  agentIdLabel.innerHTML = agentId
  chatIdLabel.innerHTML = chatId
  return { agentId: agentId, chatId: chatId }

}

const createAgent = async () => {
  try{
    const agentsIds = {} = await agentsAPIworkflow(false)
    console.log(agentsIds)
    agentId = agentsIds.agentId
    chatId = agentsIds.chatId

    return
  }
  catch(err){
    agentIdLabel.innerHTML = `<span style='color:red'>Failed</span>`
    chatIdLabel.innerHTML = `<span style='color:red'>Failed</span>`
    throw new Error(err)
  }
}


// Paste Your Created Agent and Chat IDs Here:
agentId = "agt_JdGCtniN"
chatId = "cht_G2msCOgoba4UQDYHIAgFX"

const setupAbly = async () => {
  ably = new Ably.Realtime(ABLY_API_KEY);
  channel = ably.channels.get("did");
  await channel.attach();
  channel.subscribe("first", (msg) => {
    sendToChat(msg);
  })
}

window.onload = () => {
  connect();
  setupAbly();
}
