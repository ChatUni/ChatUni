import { DB, get, post } from './http'
import { remark } from 'remark'
import { range, splitWhen, tap } from './util'

const categories = {
  '听力文本': {
    title: 'listen',
    scripts: ['Listen to'],
    parts: ['C1', 'L1', 'L2', 'C2', 'L3'],
    keepScriptTitle: true,
   },
  '阅读': {
    title: 'read',
    parts: ['R1', 'R2', 'R3'],
  },
  '综合写作': {
    title: 'write',
    parts: ['Reading Passage:'],
    scripts: ['听力文本:'],
    questions: ['题目：', '独立写作：'],
  },
  '口语': {
    title: 'speak',
    parts: ['Task1', 'Task2', 'Task3', 'Task4'],
    scripts: ['听力文本：'],
    questions: ['题目：'],
  },
}
const fillPattern = /(\d{1,2}).*?[\._…]{6,}/g

let cat
let prevParagraph
let prevQuestions = []
let isScript = false

export const parseTOEFL = async (file, returnType, save) => {
  const ast = remark.parse(file.content)
  if (returnType == 'ast') return ast
  const ids = findId(ast.children)
  const j = parseTest(ast.children, ids)
  if (save === '1') await post(DB('update', 'toefl'), j)
  return j;
}

const findId = ns => {
  for (let i = 0; i < ns.length; i++) {
    const m = paragraph(ns[i]).join('').match(/TPO(\d{1,2})( .*)?$/)
    if (m) {
      cat = categories[m[2] ? m[2].trim() : paragraph(ns[i + 1]).join('')]
      return { id: m[1], cat: cat.title }
    }
  }
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
    //return n.children.map((x, i) => paragraph(x, { ...opt, ul: !n.ordered, idx: n.start ? n.start + i : 0 })).flat(Infinity).filter(x => x)
    return n.children.map((x, i) => paragraph(x, { ...opt, ul: !n.ordered })).flat(Infinity).filter(x => x)
  } else if (n.type == 'listItem') {
    return n.children.map(x => paragraph(x, opt)).flat(Infinity).map(x => opt.ul ? `<ul>${x}` : opt.idx ? `${opt.idx}. ${x}` : x)
  } else if (n.type == 'image') {
    return `<img>${n.url}`
  } else {
    return []
  }
}

const matchHeading = (node, level) => (level ? [] : ['paragraph']).concat('heading').includes(node.type) && (!level || node.depth == level)

const matchText = (text, match, ci, exact, start, firstLine) => {
  if (Array.isArray(text)) text = firstLine ? text[0] : text.join('\n')
  const t = ci ? text.toLowerCase() : text
  const m = ci ? match.toLowerCase() : match
  return exact ? t == m : start ? t.startsWith(m) : t.includes(m)
}

