import 'package:firebase_auth/firebase_auth.dart';

class userInfo {
  static String userID = FirebaseAuth.instance.currentUser!.uid;

  getID() {
    return userID;
  }
}