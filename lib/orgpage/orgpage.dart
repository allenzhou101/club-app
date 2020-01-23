import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/explore/explore.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:club_app/main.dart';

class OrgPage extends StatefulWidget {
  final String orgID;
  OrgPage({Key key, this.orgID}) : super(key: key);
  OrgPageState createState() => OrgPageState();
}

class OrgPageState extends State<OrgPage> {
  @override
  bool pressAttention = true;

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Org Page")),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('groups')
              .document(widget.orgID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text("Loading...");
            else {
              DocumentSnapshot ds = snapshot.data;
              List<String> eventList = new List<String>.from(ds['eventList']);

              return Center(
                  child: ListView(
                children: <Widget>[
                  Text(widget.orgID),
                  joinGroup(widget.orgID),
                  Members(memberList: ds['members']),
                  About(description: ds['description']),
                  Events(eventList: eventList),
                ],
              ));
            }
          },
        ));
  }
}

StreamBuilder joinGroup(orgID) {
  return StreamBuilder(
      stream: Firestore.instance.collection('users').document(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var ds = snapshot.data;
          List<String> adminList = new List<String>.from(ds['groupAdmin']);
          List<String> myGroups = new List<String>.from(ds['myGroups']);
          for (var i = 0; i < adminList.length; i++) {
            if (adminList[i] == orgID) {
              return Container(
                  width: 150,
                  child: Text("You are an administrator of this group"));
            }
          }
          for (var j = 0; j < myGroups.length; j++) {
            if (myGroups[j] == orgID) {
              return RaisedButton(
                color: Colors.grey,
                child: Text("Leave this group"),
                onPressed: () {
                  Firestore.instance
                      .collection("groups")
                      .document(orgID)
                      .updateData({
                    'members': FieldValue.arrayRemove([uid])
                  });
                  Firestore.instance
                      .collection("users")
                      .document(uid)
                      .updateData({
                    'myGroups': FieldValue.arrayRemove([orgID])
                  });
                  //setState(() => pressAttention = !pressAttention);
                },
              );
            }
          }

          return RaisedButton(
            color: PrimaryColor,
            child: Text("Join this group"),
            onPressed: () {
              Firestore.instance
                  .collection("groups")
                  .document(orgID)
                  .updateData({
                'members': FieldValue.arrayUnion([uid])
              });
              Firestore.instance.collection("users").document(uid).updateData({
                'myGroups': FieldValue.arrayUnion([orgID])
              });
              //setState(() => pressAttention = !pressAttention);
            },
          );
        }
        return Text("Loading...");
      });
}

class Members extends StatelessWidget {
  List<dynamic> memberList;

  Members({this.memberList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int memberCount = memberList.length;
    if (memberCount == 1) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MemberList(memberList: memberList);
            }));
          },
          child: Text(memberCount.toString() + " Member",
              textAlign: TextAlign.center));
    } else {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MemberList(memberList: memberList);
            }));
          },
          child: Text(memberCount.toString() + " Members",
              textAlign: TextAlign.center));
    }
  }
}

class About extends StatelessWidget {
  String description;
  About({this.description});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[Text("About"), Text(description)],
    );
  }
}

class Events extends StatelessWidget {
  List<String> eventList;
  Events({this.eventList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: ListMyWidgets(eventList)));
  }

  List<Widget> ListMyWidgets(eventList) {
    List<Widget> list = new List();
    for (var i = 0; i < eventList.length; i++) {
      list.add(StreamBuilder(
          stream: Firestore.instance
              .collection("events")
              .document(eventList[i])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading");
            } else {
              var ds = snapshot.data;
              return EventCard(
                  docID: ds.documentID,
                  name: ds["eventName"],
                  date: ds["time"],
                  location: ds['location'],
                  description: ds['description'],
                  organizingGroup: ds['organizingGroup']);
            }
          }));
    }

    return list;
  }

//  buildList (List<String> eventList, int i){
//    StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('events').snapshots(),
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) return Text("Loading...");
//
//          return Container(
//              height: 300,
//              child: ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  shrinkWrap: true,
//                  itemCount: snapshot.data.documents.length,
//                  padding: const EdgeInsets.only(top: 5.0),
//                  itemBuilder: (context, index) {
//                    DocumentSnapshot ds = snapshot.data.documents[index];
//                    if (ds.documentID == eventList[i]) {
//                      return Text(ds['eventName']);
//                      //, location: ds['location'], description: ds['description'], organizingGroup: ds['organizingGroup'], organizingIndividuals: ds['organizingIndividuals'], participatingIndividuals: ds['participatingIndividuals']
//                    }
//                    return Text("");
//                  }));
//        });
//}
}

class MemberList extends StatelessWidget {
  List<dynamic> memberList;
  MemberList({this.memberList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> list = [];
    for (var i = 0; i < memberList.length; i++) {
      list.add(buildPerson(memberList[i].toString()));
    }
    return Scaffold(
        appBar: AppBar(title: Text("Member List")),
        body: Column(
          children: list,
        ));
  }
}

Widget buildPerson(name) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center, children: [Text(name)]);
}
