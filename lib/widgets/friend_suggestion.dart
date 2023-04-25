import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/resources/chatApi.dart';
import 'package:first_app/widgets/add_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../provider/user_provider.dart';
import '../resources/firestore_method.dart';
import '../models/user.dart' as UserModel;
import 'chat_user_card.dart';

class FriendSuggestion extends StatefulWidget {
  const FriendSuggestion({
    super.key,
  });

  @override
  State<FriendSuggestion> createState() => _FriendSuggestionState();
}

class _FriendSuggestionState extends State<FriendSuggestion> {
  UserModel.User? _user;

  @override
  void initState() {
    UserModel.User? user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    _user = user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // List<Stream> streamList = [
    //   FirestoreMethods().friendSuggestion(_user),
    //   FirestoreMethods().friendSuggestion3(_user),
    // ];
    // Stream combinedStream = StreamGroup.merge(streamList);

    List<UserModel.User> list = [];
    List<UserModel.User> newFriendsList = [];

    List<UserModel.User> myFriendSugesstionList = [];

    return StreamBuilder(
      stream: ChatApi().getAllUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data?.docs;

        list = data?.map((e) => UserModel.User.fromSnap(e)).toList() ?? [];
        list.removeWhere((item) => item.followers.contains(_user?.uid));
        newFriendsList = List.from(list);

        list.removeWhere((item) => item.followers.contains(_user?.uid));
        list.retainWhere((element) =>
            element.hobby == _user?.hobby || element.study == _user?.study);
        myFriendSugesstionList = List.from(list);

        return Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                Text('Find Friends',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22)),
                DefaultTabController(
                    length: 2, // length of tabs
                    initialIndex: 0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: TabBar(
                              indicatorColor: themeProvider.isDarkMode
                                  ? Color(0xff03dac6)
                                  : Color.fromARGB(255, 224, 45, 45),
                              tabs: [
                                Tab(text: 'Suggested for you'),
                                Tab(text: 'Discover People'),
                              ],
                            ),
                          ),
                          Container(
                              height: 400, //height of TabBarView
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                              child: TabBarView(children: <Widget>[
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: myFriendSugesstionList.length,
                                  itemBuilder: (context, index) =>
                                      AddFriendCard(
                                          snap: myFriendSugesstionList[index]),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: newFriendsList.length,
                                  itemBuilder: (context, index) =>
                                      AddFriendCard(
                                          snap: newFriendsList[index]),
                                ),
                              ]))
                        ])),
              ]),
        );
      },
    );
  }
}
