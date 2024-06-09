import { makeApi } from './utils/http'
import { chat, initAI } from './utils/openai'
import { tutors } from './data/tutors'

export const handler = makeApi({
  handlers: {
    get: {
      tutors: q => tutors,
      greeting: q => tutors.find(x => x.id == q.id).greetings,
    },
    post: {
      chat: (q, b) => chat(b.text),
    },
  },
  initAI,
})
