import { makeApi } from './utils/http'
import { chat, initAI } from './utils/openai'
import { tutors } from './data/tutors'
import { getTutors, saveChatId } from './utils/tutor'

export const handler = makeApi({
  handlers: {
    get: {
      tutors: q => getTutors(),
      greeting: q => tutors.find(x => x.id == q.id).greetings,
    },
    post: {
      chat: (q, b) => chat(b.text),
      saveChatId: (q, b) => saveChatId(q.id, q.chatId),
    },
  },
  initAI,
  nocache: true,
})
