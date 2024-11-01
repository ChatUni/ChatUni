import { cdVersion } from './utils/cloudinary'
import { makeApi } from './utils/http'
import { parseMD } from './utils/markdown'
import pusher from './utils/pusher'

export const handler = makeApi({
  handlers: {
    get: {
      cdVer: q => cdVersion()
    },
    post: {
      pusher: (q, b) => pusher.trigger(q.channel, q.event, b),
      parseMD: (q, b) => parseMD(b.file, q.returnType, q.save),
    },
  },
})