const splitBy = (a, keys, { level, keepFirst, ci, exact, start, firstLine } = {}) => {
  const ids = keys.map(k => a.findIndex(x => matchHeading(x, level) && matchText(paragraph(x, { noStyle: true }), k, ci, exact, start, firstLine)))
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

const parseTest = (a, ids) => {
  const ps = splitBy(a, cat.parts, { exact: true, keepFirst: false, firstLine: true })
  return {
    id: ids.id,
    [ids.cat]: ps.map((x, i) => parsePart(x, cat.parts[i])),
  }
}

const parsePart = (a, name) => ({
  name, from: 0, to: 0,
  groups: [parseGroup(a, name)]
})

const parseGroup = (a, partName) => {
  let paragraphs = a.map(x => parseParagraph(x, partName)).filter(x => x)
  paragraphs = fixSquareQuestion(paragraphs)
  fixSpeakQuestion(paragraphs)
  paragraphs = fixDuplicateTitle(paragraphs, partName)
  return { name: '', from: 1, to: 1, paragraphs }
}

const genFillQuestionsForImgOnly= (paragraphs, r) => {
  if (paragraphs.every(p => !p.questions) && paragraphs.some(p => p.content.some(c => c.startsWith('<img>')))) {
    paragraphs.push({
      content: r.map(x => `${x} ......`),
      questions: r.map(x => ({ number: x })),
      type: 'fill',
    })
  }
}

const genContainQuestions = paragraphs => {
  if (paragraphs.some(p => p.content.some(c => c.match(/^Write the correct letter, .+, in boxes .+ on your answer sheet.$/)))) {
    paragraphs.filter(x => x.type === 'choice').forEach(x => {
      x.type = 'instruction'
      delete x.questions
    })
    const mr = x => x.match(/^(\d{1,2}) +(.+)$/)
    paragraphs.forEach(p => {
      if (p.content.length === 1) {
        const m = mr(p.content[0])
        if (m) {
          const num = +m[1]
          p.content = [m[2], `${num} ......`]
          p.questions = [{ number: num }]
          p.type = 'fill'
        }
      } else if (p.content.length > 1) {
        const ms = p.content.map(mr)
        if (ms.every(x => x)) {
          p.content = ms.map(x => [x[2], `${+x[1]} ......`]).flat()
          p.questions = ms.map(x => ({ number: +x[1] }))
          p.type = 'fill'
        }
      }
    })
  }
}

const genSpeakQuestions = (paragraphs, pidx) => {
  let n = 0
  paragraphs.forEach(p => {
    const qs = p.content.filter(c => c.startsWith('<ul>'))
    if (qs.length > 0) {
      p.type = 'speak'
      p.questions = qs.map(q => ({ number: ++n, subject: removeStyle(q) }))
      if (pidx == 0) p.content = p.content.filter(c => !c.startsWith('<ul>'))
      if (pidx == 2) p.content = []
    }
  })
  return pidx == 0 ? paragraphs.filter((p, i) => p.type === 'speak' || i == 0) : paragraphs
}

const questionRange = t => {
  if (Array.isArray(t)) t = t.join('\n')
  let r = t.match(/Questions (\d+)[-–](\d+)/)
  if (!r) r = t.match(/Questions (\d+) and (\d+)/)
  return r ? [+r[1], +r[2]] : [0, 0]
}

const isChoiceText = x => x.match(/^[A-J]\. /)

const parseParagraph = (n, partName) => {
  const target = { type: isScript ? 'script' : 'instruction', content: paragraph(n) }
  const c0 = removeStyle(target.content?.[0] || '')

  if (target.content.every(isChoiceText) && prevParagraph) {
    prevParagraph.questions[0].choices.push(...target.content)
    return null
  }
  if (c0.startsWith('答案')) {
    prevQuestions.push(prevParagraph.questions[0])
    const s = c0.slice(3).replace(/ /g, '')
    const ans = []
    let n = 0
    for (let i = 0; i < s.length; i++) {
      if (s[i] == '(') {
        n = i + 1
      } else if (s[i] == ')') {
        ans.push(s.slice(n, i))
        n = 0
      } else if (n == 0) {
        ans.push(s[i])
      }
    }
    prevQuestions.forEach((q, i) => (q.answer = ans[i]))
    prevParagraph = null
    prevQuestions = []
    return null
  }
  if (cat.scripts?.some(x => c0.startsWith(x))) {
    isScript = true
    target.type = 'script'
    return cat.keepScriptTitle ? target : null
  }
  if (cat.questions) {
    const i = cat.questions.findIndex(q => c0.startsWith(q))
    if (i > -1) {
      isScript = false
      target.type = cat.title
      target.questions = [{ number: i + 1, subject: target.content.join(' ').slice(cat.questions[i].length) }]
      target.content = []
    }
  }
  if (n.type == 'list') {
    isScript = false
    if (n.ordered) {
      if (target.content.length == 1) {
        if (prevParagraph) prevQuestions.push(prevParagraph.questions[0])
        target.questions = [{ number: n.start, subject: target.content.join(' '), choices: [] }]
        prevParagraph = target
      } else {
        const qs = splitWhen(target.content, x => !isChoiceText(x))
        target.questions = tap(qs).map((q, i) => ({ number: n.start + i, subject: q[0], choices: q.slice(1) }))
      }
      target.type = 'choice'
      target.content = []
    }
  }

  return target
}

const mergeContent = c => {
  const nl = [' ', ',']
  const l = []
  let s = -1
  for (let i = 0; i < c.length; i++) {
    if (c[i]) {
      const isOpen = nl.includes(c[i][c[i].length - 1])
      const isClose = nl.includes(c[i][0])
      if (s > -1 ) {
        if (isClose && !isOpen) {
          l.push(c.slice(s, i + 1).map(removeStyle).join(''))
          s = -1
        }
      } else {
        if (isOpen) s = i
        else l.push(c[i])
      }
    }
  }
  return l
}

const removeStyle = t => {
  const n = styles.findIndex(x => t.startsWith(x))
  return n == -1 ? t : t.slice(styles[n].length)
}

const getFillQuestions = t => {
  if (Array.isArray(t)) t = t.join('\n')
  // const r = t.matchAll(/(\d+).*?[\._…]{6,}/g).toArray()
  const r = []
  let a
  while ((a = fillPattern.exec(t)) !== null) {
    r.push(a)
  }
  return r.length > 0 ? r.map(x => ({ number: +x[1] })) : null
}

const getOrderedListQuestions = (n, target, type) => {
  if (target.content.every(x => /[\._…]{6,}/.test(x))) {
    target.type = 'fill'
    target.questions = target.content.map((_, i) => ({ number: i + n.start }))
  } else {
    target.type = type // 11. subject... choices... 12. subject...
    target.questions = n.children.map((q, i) => {
      const cs = q.children[0].children
      const s = paragraph(cs[0])
      const r = { number: i + n.start }
      if (type === 'choice') {
        const isMultiLine = cs.length == 1 && Array.isArray(s)
        r.subject = isMultiLine ? s[0] : s
        r.choices = isMultiLine ? s.slice(1) : cs.slice(1).filter(c => c.type != 'break').map(paragraph).flat(Infinity)
      }
      return r
    })
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
      target.type = 'choice'  // 11 subject... choices... 12 subject...
      const m = content[0].match(/^(<\w{1,2}>)*(\d+)( .+)?$/)
      target.questions = m ? [{
        number: +m[2],
        subject: content[n - 1].replace(/^\d{1,2} /, ''),
        choices: content.slice(n)
      }] : // multi-choice
      [...Array(to - from + 1).keys()].map(i => ({ number: i + from }))
    }
  }
  if (!target.questions) target.type = 'instruction'
}

