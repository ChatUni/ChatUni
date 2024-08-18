import { DB, get, post } from './http'

const DID = 'https://api.d-id.com'
const headers = {
  Authorization: `Basic ${process.env.D_ID_API_KEY}`,
  'content-type': 'application/json'
}
const db = DB('algo.ChatUni')

export const createAgent = (name, voice, img, desc) => post(`${DID}/agents`, {
  "presenter": {
    "type": "talk",
    "voice": {
      "type": "microsoft",
      "voice_id": voice
    },
    "thumbnail": img,
    "source_url": img,
  },
  "llm": {
    "type": "openai",
    "provider": "openai",
    "model": "gpt-3.5-turbo-1106",
    "instructions": desc
  },
  "preview_name": name
}, headers)

export const importAgent = async () => {
  const tutors = await get(db('doc', 'tutors'))
  const { agents } = await get(`${DID}/agents/me`, headers)
  for (t of tutors) {
    // await createAgent(t.name, t.gender == '男' ? 'en-US-RyanMultilingualNeural' : 'en-US-JennyMultilingualNeural', `https://chatuni.netlify.app/icons/${t.id}.png`, t.system)
    // const { agents } = await get(`${DID}/agents/me`, headers)
    const agent = agents.find(x => x.preview_name == t.name)
    t.agentId = agent.id
    t.idleVideo = agent.presenter.idle_video
    t.stillImage = agent.presenter.source_url
    t.chatId = ''
    await post(db('save', 'tutors'), t)
  }
}