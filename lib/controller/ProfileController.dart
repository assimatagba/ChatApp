
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:flutter_chat/widgets/CustomImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;


class ProfileController extends StatefulWidget {
  ProfileControllerState createState() => ProfileControllerState();
}

class ProfileControllerState extends State<ProfileController> {

  String prenom;
  String nom;

  MyUser me;

  User user = FirebaseHelper().auth.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (me == null)
        ? Center(child: Text("Chargement..."),)
        : SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomImage(me.imageUrl, me.initiales, MediaQuery.of(context).size.width / 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.camera_enhance),
                        onPressed: () {
                          _takeAPic(ImageSource.camera);
                        },
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () {
                        _takeAPic(ImageSource.gallery);
                      },
                    )
                  ],
                ),
                TextField(
                  decoration: InputDecoration(hintText: me.prenom),
                  onChanged: (str) {
                    setState(() {
                      prenom = str;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: me.nom),
                  onChanged: (str) {
                    setState(() {
                      nom = str;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Sauvegarder"),
                    onPressed: saveChanges,
                ),
                FlatButton(
                  child: Text("Se deconnecter"),
                  onPressed: logOut,
                ),
              ],
            ),
          ),
    );
  }

  Future<void> logOut() async {
    Text title = Text("Se deconnecter");
    Text content = Text("Etes vous sure de vouloir vous deconnecter");
    FlatButton noBtn = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Non")
    );

    FlatButton yesBtn = FlatButton (
      child: Text("Oui"),
      onPressed: () {
        FirebaseHelper().handleLogOut().then((bool) {
          Navigator.of(context).pop();
        });
      },
    );
    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(title: title, content: content, actions: <Widget>[yesBtn, noBtn],)
              : AlertDialog(title: title, content: content, actions: <Widget>[yesBtn, noBtn],);
    }
    );
  }

  // Sauvegarder nos donnees
  saveChanges() {
    Map map = me.toMap();
    if (prenom != null && prenom != "") {
      map["prenom"] = prenom;
    }
    if (nom != null && prenom != "") {
      map["nom"] = nom;
    }
    FirebaseHelper().addUser(me.uid, map);
    _getUser();
  }

  _getUser() {
    FirebaseHelper().getUser(user.uid).then((me) {
      setState(() {
        this.me = me;
      });
    });
  }


  // Fonction pour prendre une photo

  Future<void> _takeAPic(ImageSource source) async {
    PickedFile img = await ImagePicker().getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (img != null ) {
      io.File file = io.File(img.path);
      FirebaseHelper().savePic(file, FirebaseHelper().entryUser.child(me.uid)).then((str) {
        // Add User
        Map map = me.toMap();
        map["imageUrl"] = str;
        FirebaseHelper().addUser(me.uid, map);
        _getUser();
      });
    }
  }
  /*Future<void> _takeAPic(ImageSource source) async {
    PickedFile img = await ImagePicker().getImage(source: source, maxWidth: 500, maxHeight: 500 );
    if (img != null ) {
      io.File file = io.File(img.path);
      FirebaseHelper().savePic(file, FirebaseHelper().entryUser.child(me.uid)).then((str){
        // Add user
        Map map = me.toMap();
        map["imageUrl"] = str;
        FirebaseHelper().addUser(me.uid, map);
        _getUser();
      });
    }
  }*/

}