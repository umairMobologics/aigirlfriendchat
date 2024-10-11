import 'dart:developer';

import 'package:agora_new_updated/Database/HiveDatabase/SaveMessagesService.dart';
import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:agora_new_updated/models/MessageModel.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/ChatScreen/AboutScreen.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Controller/CharScreenController.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Chatscreen extends StatelessWidget {
  final int index;
  final bool isFirstTime;
  final GirlFriend girlfriend; // Add this line to accept the girlfriend data

  const Chatscreen({
    super.key,
    required this.index,
    required this.isFirstTime,
    required this.girlfriend, // Add this line to accept the girlfriend data
  });

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(girlfriend.girlFriendImage),
                fit: BoxFit.cover)),
        child: ChatScreenBody(
            girlfriend: girlfriend), // Pass the girlfriend data here
      ),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  final GirlFriend girlfriend; // Add this line to accept the girlfriend data

  const ChatScreenBody({
    super.key,
    required this.girlfriend, // Accept girlfriend data
  });

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final dataProvider = Provider.of<ChatProvider>(context, listen: false);

        if (dataProvider.messages.isEmpty) {
          dataProvider.addMessage(
            "Umair", // The sender
            "Hi, it's ${widget.girlfriend.girlFriendName}. I'm super excited to chat! What's up? How's your day going?", // Use girlfriend's name
            false, // Assuming it's sent by Umair (you)
            TimeOfDay.now().format(context), // The time
          );
        } else {
          log("old chat");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    // var chatProvider = Provider.of<ChatProvider>(context); // Get the provider

    return Column(
      children: [
        appBarWidget(mq, context),
        ValueListenableBuilder<Box<SaveMessagesModel>>(
            valueListenable: SaveMessageService.getAllmessages().listenable(),
            builder: (context, box, _) {
              final data = box.values.toList().cast<SaveMessagesModel>();
              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: data.length, // Use the messages from provider
                  itemBuilder: (context, index) {
                    final message = data[index];
                    return _buildChatBubble(
                      message.sender!,
                      message.message!,
                      message.isSender!,
                      message.time!,
                    );
                  },
                ),
              );
            }),
        _buildMessageInputField(context), // Pass context for provider access
      ],
    );
  }

  // Modify the input field to add a new message using the provider
  Widget _buildMessageInputField(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // Add the new message
              if (controller.text.isNotEmpty) {
                chatProvider.addMessage(
                  "Umair", // The sender
                  controller.text, // The message content
                  false, // Assuming it's sent by Umair (you)
                  TimeOfDay.now().format(context), // The time
                );
                controller.clear(); // Clear the input field
              }
            },
          ),
        ],
      ),
    );
  }

  Widget appBarWidget(Size mq, BuildContext context) {
    return SafeArea(
      child: Container(
        // height: 150,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        color: black.withOpacity(0.2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Center(
                          child: Icon(Icons.arrow_back, color: white))),
                ),
                SizedBox(
                  width: mq.width * 0.03,
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.girlfriend.girlFriendImage),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  width: mq.width * 0.02,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Aboutscreen(girlfriend: widget.girlfriend),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.girlfriend.girlFriendName,
                        style: const TextStyle(color: white, fontSize: 16),
                      ),
                      const Text(
                        "Tap for more info",
                        style: TextStyle(color: white54, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white54)),
              child: const Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.star,
                    color: white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "PRO",
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(
      String sender, String message, bool isSender, String time) {
    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender
              ? Colors.black.withOpacity(0.6)
              : const Color.fromARGB(255, 0, 52, 94).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: white),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: white),
            ),
          ],
        ),
      ),
    );
  }

// Widget _buildMessageInputField() {
//   return Padding(
//     padding: const EdgeInsets.all(8),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: "Type your message...",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send, color: Colors.blue),
//           onPressed: () {
//             // Add functionality to send a message
//           },
//         ),
//       ],
//     ),
//   );
// }
}
