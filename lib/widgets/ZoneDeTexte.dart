import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:image_picker/image_picker.dart';

class ZoneDeTexte extends StatefulWidget {
 MyUser partenaire;
 MyUser me;
 
 ZoneDeTexte(this.partenaire, this.me);
  
 ZoneState createState() => ZoneState();
}

class ZoneState extends State<ZoneDeTexte> {

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(3.5),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.camera_enhance), onPressed: () => takeAPic(ImageSource.camera)),
          IconButton(icon: Icon(Icons.photo_library), onPressed: () => takeAPic(ImageSource.gallery)),
          Flexible(
            child: TextField(
              controller: _controller, // controler ce qu'on saisit
              decoration: InputDecoration.collapsed(hintText: "Saissisez votre message"),
              maxLines: null,
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _sendButtonPressed()
          ),

        ],
      ),
    );
  }

  _sendButtonPressed() {
    print("send");
      if ( _controller.text != null && _controller.text != "" ) {
        String text = _controller.text;
        // 1 send to firebase
        FirebaseHelper().sendMessage(widget.me, widget.partenaire, text, null);
        // 2 Clear textfield
        _controller.clear();
        // 3 Fermer
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        print("Texte vide");
      }
  }

  Future<void> takeAPic(ImageSource source) async {
    PickedFile picked = await ImagePicker().getImage(source: source, maxWidth: 1000, maxHeight: 1000);
    if (picked != null) {
      File file = File(picked.path);
      String date = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseHelper().entryMessage.child(widget.me.uid).child(date);
      // save pic
      FirebaseHelper().savePic(file, ref).then((imageUrl) {
        FirebaseHelper().sendMessage(widget.me, widget.partenaire, null, imageUrl);
      });
    }
  }
}