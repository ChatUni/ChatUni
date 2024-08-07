import axios from 'axios'
import { API, ADMIN } from './db'

const DB = 'algo.ChatUni'
const api = API(DB)
const admin = ADMIN(DB)

export const getTutors = () => axios.get(api('doc', 'tutors')).then(r => r.data)