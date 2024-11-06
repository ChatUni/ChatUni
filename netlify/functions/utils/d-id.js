import { DB, get, patch, post } from './http'

const DID = 'https://api.d-id.com'
const headers = {
  Authorization: `Basic ${process.env.D_ID_API_KEY}`,
  'content-type': 'application/json'
}

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
  const tutors = await get(DB('doc', 'tutors'))
  const { agents } = await get(`${DID}/agents/me`, headers)
  for (t of tutors) {
    // await createAgent(t.name, t.gender == '男' ? 'en-US-RyanMultilingualNeural' : 'en-US-JennyMultilingualNeural', `${window.HOST}/icons/${t.id}.png`, t.system)
    // const { agents } = await get(`${DID}/agents/me`, headers)
    const agent = agents.find(x => x.preview_name == t.name)
    t.agentId = agent.id
    t.idleVideo = agent.presenter.idle_video
    t.stillImage = agent.presenter.source_url
    t.chatId = ''
    await post(DB('save', 'tutors'), t)
  }
}

export const updateAgent = async (id, { prompt, personality, skill, desc }) => {
  const tutors = await get(DB('doc', 'tutors'))
  const tutor = tutors.find((x) => x.id == id)
  if (!tutor) return 'Tutor not found'

  if (prompt) {
    const ep = `${DID}/agents/${tutor.agentId}`
    await patch(ep, {
      "llm": {
        "type": "openai",
        "provider": "openai",
        "model": "gpt-3.5-turbo-1106",
        "instructions": prompt
      },
    }, headers)
    tutor.system = prompt
  }

  if (personality) tutor.personality = personality
  if (skill) tutor.skill = skill
  if (desc) tutor.desc = desc

  await post(DB('save', 'tutors'), tutor)

  return tutor
}