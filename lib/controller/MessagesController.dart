import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/ChatController.dart';
import 'package:flutter_chat/model/Conversation.dart';
import 'package:flutter_chat/model/DateHelper.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/widgets/CustomImage.dart';

class MessagesController extends StatefulWidget {
  MessagesControllerState createState() => MessagesControllerState();
}

class MessagesControllerState extends State<MessagesController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String uid = FirebaseHelper().auth.currentUser.uid;
    return FirebaseAnimatedList(
        query: FirebaseHelper().entry_conversation.child(FirebaseHelper().auth.currentUser.uid),

        itemBuilder: (BuildContext ctx, DataSnapshot snap, Animation<double> animation, int index) {
          Conversation conversation = Conversation(snap);
          String sub = (conversation.uid == uid ) ? "Moi: " : "";
          sub += ("${conversation.msg}");
          return ListTile(
            leading: CustomImage(conversation.user.imageUrl, conversation.user.initiales, 20),
            title: Text(conversation.user.fullName()),
            subtitle: Text(sub),
            trailing: Text(DateHelper().convert(conversation.date)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext ctx){
                    return ChatController(conversation.user);
                  }
              ));
            },
          );
        }
    );
  }
}