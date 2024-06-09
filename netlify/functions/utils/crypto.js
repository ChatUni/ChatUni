import crypto from 'crypto'

const CRYPTO_KEY = Buffer.from('vGdros11d7eJsFS5', 'utf8')
const CRYPTO_IV = Buffer.from('c3nPUzoa5LHyUBGI', 'utf8')

export const toBase64 = data =>
  data ? Buffer.from(data, 'utf-8').toString('base64') : ''

export const fromBase64 = data =>
  data ? Buffer.from(data, 'base64').toString('utf-8') : ''

const aes = (data, key, iv, isEncrypt) => {
  if (!data) return ''
  const [from, to] = isEncrypt ? ['utf8', 'hex'] : ['hex', 'utf8']
  const create = isEncrypt ? 'createCipheriv' : 'createDecipheriv'
  const cipher = crypto[create]('aes-128-cbc', key, iv)
  return `${cipher.update(data, from, to)}${cipher.final(to)}`
}

export const aesEncrypt = (data, key, iv) => aes(data, key, iv, true)

export const aesDecrypt = (data, key, iv) => aes(data, key, iv, false)

export const encrypt = (data, key = CRYPTO_KEY) =>
  aesEncrypt(data, key, CRYPTO_IV)

export const decrypt = (data, key = CRYPTO_KEY) =>
  aesDecrypt(data, key, CRYPTO_IV)
