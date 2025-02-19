import { makeApi } from './utils/http'
import { getIelts, getTOEFL, getSAT, getJLPT, getResults, saveResult } from './utils/course'
import { parseJLPT } from './utils/jlpt'
import { score, explain } from './utils/gemini'

export const handler = makeApi({
  db_handlers: {
    get: {
      ielts: q => getIelts(),
      toefl: q => getTOEFL(),
      sat: q => getSAT(),
      jlpt: q => getJLPT(),
      results: q => getResults(q.userId),
    },
    post: {
      saveResult: (q, b) => saveResult(b.result),
      parseJLPT: (q, b) => parseJLPT(b.url),
    },
  },
  handlers: {
    get: {
      score: q => score(q.msg),
    },
    post: {
      explain: (q, b) => explain(b.msg),
    }
  },
  nocache: true,
})
