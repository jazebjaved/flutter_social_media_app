import 'package:first_app/resources/auth.method.dart';
import 'package:first_app/screen/login_screen.dart';
import 'package:first_app/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
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
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/registration.jpg",
                        width: double.infinity,
                        height: 280,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
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
                            Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-photo/expressive-redhead-bearded-man-with-hat_176420-32268.jpg?w=900&t=st=1674335508~exp=1674336108~hmac=7096c14c90da07b8eab01c4761c68488118f7830bf777129e81aef0a96e37966'),
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
                              textEditingController: _emailController,
                              textInputType: TextInputType.emailAddress,
                              hintText: 'Email ID',
                              iconType: Icon(Icons.email_outlined),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _usernameController,
                              textInputType: TextInputType.text,
                              hintText: 'Username',
                              iconType: Icon(Icons.verified_user_outlined),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _passwordController,
                              textInputType: TextInputType.text,
                              hintText: 'Password',
                              isPass: true,
                              iconType: const Icon(Icons.lock_outline),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: _bioController,
                              textInputType: TextInputType.multiline,
                              hintText: 'Bio',
                              iconType: Icon(Icons.content_copy),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(13),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: signUpUser,
                                onHover: (value) {},
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Register',
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
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    onTap: navigateToLogin,
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
