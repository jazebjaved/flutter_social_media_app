import 'dart:io';

import 'package:first_app/misc/utils.dart';
import 'package:first_app/provider/user_provider.dart';
import 'package:first_app/resources/firestore_method.dart';
import 'package:first_app/responsive/mobile_screen_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import '../models/user.dart' as UserModel;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  String? mediaType;
  VideoPlayerController? _controller;
  bool isVideo = false;

  final picker = ImagePicker();
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
                  XFile? file2 =
                      await picker.pickImage(source: ImageSource.camera);
                  final path = File(file2!.path);

                  Uint8List file = await testCompressFile(path);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Pick an Image'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? file2 =
                      await picker.pickImage(source: ImageSource.gallery);
                  final path = File(file2!.path);

                  Uint8List file = await testCompressFile(path);

                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Pick a Video'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? file2 = await picker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  final path = File(file2!.path);
                  print(path.length);

                  //use to compress a video
                  MediaInfo? mediaInfo = await VideoCompress.compressVideo(
                    path.path,
                    quality: VideoQuality.LowQuality,
                    deleteOrigin: false, // It's false by default
                  );

                  // use to convert mediainfo file to File type
                  File? fileType = mediaInfo!.file;

                  // use to convert File type to UNIT8LIst type
                  Uint8List file = fileType!.readAsBytesSync();

                  // Uint8List? file = await VideoCompress.getByteThumbnail(
                  //   path.path,
                  //   quality: 50,
                  // );
                  print(file);

                  final mimeType = lookupMimeType(path.path);
                  final trimmed = mimeType!.split('/').first;
                  print(trimmed);

                  // final thumbnailFile = await VideoCompress.getFileThumbnail(
                  //   path.path,
                  //   quality: 50, // default(100)
                  // );

                  _controller = VideoPlayerController.file(fileType)
                    ..initialize().then((_) {
                      setState(() {});
                      _controller!.play();
                      mediaType = trimmed;
                      _file = file;
                      isVideo = true;
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

  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 25,
    );
    print(file.lengthSync());
    print(result!.length);
    return result;
  }

  creatPost(
    String uid,
    String username,
    String profImage,
    bool isVideo,
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
        isVideo: isVideo,
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
    _controller?.dispose();
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
                  mediaType == "video"
                      ? Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 30),
                          child: Column(
                            children: [
                              Stack(children: [
                                AspectRatio(
                                  aspectRatio: 12 / 15,
                                  child: VideoPlayer(_controller!),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _file = null;
                                        mediaType = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    _controller!.value.isPlaying
                                        ? _controller!.pause()
                                        : _controller!.play();
                                  });
                                },
                                child: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
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
                                    icon:
                                        const Icon(Icons.upload_file_outlined),
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
                                      isVideo,
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
