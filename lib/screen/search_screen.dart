import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screen/profile_screen.dart';
import 'package:first_app/widgets/add_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Friends')),
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
                  fillColor: Colors.white,
                  labelText: 'Search Friends',
                  prefixIcon: Icon(Icons.emoji_people_outlined),

                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                )),
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
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]['uid'],
                                  ),
                                ),
                              ),
                              child: AddFriendCard(
                                  snap: snapshot.data!.docs[index]),
                            );
                          });
                    } else {
                      //if the process is not finished then show the indicator process
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                )
              : const Text('post'),
        ]),
      ),
    );
  }
}
