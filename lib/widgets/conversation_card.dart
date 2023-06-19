import 'package:cached_network_image/cached_network_image.dart';
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
        ? _redMessage(context)
        : _blueMessage(context);
  }

  Widget _redMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: messages.type == Type.text
                ? Padding(
                    padding: const EdgeInsets.all(19),
                    child: Text(
                      messages.msg,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: messages.msg,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      // Image.network(
                      //   messages.msg,
                      //   fit: BoxFit.fitWidth,
                      //   height: 270,
                      // ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // show icon only when read field not empty

                Text(
                  DateUtil.getFormattedTime(
                      context: context, time: messages.sent),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (messages.read.isNotEmpty)
                  const Icon(
                    Icons.done_all_outlined,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blueMessage(BuildContext context) {
    //funtion to show blue tick icon for read meesage
    if (messages.read.isEmpty) {
      ChatApi().updateMessageReadStatus(messages);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
                color: Color.fromARGB(65, 158, 158, 158),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: messages.type == Type.text
                ? Padding(
                    padding: const EdgeInsets.all(19),
                    child: Text(
                      messages.msg,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: messages.msg,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(DateUtil.getFormattedTime(
                context: context, time: messages.sent)),
          )
        ],
      ),
    );
  }
}
