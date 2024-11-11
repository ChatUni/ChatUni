import { makeApi } from './utils/http'
import { getIelts, getSAT, saveResult } from './utils/course'
import { score } from './utils/gemini'

export const handler = makeApi({
  db_handlers: {
    get: {
      ielts: q => getIelts(),
      sat: q => getSAT(),
    },
    post: {
      saveResult: (q, b) => saveResult(b.result),
    },
  },
  handlers: {
    get: {
      score: q => score(q.msg),
    },
  },
  nocache: true,
})
