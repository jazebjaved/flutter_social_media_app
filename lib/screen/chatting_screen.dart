import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:first_app/misc/utils.dart';
import 'package:first_app/resources/storage_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../provider/user_provider.dart';
import '../resources/chatApi.dart';
import '../widgets/conversation_card.dart';
import '../models/user.dart' as UserModel;

class ChattingScreen extends StatefulWidget {
  final UserModel.User user;
  const ChattingScreen({super.key, required this.user});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<Message> _list = [];
  final TextEditingController _chattingController = TextEditingController();

  bool _showEmoji = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chattingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: _appbar(context),
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: ChatApi().getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding: const EdgeInsets.only(top: 18),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ConversationCard(
                                        messages: _list[index]);
                                  });
                            } else {
                              return const Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      }),
                ),
                if (_showEmoji)
                  SizedBox(
                    height: 243.55,
                    child: EmojiPicker(
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)

                        // Set it to null to hide the Backspace-Button
                      },

                      textEditingController:
                          _chattingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]

                      config: Config(
                        bgColor: Colors.white,
                        columns: 8,
                        emojiSizeMax: 25 * (Platform.isAndroid ? 1.30 : 1.0),
                      ),
                    ),
                  ),
                _chatInput(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: widget.user.photoUrl,
            width: 44,
            height: 44,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              widget.user.bio,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 20,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  Widget _chatInput(BuildContext context) {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).getUser;
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      size: 26,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    onTap: () {
                      if (_showEmoji) {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      }
                    },
                    controller: _chattingController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        hintText: 'type something', border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () async {
                      Uint8List file2 = await pickImage(ImageSource.gallery);
                      Uint8List file = await testComporessList(file2);

                      await StorageMethods()
                          .sendChatImage(widget.user, file, currentUser!);
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Uint8List file2 = await pickImage(ImageSource.camera);
                      Uint8List file = await testComporessList(file2);

                      await StorageMethods()
                          .sendChatImage(widget.user, file, currentUser!);
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 24,
            child: MaterialButton(
              onPressed: () {
                if (_chattingController.text.isNotEmpty) {
                  ChatApi().sendMessage(widget.user, _chattingController.text,
                      Type.text, currentUser!);
                  _chattingController.text = "";
                }
              },
              child: const Icon(
                Icons.send_outlined,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
