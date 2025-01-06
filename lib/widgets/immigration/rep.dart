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
  final List<Map<String, String>> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text});
    });

    _textController.clear();

    try {
      final List<Map<String, String>> chatHistory = [
        {
          'role': 'system',
          'content':
              'You work as a customer service representative for the Santa Clara County 211 call center. Your job is to provide accurate information about the services Santa Clara County can offer. Always speak in sentences and lists. Ask the user questions about their current situation to get a better understanding of all the services Santa Clara county can offer them. Start the conversation by asking the user how you can help them today.',
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
        final data = jsonDecode(response.body);
        final chatGPTMessage = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add({'sender': 'chatgpt', 'message': chatGPTMessage});
        });

        // Use ElevenLabs TTS API to synthesize the response
        await _synthesizeSpeech(chatGPTMessage);
      } else {
        setState(() {
          _messages.add({
            'sender': 'chatgpt',
            'message': 'Error: Unable to fetch response.',
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'chatgpt', 'message': 'Error: $e'});
      });
    }
  }

  Future<void> _synthesizeSpeech(String text) async {
    try {
      final audioBytes = await tts11(text, 'Xb7hH8MSUJpSbSDYk0k2');
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
        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
            if (val.finalResult) {
              _sendMessage(_spokenText);
            }
          }),
        );
      }
    }
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
          title: const Text('ChatGPT Chat UI'),
          backgroundColor: Colors.indigo,
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                _messages[_messages.length - 1 - index];
                            final isUser = message['sender'] == 'user';

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.blue[200]
                                      : Colors.grey[300],
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
                                child: Text(
                                  message['message']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isListening ? _stopListening : _startListening,
          child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        ),
      );
}
