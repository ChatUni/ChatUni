import { DB, get, post } from './http'

const db = DB('algo.ChatUni')

export const getTutors = () => get(db('doc', 'tutors'))

export const saveChatId = async (id, chatId) => {
  const tutor = await get(`${db('getById', 'tutors')}&params={"id":${id}}`)
  tutor.chatId = chatId
  await post(db('save', 'tutors'), tutor)
}