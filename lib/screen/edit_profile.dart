import 'package:first_app/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../misc/utils.dart';
import '../models/user.dart' as UserModel;
import '../resources/auth.method.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel.User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _image;
  bool isLoading = false;

  void selectImage() async {
    Uint8List img2 = await pickImage(ImageSource.gallery);
    Uint8List img = await testComporessList(img2);
    setState(() {
      _image = img;
    });
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

  @override
  Widget build(BuildContext context) {
    String uid = widget.user.uid;

    final TextEditingController emailController =
        TextEditingController(text: widget.user.email);
    final TextEditingController usernameController =
        TextEditingController(text: widget.user.username);
    final TextEditingController bioController =
        TextEditingController(text: widget.user.bio);

    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      emailController.dispose();
      usernameController.dispose();
      bioController.dispose();
    }

    void updateUserProfile() async {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().updateProfile(
        uid: uid,
        email: emailController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: _image,
      );

      if (res != 'success') {
        ShowSnackBar(res, context);
      } else {
        ShowSnackBar('You have succussfully update your profile', context);
      }
      print(res.toString());
      setState(() {
        isLoading = false;
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
                body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(widget.user.photoUrl),
                                    ),
                              Positioned(
                                bottom: -12,
                                right: 10,
                                child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldInput(
                            textEditingController: emailController,
                            textInputType: TextInputType.emailAddress,
                            hintText: 'Email ID',
                            iconType: const Icon(Icons.email_outlined),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldInput(
                            textEditingController: usernameController,
                            textInputType: TextInputType.text,
                            hintText: 'Username',
                            iconType: const Icon(Icons.verified_user_outlined),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldInput(
                            textEditingController: bioController,
                            textInputType: TextInputType.multiline,
                            hintText: 'Bio',
                            iconType: const Icon(Icons.content_copy),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(13),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: updateUserProfile,
                              onHover: (value) {},
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Update',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 21,
                                          fontWeight: FontWeight.w500),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
