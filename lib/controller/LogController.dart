import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';

class LogController extends StatefulWidget {
  LogControllerState createState()=> LogControllerState();
}


class LogControllerState extends State<LogController> {
  bool _log = true;
  String _addressMail;
  String _password;
  String _prenom;
  String _nom;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Authentification"),),
      body: SingleChildScrollView(
        child: Column( // ajouter des elements de facon horizontal
          children: <Widget>[ // besoin de plusieurs widgets
            Container(
              margin: EdgeInsets.all(20), // Marge du controlleur
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height / 2, // prendre la moitié de l'ecran en hauteur
              child: Card(
                elevation: 7.5,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: textfields(),
                  ),
                ),
              ),
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    _log = !_log;
                  });
                },
                child: Text((_log ) ? "Authentification" : "Creation de compte")
            ),
            RaisedButton(
                onPressed: _handleLog,
              child: Text("C'est parti"),
            )
          ],
        ),
      ), // si besoin de scroller
    );
  }

  // Gérer le bouton de connexion
  _handleLog() {
    // verifier si l'addresse mail est vide
    if ( _addressMail != null ){
      // verifier si le mdp est nul
      if ( _password != null ) {
        // Mdp non nul
        if ( _log ) {
          // Connexion
          FirebaseHelper().handleSignIn(_addressMail, _password).then((user) {
            print(user.uid);
          }).catchError((error) {
            alerte(error.toString());
          });

        } else {
          // creation de compte
          if ( _prenom != null ) {
            if ( _nom  != null) {
              // methode pour creer un nouvel user
              FirebaseHelper().create(_addressMail, _password, _prenom, _nom).then((user)  {
                print(user.uid);
              }).catchError((error) {
                alerte(error.toString());
              });

            } else {
              // alerte pas de nom
              alerte("Aucun nom n'a été renseigné");

            }
          } else {
            // Alerte pas de prenom
            alerte("Aucun prenom n'a été renseigné");

          }
        }

      } else {
        // Mdp null
        alerte("Aucun mdp n'a été renseigné");

      }
      // Mail existant

    } else {
      // Pas de mail
      alerte("Aucune adresse mail n'a été renseignée");
    }
  }

  List<Widget> textfields() {
    List<Widget> widgets = [];

    widgets.add(TextField(
      decoration: InputDecoration(hintText: "Address mail"),
      onChanged: (string) { // on recupere un string
        setState(() {
          _addressMail = string;
        });
      },
    ));

    widgets.add(TextField(
      decoration: InputDecoration(hintText: "Mot de passe"),
      obscureText: true,
      onChanged: (string) {
        setState(() {
          _password = string;
        });
      },
    ));

    if (!_log) {
      widgets.add(TextField(
        decoration: InputDecoration(hintText: "Prenom"),
        onChanged: (string) {
          _prenom = string;
        },
      ));

      widgets.add(TextField(
        decoration: InputDecoration(hintText: "Nom"),
        onChanged: (string) {
          _nom = string;
        },
      ));
    }
    return widgets;
  }


  // Creer les alertes
  Future<void> alerte ( String message ) async {
    Text title = Text("Erreur");
    Text msg = Text(message);
    FlatButton okButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("OK"),
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
      builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
            ? CupertinoAlertDialog(title: title, content: msg, actions: <Widget>[okButton],)
            : AlertDialog(title: title, content: msg, actions: <Widget>[okButton],);
      }
    );
  }
}



