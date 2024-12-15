export const tap = x => { console.log(x); return x; }

export const range = (from, to) => [...Array(to - from + 1).keys()].map(i => i + from)

export const splitWhen = (a, f) => {
  const r = []
  let t = []
  for (let x of a) {
    if (f(x)) {
      if (t.length > 0) r.push(t)
      t = [x]
    } else {
      t.push(x)
    }
  }
  return r
}