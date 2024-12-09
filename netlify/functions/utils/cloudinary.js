import fs from 'fs'
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

export const cdupload = (url, folder) =>
  cd.v2.uploader.upload(url, {
    asset_folder: folder,
    use_filename: true,
    unique_filename: false,
    overwrite: true,
  })

export const cdUploadFolder = async (local, remote) => {
  try {
    const fns = fs.readdirSync(local)
    for (let f of fns) {
      console.log(`${local}/${f}`)
      await cdupload(`${local}/${f}`, remote)
      console.log(f)
    }
    return 'done'
  } catch (e) {
    return e.message
  }
}