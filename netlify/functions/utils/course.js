import { sortBy } from 'lodash'
import { DB, get, post } from './http'

export const getIelts = () => get(DB('doc', 'ielts')).then(r => sortBy(r, 'id'))
export const getSAT = () => get(DB('doc', 'sat')).then(r => sortBy(r, 'id'))
