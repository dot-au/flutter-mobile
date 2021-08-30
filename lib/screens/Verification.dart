import 'package:dot_mobile/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verification extends StatelessWidget {
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
                  "Verification",
                  style: Get.textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("Please type the verication code sent to your email",
                    style: Get.textTheme.bodyText1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, top: 15.0),
                ),
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
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: _buildNumberField(),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: _buildNumberField(),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: _buildNumberField(),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: _buildNumberField(),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: _buildNumberField(),
              ),
              SizedBox(
                width: 20.0,
              ),
              new Flexible(
                child: _buildNumberField(),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text("resent verication code"),
            style:
                ButtonThemes.textButtonThemeWithScaffoldBackground().copyWith(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
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
                'Verify',
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

  Widget _buildNumberField() {
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
