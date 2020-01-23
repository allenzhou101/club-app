import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/eventpage/event_page.dart';
import 'package:club_app/main.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
        backgroundColor: PrimaryColor,
        title: Text("Explore Events"),
          leading: Text("")
    ),
    // drawer: Drawer(),
    body: ListView(children: [
      FeaturedCard(),
      EventRow(category: "Popular Now"),
      EventRow(category: "Technology"),
      EventRow(category: "Sustainability"),
      EventRow(category: "Culture")
    ]));
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

//Scrollable row for each category of events
class EventRow extends StatelessWidget {
  final String category;

  EventRow({this.category: ""});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.all(10),
          child: Text(category,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
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
                          List<String> organizingIndividuals =
                              List<String>.from(ds['organizingIndividuals']);
                          List<String> participatingIndividuals =
                              List<String>.from(ds['participatingIndividuals']);
                          //print(organizingIndividuals.toString());
                          //print(participatingIndividuals.toString());
                          // print(ds['category']);
                          //print(ds.documentID);
                          if (ds['category'] == category ||
                              category == 'Popular Now') {
                            return EventCard(
                                docID: ds.documentID,
                                name: ds["eventName"],
                                date: ds["time"],
                                location: ds['location'],
                                description: ds['description'],
                                organizingGroup: ds['organizingGroup'],
                                organizingIndividuals: organizingIndividuals,
                                participatingIndividuals:
                                    participatingIndividuals);
                            //, location: ds['location'], description: ds['description'], organizingGroup: ds['organizingGroup'], organizingIndividuals: ds['organizingIndividuals'], participatingIndividuals: ds['participatingIndividuals']
                          }
                          return Text("");
                        }));
              }))
    ]);
  }
}

//@override
//List<Widget> makeListWidget(AsyncSnapshot snapshot) {
//  print("check");
//  return snapshot.data.documents.map<Widget>((document) {
//    EventCard(name: "eventName", date:"time");
//  }).toList();
//}

class EventCard extends StatelessWidget {
  final String docID, name, date, location, description, organizingGroup;
  final List<String> organizingIndividuals, participatingIndividuals;

  EventCard(
      {this.docID,
      this.name: "",
      this.date: "",
      this.location,
      this.description,
      this.organizingGroup,
      this.organizingIndividuals,
      this.participatingIndividuals});
  //this.location, this.description, this.organizingGroup, this.organizingIndividuals, this.participatingIndividuals
  @override
  Widget build(context) {
    return GestureDetector(
        child: SizedBox(
            width: 200,
            child: Column(children: [
              Image.asset('assets/images/lanterns.jpg'),
              ListTile(
                title: Text(name),
                subtitle: Text(date),
              )
            ])),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EventInner(
                docID: this.docID,
                name: this.name,
                date: this.date,
                location: this.location,
                description: this.description,
                organizingGroup: this.organizingGroup,
                organizingIndividuals: this.organizingIndividuals,
                participatingIndividuals: this.participatingIndividuals);
          }));
        });
  }
}

class FeaturedCard extends StatelessWidget {
  final databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: databaseReference
            .collection("events")
            .document("T6ytg7AXav8O5QdsmMNO")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          var ds = snapshot.data;
          List<String> organizingIndividuals =
              List<String>.from(ds['organizingIndividuals']);
          List<String> participatingIndividuals =
              List<String>.from(ds['participatingIndividuals']);

          return GestureDetector(
              child: Card(
                  child: Column(children: [
                Image.asset('assets/images/canoe.jpg'),
                ListTile(
                  title: Text(ds['eventName']),
                  subtitle: Text(ds['time']),
                )
              ])),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EventInner(
                      docID: ds.documentID,
                      name: ds["eventName"],
                      date: ds["time"],
                      location: ds['location'],
                      description: ds['description'],
                      organizingGroup: ds['organizingGroup'],
                      organizingIndividuals: organizingIndividuals,
                      participatingIndividuals: participatingIndividuals);
                }));
              });
        });
  }
}
