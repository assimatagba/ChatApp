import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat/model/MyUser.dart';

class Conversation {
  MyUser user;
  String date;
  String msg;
  String uid;

  Conversation(DataSnapshot snapshot) {
    Map map = snapshot.value;
    user = MyUser(snapshot);
    date = map["dateString"];
    msg = map["lastMsg"];
    uid = map["myID"];
  }
}