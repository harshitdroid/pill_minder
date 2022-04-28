import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pill_minder/Sign%20up%20Page.dart';
import 'package:pill_minder/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Welcome to Pill Tracker'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  int _counter = 0;
  bool isChecked = false;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            width: 350,
            height: 200,
            child: Image(
                  image: NetworkImage('https://i.ibb.co/pJfR7yw/Pill-Tracker-Logo.png'),
            ),
          ),
          Container(
            width: 350,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
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
                labelText: 'Password',
              ),
            ),
            ),
            Row(
              children: [
                SizedBox(
                width: 10,
                ),
                Checkbox(value: isChecked ,onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),

                Text('Remember me',
                  style: TextStyle(fontSize: 12),)
              ],

            ),


            Row(children:[
              Spacer(flex: 3),
              Expanded(
                flex: 25,
                child: ElevatedButton(onPressed: () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                      .then((value) {
                    // Disable persistence on web platforms
                    //await FirebaseAuth.instance.setPersistence(Persistence.NONE);
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1), // default 4s
                      content: const Text('Logged In'),
                    ),
                    );
                  print("Login Successfully");

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  }).catchError((error){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1), // default 4s
                        content: const Text('Invalid Email/Password'),
                      ),
                    );

                  print("Failed to login");
                  print(error.toString());
                      });
              },
                child: Text('Login'),

              ),
              ),
              Spacer(flex: 3),
             Expanded(
               flex: 25,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     primary: Colors.red.shade700,
                   ),
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => SignUp()),
                     );
                   },
                   child: Text(
                       'Sign up'
                   ),
                 ),
             ),
              Spacer(flex: 3)
            ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text('Forgot Password?',
                style: TextStyle(fontSize: 12),)
              ],

            )

          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => HomePage()),
      //     );
      //   },
      //   backgroundColor: Colors.blue.shade200,
      //   child: const Icon(Icons.add),
      // ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
