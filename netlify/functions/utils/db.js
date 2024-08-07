export const API  = db => (type, doc) => `https://sace-mongodb.netlify.app/.netlify/functions/api?type=${type}&db=${db}&doc=${doc}`

export const ADMIN  = db => (type, doc) => `https://sace-mongodb.netlify.app/.netlify/functions/admin?type=${type}&db=${db}&doc=${doc}`