const isTrueFalse = p => {
  let t = []
  if (p.content.length === 3)
    t = p.content
  else if (p.content.length === 6)
    t = [p.content[0], p.content[2], p.content[4]]
  const r = t.map(x => removeStyle(x).split(' ')[0]).join()
  return r === 'TRUE,FALSE,NOT' || r === 'YES,NO,NOT'
}

const CNT = ['1st', '2nd', '3rd', '4th']
const fixSquareQuestion = paragraphs => {
  const idx = paragraphs.findIndex(x => (x.questions || []).some(q => q.subject.includes('[■]')))
  if (idx > -1) {
    const ps = paragraphs.slice(idx + 1)
    let idx2 = ps.findIndex(x => x.type == 'choice')
    if (idx2 == -1) idx2 = ps.length
    const q = {
      number: paragraphs[idx].questions[0].number,
      subject: '',
      choices: [...Array(4).keys()].map(i => `${String.fromCharCode(65 + i)}. Insert before the ${CNT[i]} ■.`)
    }
    paragraphs = [
      ...paragraphs.slice(0, idx + idx2 + 1),
      { type: 'choice', content: [], questions: [q] },
      ...paragraphs.slice(idx + idx2 + 1)
    ]
  }
  return paragraphs
}

const fixSpeakQuestion = paragraphs => {
  if (paragraphs.length == 2 && removeStyle(paragraphs[0].content[0]) == 'Task1') {
    paragraphs[1].type = 'speak'
    paragraphs[1].questions = [{ number: 1 }]
  }
}

