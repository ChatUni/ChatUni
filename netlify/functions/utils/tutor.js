import { DB, get, post } from './http'
import { sortBy } from 'lodash'

export const getTutors = () => get(DB('doc', 'tutors')).then(r => sortBy(r, [x => x.lang === 'English' ? 0 : 1, 'id']))

export const saveChatId = async (id, chatId) => {
  const tutor = await get(`${DB('getById', 'tutors')}&params={"id":${id}}`)
  tutor.chatId = chatId
  await post(DB('save', 'tutors'), tutor)
}