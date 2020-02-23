import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:club_app/eventpage/event_page.dart';
import 'package:club_app/main.dart';
import 'package:club_app/explore/explore.dart';



class CalendarPage extends StatelessWidget {
  List<Widget> orderedDates = [];



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PrimaryColor,
          title: Text("Calendar", style: appBarStyle),
          leading: Text(""),
        ),
        body: buildStream());
//    return ListView(children: [
//      Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Text("My Calendar", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//      ),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//      CalendarEvent(),
//    ]);
  }

  Column buildColumn()  {
    return Column(
      children: orderedDates,
    );
  }

  StreamBuilder buildStream() {

    Stream<DocumentSnapshot> courseDocStream =
        Firestore.instance.collection('users').document(uid).snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: courseDocStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // get course document
            var courseDocument = snapshot.data.data;
            // get sections from the document
            var sections = courseDocument['myEvents'];
            // build list using names from sections
            if (sections.length == 0) {
              return Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60),
                    Text("You are not registered for any events")
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: sections != null ? sections.length : 0,
              itemBuilder: (_, int index) {
                //print(sections[index]);
                return buildListTile(sections[index]);
              },
            );
          } else {
            return Container();
          }
        });
  }

  StreamBuilder buildListTile(String eventID) {

    return StreamBuilder(
        stream: Firestore.instance
            .collection("events")
            .document(eventID)
            .snapshots(),
        builder: (context, snapshot) {
          DocumentSnapshot ds = snapshot.data;
          if (!snapshot.hasData) {
            return Text("");
          } else {
            List<String> organizingIndividuals =
                List<String>.from(ds['organizingIndividuals']);
            List<String> participatingIndividuals =
                List<String>.from(ds['participatingIndividuals']);


            //Attemped sorting of dates
//            if (orderedDates.length == 0) {
//              orderedDates.add(ds['time']);
//            }
//            else {
//              for (int i = 0; i < orderedDates.length; i++) {
//                if (!(ds['time'].compareTo(orderedDates[i]) > 0)) {
//                  orderedDates.insert(i, ds['time']);
//                  break;
//                }
//                if ((i == orderedDates.length-1)) {
//                  orderedDates.add(ds['time']);
//                  break;
//                }
//              }
//            }
//            print(orderedDates.toString());

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => EventInner(
                          imageURL: ds['imageURL'],
                          docID: ds.documentID,
                          name: ds["eventName"],
                          date: ds["time"],
                          location: ds['location'],
                          description: ds['description'],
                          organizingGroup: ds['organizingGroup'],
                          organizingIndividuals: organizingIndividuals,
                          participatingIndividuals: participatingIndividuals)));
                },
                child:
Padding(
                padding: EdgeInsets.only(
          left: 10
          ),
                    child:

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(convertDate(ds['time']), style: TextStyle(fontSize: 18, color: brownOrange)),
                          SizedBox(height: 5),
                          Text(ds['eventName'], style: TextStyle(fontSize: 25)),
                          Text(ds['location']),
                          Divider(color: Colors.grey, )
                        ])
)
            );
          }
        });
  }
}

class CalendarEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("8:30 AM", style: TextStyle(color: Colors.deepOrange)),
              Text("Concrete Canoe Paddle Day",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Concrete Canoe Team"),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(Icons.location_on), Text("Lady Bird Lake")]),
              SizedBox(height: 15),
              Divider()
            ]));
  }
}
