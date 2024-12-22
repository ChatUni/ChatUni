import 'dart:convert';

import 'package:chatuni/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Call center representative',
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
  final List<Map<String, String>> _messages = []; // To store chat messages

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text});
    });

    _textController.clear();

    try {
      // Construct the conversation history for context
      final List<Map<String, String>> chatHistory = [
        {
          'role': 'system',
          'content':
              'You work as a customer service representative for the Santa Clara County 211 call center. Your job is to provide accurate information about the services Santa Clara County can offer. If you do not know the answer to a question, you can ask the caller to hold while you look up the information. You can also transfer the call to a supervisor if you are unable to answer the question. If the user asks for services they are eligible to apply for, ask them questions about their situation to determine their eligibility. If the user asks for services they are not eligible for, inform them of their ineligibility and provide information about other services they may be eligible for. If the user asks for services that are not offered by Santa Clara County, inform them that the service is not available and provide information about other services they may be eligible for. Once a program has been determined, provide information on how to apply for it.',
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ChatGPT Chat UI'),
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

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['message']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
                bottom: 208.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
