import cd from 'cloudinary'

cd.config({
  cloud_name: 'daqc8bim3',
  api_key: process.env.CLOUDINARY_KEY,
  api_secret: process.env.CLOUDINARY_SECRET,
})

export const cdList = () =>
  cd.v2.api
    .resources({ max_results: 500 })
    .then(r => sortWith([ascend(prop('public_id'))], r.resources))

export const cdVersion = () =>
  cd.v2.api
    .resources({ max_results: 500 })
    .then(r => sortWith([descend(prop('version'))], r.resources)[0].version)
