import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/model/MyUser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;



// Creation de la base pour acceder facilement a firebase
class FirebaseHelper {

  // Authentification

  final auth = FirebaseAuth.instance;

  // Authentification avec un user existant
  Future<User> handleSignIn( String mail, String mdp) async {
    final User user = (await auth.signInWithEmailAndPassword(email: mail, password: mdp)).user;
    return user;
  }

  Future<bool> handleLogOut() async {
    await auth.signOut();
    return true;
  }

  // Creation d'un user existant
  Future<User> create(String mail, String mdp, String prenom, String nom) async {
    final create = await auth.createUserWithEmailAndPassword(email: mail, password: mdp);
    final User user = create.user;
    String uid = user.uid;
    Map<String, String> map = {
      "prenom": prenom,
      "nom": nom,
      "uid": uid,
    };
    addUser(uid, map);

    return user;
  }

  sendMessage(MyUser me, MyUser partenaire, String texte, String imageUrl) {
    // 1 id1 + id2
    String ref = getMessageRef(me.uid, partenaire.uid);
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    //String date = DateTime.now().toString();
    Map map = {
      "from": me.uid,
      "to": partenaire.uid,
      "text": texte,
      "dateString": DateTime.now().millisecondsSinceEpoch.toString(),
      "imageUrl": imageUrl,
      //"dateString": DateTime.now().toString(),
    };

    entry_message.child(ref).child(date).set(map);
    // Notification de dernier message de conversation
    // notif au partenaire
    entry_conversation.child(me.uid).child(partenaire.uid).set(setConversation(partenaire, me.uid, texte, date));
    // notif a moi
    entry_conversation.child(partenaire.uid).child(me.uid).set(setConversation(me, me.uid, texte, date));
  }
  
  setConversation(MyUser user, String sender, String last, String dateString) {
    // 1 view User, lastMessage, Date
    Map map = user.toMap();
    map["myID"] = sender;
    map["lastMsg"] = last;
    map["dateString"] = dateString;
    
    return map;
  }

  getMessageRef(String from, String to) {
    List<String> list = [from, to];
    list.sort((a, b) => a.compareTo(b));
    String ref = "";
    for (var x in list ) {
      ref += x + "+";
    }
    return ref;
  }

  // Database

  static final entryPoint = FirebaseDatabase.instance.reference(); // point d'entrée db
  final entry_user = entryPoint.child("users"); // point d'entrée users
  final entry_message = entryPoint.child("messages"); // point d'entrée messages
  final entry_conversation = entryPoint.child("conversations"); // point d'entrée conversation

  // Ajouter un user
  addUser(String uid, Map map) {
    entry_user.child(uid).set(map);
  }

  // Recuperer un user
  Future<MyUser> getUser(String uid) async {
    DataSnapshot snapshot = await entry_user.child(uid).once(); // une seule recuperation
    MyUser user = MyUser(snapshot);
    return user;
  }
  
  
  // Enregistrer les images

  static final entryStorage = FirebaseStorage.instance.ref();
  final entryUser = entryStorage.child('users');
  final entryMessage = entryStorage.child("messages");


  Future<String> savePic(io.File file, Reference reference) async {
    UploadTask task = reference.putFile(file);
    TaskSnapshot snap = await task;
    String url = await snap.ref.getDownloadURL();
    return url;

  }
}