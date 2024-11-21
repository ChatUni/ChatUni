import { sortBy } from 'lodash'
import { get, getById, replace } from './db'

export const getTutors = () => get('tutors').then(r => sortBy(r, [
  x => x.id >= 1000 ? 0 : 1,
  x => x.lang === 'English' ? 0 : 1,
  'id'
]))

export const saveChatId = async (id, chatId) => {
  const tutor = await getById('tutors', id)
  tutor.chatId = chatId
  await replace('tutors', tutor)
}