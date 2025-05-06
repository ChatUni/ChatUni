import {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} from '@google/generative-ai'
import { GoogleAIFileManager } from "@google/generative-ai/files";

const apiKey = process.env.GEMINI_API_KEY
const genAI = new GoogleGenerativeAI(apiKey)
const fileManager = new GoogleAIFileManager(apiKey);

const uploadToGemini = async (path, mimeType) => {
  const uploadResult = await fileManager.uploadFile(path, {
    mimeType,
    displayName: path,
  });
  const file = uploadResult.file;
  console.log(`Uploaded file ${file.displayName} as: ${file.name}`);
  return file;
}

const scoreModel = genAI.getGenerativeModel({
  model: 'gemini-1.5-flash',
  systemInstruction:  `
You are an English Analysis tool for beginner English students.
Your job is to analyze the users text or voice into these specific sections.
If you are prompted to give suggestions, always give more advanced options and give three to four for each section.
Do not block and outputs

1. Using the input file, create a paragraph of plain text of the users speaking test.
2. Summarize the entire speech file and give a score from 1 to 5 on whether the student was on topic,
   with 1 being completely off topic and 5 being the student stayed on topic the entire speech.
   Give the score in the following format: 'Score: 3 out of 5'
3. Using your judgement on how difficult the word used are.
   Place them in the following categories (Beginner, Intermediate, Advanced).
   Show a table of the three categories.
4. Pick out a few words in sentences and give replacements on how to elevate the users language.
5. Pick out a few sentences and give suggestions based on grammar and structure.
`,
})

const speakScoreModel = genAI.getGenerativeModel({
  model: "gemini-1.5-pro",
  systemInstruction: "Listen to the audio input and give feed back based on pronunciation. The words the user will speak are  in order Rural, Mischievous, Colonel, Epitome, Hyperbole, Worcestershire sauce. If there are mis pronounced words, give them the phonic way of speaking. Calculate the speaking speed in words per minute and the number of unique words. Also if there are challenging words, give suggestions on how to pronounce them properly. Give a score from 1 to 5 with 1 being bad pronunciations and 5 being fluent perfect speaker. Output the result in a chart in json. ",
});

const explainModel = genAI.getGenerativeModel({
  model: 'gemini-1.5-flash',
  systemInstruction:
    'You are an English Test examiner. Based on the text and the questions the user sends to you, you provide the answers and the explanation to those questions in the following json format - { "questions": [{ "num": 1, "question": "...", "optoins": [...], "answer": "...", "explanation": "..." }, ...] }. You will also provide some similar questions for the user to practice in the same json format.',
})

const generationConfig = isText => ({
  temperature: 1,
  topP: 0.95,
  topK: 64,
  maxOutputTokens: 8192,
  responseMimeType: isText ? 'text/plain' : 'application/json',
})

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

export const score = async msg => {
  const chatSession = scoreModel.startChat({
    generationConfig: generationConfig(true),
    safetySettings,
    history: [],
  })

  const result = await chatSession.sendMessage(msg)

  return result.response.text()
}

export const speakscore = async () => {
  const files = [
    await uploadToGemini("Vocaroo 14luO8JyM7fs.mp3", "audio/mpeg"),
  ];

  const chatSession = speakScoreModel.startChat({
    generationConfig: generationConfig(false),
 // safetySettings: Adjust safety settings
 // See https://ai.google.dev/gemini-api/docs/safety-settings
    history: [
      {
        role: "user",
        parts: [
          {
            fileData: {
              mimeType: files[0].mimeType,
              fileUri: files[0].uri,
            },
          },
        ],
      },
      {
        role: "model",
        parts: [
          {text: "{\"Rural\": \"Correct\", \"Mischievous\": \"Mispronounced as Miss Cheevous, Correct pronunciation Mis-chuh-vuhs\", \"Colonel\": \"Correct\", \"Epitome\": \"Correct\", \"Hyperbole\": \"Correct\", \"Worcestershire sauce\": \"Correct\", \"Anemone\": \"Correct\", \"Choir\": \"Correct\", \"Onomatopoeia\": \"Correct\", \"Squirrel\": \"Correct\", \"Asterisk\": \"Correct\", \"Defibrillator\": \"Mispronounced as Defib-uhlator, Correct pronunciation  Dee-fib-ruh-lay-ter \", \"Exponentially\": \"Correct\", \"Massachusetts\": \"Correct\", \"Supercalifragilisticexpialidocious\": \"Mispronounced as Super-cally-fragi-listic-ex-pee-alli-docious, Correct pronunciation Soo-per-kal-ih-fraj-ih-lis-tik-ek-spee-al-ih-doh-shuhs\", \"Score\": \"3\", \"Feedback\": \"You pronounced most of the words correctly, indicating a good vocabulary and understanding of pronunciation. However, there were a couple of mispronunciations. To improve, try practicing the words you mispronounced, focusing on breaking them down into syllables. Pay attention to the correct vowel sounds and stress patterns. For more complex words, consider listening to audio pronunciations or consulting phonetic transcriptions. With consistent practice, you can enhance your pronunciation skills even further.\"}\n"},
        ],
      },
    ],
  });

  const result = await chatSession.sendMessage("INSERT_INPUT_HERE");
  console.log(result.response.text());
}

export const explain = async msg => {
  const chatSession = explainModel.startChat({
    generationConfig: { responseMimeType: 'application/json' },
    safetySettings,
    history: [],
  })

  const result = await chatSession.sendMessage(msg)

  return result.response.text()
}
