import { DB, get, post } from './http'

const db = DB('algo.ChatUni')

export const getIelts = () => get(db('doc', 'ielts'))