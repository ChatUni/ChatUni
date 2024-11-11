import { sortBy } from 'lodash'
import { get, maxId, replace } from './db'

export const getIelts = () => get('ielts').then(r => sortBy(r, 'id'))
export const getSAT = () => get('sat').then(r => sortBy(r, 'id'))

export const saveResult = async result => {
  if (!result.id) result.id = (await maxId('result')) + 1
  await replace('result', result)
  return result
}
