import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;

import '../screen/chatting_screen.dart';

class ChatUserCard extends StatelessWidget {
  final UserModel.User user;
  const ChatUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChattingScreen(user: user)));
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 15,
          ),
          child: Row(
            children: [
              Badge(
                position: BadgePosition.bottomEnd(bottom: 5, end: 0),
                badgeStyle: BadgeStyle(badgeColor: Colors.green, elevation: 2),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    'Last User Message',
                    style: TextStyle(color: Color.fromARGB(169, 0, 0, 0)),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '11:30',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFEE0F38),
                    radius: 14,
                    child: Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