const fixDuplicateTitle = (paragraphs, partName) => 
  removeStyle(paragraphs[0].content[0]) == partName ? paragraphs.slice(1) : paragraphs

const parseTestAnswer = (listen, read) => ({
  listen: parseAnswer(listen),
  read: parseAnswer(read),
})

const parseAnswer = comp => {
  const a1 = comp.filter(x => x.type == 'list' && x.ordered)
    .map(l => l.children.map((li, i) => ({
      number: l.start + i,
      answer: paragraph(li.children[0]).join('')
    })))
    .flat()
  const a2 = comp.filter(x => x.type == 'paragraph')
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

const attachTestAnswer = (q, a) => {
  q.forEach((t, i) => {
    attachAnswer(t.listen, a[i].listen)
    attachAnswer(t.read, a[i].read)
  })  
}

const attachAnswer = (comp, a) => {
    const qs = comp.map(p => p.groups.map(g => g.paragraphs.map(x => x.questions).filter(x => x))).flat(Infinity)
    qs.forEach(q => {
      const m = a.find(x => x.number == q.number)
      if (m) q.answer = m.answer
    })
}

const styles = ['<b>', '<i>', '<ul>', '<img>', '<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<h6>']
const closeStyles = ['</b>', '</i>', '</ul>', '</img>', '</h1>', '</h2>', '</h3>', '</h4>', '</h5>', '</h6>']

const visual = q => q.map(vTest).join('<hr>')
const vTest = (t, i) => `<div><h1>Test ${i + 1}</h1>${vListen(t.listen)}</div>`
const vListen = (t, i) => `<div><h2>Listen</h2>${t.map(vPart).join('')}</div>`
const vPart = (t, i) => `<div><h3>${t.name}</h3>${t.groups.map(vGroup).join('')}</div>`
const vGroup = (t, i) => `<div><h4>Questions ${t.from} to ${t.to}</h4>${t.paragraphs.map(x => vParagraph(x, t.from, t.to)).join('<br/>')}</div>`
const vParagraph = (t, from, to) => {
  if (t.type == 'instruction') return vContent(t)
  if (t.type == 'fill') return `${vFillQuestion(t, from, to)}<div>(${t.questions.map(q => q.answer).join()})</div>`
  if (t.type == 'choice') {
    const qs = t.questions.map(vChoiceQuestion).join('<br>')
    return t.questions.some(q => q.choices) ? qs : `${vContent(t)}<br/>${qs}`
  }
}

const vContent = t => t.content.map(x => `<div>${closeStyle(x)}</div>`).join('')
const vFillQuestion = (t, from, to) => t.content.map((x, i) => {
  const noNum = /[a-zA-Z]+ [\._…]{6,}/.test(x)
  return `<div>${noNum ? `${i + from}. ` : ''}${closeStyle(x)}</div>`
}).join('')
const vChoiceQuestion = q => `<div><b>${q.number}.</b> ${closeStyle(q.subject)}</div>${(q.choices || []).map(c => `<div>  ${closeStyle(c)}</div>`).join('')}<div>(${q.answer})</div>`

const closeStyle = t => {
  if (!t || typeof(t) !== "string") return ''
  const n = styles.findIndex(x => t.startsWith(x))
  if (n == -1) return t
  const s1 = styles[n]
  const s2 = closeStyles[n]
  const remain = t.slice(s1.length)
  if (s1 == '<img>') return `<img src="${remain}">`
  return `${s1}${closeStyle(remain)}${s2}`
}