import { DB, get, post } from './http'
import { sortBy } from 'lodash'

const db = DB('algo.ChatUni')

export const getTutors = () => get(db('doc', 'tutors')).then(r => sortBy(r, [x => x.lang === 'English' ? 0 : 1, 'id']))

export const saveChatId = async (id, chatId) => {
  const tutor = await get(`${db('getById', 'tutors')}&params={"id":${id}}`)
  tutor.chatId = chatId
  await post(db('save', 'tutors'), tutor)
}