import { sortBy, orderBy } from 'lodash'
import { get, maxId, replace } from './db'

export const getIelts = () => get('ielts').then(r => sortBy(r, 'id'))
export const getSAT = () => get('sat').then(r => sortBy(r, 'id'))
export const getResults = id => get('result').then(r => orderBy(r.filter(x => x.userId == id), 'id', 'desc'))

export const saveResult = async result => {
  if (!result.id) result.id = (await maxId('result')) + 1
  await replace('result', result)
  return result
}
