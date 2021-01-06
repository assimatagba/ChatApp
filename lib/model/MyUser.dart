import 'package:firebase_database/firebase_database.dart';

//
class MyUser {
  String uid;
  String prenom;
  String nom;
  String imageUrl;
  String initiales;

  // Recuperer un utilisateur a partir d'un snapshot de firebase
  MyUser(DataSnapshot snapshot) {
    uid = snapshot.key;
    Map map = snapshot.value;
    prenom = map["prenom"];
    nom = map["nom"];
    imageUrl = map["imageUrl"];
    if (prenom != null && prenom .length > 0){
      initiales = prenom[0];
    }
    if (nom != null && nom.length > 0 ) {
      if (initiales != null) {
        initiales += nom[0];
      } else {
        initiales = nom[0];
      }
    }
  }

  // Fonction qui va convertir et renvoyer une map avec les donnees
  Map toMap() {
    return {
      "prenom": prenom,
      "nom": nom,
      "imageUrl": imageUrl,
      "uid": uid,
    };
  }

  String fullName() {
    return "$prenom $nom";
  }
}