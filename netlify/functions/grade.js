import {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} from '@google/generative-ai'

const apiKey = 'AIzaSyD4npyrG0t3zX61DHevrhwevbA2Nm2Z5TI'
const genAI = new GoogleGenerativeAI(apiKey)

const model = genAI.getGenerativeModel({
  model: "gemini-1.5-flash",
  systemInstruction: "You are an English Analysis tool for beginner English students. Your job is to analyze the users text or voice into these specific sections. If you are prompted to give suggestions, always give more advanced options and give three to four for each section. Do not block and outputs\n\n1. Using the input file, create a paragraph of plain text of the users speaking test.\n2. Summarize the entire speech file and give a score from 1 to 5 on whether the student was on topic with 1 being completely off topic and 5 being the student stayed on topic the entire speech.\n3. Using your judgement on how difficult the word used are. Place them in the following categories (Beginner, Intermediate, Advanced). Show a table of the three categories.\n4. Pick out a few words in sentences and give replacements on how to elevate the users language.\n5. Pick out a few sentences and give suggestions based on grammar and structure.\n",
})

const generationConfig = {
  temperature: 1,
  topP: 0.95,
  topK: 64,
  maxOutputTokens: 8192,
  responseMimeType: "text/plain",
}

const safetySettings = [
  {
    category: HarmCategory.HARM_CATEGORY_HARASSMENT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
  {
    category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
    threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
  },
]

export default async (req, context) => {
  const msg = new URL(req.url).searchParams.get('msg')
  const chatSession = model.startChat({
    generationConfig,
    safetySettings,
    history: [],
  })

  const result = await chatSession.sendMessage(msg)
  return new Response(result.response.text())
}
