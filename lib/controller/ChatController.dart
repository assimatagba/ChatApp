import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/model/Message.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:flutter_chat/widgets/ChatBubble.dart';
import 'package:flutter_chat/widgets/CustomImage.dart';
import 'package:flutter_chat/widgets/ZoneDeTexte.dart';

class ChatController extends StatefulWidget {
  MyUser partenaire;

  // constructeur pour savoir avec qui on dialogue
  ChatController(this.partenaire);

  ChatControllerState createState() => ChatControllerState();
}

class ChatControllerState extends State<ChatController> {

  MyUser me;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String uid = FirebaseHelper().auth.currentUser.uid;
    FirebaseHelper().getUser(uid).then((user) {
      setState(() {
        this.me = user;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomImage(widget.partenaire.imageUrl, widget.partenaire.initiales, 20),
            Text(widget.partenaire.fullName()),
          ],
        )
      ),
        body: InkWell(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // fermerle clavier si on appuie n'importe ou
          child: Column(
            children: <Widget>[
              Flexible(
                  child: (me != null)
                      ? FirebaseAnimatedList(
                      query: FirebaseHelper().entry_message.child(FirebaseHelper().getMessageRef(me.uid, widget.partenaire.uid)),
                      sort: (a, b) => b.key.compareTo(a.key),
                      reverse: true,
                      itemBuilder: (BuildContext ctx, DataSnapshot snap, Animation<double> animation, int index) {
                        Message msg = Message(snap);
                        return ChatBubble(msg, widget.partenaire, animation);
                      }
                  )
                      : Center(child: Text("Chargement"),)
              ),
              Divider(height: 2,),
              ZoneDeTexte(widget.partenaire, me)
            ],
          ),
        )
    );
  }
}