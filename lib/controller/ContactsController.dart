import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/ChatController.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:flutter_chat/widgets/CustomImage.dart';

class ContactsController extends StatefulWidget {
  ContactsControllerState createState() => ContactsControllerState();
}

class ContactsControllerState extends State<ContactsController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FirebaseAnimatedList(
      // Recuperer les utilisateurs
        query: FirebaseHelper().entry_user,
        sort: (a, b) => (a.value["prenom"].toString().toLowerCase()).compareTo(b.value["prenom"].toString().toLowerCase()),
        itemBuilder: (BuildContext cxt, DataSnapshot snap, Animation<double> animation, int index ) {
          MyUser newUser = MyUser(snap);
          // Afficher tous les user sauf le current user
          if ( FirebaseHelper().auth.currentUser.uid == newUser.uid) {
              return Container();
          } else {
            return ListTile(
              leading: CustomImage(newUser.imageUrl, newUser.initiales, 20), // afficher les images
              title: Text(newUser.fullName()),
              trailing: IconButton( // Icone pour envoyer un message
                icon: Icon(Icons.message),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) {
                            return ChatController(newUser);
                          }
                      ));
                },
              ),
            );
          }
        }
    );
  }
}