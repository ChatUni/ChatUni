import { makeApi } from './utils/http'
import { chat, initAI } from './utils/openai'

export const handler = makeApi({
  handlers: {
    post: {
      chat: (q, b) => chat(b.text),
    },
  },
  initAI,
})
