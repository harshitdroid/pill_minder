import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pill_minder/addMed.dart';
import 'package:pill_minder/main.dart';
import 'package:pill_minder/profilePage.dart';
import 'package:pill_minder/userInfo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateMed extends StatefulWidget {
  const UpdateMed({Key? key}) : super(key: key);

  @override
  _UpdateMed createState() => _UpdateMed();
}


class _UpdateMed extends State<UpdateMed> {
  final String userID = userInfo().getID();
  var medList = [];
  _UpdateMed(){
    refreshList();
    FirebaseDatabase.instance.ref().child(userID).onChildChanged.listen((event) {
      print("Data Changed");
      refreshList();
    });
    FirebaseDatabase.instance.ref().child(userID).onChildRemoved.listen((event) {
      print("Data removed");
      refreshList();
    });
    FirebaseDatabase.instance.ref().child(userID).onChildAdded.listen((event) {
      print("Data Added");
      refreshList();
    });
    FirebaseDatabase.instance.ref().child(userID).onChildMoved.listen((event) {
      print("Data Moved");
      refreshList();
    });
  }
  void refreshList() {
    FirebaseDatabase.instance.ref().child(userID).get()
        .then((datasnapshot) {
      print("Successfully loaded data");
      print(datasnapshot.key);
      print(datasnapshot.value);
      print("Iterating Value");
      var tempList = [];
      for ( var doc in datasnapshot.children) {
        //print("${doc.key} => ${doc.value}");
        tempList.add(doc.value);
      }
      print("Final List");
      print(tempList);
      medList = tempList;
      setState(() {

      });
    }).catchError((error) {
      print("Failed to load data");
    });
  }
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
      body: Container(
        child: Column(
          children: [
            Container(
              child : TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    itemCount: medList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 2,bottom: 2, right: 10, left: 10),
                        color: Colors.orange,
                        child: Row(
                          children: [
                            Text('${medList[index]['medName']}'),
                          ],
                        ),
                      );
                    })
            ),
          ],
        ),

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
