import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/eventpage/event_page.dart';
class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      FeaturedCard(),
      EventRow(category: "Popular Now"),
      EventRow(category: "Technology"),
      EventRow(category: "Sustainability"),
      EventRow(category: "Culture")
    ]);
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
                          print(ds['category']);
                          if (ds['category'] == category ||
                              category == 'Popular Now') {
                            return EventCard(
                                name: ds["eventName"], date: ds["time"]);
                            //, location: ds['location'], description: ds['description'], organizingGroup: ds['organizingGroup']
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
  final String name, date;

  EventCard({this.name: "", this.date: ""});

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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {return EventInner();}
          ));
        });
  }
}

class FeaturedCard extends StatelessWidget {
  final databaseReference = Firestore.instance;

//databaseReference.collection("users")

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Image.asset('assets/images/canoe.jpg'),
      ListTile(
        title: Text('Concrete Canoe Club Meeting'),
        subtitle: Text('Fri, Nov 29'),
      )
    ]));
  }
}
