import 'package:firebase_database/firebase_database.dart';

class Message {
  String from;
  String to;
  String text;
  String dateString;
  String imageUrl;

  Message(DataSnapshot snapshot) {
    Map value= snapshot.value;

    from = value["from"];
    to = value["to"];
    text = value["text"];
    dateString = value["dateString"];
    imageUrl = value["imageUrl"];
  }
}