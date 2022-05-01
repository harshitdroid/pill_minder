import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          child: const Image(
            image: const NetworkImage('https://i.ibb.co/pJfR7yw/Pill-Tracker-Logo.png'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
          Container(
            width: 350,
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 350,
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-mail',
            ),
          ),
        ),

        const SizedBox(
          height: 10,
        ),
        Container(
          width: 350,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Enter Password',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: const Text('sign up'),
          onPressed: () async {
            //1. get email and password typed
            print(usernameController.text);
            print(emailController.text);
            print(passwordController.text);
            var timeStamp = new DateTime.now().millisecondsSinceEpoch;
            //2. send it to firebase auth
            FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
                .then((authResult) {
                  String? userID = authResult.user?.uid.toString();
              var userProfile = {
                'uid' : authResult.user?.uid,
                'Name' : usernameController.text,
                'email' : emailController.text,
              };
              FirebaseDatabase.instance.ref().child("users/" + userID.toString())
                  .set(userProfile)
                  .then((value) => {

              }).catchError((error) {

              });
            });

          },

        ),

        FlutterPwValidator(
            controller: passwordController,
            minLength: 6,
            uppercaseCharCount: 1,
            numericCharCount: 1,
            specialCharCount: 1,
            width: 400,
            height: 150,
          onSuccess: () {
            print("MATCHED");
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                content: new Text("Password is matched")));
          },
          onFail: () {
            print("NOT MATCHED");
          },
        ),

      ],
    ),

    );

  }

}
