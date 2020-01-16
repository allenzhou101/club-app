import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/explore/explore.dart';

class OrgPage extends StatefulWidget {
  final String orgID;
  OrgPage({Key key, this.orgID}): super(key: key);
  OrgPageState createState() => OrgPageState();

}

class OrgPageState extends State<OrgPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(widget.orgID);
    return Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection('groups').document(widget.orgID).snapshots(),
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
    return new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        children: ListMyWidgets(eventList)));
  }

  List<Widget> ListMyWidgets(eventList) {
    List<Widget> list = new List();
    for (var i = 0; i < eventList.length; i++) {
      list.add(StreamBuilder(
          stream: Firestore.instance.collection("events").document(eventList[i]).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading");
            }
            else {
              var ds = snapshot.data;
              return EventCard(
                  docID: ds.documentID,name: ds["eventName"], date: ds["time"], location: ds['location'], description: ds['description'], organizingGroup: ds['organizingGroup']
              );
            }
          }
      ));
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






