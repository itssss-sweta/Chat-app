import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/core/utils/filepicker.dart';
import 'package:chat_app/features/chatpage/presentation/ui/components/navbarcontainer.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final String title;
  const ChatPage({super.key, required this.title});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  String currentMessage = '';

  TextEditingController message = TextEditingController();
  ScrollController _scrollController = ScrollController();

  late WebSocketChannel channel;

  Future<void> pickImage() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowCompression: true,
    //   allowedExtensions: ["jpg", "png", "jpeg"],
    //   allowMultiple: true,
    //   onFileLoading: (value) {
    //     return const CircularProgressIndicator();
    //   },
    // );
    var result = await pickFile();

    // log(result?.files.toString() ?? '');
    if (result != null) {
      setState(() {
        messages.addAll(result.files.map((file) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          return Message(type: MessageType.image, content: file);
        }).toList());
        // log(messages.toString());
      });
      if (messages.isNotEmpty && messages.last.content != null) {
        File imageFile =
            File((messages.last.content as PlatformFile).path ?? '');
        List<int> imageBytes = await imageFile.readAsBytes();

        // Encode the image bytes to base64
        String base64Image = base64Encode(imageBytes);
        // log(base64Image);

        // Send the base64-encoded image data
        channel.sink.add(base64Image);
      }
    }
  }

  void sendMessage({String? text}) async {
    // log(message.text);
    channel.sink.add(text);
    // log('$text inside function');
    setState(() {
      messages.add(Message(type: MessageType.text, content: text));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    // log(messages.length.toString());
    message.clear();
  }
  // else {
  //   if (messages.isNotEmpty && messages.last.path != null) {
  //     File imageFile = File(messages.last.path!);
  //     List<int> imageBytes = await imageFile.readAsBytes();
  //     // Encode the image bytes to base64
  //     String base64Image = base64Encode(imageBytes);
  //     log(base64Image);
  //     // Send the base64-encoded image data
  //     channel.sink.add(base64Image);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('wss://socketsbay.com/wss/v2/1/demo/'));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    channel.sink.close();
    // message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green.shade500,
        elevation: 0.2,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height - 150,
        child: StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              log('dataRuntimeType: ${snapshot.data.runtimeType.toString()}');
              log('data: ${snapshot.data.toString()}');
              log('hasdata:${snapshot.hasData.toString()}');
              log('state:${snapshot.connectionState.toString()}');
              if (snapshot.hasData) {
                // log(snapshot.data);
                var start = snapshot.data.toString().startsWith('{');
                var end = snapshot.data.toString().endsWith('}');
                final data = snapshot.data;
                if (!start && !end) {
                  // Add the message only if it's not already in the list
                  // if (!messages
                  //     .contains(Message(type: MessageType.text, content: data))) {

                  messages.add(Message(type: MessageType.text, content: data));
                  // }
                }
              }
              // log(data.runtimeType.toString());

              return ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var currentMessageIndex = messages[index];
                  // log(data);
                  // if (currentMessage.type == MessageType.text) {
                  //   log(currentMessage.content);
                  // }

                  // if (fileExtension.endsWith('.jpg') ||
                  //     fileExtension.endsWith('.jpeg') ||
                  //     fileExtension.endsWith('.png')) {
                  // Display text message
                  if (currentMessageIndex.type == MessageType.image) {
                    log((currentMessageIndex.content as PlatformFile).path ??
                        "");
                    return BubbleNormalImage(
                        id: currentMessageIndex.content.hashCode.toString(),
                        image: Image.file(
                          File(
                            (currentMessageIndex.content as PlatformFile)
                                    .path ??
                                "",
                          ),
                          color: Colors.green.shade50,
                        ));
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey.shade300,
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       padding: const EdgeInsets.all(16),
                    //       // child: Text(messages[index].path ?? ''),
                    //       child: (messages[index].path != null)
                    //           ? Image.file(
                    //               File(
                    //                 messages[index].path ?? '',
                    //               ),
                    //               height: 200,
                    //             )
                    //           : null),
                    // );
                  }
                  //  else if (fileExtension.endsWith('.mp4') ||
                  //     fileExtension.endsWith('.mov') ||
                  //     fileExtension.endsWith('.avi')) {
                  //   // Display video file
                  //   return Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.grey.shade300,
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         padding: const EdgeInsets.all(16),
                  //         child: AspectRatio(
                  //           aspectRatio: 16 /
                  //               9, // You may need to adjust this based on your videos
                  //           child: VideoPlayer(
                  //             VideoPlayerController.file(
                  //                 File(messages[index].path!)),
                  //           ),
                  //         ),
                  //       ));
                  // }
                  else {
                    currentMessage = currentMessageIndex.content;

                    // Display file message
                    return BubbleSpecialOne(
                      text: currentMessage,
                      color: Colors.green.shade200,
                    );
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey.shade300,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     padding: const EdgeInsets.all(16),
                    //     child: Text(currentMessage),
                    //     // child: (messages.first.bytes != null)
                    //     //     ? Image.memory(messages.first.bytes!)
                    //     //     : null,
                    //     // child: StreamBuilder(
                    //     //   stream: channel.stream,
                    //     //   builder: (context, snapshot) {
                    //     //     // log(snapshot.data);
                    //     //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
                    //     //   },
                    //     // ),
                    //   ),
                    // );
                  }
                },
              );
            }),
      ),
      // bottomSheet: MessageBar(
      //   onSend: (text) {
      //     log('jdfj');
      //     sendMessage(text: text);
      //     currentMessage = text;
      //     log(text);
      //   },
      //   messageBarColor: Colors.green.shade50,
      //   sendButtonColor: Colors.green.shade400,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(left: 8, right: 8),
      //       child: InkWell(
      //         child: Icon(
      //           Icons.add,
      //           color: Colors.green.shade400,
      //           size: 24,
      //         ),
      //         onTap: () {
      //           pickImage();
      //         },
      //       ),
      //     ),
      //     // Padding(
      //     //   padding: const EdgeInsets.only(left: 8, right: 8),
      //     //   child: InkWell(
      //     //     child: const Icon(
      //     //       Icons.camera_alt,
      //     //       color: Colors.green,
      //     //       size: 24,
      //     //     ),
      //     //     onTap: () {},
      //     //   ),
      //     // ),
      //   ],
      // ),

      bottomSheet: Container(
        width: MediaQuery.sizeOf(context).width * 2,
        height: 50,
        constraints: const BoxConstraints(
          minHeight: 40,
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade500,
          border: Border.all(
            color: Colors.green.shade400,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            NavBarContainer(
              icon: Icons.file_copy_outlined,
              onTap: () {
                pickImage();
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: TextField(
                  maxLines: 10,
                  keyboardType: TextInputType.text,
                  controller: message,
                  maxLength: 250,
                  decoration: const InputDecoration(
                    hintText: 'Enter a text......',
                    counterText: '',
                  ),
                ),
              ),
            ),
            NavBarContainer(
              icon: Icons.send_outlined,
              onTap: () {
                //sendMessage(text: message.text);
                String sentMessage = 'Sent:${message.text}';
                log(sentMessage);
                if (message.text.isNotEmpty) {
                  // log(message.text);
                  channel.sink.add(message.text);
                  setState(() {
                    messages.add(
                        Message(type: MessageType.text, content: message.text));
                    // _scrollController
                    //     .jumpTo(_scrollController.position.maxScrollExtent);
                  });
                  message.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageType { text, image }

class Message {
  final MessageType type;
  final dynamic content;

  Message({required this.type, required this.content});
}
