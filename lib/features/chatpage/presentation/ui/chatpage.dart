import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/core/utils/filepicker.dart';
import 'package:chat_app/features/chatpage/presentation/ui/components/navbarcontainer.dart';
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
  List<PlatformFile> messages = [];

  TextEditingController message = TextEditingController();

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

    log(result?.files.first.toString() ?? '');
    if (result != null) {
      setState(() {
        messages.addAll(result.files);
      });
      if (messages.isNotEmpty && messages.last.path != null) {
        File imageFile = File(messages.last.path!);
        List<int> imageBytes = await imageFile.readAsBytes();

        // Encode the image bytes to base64
        String base64Image = base64Encode(imageBytes);
        log(base64Image);

        // Send the base64-encoded image data
        channel.sink.add(base64Image);
      }
    }
  }

  void sendMessage() async {
    if (message.text.isNotEmpty) {
      log(message.text);
      channel.sink.add(message.text);
      setState(() {
        messages.add(PlatformFile(name: message.text, size: 1));
      });

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
  }

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
        Uri.parse('wss://socketsbay.com/wss/v2/1/demo/'));
  }

  @override
  void dispose() {
    channel.sink.close();
    message.dispose();
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
            if (snapshot.hasData) {
              log(snapshot.data);
              var start = snapshot.data.toString().startsWith('{');
              var end = snapshot.data.toString().endsWith('}');
              if (!start && !end) {
                messages.add(PlatformFile(name: snapshot.data, size: 1));
              }
              // }
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                String currentMessage = messages[index].name;
                String fileExtension = messages[index].name.toLowerCase();

                if (fileExtension.endsWith('.jpg') ||
                    fileExtension.endsWith('.jpeg') ||
                    fileExtension.endsWith('.png')) {
                  // Display text message
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        // child: Text(messages[index].path ?? ''),
                        child: (messages[index].path != null)
                            ? Image.file(
                                File(
                                  messages[index].path ?? '',
                                ),
                                height: 200,
                              )
                            : null),
                  );
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
                  // Display file message
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(currentMessage),
                      // child: (messages.first.bytes != null)
                      //     ? Image.memory(messages.first.bytes!)
                      //     : null,
                      // child: StreamBuilder(
                      //   stream: channel.stream,
                      //   builder: (context, snapshot) {
                      //     // log(snapshot.data);
                      //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
                      //   },
                      // ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
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
                pickFile();
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
                sendMessage();
                // String sentMessage = 'Sent:${message.text}';
                // if (message.text.isNotEmpty) {
                //   log(message.text);
                //   channel.sink.add(message.text);
                //   setState(() {
                //     messages.add(PlatformFile(name: message.text, size: 1));
                //   });
                //   message.clear();
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
