import OpenAI from 'openai'
import axios from 'axios'
import { tap } from './util'

let openai
let assistant
let thread

export const initAI = async () => {
  if (!openai) {
    openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
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


export const explain = async msg => {
  const r = await axios.post(
    //'https://api.openai.com/v1/chat/completions',
    'https://api.groq.com/openai/v1/chat/completions',
    //'https://openrouter.ai/api/v1/chat/completions',
    {
      //'model': 'gpt-4o-mini',
      //'model': 'llama-3.3-70b-versatile',
      'model': 'deepseek-r1-distill-llama-70b',
      //'model': 'deepseek/deepseek-r1-distill-llama-70b:free',
      'messages': [
        {
          'role': 'system',
          'content': `
You are an English Test examiner.
Based on the text and the questions the user sends to you, you provide the answers and the explanation to those questions.
Your response should be in the following json format
{"questions": [{ "num": 1, "question": "...", "optoins": [...], "answer": "...", "explanation": "..." }, ...] }.
For "complete sentences" type of questions, separate each "blank" into an individual question.
The question field will be the sentence to be completed, use ___ to indicate the blank in the sentence to be completed.
For "TRUE,FALSE,NOT GIVEN" type of questions, add "TRUE", "FALSE", "NOT GIVEN" to the options list.
You will always provide some similar questions for the user to practice in the same json format, under the "similar_questions" field.
Your response should be just the json string, without any additional words.`,
        },
        {
          'role': 'user',
          'content': msg,
        },
      ],
    },
    {
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
        'Authorization': `Bearer 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`,
        //'Authorization': `Bearer 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`,
      }
    }
  );
  return tap(r.data.choices[0].message.content
    .replace(/\n/g, '')
    .replace('practice_questions', 'similar_questions')
    .replace('```json', '')
    .replace('```', '')
    .replace(/<think>.*<\/think>/, ''))
}
