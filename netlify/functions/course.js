import { makeApi } from './utils/http'
import { getIelts, getSAT } from './utils/course'

export const handler = makeApi({
  handlers: {
    get: {
      ielts: q => getIelts(),
      sat: q => getSAT(),
    },
  },
  nocache: true,
})
