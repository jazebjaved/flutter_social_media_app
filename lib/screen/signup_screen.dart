import 'package:first_app/resources/auth.method.dart';
import 'package:first_app/screen/login_screen.dart';
import 'package:first_app/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../misc/utils.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _studyController = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  Uint8List? _image;
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    dateinput.dispose();
    _hobbyController.dispose();
    _studyController.dispose();
  }

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

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
      dob: dateinput.text,
      hobby: _hobbyController.text,
      study: _studyController.text,
    );

    if (res != 'success') {
      ShowSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image.asset(
                      //   "assets/images/registration2.jpg",
                      //   width: double.infinity,
                      // ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Wrap(
                          runSpacing: 15,
                          children: [
                            // const Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Text(
                            //     'Sign up',
                            //     style: TextStyle(
                            //         fontSize: 33,
                            //         fontFamily: "Poppins-Regular",
                            //         fontWeight: FontWeight.w800,
                            //         color: Color.fromARGB(213, 45, 44, 44)),
                            //   ),
                            // ),
                            Center(
                              child: Stack(
                                children: [
                                  _image != null
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage: MemoryImage(_image!),
                                        )
                                      : const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/profile_avatar.png'),
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
                            ),

                            TextFieldInput(
                              textEditingController: _emailController,
                              textInputType: TextInputType.emailAddress,
                              hintText: 'Email ID',
                              iconType: const Icon(Icons.email_outlined),
                            ),

                            TextFieldInput(
                              textEditingController: _usernameController,
                              textInputType: TextInputType.text,
                              hintText: 'Username',
                              iconType: const Icon(
                                Icons.verified_user_outlined,
                              ),
                            ),

                            TextFieldInput(
                              textEditingController: _passwordController,
                              textInputType: TextInputType.text,
                              hintText: 'Password',
                              isPass: true,
                              iconType: const Icon(
                                Icons.lock_outline,
                              ),
                            ),

                            TextField(
                              controller:
                                  dateinput, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Date of Birth" //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        1950), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    dateinput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ),

                            TextFieldInput(
                              textEditingController: _bioController,
                              textInputType: TextInputType.multiline,
                              hintText: 'Bio',
                              iconType: const Icon(Icons.content_copy),
                            ),
                            TextFieldInput(
                              textEditingController: _hobbyController,
                              textInputType: TextInputType.text,
                              hintText: 'Hobbies, e.g  book reading etc. ',
                              iconType: const Icon(Icons.content_copy),
                            ),

                            TextFieldInput(
                              textEditingController: _studyController,
                              textInputType: TextInputType.text,
                              hintText:
                                  'Field of Study, e.g  Biology, IT etc. ',
                              iconType: const Icon(Icons.read_more_outlined),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(13),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: signUpUser,
                                onHover: (value) {},
                                child: isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Joined Before?',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: navigateToLogin,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
