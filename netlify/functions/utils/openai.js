import OpenAI from 'openai'
import { decrypt } from './crypto'

let openai
let assistant
let thread

export const initAI = async () => {
  if (!openai) {
    openai = new OpenAI({
      apiKey: decrypt(process.env.OPENAI_API_KEY),
    })
  }

  if (!assistant) {
    assistant = await openai.beta.assistants.create({
      name: 'David',
      instructions:
        'You are a professional English tutor. You help me learn English and correct my mistakes.',
      model: 'gpt-4o',
    })
  }
}

const createThread = async () => {
  if (!thread) {
    thread = await openai.beta.threads.create()
  }
}

const createMsg = text =>
  openai.beta.threads.messages.create(thread.id, {
    role: 'user',
    content: text,
  })

const createRun = () =>
  openai.beta.threads.runs.create(thread.id, {
    assistant_id: assistant.id,
  })

const runComplete = async runId => {
  while (true) {
    const run = await openai.beta.threads.runs.retrieve(thread.id, runId)
    if (run.status === 'completed') return
    await new Promise(r => setTimeout(r, 100))
  }
}

const getFinalMsg = async () => {
  const msgs = await openai.beta.threads.messages.list(thread.id)
  return msgs.data[0].content[0].text.value
}

export const chat = async text => {
  await createThread()
  await createMsg(text)
  const run = await createRun()
  await runComplete(run.id)
  return await getFinalMsg()
}
