import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/LogController.dart';
import 'package:flutter_chat/controller/MainAppController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _handleAuth(),
    );
  }
}

// verifier l'authentification
Widget _handleAuth() {
  return StreamBuilder<User>(
    stream: FirebaseAuth.instance.authStateChanges(), // Verifier les changement d'authenfication de l'app
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        // Si on est authentifier accès à l'app
        return MainAppController();
      } else{
        // Si on est pas authentifier, redirection pour connection
        return LogController();
      }
    },
  );
}
