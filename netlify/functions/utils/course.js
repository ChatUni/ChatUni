import { sortBy, orderBy } from 'lodash'
import { get, maxId, replace } from './db'

export const getIelts = () => get('ielts').then(r => orderBy(r, [x => x.id.split('-')[0], x => x.id.split('-')[1]], ['desc', 'asc']))
export const getSAT = () => get('sat').then(r => orderBy(r, 'id', 'desc'))
export const getResults = id => get('result').then(r => orderBy(r.filter(x => x.userId == id), 'id', 'desc'))

export const saveResult = async result => {
  if (!result.id) result.id = (await maxId('result')) + 1
  await replace('result', result)
  return result
}
