import { makeApi } from './utils/http'
import pusher from './utils/pusher'

export const handler = makeApi({
  handlers: {
    post: {
      pusher: (q, b) => pusher.trigger(q.channel, q.event, b.msg),
    },
  },
})
