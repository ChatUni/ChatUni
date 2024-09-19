import { remark } from 'remark'
import { tap } from './util'

const categories = ['LISTENING', 'READING', 'WRITING', 'SPEAKING']

let prevParagraph

export const parseMD = (file, returnType) => {
  const ast = remark.parse(file.content)
  const [p1, p2] = splitBy(ast.children, ['answer key'], { level: 1, keepFirst: true, ci: true })
  let tests = splitOnEvery(p1, 'Test ', { level: 1, start: true })
  const q = tests.map(parseTest)
  tests = splitOnEvery(p2, 'TEST ', { start: true })
  const a = tests.map(parseTestAnswer).filter(x => x.length > 0)
  attachAnswer(q, a)
  return returnType == 'html' ? visual(q) : q
}

const paragraph = (n, opt = {}) => {
  if (n.type == 'paragraph') {
    return n.children.map(x => paragraph(x, opt)).flat(Infinity).filter(x => x)
  } else if (n.type == 'heading') {
    return [`${opt.noStyle ? '' : `<h${n.depth}>`}${n.children[0].value}`]
  } else if (n.type == 'text') {
    return n.value.includes('\n') ? n.value.split('\n') : n.value
  } else if (n.type == 'break') {
    return null
  } else if (n.type == 'strong') {
    return `${opt.noStyle ? '' : `<b>`}${n.children[0].value}`
  } else if (n.type == 'emphasis') {
    return `${opt.noStyle ? '' : `<i>`}${n.children[0].value}`
  } else if (n.type == 'list') {
    return n.children.map(x => paragraph(x, { ...opt, ul: !n.ordered })).flat(Infinity).filter(x => x)
  } else if (n.type == 'listItem') {
    return n.children.map(x => paragraph(x, opt)).flat(Infinity).map(x => opt.ul ? `<ul>${x}` : x)
  } else if (n.type == 'image') {
    return `<img>${n.url}`
  } else {
    return []
  }
}

const matchHeading = (node, level) => (level ? [] : ['paragraph']).concat('heading').includes(node.type) && (!level || node.depth == level)

const matchText = (text, match, ci, exact, start) => {
  if (Array.isArray(text)) text = text.join('\n')
  const t = ci ? text.toLowerCase() : text
  const m = ci ? match.toLowerCase() : match
  return exact ? t == m : start ? t.startsWith(m) : t.includes(m)
}

const splitBy = (a, keys, { level, keepFirst, ci, exact, start } = {}) => {
  const ids = keys.map(k => a.findIndex(x => matchHeading(x, level) && matchText(paragraph(x, { noStyle: true }), k, ci, exact, start)))
  return splitAt(a, ids, keepFirst)
}

const splitOnEvery = (a, key, { level, keepFirst, ci, exact, start } = {}) => {
  const ids = a.map((x, i) => matchHeading(x, level) && matchText(paragraph(x, { noStyle: true }), key, ci, exact, start) ? i : -1)
    .filter(x => x > -1)
  return splitAt(a, ids, keepFirst)
}

const splitAt = (a, ids, keepFirst) => ids
  .concat(a.length)
  .reduce((p, c) => [...p, [p[p.length - 1][1], c]], [[0, 0]])
  .slice(keepFirst ? 1 : 2)
  .map(x => a.slice(x[0], x[1]))

const parseTest = a => {
  const [listen, read, write, speak] = splitBy(a, categories, { exact: true })
  const parts = splitOnEvery(listen, 'PART ', { start: true })
  return {
    listen: parts.map(parsePart)
  }
}

const parsePart = a => {
  const name = paragraph(a[0], { noStyle: true }).join(' ')
  const [from, to] = questionRange(name)
  let groups = splitOnEvery(a, 'Questions ', { start: true })
  if (groups.length == 0) groups = [a]
  return {
    name, from, to,
    groups: groups.map(parseGroup)
  }
}

const parseGroup = a => {
  const name = paragraph(a[0], { noStyle: true }).join(' ')
  const [from, to] = questionRange(name)
  return {
    name, from, to,
    paragraphs: a.slice(1).map(x => parseParagraph(x, from, to)).filter(x => x)
  }
}

const questionRange = t => {
  if (Array.isArray(t)) t = t.join('\n')
  let r = t.match(/Questions (\d+)[-–](\d+)/)
  if (!r) r = t.match(/Questions (\d+) and (\d+)/)
  return r ? [+r[1], +r[2]] : [0, 0]
}

const parseParagraph = (n, from, to) => {
  const target = { content: paragraph(n) }
  if (n.type == 'list') {
    if (!n.ordered) { // unordered list always belong to prev paragraph
      if (prevParagraph.type == 'choice') {
        prevParagraph.questions[0].choices = target.content
      } else if (prevParagraph.type == 'instruction') {
        prevParagraph.content = [prevParagraph.content, ...target.content].flat(Infinity)
        getNonOrderedListQuestions(prevParagraph.content, from, to, prevParagraph)
      }
      return null
    } else {
      getOrderedListQuestions(n, target)
    }
  } else {
    getNonOrderedListQuestions(target.content, from, to, target)
  }

  if (target.type == 'instruction' && /^(Test|TEST) \d$/.test(target.content)) return null
  if (!target.questions) delete target.questions
  
  prevParagraph = target
  return prevParagraph
}

