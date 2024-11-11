import { cdVersion } from './utils/cloudinary'
import { makeApi } from './utils/http'
import { parseMD } from './utils/markdown'
import pusher from './utils/pusher'
import { get, count, flat, replace, getById, maxId } from './utils/db'

export const handler = makeApi({
  db_handlers: {
    get: {
      doc: q => get(q.doc),
      count: q => count(q.doc),
      getById: q => getById(q.doc, q.id),
      flat: q => flat(q.doc, q.agg),
      maxId: q => maxId(q.doc),
    },
    post: {
      save: (q, b) => replace(q.doc, b, q.id), // q.id specify the identity field
      parseMD: (q, b) => parseMD(b.file, q.returnType, q.save),
    },
  },
  handlers: {
    get: {
      cdVer: q => cdVersion(),
    },
    post: {
      pusher: (q, b) => pusher.trigger(q.channel, q.event, b),
    },
  },
  nocache: true,
})
