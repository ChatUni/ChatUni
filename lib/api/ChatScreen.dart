import 'package:chatuni/store/chatscreen.dart';
import 'package:chatuni/widgets/common/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore chatStore = ChatStore();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Gemini AI'),
        ),
        body: Stack(
          children: [
            Observer(
              builder: (_) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 90),
                itemCount: chatStore.history.reversed.length,
                controller: chatStore.scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  var text = chatStore.history.reversed.toList()[index];
                  return MessageTile(
                    sendByMe: index % 2 == 0,
                    message: text,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await chatStore.pickFile(context);
                      },
                      icon: const Icon(Icons.add),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                          cursorColor: Colors.green,
                          controller: chatStore.textController,
                          autofocus: true,
                          focusNode: chatStore.textFieldFocus,
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        chatStore.addMessage(chatStore.textController.text);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              blurRadius: 3,
                              spreadRadius: 3,
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        child: Observer(
                          builder: (_) => chatStore.loading
                              ? const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
