import { MongoClient } from 'mongodb'
import { tap } from './util'

let db = null

export const connectDB = async conn =>
  (!conn && db) ||
  (db = await MongoClient.connect(conn).then(x => x.db()))

export const connect = async dbName => {
  console.log(`Connect MongoDB ${process.env.DBCS}`)
  await connectDB(process.env.DBCS.replace('{db}', dbName))
}

export const count = doc => db.collection(doc).count()

export const get = doc =>
  db.collection(tap(doc)).find().project({ _id: 0 }).toArray()

export const getById = (doc, id) =>
  db.collection(doc).findOne({ id: +id }, { projection: { _id: 0 } })

export const maxId = doc =>
  db
    .collection(doc)
    .find()
    .project({ _id: 0, id: 1 })
    .sort({ id: -1 })
    .limit(1)
    .toArray()
    .then(r => (r.length > 0 ? r[0].id + 1 : 0))

// 0: prop ('$videos')
// 1: number
// 2: map ({ name: 'Fiona' })
// 3: projectMap ({ id: 1, name: 0, title: '$videos.title' })
// 4: compareMap ({ rank: -1 })
// 5: name (default to Stage name)
const Stages = {
  u: ['unwind', 0],
  l: ['limit', 1],
  k: ['skip', 1],
  m: ['match', 2],
  a: ['addFields', 2],
  r: ['sample', 2],
  p: ['project', 3],
  s: ['sort', 4],
  c: ['count', 5],
  f: ['lookup', 6],
}

const Ops = {
  in: v => v.split(';'),
  first: v => '$' + v,
  //gt: (v, k) => ['$' + k, +v],
  //lt: (v, k) => ['$' + k, +v],
}

const strNum = v => {
  if (!v) return ''
  if (v.length > 2 && v[0] === "'" && v[v.length - 1] === "'") return v.slice(1, -1)
  return isNaN(+v) ? v : +v
}

export const flat = async (doc, agg) => {
  // agg = 'm_id=1,code='123',firstName=in$Nan;Fiona,name=regex$fan&u_songs&p_id,name=0,img=movies.img&s_type,date=-1&r_size=20'
  console.log(agg)
  const liftUps = []
  const stages = !agg
    ? [{ $match: {} }]
    : agg.split('&').map(s => {
        const ss = s.split('_')
        const stage = ss[0]
        const props = ss.slice(1).join('_')
        const $stage = `$${Stages[stage][0]}`
        const type = Stages[stage][1]

        if (type === 0) return [{ [$stage]: `$${props}` }]
        if (type === 1) return [{ [$stage]: +props }]
        if (type === 2) {
          const ps = props.split(',').map(p => {
            let [k, v] = p.split('=')
            if (v.includes('$')) {
              // prop value contains operator
              const [op, opv] = v.split('$')
              return [k, { [`$${op}`]: strNum(Ops[op] ? Ops[op](opv, k) : opv) }]
            }
            if (v.includes('.')) {
              if (stage === 'a') liftUps.push(k)
              v = '$' + v
            }
            return [k, strNum(v)]
          }).filter(x => x)
          return ps.length > 0 ? [{ [$stage]: Object.fromEntries(ps) }] : []
        }
        if (type === 3 || type === 4) {
          const ps = props.split(',').map(p => {
            const isMinus = p.startsWith('-')
            const k = isMinus ? p.slice(1) : p
            const v = isMinus ? (type === 3 ? 0 : -1) : 1
            return [k, v]
          })
          if (type === 3 && liftUps.length > 0) liftUps.forEach(x => ps.push([x, 1]))
          return [{ [$stage]: Object.fromEntries(ps) }]
        }
        if (type === 5) return [{ [$stage]: props || stage }]
        if (type === 6) return props.split(',').reduce((p, c) => {
          const ps = c.split('|')
          const isCollection = ps[0].startsWith('+')
          const single = isCollection ? ps[0].slice(1) : ps[0]
          const plural = ps.length > 1 ? ps[1] : `${single}s`
          const prefix = p.length > 0 ? `${p[p.length - 3]['$lookup'].as}.` : ''
          return [
            ...p,
            { '$lookup': {
              from: plural,
              localField: isCollection ? 'id' : `${prefix}${single}_id`,
              foreignField: isCollection ? `${doc}_id` : 'id',
              as: isCollection ? plural : single
            }},
            isCollection ? null : { '$unwind': `$${single}` },
            { '$project': { [`${single}._id`]: 0 } }
          ].filter(x => x)
        }, [])
      }).flat().filter(x => x)
  stages.push({ '$project': { _id: 0 } })
  console.log(doc, stages)
  const r = await db.collection(doc).aggregate(stages).toArray()
  console.log(r.length)
  return r
}

export const add = (doc, obj) => db.collection(doc).insertMany(makeArray(obj))

export const replace = async (doc, obj, id = 'id') => {
  const list = makeArray(obj)

  if (id === 'id' && list.some(o => !o.id)) {
    const id1 = await maxId(doc)
    const id = Math.max(...list.map(o => o.id || 0), id1) + 1
    list.filter(o => !o.id).forEach((o, i) => (o.id = id + i))
  }

  await Promise.all(
    list.map(o => {
      delete o._id
      return db.collection(doc).replaceOne({ [id]: o[id] }, o, { upsert: true })
    })
  )

  return list
}

export const save = replace

export const addToList = (doc, id, list, obj) =>
  db.collection(doc).updateOne({ id: +id }, { $addToSet: { [list]: obj } })

export const replaceList = (doc, id, list, obj) =>
  db
    .collection(doc)
    .updateOne(
      { id: +id, [list + '.id']: obj.id },
      { $set: { [list + '.$']: obj } }
    )

export const update = (doc, obj) =>
  db.collection(tap(doc)).updateOne({ id: tap(obj.id) }, { $set: obj })

export const remove = (doc, id) => db.collection(doc).deleteOne({ id: +id })

export const removeAll = doc => db.collection(doc).deleteMany({})

const makeArray = x => (Array.isArray(x) ? x : [x])
