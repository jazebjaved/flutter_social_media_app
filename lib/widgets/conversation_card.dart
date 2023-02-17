import 'package:first_app/resources/chatApi.dart';
import 'package:flutter/material.dart';

import '../misc/data_utils.dart';
import '../models/message.dart';

class ConversationCard extends StatelessWidget {
  final Message messages;
  const ConversationCard({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ChatApi().user.uid == messages.fromId
        ? _greenMessage(context)
        : _blueMessage(context);
  }

  Widget _greenMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              // show icon only when read field not empty
              if (messages.read.isNotEmpty)
                Icon(
                  Icons.done_all_outlined,
                  color: Colors.blue,
                ),
              SizedBox(
                width: 5,
              ),
              Text(DateUtil.getFormattedTime(
                  context: context, time: messages.sent)),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: Text(
              messages.msg,
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Widget _blueMessage(BuildContext context) {
    //funtion to show blue tick icon for read meesage
    if (messages.read.isEmpty) {
      ChatApi().updateMessageReadStatus(messages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(65, 158, 158, 158),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              messages.msg,
              style: TextStyle(color: Colors.black),
            )),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
              DateUtil.getFormattedTime(context: context, time: messages.sent)),
        )
      ],
    );
  }
}
