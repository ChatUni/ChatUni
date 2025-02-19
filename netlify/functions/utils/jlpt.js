import { DB, get, post } from './http'
import { remark } from 'remark'
import { range, splitWhen, tap } from './util'

const extract = (url, selectors) => fetch(
  `https://sace-mongodb.netlify.app/.netlify/functions/web?type=extractUrl&url=${url}&selectors=${encodeURIComponent(selectors)}`
).then(r => r.json())

export const parseJLPT = async url => {
  const [_, level, type, id] = url.match(/jlpt-n(\d)-(\w+)-exercise-(\d+)/)
  const test = { id: `N${level}${type[0].toUpperCase()}-${id}`, title: `N${level} ${type[0].toUpperCase()}${type.slice(1)} Test ${id}` }
  const isListen = type == 'listening'

  let ps = await extract(url, '.entry p@innerHTML')
  ps = ps.map(p => p.replace('<strong>', '').replace('</strong>', '').replace(/<input\b[^>]*>/g, ''))
  const ps1 = isListen ? await extract(url, '.entry!audio@src,p strong,img@src') : []
  const answerIdx = ps.findIndex(x => x === 'Answer Key:')
  const ans = ps[answerIdx + 1].matchAll(/(Question (\d+): (\d))/g)
  const answers = ans.toArray().map(x => x[3])
  let n = 0
  const pas = ps.slice(0, answerIdx).filter((p, i) => !isListen || i % 2 == 1).map((p, i) => {
    const ls = p.split('<br>')
    const m = isListen ? ps[i * 2].match(/^(\d+)\. (.+)/) : ls[0].match(/^(\d+)\. (.+[。？])/)
    const p1 = m
      ? {
        type: 'choice',
        content: [],
        questions: [{
          number: +m[1],
          subject: m[2],
          choices: ls.slice(isListen ? 0 : 1).map((x, i) => `${String.fromCharCode(i + 65)}. ${x.trim()}`),
          answer: String.fromCharCode(+answers[n++] + 64),
        }],
      }
      : {
        type: 'instruction',
        content: ls,
      }
    return isListen ? [{
      type: 'instruction',
      content: [
        `<mp3>N${level}L-${id}-${i+1}`,
        `<img>N${level}L-${id}-${i+1}`,
      ]}, p1] : [p1]
  }).flat()
  test.test = [{
    name: '',
    from: 0,
    to: 0,
    groups: [{
      name: '',
      from: 0,
      to: 0,
      paragraphs: pas,
    }],
  }]
  
  //await post(DB('update', 'jlpt'), test)
  return test
}