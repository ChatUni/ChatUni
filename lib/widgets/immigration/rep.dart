import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatuni/api/elevenlabs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '/env.dart'; // Ensure this file contains your ElevenLabs API key

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ChatGPT Chat UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ChatScreen(),
      );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  String _selectedLanguage = 'English';
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Español': 'es-ES', // Spanish
    '中文': 'zh-CN', // Chinese
    'Français': 'fr-FR', // French
    'Deutsch': 'de-DE', // German
    'Italiano': 'it-IT', // Italian
    '日本語': 'ja-JP', // Japanese
    '한국어': 'ko-KR', // Korean
    'Português': 'pt-PT', // Portuguese
    'Русский': 'ru-RU', // Russian
    'हिन्दी': 'hi-IN', // Hindi
    'العربية': 'ar-SA', // Arabic
    'Türkçe': 'tr-TR', // Turkish
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text, 'translated': null});
    });

    _textController.clear();

    try {
      final List<Map<String, String>> chatHistory = [
        {
          'role': 'system',
          'content':
              'Limit responses to three sentences and assume the user can read English so send all responses in English. You work as a customer service representative for the Santa Clara County 211 call center. Your job is to provide accurate information about the services Santa Clara County can offer. Always speak in sentences and lists. Ask the user questions about their current situation to get a better understanding of all the services Santa Clara County can offer them. Start the conversation by asking the user how you can help them today.',
        },
        ..._messages.map(
          (msg) => {
            'role': msg['sender'] == 'user' ? 'user' : 'assistant',
            'content': msg['message']!,
          },
        ),
      ];

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Env.openaiApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': chatHistory,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String chatGPTMessage = data['choices'][0]['message']['content'].trim();

        setState(() {
          _messages.add({
            'sender': 'chatgpt',
            'message': chatGPTMessage,
            'translated': null,
          });
        });

        // If selected language is not English, translate the response automatically
        if (_selectedLanguage != 'English') {
          await _handleAutomaticTranslation(
            _messages.length - 1,
            chatGPTMessage,
          );
        } else {
          // Synthesize the original English speech
          await _synthesizeSpeech(chatGPTMessage);
        }
      } else {
        setState(() {
          _messages.add({
            'sender': 'chatgpt',
            'message': 'Error: Unable to fetch response.',
            'translated': null,
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          {'sender': 'chatgpt', 'message': 'Error: $e', 'translated': null},
        );
      });
    }
  }

  Future<void> _handleAutomaticTranslation(
      int messageIndex, String originalMessage) async {
    try {
      final languageCode = _languageCodes[_selectedLanguage]!;

      // Translate the message
      final translatedMessage =
          await _translateToLanguage(originalMessage, languageCode);

      setState(() {
        _messages[messageIndex]['translated'] = translatedMessage;
      });

      // Synthesize the translated speech
      await _synthesizeSpeech(translatedMessage);
    } catch (e) {
      print('Error translating or synthesizing speech: $e');
    }
  }

  void _checkSupportedLocales() async {
    final locales = await _speech.locales();
    for (var locale in locales) {
      print('Locale: ${locale.localeId} - ${locale.name}');
    }
  }

  Future<String> _translateToLanguage(String text, String languageCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Env.openaiApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that translates text to $languageCode.',
            },
            {
              'role': 'user',
              'content': 'Translate this text to $languageCode: "$text"',
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      print('Error translating text: $e');
      return 'Translation error';
    }
  }

  void _speakTranslatedText(String text) async {
    await _synthesizeSpeech(text);
  }

  void _handleTranslate(int index) async {
    final message = _messages[index];
    if (message['translated'] != null) return; // Avoid re-translating

    final languageCode = _languageCodes[_selectedLanguage]!;
    final translatedMessage =
        await _translateToLanguage(message['message']!, languageCode);
    setState(() {
      _messages[index]['translated'] = translatedMessage;
    });

    await _synthesizeSpeech(translatedMessage);
  }

  Future<void> _synthesizeSpeech(String text) async {
    try {
      // Your implementation for ElevenLabs TTS API
      final audioBytes = await tts11(text, 'pFZP5JQG7iQjIQuC4Bku');
      await _audioPlayer.play(BytesSource(audioBytes));
    } catch (e) {
      print('Error synthesizing speech: $e');
    }
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);

        final selectedLocale = _languageCodes[_selectedLanguage]!;

        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
            if (val.finalResult) {
              _sendMessage(_spokenText);
            }
          }),
          localeId: selectedLocale, // Dynamically set the language locale
        );
      }
    }
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Select Input Language'),
        children: _languageCodes.keys
            .map(
              (language) => SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  language,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('211 Chat REP'),
          backgroundColor: const Color.fromARGB(255, 20, 171, 218),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUser = message['sender'] == 'user';
                  final translated = message['translated'];

                  return Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isUser
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isUser
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            if (translated != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        translated,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.volume_up,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () => _speakTranslatedText(
                                        translated,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.translate,
                            color: Colors.indigo,
                          ),
                          onPressed: () => _handleTranslate(
                            _messages.length - 1 - index,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 100.0,
                left: 10.0,
                right: 10.0,
                top: 10.0,
              ),
              child: Row(
                children: [
                  // Expanded Text Field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Microphone button
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                      tooltip: 'Start voice input',
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Send button
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Selected language display (as a button)
                  GestureDetector(
                    onTap: () {
                      _showLanguageSelector(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            size: 16,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _selectedLanguage,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
