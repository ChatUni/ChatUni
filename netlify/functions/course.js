import { makeApi } from './utils/http'
import { getIelts } from './utils/course'

export const handler = makeApi({
  handlers: {
    get: {
      ielts: q => getIelts(),
    },
  },
})
