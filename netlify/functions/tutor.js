import { makeApi } from './utils/http'
import { chat, initAI } from './utils/openai'
import { tutors } from './data/tutors'
import { getTutors, saveChatId } from './utils/tutor'
import { importAgent, updateAgent } from './utils/d-id'

export const handler = makeApi({
  handlers: {
    get: {
      tutors: q => getTutors(),
      greeting: q => tutors.find(x => x.id == q.id).greetings,
    },
    post: {
      chat: (q, b) => chat(b.text),
      saveChatId: (q, b) => saveChatId(q.id, q.chatId),
      importAgent: (q, b) => importAgent(),
      updateAgent: (q, b) => updateAgent(b.id, b),
    },
  },
  initAI,
  nocache: true,
})
