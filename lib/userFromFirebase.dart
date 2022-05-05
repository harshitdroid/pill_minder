import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pill_minder/userInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class userFromFirebase{
  var medicineList = [];
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection(uid).get().then(QuerySnapshot){
    print("successfully oaded")
  }
}