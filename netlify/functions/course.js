import { makeApi } from './utils/http'
import { getIelts, getTOEFL, getSAT, getResults, saveResult } from './utils/course'
import { score } from './utils/gemini'

export const handler = makeApi({
  db_handlers: {
    get: {
      ielts: q => getIelts(),
      toefl: q => getTOEFL(),
      sat: q => getSAT(),
      results: q => getResults(q.userId),
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
