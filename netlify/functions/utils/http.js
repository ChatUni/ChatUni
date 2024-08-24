import axios from 'axios'
import { tap } from './util'

const FUNC = '/.netlify/functions/'
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

const headers = nocache => ({
  'Access-Control-Allow-Credentials': true,
  'Access-Control-Allow-Headers':
    'Origin, X-Requested-With, Content-Type, Content-Length, Content-MD5, Accept, Accept-Version, Authorization, X-CSRF-Token, Date, X-Api-Version',
  'Access-Control-Allow-Methods':
    'GET,OPTIONS,POST,PUT,PATCH,DELETE,COPY,PURGE',
  'Access-Control-Allow-Origin': '*',
  'Cache-Control': nocache ? 'no-cahce' : 'max-age=31536000',
  'Content-Type': 'application/json',
})

export const res = (body, code, nocache) => ({
  statusCode: code || 200,
  headers: headers(nocache),
  body: JSON.stringify(body),
})

export const makeApi =
  ({ handlers, connectDB, initAI, nocache }) =>
  async (event, context) => {
    context.callbackWaitsForEmptyEventLoop = false
    const q = event.queryStringParameters
    const method = event.httpMethod.toLowerCase()
    const body = method === 'post' && tryc(() => JSON.parse(event.body))
    origin = event.rawUrl.slice(0, event.rawUrl.indexOf(FUNC) + FUNC.length)

    return tryc(
      async () => {
        initAI && (await initAI())
        const t = handlers[method]?.[q.type]
        if (!t) return res('', 404)
        if (q.params) q.params = JSON.parse(q.params)
        // const r = await t(q, body, event, Response)
        const r = await t(q, body, event)
        return res(r || 'done', 200, nocache)
      },
      e => res(e, 500)
    )
  }

const tryc = (func, err) => {
  try {
    return func()
  } catch (e) {
    console.error(e)
    return typeof err === 'function' ? err(e) : err
  }
}
