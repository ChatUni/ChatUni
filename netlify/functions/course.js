import { makeApi } from './utils/http'
import { getIelts, getSAT, saveResult } from './utils/course'
import { score } from './utils/gemini'

export const handler = makeApi({
  handlers: {
    get: {
      ielts: q => getIelts(),
      sat: q => getSAT(),
      score: q => score(q.msg),
    },
    post: {
      saveResult: (q, b) => saveResult(b.result),
    }
  },
  nocache: true,
})
