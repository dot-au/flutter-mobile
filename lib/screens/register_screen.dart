import 'package:dot_mobile/screens/Login.dart';
import 'package:dot_mobile/screens/Verification.dart';
import 'package:dot_mobile/themes.dart';
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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

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
            child: _buildTextFormField(
                hintText: "Email Address",
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
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, top: 15.0),
            child: _buildTextFormField(
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
                  await Get.to(() => Verification());

                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
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

  Widget _buildTextFormField({
    required String hintText,
    required IconData icon,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorThemes.primaryColor,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Icon(
            icon,
            color: ColorThemes.primaryColor,
          ),
        ),
        prefixStyle: TextStyle(color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
