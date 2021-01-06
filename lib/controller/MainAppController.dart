// Si on est Authentifié
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controller/ContactsController.dart';
import 'package:flutter_chat/controller/MessagesController.dart';
import 'package:flutter_chat/controller/ProfileController.dart';
import 'package:flutter_chat/model/FirebaseHelper.dart';

class MainAppController extends StatelessWidget {

  User user = FirebaseHelper().auth.currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final current = Theme.of(context).platform;
    if ( current == TargetPlatform.iOS) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Colors.blue,
            activeColor: Colors.black,
            inactiveColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.message)),
              BottomNavigationBarItem(icon: Icon(Icons.supervisor_account)),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
            ],
          ),
          tabBuilder: (BuildContext cxt, int index) {
            Widget controllerSelected = controllers()[index];
            return Scaffold(
              appBar: AppBar(title: Text("Flutter chat")),
              body: controllerSelected,
            );
          },
      );
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Flutter Chat"),
              bottom: TabBar(tabs: [
                Tab(icon: Icon(Icons.message),),
                Tab(icon: Icon(Icons.supervisor_account),),
                Tab(icon: Icon(Icons.account_circle),),
              ]),
            ),
            body: TabBarView(
              children: controllers(),
            ),
          ));
    }
  }

  List<Widget> controllers() {
    return [
      MessagesController(),
      ContactsController(),
      ProfileController(),
    ];
  }
}