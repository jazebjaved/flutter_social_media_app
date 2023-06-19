import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screen/profile_screen.dart';
import 'package:first_app/widgets/add_friend_card.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as UserModel;
import '../widgets/friend_suggestion.dart';
import '../widgets/my_drawer_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel.User> _list = [];

  bool _isShowUser = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
      ),
      drawer: const MyHeaderDrawer(),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: TextFormField(
              controller: _searchController,
              onFieldSubmitted: (String _) {
                setState(() {
                  _isShowUser = true;
                });
              },
              decoration: const InputDecoration(
                filled: true, //<-- SEE HERE
                labelText: 'Search Friends',
                prefixIcon: Icon(Icons.emoji_people_outlined),

                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
              ),
            ),
          ),
          _isShowUser
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('user')
                      .where('username',
                          isGreaterThanOrEqualTo: _searchController.text)
                      .get(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (_searchController.text.isEmpty) {
                        return const Text('Enter User Name before');
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No User Found',
                          ),
                        );
                      }
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => UserModel.User.fromSnap(e))
                              .toList() ??
                          [];

                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: _list[index].uid,
                                  ),
                                ),
                              ),
                              child: AddFriendCard(snap: _list[index]),
                            );
                          });
                    } else {
                      //if the process is not finished then show the indicator process
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
                )
              : const FriendSuggestion(),
        ]),
      ),
    );
  }
}
