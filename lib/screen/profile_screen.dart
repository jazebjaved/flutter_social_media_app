import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/misc/utils.dart';
import 'package:first_app/models/post.dart';
import 'package:first_app/provider/user_provider.dart';
import 'package:first_app/resources/auth.method.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/screen/edit_profile.dart';
import 'package:first_app/screen/login_screen.dart';
import 'package:first_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;
import '../resources/chatApi.dart';
import 'chatting_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Post> _list = [];
  late UserModel.User _userList;

  int postLen = 0;
  int following = 0;
  int followers = 0;
  bool isfollowing = false;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    // updateFollowers();
  }

  Future getData() async {
    setState(() {
      isloading = true;
    });
    try {
      //for post lenghth
      QuerySnapshot<Map<String, dynamic>> postSnap = await FirebaseFirestore
          .instance
          .collection('post')
          .where('uid', isEqualTo: widget.uid)
          .get();
      final data = postSnap.docs;
      _list = data.map((e) => Post.fromJson(e)).toList();
      postLen = postSnap.docs.length;

      setState(() {});
    } catch (e) {
      ShowSnackBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  // Future updateFollowers() async {
  //   try {
  //     DocumentSnapshot userSnap2 = await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(widget.user.uid)
  //         .get();
  //     _userList = UserModel.User.fromSnap(userSnap2);
  //     //for post lenghth

  //     followers = _userList.followers.length;
  //     following = _userList.following.length;
  //     isfollowing =
  //         _userList.followers.contains(FirebaseAuth.instance.currentUser!.uid);

  //     setState(() {});
  //   } catch (e) {
  //     ShowSnackBar(e.toString(), context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).getUser;
    return isloading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
              ),
              actions: [
                if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
                  IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    tooltip: 'Open shopping cart ',
                    onPressed: () async {
                      await AuthMethods().LogOutUser();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Login())); // handle the press
                    },
                  ),
              ],
            ),
            body: StreamBuilder(
                stream: ChatApi().updateFollowers(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data;
                  _userList = UserModel.User.fromSnap(data!);
                  followers = _userList.followers.length;
                  following = _userList.following.length;
                  isfollowing = _userList.followers
                      .contains(FirebaseAuth.instance.currentUser!.uid);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: Colors.red,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                _userList.photoUrl,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            _userList.username,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Center(
                          child: Text(
                            _userList.bio,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 82, 79, 79)),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 73,
                                child: Column(
                                  children: [
                                    Text(
                                      postLen.toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 121, 118, 118)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 73,
                                child: Column(
                                  children: [
                                    Text(
                                      following.toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'Followings',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 121, 118, 118)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 73,
                                child: Column(
                                  children: [
                                    Text(
                                      followers.toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 121, 118, 118)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        backgroundColor:
                                            const Color(0xFFEE0F38),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 48, vertical: 14)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditProfileScreen(
                                                      user: _userList)));
                                    },
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  )
                                : isfollowing
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            backgroundColor:
                                                const Color(0xFFEE0F38),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 48, vertical: 14)),
                                        onPressed: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            _userList.uid,
                                          );
                                          setState(() {
                                            isfollowing = false;

                                            // updateFollowers();
                                          });
                                        },
                                        child: const Text(
                                          'Unfollow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      )
                                    : TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            backgroundColor:
                                                const Color(0xFFEE0F38),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 48, vertical: 14)),
                                        onPressed: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            _userList.uid,
                                          );
                                          setState(() {
                                            isfollowing = true;
                                            // updateFollowers();
                                          });
                                        },
                                        child: const Text(
                                          'Follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (FirebaseAuth.instance.currentUser!.uid !=
                                widget.uid)
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(58, 244, 67, 54),
                                radius: 28,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ChattingScreen(
                                                user: _userList)));
                                  },
                                  icon: const Icon(
                                    Icons.chat_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor:
                                  const Color.fromARGB(57, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 14)),
                          onPressed: () {},
                          child: const Text(
                            'Photos',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('post')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: ((context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Post yet',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }

                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        ['postPicUrl'],
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  );
                                  // Image.network(
                                  //     snapshot.data!.docs[index]['postPicUrl']);
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                              );
                            } else {
                              //if the process is not finished then show the indicator process
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                        )
                      ],
                    ),
                  );
                }),
          );
  }
}
