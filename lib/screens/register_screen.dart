import 'package:dot_mobile/screens/login_screen.dart';
import 'package:dot_mobile/screens/Verification.dart';
import 'package:dot_mobile/themes.dart';
import 'package:dot_mobile/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
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
                  "Register",
                  style: Get.textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                RegisterForm(),
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
                await Get.to(() => Login());
              },
              style: ButtonThemes.textButtonThemeWithScaffoldBackground(),
              child: Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      text: "Sign in",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
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
                  Get.snackbar(
                    "Registering...",
                    "Please wait for a few seconds",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.value.text,
                      password: passwordController.value.text,
                    );
                    await userCredential.user!.sendEmailVerification();
                    await Get.to(() => Login());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      Get.snackbar(
                        "The password provided is too weak.",
                        "Please try another password.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else if (e.code == 'email-already-in-use') {
                      Get.snackbar(
                        "The email is already in use.",
                        "Please try another email.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                }
              },
              child: Text(
                'SIGN UP',
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
