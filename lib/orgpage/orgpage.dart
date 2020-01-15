import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrgPage extends StatefulWidget {
  OrgPageState createState() => OrgPageState();
  final String orgID;
  OrgPage({Key key, this.orgID}): super(key: key);
}

class OrgPageState extends State<OrgPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection('groups').document("xxjY6BHZ82IxX8zdFly3").snapshots(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) return Text("Loading...");
            else {
              DocumentSnapshot ds = snapshot.data;
              List<String> eventList = new List<String>.from(ds['eventList']);

              return Center(
                  child: ListView(
                    children: <Widget>[
                      Text(ds['groupName']),
                      RaisedButton(
                        child: Text("Join this group"),
                        onPressed: () {},
                      ),
                      Members(memberCount: ds['members'].length),
                      About(description: ds['description']),
                      Events(eventList: eventList)
                    ],
                  )
              );
            }
          },
        )
    );
  }
}

class Members extends StatelessWidget {
  int memberCount;
  Members({this.memberCount});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (memberCount == 1) {
      return Text(memberCount.toString() + " Member", textAlign: TextAlign.center);

    }
    else {
      return Text(memberCount.toString() + " Members", textAlign: TextAlign.center);

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
    print(eventList[0]);
    final children;
    for (var i = 0; i < eventList.length; i++) {
      StreamBuilder(
          stream: Firestore.instance.collection("events").document(eventList[i]).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("Hey");
              return Text("Loading");

            }
            else {
              print(snapshot.data);
              print("Hello");
              return Text("Hey");
            }
          }
      );
    }
    return Text("Hello");
  }

  buildList (List<String> eventList, int i){
    StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");

          return Container(
              height: 300,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 5.0),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    // print(ds['category']);
                    //print(ds.documentID);
                    if (ds.documentID == eventList[i]) {
                      return Text(ds['eventName']);
                      //, location: ds['location'], description: ds['description'], organizingGroup: ds['organizingGroup'], organizingIndividuals: ds['organizingIndividuals'], participatingIndividuals: ds['participatingIndividuals']
                    }
                    return Text("");
                  }));
        });
}
}






