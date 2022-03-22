import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
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
        title: Text('Sign Up'),
      ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          child: Image(
            image: NetworkImage('https://i.ibb.co/pJfR7yw/Pill-Tracker-Logo.png'),
          ),
        ),
        //   TextField(
        //     controller: usernameController,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     labelText: 'Username',
        //   ),
        // ),
        Container(
          width: 350,
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'E-mail',
            ),
          ),
        ),

        SizedBox(
          height: 10,
        ),
        Container(
          width: 350,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Password',
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FlutterPwValidator(
            controller: passwordController,
            minLength: 6,
            uppercaseCharCount: 1,
            numericCharCount: 3,
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
        ElevatedButton(
          child: Text('sign up'),
          onPressed: () async {
            //1. get email and password typed
            print(usernameController.text);
            print(emailController.text);
            print(passwordController.text);

            //2. send it to firebase auth
            try {
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
              }
            } catch (e) {
              print(e);
            }
          },
        )
      ],
    ),
    );

  }
}
