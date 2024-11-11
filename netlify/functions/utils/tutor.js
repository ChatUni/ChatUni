import { sortBy } from 'lodash'
import { get, getById, save } from './db'

export const getTutors = () => get('tutors').then(r => sortBy(r, [x => x.lang === 'English' ? 0 : 1, 'id']))

export const saveChatId = async (id, chatId) => {
  const tutor = await getById('tutors', id)
  tutor.chatId = chatId
  await save('tutors', tutor)
}