const getFillQuestions = t => {
  if (Array.isArray(t)) t = t.join('\n')
  // const r = t.matchAll(/(\d+).*?[\._…]{6,}/g).toArray()
  const re = /(\d+).*?[\._…]{6,}/g
  const r = []
  let a
  while ((a = re.exec(t)) !== null) {
    r.push(a[1])
  }
  return r.length > 0 ? r.map(x => ({ number: +x[1] })) : null
}

const getOrderedListQuestions = (n, target) => {
  if (target.content.every(x => /[\._…]{6,}/.test(x))) {
    target.type = 'fill'
    target.questions = target.content.map((_, i) => ({ number: i + n.start }))
  } else {
    target.type = 'choice'
    target.questions = n.children.map((q, i) => ({
      number: i + n.start,
      subject: paragraph(q.children[0].children[0]),
      choices: q.children[0].children.slice(1).filter(c => c.type != 'break').map(paragraph).flat(Infinity)
    }))
  }
}

const getFirstChoiceInParagraph = t => {
  const n = t.findIndex(x => /^(<\w{1,2}>)*A\.? /.test(x))
  const b = t.length > 2 && n > -1 && t.slice(n)
    .map((x, i) => new RegExp(`^(<\\w{1,2}>)*${String.fromCharCode(65 + i)}\\.? `).test(x)).every(x => x)
  return b ? n : -1
}

const getNonOrderedListQuestions = (content, from, to, target) => {
  target.questions = getFillQuestions(content)
  if (target.questions) {
    target.type = 'fill'
  } else {
    const n = getFirstChoiceInParagraph(content)
    if (n > -1) {
      target.type = 'choice'
      const m = content[0].match(/^(<\w{1,2}>)*(\d+)( .+)?$/)
      target.questions = m ? [{
        number: +m[2],
        subject: content[n - 1],
        choices: content.slice(n)
      }] : // multi-choice
      [...Array(to - from + 1).keys()].map(i => ({ number: i + from }))
    }
  }
  if (!target.questions) target.type = 'instruction'
}

const parseTestAnswer = a => {
  const [listen, read] = splitBy(a, categories.slice(0, 2), { exact: true })
  const a1 = listen.filter(x => x.type == 'list' && x.ordered)
    .map(l => l.children.map((li, i) => ({
      number: l.start + i,
      answer: paragraph(li.children[0]).join('')
    })))
    .flat()
  const a2 = listen.filter(x => x.type == 'paragraph')
    .map(x => {
      const ms = paragraph(x, { noStyle: true }).map(y => y.match(/^(\d+) (.+)$/))
      return ms.every(y => y)
        ? ms.map(y => ({ number: y[1], answer: y[2] }))
        : null
    })
    .filter(x => x)
    .flat()
  return a1.concat(a2)
}

const attachAnswer = (q, a) => {
  q.forEach((t, i) => {
    const qs = t.listen.map(p => p.groups.map(g => g.paragraphs.map(x => x.questions).filter(x => x))).flat(Infinity)
    qs.forEach(q => {
      const m = a[i].find(x => x.number == q.number)
      if (m) q.answer = m.answer
    })
  })  
}

const styles = ['<b>', '<i>', '<ul>', '<img>', '<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<h6>']
const closeStyles = ['</b>', '</i>', '</ul>', '</img>', '</h1>', '</h2>', '</h3>', '</h4>', '</h5>', '</h6>']

const visual = q => q.map(vTest).join('<hr>')
const vTest = (t, i) => `<div><h1>Test ${i + 1}</h1>${vListen(t.listen)}</div>`
const vListen = (t, i) => `<div><h2>Listen</h2>${t.map(vPart).join('')}</div>`
const vPart = (t, i) => `<div><h3>${t.name}</h3>${t.groups.map(vGroup).join('')}</div>`
const vGroup = (t, i) => `<div><h4>Questions ${t.from} to ${t.to}</h4>${t.paragraphs.map(vParagraph).join('<br/>')}</div>`
const vParagraph = (t, i) => {
  if (t.type == 'instruction') return vContent(t)
  if (t.type == 'fill') return `${vContent(t)}<div>(${t.questions.map(q => q.answer).join()})</div>`
  if (t.type == 'choice') {
    const qs = t.questions.map(vChoiceQuestion).join('<br>')
    return t.questions.some(q => q.choices) ? qs : `${vContent(t)}<br/>${qs}`
  }
}

const vContent = t => t.content.map(x => `<div>${closeStyle(x)}</div>`).join('')
const vChoiceQuestion = q => `<div><b>${q.number}.</b> ${closeStyle(q.subject)}</div>${(q.choices || []).map(c => `<div>  ${closeStyle(c)}</div>`).join('')}<div>(${q.answer})</div>`

const closeStyle = t => {
  if (!t) return ''
  const n = styles.findIndex(x => t.startsWith(x))
  if (n == -1) return t
  const s1 = styles[n]
  const s2 = closeStyles[n]
  const remain = t.slice(s1.length)
  if (s1 == '<img>') return `<img src="${remain}">`
  return `${s1}${closeStyle(remain)}${s2}`
}