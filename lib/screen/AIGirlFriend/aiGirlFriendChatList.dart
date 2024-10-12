import 'dart:developer';

import 'package:agora_new_updated/Database/listGirlfriendDatabase.dart';
import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/ChatScreen/ChatScreen.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Controller/PageViewController.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/StartNewChat/PageViewScreen.dart';
import 'package:agora_new_updated/screen/AIGirlFriend/Widgets/CustomButton.dart';
import 'package:agora_new_updated/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AIGirlFriend extends StatefulWidget {
  const AIGirlFriend({super.key});

  @override
  _AIGirlFriendState createState() => _AIGirlFriendState();
}

class _AIGirlFriendState extends State<AIGirlFriend> {
  late Future<List<GirlFriend>> _girlfriendsFuture;

  @override
  void initState() {
    super.initState();
    _girlfriendsFuture = GirlfriendDatabaseHelper().getAllGirlfriends();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        title: const Text(
          "Genesia AI",
          style: TextStyle(
              fontSize: 30, color: white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white54)),
            child: const Row(
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
          const SizedBox(width: 20)
        ],
        elevation: 10,
      ),
      body: FutureBuilder<List<GirlFriend>>(
        future: _girlfriendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: white),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                textAlign: TextAlign.center,
                "Hurry up, Start new chat and talk with you friend",
                style: TextStyle(color: white),
              )),
            );
          } else {
            final girlfriends = snapshot.data!.reversed.toList();
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: girlfriends.length,
              itemBuilder: (context, index) {
                final girlfriend = girlfriends[index];
                log("girlfriend id is : ${girlfriend.conversationID}");

                return MessageCard(
                    mq: mq, index: index, girlfriend: girlfriend);
              },
            );
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (_) => PageViewController(),
                      child: const Pageviewscreen()),
                ),
              );
            },
            child: const CustomButton(
              text: "Start New Chat",
            ),
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.mq,
    required this.index,
    required this.girlfriend,
  });

  final Size mq;
  final int index;
  final GirlFriend girlfriend; // Girlfriend data passed here

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          highlightColor: grey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chatscreen(
                  index: index,
                  isFirstTime: false,
                  girlfriend: girlfriend,
                ),
              ),
            );
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            height: mq.height * 0.1,
            width: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 12, 25, 61)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(girlfriend.girlFriendImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: mq.width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          girlfriend.girlFriendName,
                          style: const TextStyle(color: white),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Hey! What are you up to?",
                              style: TextStyle(color: white54),
                            ),
                            SizedBox(width: mq.width * 0.01),
                            const Text(
                              ". 1h",
                              style: TextStyle(color: white54),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Text(
                  ".",
                  style: TextStyle(
                      fontSize: 30, color: white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
