import 'package:first_app/misc/utils.dart';
import 'package:first_app/resources/auth.method.dart';
import 'package:first_app/screen/signup_screen.dart';
import 'package:first_app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

import '../responsive/mobile_screen_layout.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void LoginUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().LoginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MobileScreenLayout(),
        ),
      );
    } else {
      ShowSnackBar(res, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  void NavigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUp()));
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
                      Image.asset(
                        "assets/images/login.jpg",
                        width: double.infinity,
                        height: 350,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Login Now',
                                style: TextStyle(
                                  fontSize: 33,
                                  fontFamily: "Poppins-Regular",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFieldInput(
                              textEditingController: _emailController,
                              textInputType: TextInputType.emailAddress,
                              hintText: 'Email ID',
                              iconType: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFieldInput(
                              textEditingController: _passwordController,
                              textInputType: TextInputType.text,
                              hintText: 'Password',
                              isPass: true,
                              iconType: const Icon(Icons.lock_outline),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Poppins-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
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
                                onPressed: LoginUser,
                                onHover: (value) {},
                                child: _isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'New User?',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: NavigateToSignUp,
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
    );
  }
}
