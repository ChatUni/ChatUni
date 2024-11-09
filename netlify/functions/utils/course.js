import { sortBy } from 'lodash'
import { DB, get, post } from './http'

export const getIelts = () => get(DB('doc', 'ielts')).then(r => sortBy(r, 'id'))
export const getSAT = () => get(DB('doc', 'sat')).then(r => sortBy(r, 'id'))

export const saveResult = async result => {
  if (!result.id) result.id = (await get(DB('maxId', 'result'))) + 1
  await post(DB('save', 'result'), result)
  return result
}
