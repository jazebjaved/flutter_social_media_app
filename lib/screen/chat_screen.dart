import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:first_app/resources/chatApi.dart';
import 'package:first_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _chatController = TextEditingController();
  List<UserModel.User> _list = [];

  bool _isShowUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Find Friends')),
      floatingActionButton: FloatingActionButton(
        heroTag: Text("btn1"),
        backgroundColor: const Color(0xFFEE0F38),
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const AddPostScreen(),
          //   ),
          // );
        },
        child: const Icon(Icons.add_comment_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
                controller: _chatController,
                onFieldSubmitted: (String _) {
                  setState(() {
                    _isShowUser = true;
                  });
                },
                decoration: const InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color.fromARGB(213, 243, 236, 236),
                  labelText: 'Search Friends',
                  prefixIcon: Icon(Icons.emoji_people_outlined),

                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0, color: Color.fromARGB(213, 243, 236, 236)),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                )),
          ),
          _isShowUser
              ? Center(
                  child: Text('raja muna'),
                )
              : StreamBuilder(
                  stream: ChatApi().getAllUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => UserModel.User.fromSnap(e)).toList() ??
                            [];
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _list.length,
                      itemBuilder: (context, index) => ChatUserCard(
                        user: _list[index],
                      ),
                    );
                  },
                ),
        ]),
      ),
    );
  }
}
