import 'dart:developer';
import 'dart:io';
import 'package:chat_app/features/chatpage/presentation/ui/components/navbarcontainer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<PlatformFile> messages = [];

  TextEditingController message = TextEditingController();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowedExtensions: ["jpg", "png", "jpeg"],
      allowMultiple: true,
      onFileLoading: (value) {
        return const CircularProgressIndicator();
      },
    );
    log(result?.files.first.toString() ?? '');
    if (result != null) {
      setState(() {
        messages = result.files;
      });
    }
  }

  void sendMessage() {
    if (message.text.isNotEmpty) {
      setState(() {
        messages.add(PlatformFile(name: message.text, size: 1));
        message.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hii'),
        backgroundColor: Colors.green.shade500,
        elevation: 0.2,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height - 150,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            String fileExtension = messages[index].name.toLowerCase();
            log(messages[index].bytes.toString());
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
                  child: Text(messages[index].name),
                  // child: (messages.first.bytes != null)
                  //     ? Image.memory(messages.first.bytes!)
                  //     : null,
                ),
              );
            }
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
