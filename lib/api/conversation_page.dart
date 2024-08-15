import 'package:chatuni/widgets/common/message_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final bool _loading = false;
  List<String> history = [];

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Gemini AI'),
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 90),
              itemCount: history.reversed.length,
              controller: _scrollController,
              reverse: true,
              itemBuilder: (context, index) {
                var text = history.reversed.toList()[index];
                return MessageTile(
                  sendByMe: index % 2 == 0,
                  message: text,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 15),
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
                        _pickFile();
                      },
                      icon: const Icon(Icons.add),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                          cursorColor: Colors.green,
                          controller: _textController,
                          autofocus: true,
                          focusNode: _textFieldFocus,
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
                        setState(() {
                          history.add(_textController.text);
                          _textController.clear();
                          _textFieldFocus.unfocus();
                          _scrollDown();
                        });
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
                        child: _loading
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
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _pickFile() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
    } catch (e) {
      _showError(e.toString());
      return;
    }

    if (result != null) {
      final file = result.files.first;
      print('Picked file: ${file.name}');
      // Handle the picked file as needed
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Something went wrong'),
        content: SingleChildScrollView(
          child: SelectableText(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
