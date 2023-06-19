import 'package:first_app/misc/utils.dart';
import 'package:first_app/provider/user_provider.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/responsive/mobile_screen_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as UserModel;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select Option'),
            children: [
              SimpleDialogOption(
                child: const Text('Take photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file2 = await pickImage(ImageSource.camera);
                  Uint8List file = await testComporessList(file2);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file2 = await pickImage(ImageSource.gallery);
                  Uint8List file = await testComporessList(file2);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
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

  creatPost(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().UploadPost(
        description: _descriptionController.text,
        uid: uid,
        profImage: profImage,
        username: username,
        file: _file!,
      );
      if (res == "success") {
        setState(() {
          ShowSnackBar('Posted', context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MobileScreenLayout()));
          _isLoading = false;
        });
      } else {
        setState(() {
          ShowSnackBar(res, context);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        ShowSnackBar(e.toString(), context);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel.User? user = Provider.of<UserProvider>(context).getUser;
    return Row(
      children: [
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              // leading: IconButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   icon: const Icon(Icons.arrow_back),
              // ),
              title: const Text('Create Post'),
              actions: [
                IconButton(
                  icon: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(Icons.send_outlined),
                  onPressed: () {},
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading ? const LinearProgressIndicator() : Container(),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    height: 250,
                    decoration: _file != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                            ),
                          )
                        : BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    child: _file != null
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _file = null;
                                });
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              ),
                            ),
                          )
                        : Center(
                            child: IconButton(
                              onPressed: () {
                                _selectImage(context);
                              },
                              icon: const Icon(Icons.upload_file_outlined),
                              iconSize: 30,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.84,
                      child: Column(
                        children: [
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Text(
                          //     'Description',
                          //     style: TextStyle(
                          //         fontSize: 28, fontWeight: FontWeight.w800),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 13,
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: 'Write a Caption.....',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                )),
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: _file == null
                                    ? const Color.fromARGB(58, 238, 15, 56)
                                    : Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 16)),
                            onPressed: _file == null
                                ? null
                                : () => creatPost(
                                      user!.uid,
                                      user.username,
                                      user.photoUrl,
                                    ),
                            child: const Text(
                              'Post',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
