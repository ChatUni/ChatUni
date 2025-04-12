import { cdVersion, cdUploadFolder } from './utils/cloudinary'
import { makeApi } from './utils/http'
import { parseMD } from './utils/markdown'
import { parseTOEFL } from './utils/markdown_toefl'
import pusher from './utils/pusher'
import { get, count, flat, replace, update, getById, maxId, remove } from './utils/db'

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
      update: (q, b) => update(q.doc, b),
      parseMD: (q, b) => parseMD(b.file, q.returnType, q.save),
      parseTOEFL: (q, b) => parseTOEFL(b.file, q.returnType, q.save),
    },
    delete: {
      remove: (q, b) => remove(q.doc, q.id),
    },
  },
  handlers: {
    get: {
      cdVer: q => cdVersion(),
    },
    post: {
      pusher: (q, b) => pusher.trigger(q.channel, q.event, b),
      cdupload: (q, b) => cdUploadFolder(b.local, b.remote),
    },
  },
  nocache: true,
})
