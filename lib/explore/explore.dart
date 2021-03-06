import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/eventpage/event_page.dart';
import 'package:club_app/main.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: PrimaryColor,
            title: Column(children: [
              SizedBox(height: 8),
              Text("The University of Texas at Austin",
                  style: TextStyle(color: MyOrange, fontSize: 18))
            ]),
            leading: Text("")),
        // drawer: Drawer(),
        body: ListView(children: [
          //FeaturedCard(),
          Padding(
              padding: EdgeInsets.all(15),
              child: Text("Explore Events",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          //FeaturedCard(),
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
          padding: EdgeInsets.all(15),
          child: Text(category,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text("Loading...");

                return Container(
                    height: 250,
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
                                imageURL: ds['imageURL'],
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
  final String imageURL,
      docID,
      name,
      date,
      location,
      description,
      organizingGroup;
  final List<String> organizingIndividuals, participatingIndividuals;

  EventCard(
      {this.imageURL,
      this.docID,
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
        child: Padding(
            padding: EdgeInsets.only(right: 10, left: 15),
            child: SizedBox(
                width: 200,
                height: 100,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          imageURL,
                          fit: BoxFit.fill,
                          height: 120,
                          width: 250,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : LinearProgressIndicator();
                          },
                          //height: 100.0,
                          //height: 100.0,
                          //width: 800
                          //height: 50
                        ),
                      ),

//                  ListTile(
//                    title: Text(name),
//                    subtitle: Text(date),
//                  ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8),
                          Text(convertDate(date),
                              style: TextStyle(
                                  fontSize: 16, color: brownOrange)),
                          SizedBox(height: 6),
                          Text(name, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 3),
                          Text(location,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ))
                        ],
                      )
                    ]))),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EventInner(
                imageURL: imageURL,
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

Future<String> getImageURL(imageURL) async {
  final ref = FirebaseStorage.instance.ref().child(imageURL);
  // no need of the file extension, the name will do fine.
  var url = await ref.getDownloadURL();
//            if(mounted) {
//              setState((){
//                imageURL = url;
//              });
//            }
  return url;
}

class FeaturedCard extends StatefulWidget {
  @override
  FeaturedCardState createState() => FeaturedCardState();
}

class FeaturedCardState extends State<FeaturedCard> {
  final databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: databaseReference
            .collection("events")
            .document("1PFKVtQlgP2WpYa5ceHD")
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
          String imageURL = 'assets/images/canoe.jpg';

          return GestureDetector(
              child: Card(
                  child: Column(
                children: [
                  Image.network(ds['imageURL']),
                  ListTile(
                    title: Text(ds['eventName']),
                    subtitle: Text(ds['time']),
                  )
                ],
              )),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EventInner(
                      imageURL: ds['imageURL'],
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

//
        });
  }
}






String convertDate(date) {
  var splitDate = date.split(" ");
  var virTime = splitDate[1];
  var hourMinute = virTime.split(":");
  var virHour = int.parse(hourMinute[0]);
  String hour;
  var minute = hourMinute[1];
  if (virHour > 12) {
    virHour -= 12;
    hour = virHour.toString() + ":" + minute + " PM";
  } else {
    hour = virHour.toString() + ":" + minute + " AM";
  }

  var monthDay = splitDate[0].split("-");

  var virMonth = int.parse(monthDay[1]);
  String month;
  switch (virMonth) {
    case 1:
      {
        month = "January";
      }
      break;
    case 2:
      {
        month = "February";
      }
      break;
    case 3:
      {
        month = "March";
      }
      break;
    case 4:
      {
        month = "April";
      }
      break;
    case 5:
      {
        month = "May";
      }
      break;
    case 6:
      {
        month = "June";
      }
      break;
    case 7:
      {
        month = "July";
      }
      break;
    case 8:
      {
        month = "August";
      }
      break;
    case 9:
      {
        month = "September";
      }
      break;
    case 10:
      {
        month = "October";
      }
      break;
    case 11:
      {
        month = "November";
      }
      break;
    case 12:
      {
        month = "December";
      }
      break;
  }
  var day = monthDay[2];
  if (day.substring(0, 1) == "0") {
    day = day.substring(1, 2);
  }
  return month + " " + day + ", " + hour;
}