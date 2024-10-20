import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Controller/CharScreenController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/aiGirlFriendChatList.dart';
import 'package:agora_new_updated/utils/alert_dialogs.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Aboutscreen extends StatefulWidget {
  final GirlFriend girlfriend;
  const Aboutscreen({super.key, required this.girlfriend});

  @override
  State<Aboutscreen> createState() => _AboutscreenState();
}

class _AboutscreenState extends State<Aboutscreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Ink(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      (Icons.arrow_back),
                      color: white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              borderRadius: BorderRadius.circular(80),
              onTap: () {
                //showFullImage
              },
              child: CircleAvatar(
                maxRadius: 80,
                backgroundImage: AssetImage(widget.girlfriend.girlFriendImage),
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            Text(
              widget.girlfriend.girlFriendName.toUpperCase(),
              style: const TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: mq.height * 0.01),
            Text(
              "${widget.girlfriend.girlFriendAge.toString().toUpperCase()} yr - ${widget.girlfriend.girlFriendGender} ",
              style: const TextStyle(color: white54, fontSize: 18),
            ),
            SizedBox(height: mq.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showClearChatDialog(
                        context,
                        "Are you sure?",
                        "Clear chat history and make a fresh start with the character.",
                        () {
                          // log("Cleared");
                          context.read<ChatProvider>().clearConversation(
                              widget.girlfriend.conversationID);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: white),
                          color: scaffoldBackground),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Clear Chat History",
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CupertinoIcons.delete_left_fill,
                            color: white,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * 0.02),
                  InkWell(
                    onTap: () {
                      showClearChatDialog(context, "Are you sure?",
                          "The character will be deleted permanently", () {
                        context.read<ChatProvider>().deleteConversation(
                            widget.girlfriend.conversationID);
                        context
                            .read<ChatProvider>()
                            .deleteGirlfriend(widget.girlfriend.conversationID);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const AIGirlFriend()),
                            (Route<dynamic> route) => false);
                      }, yes: "Delete Character");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: white),
                          color: scaffoldBackground),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Erase Character",
                            style: TextStyle(
                                color: red, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CupertinoIcons.delete,
                            color: red,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mq.height * 0.02),
            const Divider()
          ],
        ),
      ),
    );
  }
}
