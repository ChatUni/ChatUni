import axios from 'axios'
import busboy from 'busboy'
import { tap } from './util'

const FUNC = '/.netlify/functions/'
const CONTENT_TYPES = { json: 'application/json', html: 'text/html' }

let origin = ''

export const getOrigin = () => origin

export const PORT = process?.env.PORT || 3000
export const isDev =
  process?.env.NODE_ENV &&
  ['development', 'dev'].includes(process.env.NODE_ENV.toLowerCase())
export const isProd = process?.env.NODE_ENV
  ? true
  : ['production', 'prod'].includes(process.env.NODE_ENV.toLowerCase())
export const HOST = isDev ? `http://localhost:${PORT}/` : '/'
export const API = HOST + 'api/'
export const ADMIN = HOST + 'admin/'
export const DB  = db => (type, doc) => `https://sace-mongodb.netlify.app/.netlify/functions/api?type=${type}&db=${db}&doc=${doc}`
export const get = (url, headers) => axios.get(tap(url), { headers: headers || {}}).then(r => r.data)
export const post = (url, data, headers) => axios.post(tap(url), data, { headers: headers || {}}).then(r => r.data)
export const patch = (url, data, headers) => axios.patch(tap(url), data, { headers: headers || {}}).then(r => r.data)

const headers = (nocache, returnType = 'json') => ({
  'Access-Control-Allow-Credentials': true,
  'Access-Control-Allow-Headers':
    'Origin, X-Requested-With, Content-Type, Content-Length, Content-MD5, Accept, Accept-Version, Authorization, X-CSRF-Token, Date, X-Api-Version',
  'Access-Control-Allow-Methods':
    'GET,OPTIONS,POST,PUT,PATCH,DELETE,COPY,PURGE',
  'Access-Control-Allow-Origin': '*',
  'Cache-Control': nocache ? 'no-cahce' : 'max-age=31536000',
  'Content-Type': CONTENT_TYPES[returnType],
})

export const res = (body, code, nocache, returnType) => ({
  statusCode: code || 200,
  headers: headers(nocache, returnType),
  body: JSON.stringify(body),
})

export const makeApi =
  ({ handlers, connectDB, initAI, nocache }) =>
  async (event, context) => {
    context.callbackWaitsForEmptyEventLoop = false
    const q = event.queryStringParameters
    const method = event.httpMethod.toLowerCase()
    const isForm = (event.headers?.['content-type'] || '').includes('multipart/form-data')
    let body = method === 'post' && !isForm && tryc(() => JSON.parse(event.body))
    origin = event.rawUrl.slice(0, event.rawUrl.indexOf(FUNC) + FUNC.length)

    return tryc(
      async () => {
        initAI && (await initAI())
        const t = handlers[method]?.[q.type]
        if (!t) return res('', 404)
        if (q.params) q.params = JSON.parse(q.params)
        if (isForm) body = await parseForm(event)
        // const r = await t(q, body, event, Response)
        const r = await t(q, body, event)
        return res(r || 'done', 200, nocache, q.returnType)
      },
      e => res(e, 500)
    )
  }

export const parseForm = e => new Promise(res => {
  const fields = {}
  const bb = busboy({ headers: e.headers })

  bb.on('file', (name, file, info) => {
    const { filename, mimeType } = info;
    file.on('data', data => {
      fields[name] = {
        filename,
        type: mimeType,
        content: data,
      }
    })
  })

  bb.on("field", (k, v) => fields[k] = v)
  bb.on("close", () => res(fields))
  bb.end(Buffer.from(e.body, 'base64'))
})

const tryc = (func, err) => {
  try {
    return func()
  } catch (e) {
    console.error(e)
    return typeof err === 'function' ? err(e) : err
  }
}
