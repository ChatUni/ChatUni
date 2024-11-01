export const tap = x => { console.log(x); return x; }

export const range = (from, to) => [...Array(to - from + 1).keys()].map(i => i + from)
