import cd from 'cloudinary'
import { orderBy } from 'lodash'

cd.config({
  cloud_name: 'daqc8bim3',
  api_key: process.env.CLOUDINARY_KEY,
  api_secret: process.env.CLOUDINARY_SECRET,
})

export const cdList = () =>
  cd.v2.api
    .resources({ max_results: 500 })
    .then(r => orderBy(r.resources, 'public_id'))

export const cdVersion = () =>
  cd.v2.api
    .resources({ max_results: 500 })
    .then(r => orderBy(r.resources, 'version', 'desc')[0].version)
