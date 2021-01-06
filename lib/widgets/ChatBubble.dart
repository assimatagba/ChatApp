import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/DateHelper.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/model/Message.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:flutter_chat/widgets/CustomImage.dart';
import 'package:flutter/animation.dart';

class ChatBubble extends StatelessWidget {
  Message message;
  MyUser partenaire;
  Animation animation;
  String myId = FirebaseHelper().auth.currentUser.uid;

  ChatBubble(this.message, this.partenaire, this.animation);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bubble(myId == message.from),
        ),
      ),
    );
  }


  List<Widget> bubble(bool moi) {
    CrossAxisAlignment alignment = (moi) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color color = (moi) ? Colors.lightBlue : Colors.white60;

    return <Widget> [
      (moi) ? Padding(padding: EdgeInsets.all(5)) : CustomImage(partenaire.imageUrl, partenaire.initiales, 15),
      Expanded( // bulle grossissent selon la taille desiré
          child: Column(
            crossAxisAlignment: alignment,
            children: <Widget>[
              Text(DateHelper().convert(message.dateString)),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: color,
                child: Container(
                  padding: EdgeInsets.all((message.imageUrl != null) ? 0 : 10) ,
                  child:
                  (message.imageUrl != null)
                    ? CustomImage(message.imageUrl, null, null)
                    : Text(message.text ?? ""),
                ),
              )
            ],
          )
      )
    ];
  }
}