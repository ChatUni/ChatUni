import { DB, get, post } from './http'

const DID = 'https://api.d-id.com'
const db = DB('algo.ChatUni')

export const createAgent = async (name, voice, img, desc) => {
  const tutor = await post(`${DID}/agents`, {
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
  })
  tutor.chatId = chatId
  await post(db('save', 'tutors'), tutor)
}