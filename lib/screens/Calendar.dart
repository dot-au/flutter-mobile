import 'package:dot_mobile/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Calendar extends StatelessWidget {
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
                  "Forget Password",
                  style: Get.textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("Enter the email address associated with your account",
                    style: Get.textTheme.bodyText1),
                ForgetForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class ForgetForm extends StatefulWidget {
  const ForgetForm({Key? key}) : super(key: key);

  @override
  ForgetFormState createState() {
    return ForgetFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ForgetFormState extends State<ForgetForm> {
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
            padding: const EdgeInsets.only(bottom: 36.0, top: 48.0),
            child: _buildTextFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24.0),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ButtonThemes.elevatedButtonThemeLight(),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: Text(
                'RESET PASSWORD',
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

  Widget _buildTextFormField() {
    return TextFormField(
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter information';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Email Address",
        hintStyle: TextStyle(
          color: ColorThemes.primaryColor,

          // fontWeight: FontWeight.bold,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Icon(
            Icons.email_outlined,
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
      ),
    );
  }
}
