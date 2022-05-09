import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pill_minder/homePage.dart';
import 'package:pill_minder/main.dart';
import 'package:pill_minder/profilePage.dart';
import 'package:pill_minder/userInfo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class addMed extends StatefulWidget {
  const addMed({Key? key}) : super(key: key);
  @override
  _addMedState createState() => _addMedState();
}


class _addMedState extends State<addMed> {
  var addMedicines = [];
  final String userID = userInfo().getID();
  var medNameController = TextEditingController();
  var medTimeController = TextEditingController();
  var medQuantityController = TextEditingController();
  var medmedLeftController = TextEditingController();
  String _hour = "Not set";
  String _minute= "Not set";
  String _sec = "Not set";
  String _date = "Not set";
  String _time = "Not set";
  int hourInt = 0;
  int minInt = 0;
  int secInt = 0;
  var splitted;
  String bottType = "Bottle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication'),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => profilePage()));
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
          ]
          ,
        ),

      ),
        body: Container(
          child:  Column(
         //mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const SizedBox(
             height: 10,
           ),
           Container(
             child : Padding(
               padding: const EdgeInsets.all(10.0),
               child: TextField(
                 controller: medNameController,
                 decoration: const InputDecoration(
                   border: const OutlineInputBorder(),
                   labelText: 'Medicine Name',
                 ),
               ),
             )
          ),
           const SizedBox(
             height: 10,
           ),



           Container(
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: TextField(
               controller: medQuantityController,
               decoration:  InputDecoration(
                 border:  OutlineInputBorder(),

                 labelText: 'Dosage',

               ),
               keyboardType: TextInputType.number,
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly
                 ],
             ),
             ),


           ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    "Type :      ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                Container(
                  child: DropdownButton<String>(
                    value: bottType,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        bottType = newValue!;
                      });
                    },
                    items: <String>['Bottle', 'Tablet', 'Capsule', 'Syringe']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

              ],
            ),

           const SizedBox(
             height: 20,
           ),
          const Text(
              "What time do you want to be reminded",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
                          ),
             ),

           const SizedBox(
             height: 10,
           ),
           Padding(padding: EdgeInsets.all(10.0),
           child:ElevatedButton(

             onPressed: () {
               DatePicker.showTimePicker(context,
                   theme: DatePickerTheme(
                     headerColor: Colors.blue.shade200,
                     containerHeight: 210.0,
                   ),
                   showTitleActions: true, onConfirm: (time) {
                     print('confirm $time\n');
                     _hour = '${time.hour}';
                     _minute = '${time.minute}';
                     _sec = '${time.second}';
                     _time = '${time.hour} : ${time.minute} : ${time.second}';
                     splitted = _time.split(':');
                     hourInt = int.parse(splitted[0]);
                     minInt = int.parse(splitted[1]);
                     secInt = int.parse(splitted[2]);
                     setState(() {});
                   }, currentTime: DateTime.now(), locale: LocaleType.en);
               setState(() {});
             },
             child: Container(
               alignment: Alignment.center,
               height: 50.0,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Row(
                     children: <Widget>[
                       Container(
                         child: Row(
                           children: <Widget>[
                             Icon(
                               Icons.access_time,
                               size: 18.0,
                               //color: Colors.teal,
                             ),
                             Text(
                               " $_time",
                               style: TextStyle(
                                 //color: Colors.teal,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 18.0),
                             ),
                           ],
                         ),
                       )
                     ],
                   ),
                   Text(
                     "  Change",
                     style: TextStyle(
                       //color: Colors.teal,
                         fontWeight: FontWeight.bold,
                         fontSize: 18.0),
                   ),
                 ],
               ),
             ), // color: Colors.white,
            ),
           ),


            Container(
              //padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomCenter,

              child: ElevatedButton(onPressed: (){
                FirebaseFirestore.instance.collection(userID).doc("med" + medNameController.text).set(
                    {
                     "medName" : medNameController.text,
                      "pills" : medQuantityController.text,
                      "hour" : hourInt,
                      "min" : minInt,
                      "sec" : secInt,
                      "time" : '${_time}'
                  }
                ).then((value) {
                  print("Successfully added to firebase");
                }).catchError((error) {
                  print("Failed to add to firebase");
                });
                FirebaseDatabase.instance.ref().child(userID + "/" + medNameController.text).set(
                {
                  "medName" : medNameController.text,
                  "pills" : medQuantityController.text,
                  "hour" : hourInt,
                  "min" : minInt,
                  "sec" : secInt,
                  "time" : '${_time}',
                  "Type" : bottType
                }
                ).then((value) {
                  print("Successfully added to firebase");
                }).catchError((error) {
                  print("Failed to add to firebase");
                });
            },

              child: Text(
                  "Save"
              ),
            ),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
                child: Text('back'),
              ),
            ],)

          ],
        ),
      ),
    );
  }

}
