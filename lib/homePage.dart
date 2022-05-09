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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final String userID = userInfo().getID();
  int _selectedIndex = 0;
  var medList = [];
  _HomePageState(){
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
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: All',
    ),
    Text(
      'Index 1: Bottle',
    ),
    Text(
      'Index 2: School',
    ),
    Text(
      'Index 3: Settings',
    ),
  ];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("Name",

                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),

                  Text("Dosage",

                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                  Text("Type",

                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                  Text("Time",

                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),

                ],
              ),
              Flexible(
                  child: ListView.builder(
                      itemCount: medList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                              ),
                              color: Colors.indigo.withOpacity(0.1),
                            ),
                            margin: EdgeInsets.only(top: 2,bottom: 2, right: 10, left: 10),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 100,
                                child: TextButton(
                                  onPressed: (){},
                                  child: Text('${medList[index]['medName']}',
                                    textAlign: TextAlign.left,),
                                ),
                              ),
                              Container(
                                width: 40,
                                child: TextButton(
                                  onPressed: (){},
                                  style: TextButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.4)),
                                  child: Text('${medList[index]['pills']}'),
                                ),
                              ),
                              Container(
                                width: 70,
                                child: TextButton(
                                  onPressed: (){},
                                  child: Text('${medList[index]['Type']}'),
                                ),
                              ),
                              Container(
                                width: 70,
                                child: TextButton(
                                  onPressed: (){},
                                  style: TextButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.4)),
                                  child: Text('${medList[index]['hour']}' + ':' + '${medList[index]['min']}'),
                                ),
                              ),



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
    );

  }
}
