import 'package:dot_mobile/screens/register_screen.dart';
import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Log In",
                  style: Get.textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SignInForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await Get.to(() => RegisterScreen());
              },
              style: ButtonThemes.textButtonThemeWithScaffoldBackground(),
              child: Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  children: [
                    TextSpan(
                        text: "Register",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        )),
                    // can add more TextSpans here...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, top: 42.0),
            child: CustomTextFormField(
              key: Key("emailInput"),
              hintText: "Email Address",
              controller: emailController,
              icon: Icons.email_outlined,
              validator: (value) {
                const errorMessage = "Email is invalid";
                if (value == null) {
                  return errorMessage;
                }

                final isValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);

                if (!isValid) {
                  return errorMessage;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 15.0),
            child: CustomTextFormField(
              controller: passwordController,
              key: Key("passwordInput"),
              hintText: "Password",
              icon: Icons.password_outlined,
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 8) {
                  return "Password must be at least 8 characters.";
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24.0),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ButtonThemes.elevatedButtonThemeLight(),
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    await Get.offAll(
                      () => HomeScreen(),
                      transition: Transition.fadeIn,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found' ||
                        e.code == 'wrong-password') {
                      Get.snackbar(
                        "Invalid email or password!",
                        "Please try again!",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                }
              },
              child: Text(
                'SIGN IN',
                style: Get.textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
