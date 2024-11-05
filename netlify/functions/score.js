import { makeApi } from './utils/http'
import { score } from './utils/gemini'

export const handler = makeApi({
  handlers: {
    get: {
      score: q => score(q.msg),
    },
  },
  nocache: true,
})
