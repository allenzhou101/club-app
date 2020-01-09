import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:club_app/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:club_app/main.dart';
import 'sign_in.dart';

void main() => runApp(InterestPage());

class InterestPage extends StatefulWidget {
  InterestPageState createState() => InterestPageState();
}

class InterestPageState extends State<InterestPage> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(children: [
                      StreamBuilder(
                          stream: db.collection("interests").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading...");
                            } else {
                              return Expanded(
                                  child: ListView(
                                      children: makeListWidget(snapshot)));
                            }
                          }),
                      RaisedButton(
                        child: Text("continue"),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
//                            db.collection("users").document(uid).collection("userinfo").document("myinterests").updateData({

                            //});
                            return Home();
                          }));
                        },
                      )
                    ])))));
  }

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return ListTile(
        title: OutlineButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Container(
              margin: const EdgeInsets.all(30.0),
              padding: const EdgeInsets.all(10.0),
              decoration:
                  myBoxDecoration(), //             <--- BoxDecoration here
              child: myText(document),
            ),
            onPressed: () {}),
      );
    }).toList();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  Text myText(DocumentSnapshot document) {
    if (document["Outdoors"]) {
      
    }
    return Text(document["name"]);
  }
}
