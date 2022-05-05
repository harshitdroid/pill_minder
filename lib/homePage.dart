import 'package:flutter/material.dart';
import 'package:pill_minder/addMed.dart';
import 'package:pill_minder/main.dart';
import 'package:pill_minder/profilePage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Username'),
              ),
              ListTile(
                title: const Text('Profile Page'),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => profilePage()));
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Account Settings'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  // Update the state of the app.
                  // ...
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);


                },
              ),
            ],
          ),
        ),
        body: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
        ),


    floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.push(context,
      MaterialPageRoute(builder: (context)=> addMed()));
    // Add your onPressed code here!
    },
    backgroundColor: Colors.blue.shade200,
    child: const Icon(Icons.add),
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline_rounded),
            label: 'Bottle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle),
            label: 'Tablet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Pill',
          ),
        ],
      ),
    );

  }
}
