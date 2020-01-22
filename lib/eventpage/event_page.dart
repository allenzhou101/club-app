import 'package:flutter/material.dart';
import 'package:club_app/main.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/calendar/calendar.dart';
import 'package:club_app/orgpage/orgpage.dart';

//import 'package:cached_network_image/cached_network_image.dart';

//use Hero() Widget

//class EventPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        // Use the old theme but apply the following three changes
//          textTheme: TextTheme(
//            headline: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//        title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
//            body1: TextStyle(fontSize: 18)
//
//    )),
//      home: EventInner(),
//    );
//  }
//}
class EventInner extends StatefulWidget {
  @override
  EventInnerState createState() => EventInnerState();
  final String docID, name, date, location, description, organizingGroup;
  final List<String> organizingIndividuals, participatingIndividuals;
  EventInner({Key key, this.docID, this.name: "", this.date: "", this.location, this.description, this.organizingGroup, this.organizingIndividuals, this.participatingIndividuals}): super(key: key);
}

class EventInnerState extends State<EventInner> {

  int difference = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      difference++;
    });
  }
  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      difference--;
    });
  }

  Future<void> yourGoing(String eventName, date) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You\'re Going!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(eventName),
                Text(date),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('okay'),
              onPressed: () {
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int numPeople = widget.participatingIndividuals.length;

    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream:
              Firestore.instance.collection('users').document(uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var ds = snapshot.data;
//            List<String> adminList = new List<String>.from(ds['groupAdmin']);
                  List<String> myEvents = new List<String>.from(ds['myEvents']);
                  for (var j = 0; j < myEvents.length; j++) {
                    if (myEvents[j] == widget.docID) {
                      return RaisedButton(
                          color: Colors.grey,
                          //textColor: Colors.white,
                          child: Text("Unregister"),
                          onPressed: () {
                            Firestore.instance.collection("users")
                                .document(uid)
                                .updateData({
                              'myEvents': FieldValue.arrayRemove([widget.docID])
                            });
                            Firestore.instance.collection("events").document(
                                widget.docID).updateData({
                              'participatingIndividuals': FieldValue.arrayRemove([uid])
                            });
                            setState(() {
                              _decrementCounter();
                            });
                            //yourGoing(widget.name, widget.date);
                          });
                      //setState(() => pressAttention = !pressAttention);

                    }
                  }

                  return RaisedButton(
                      color: Colors.deepOrange,
                      //textColor: Colors.white,
                      child: Text("Register"),
                      onPressed: () {
                        Firestore.instance.collection("users")
                            .document(uid)
                            .updateData({
                          'myEvents': FieldValue.arrayUnion([widget.docID])
                        });
                        Firestore.instance.collection("events").document(
                            widget.docID).updateData({
                          'participatingIndividuals': FieldValue.arrayUnion([uid])
                        });
                        setState(() {
                          _incrementCounter();
                        });
                        yourGoing(widget.name, widget.date);
                      });
                }
                return Text("Loading...");
              }),
        ),
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(""),
          centerTitle: true,
        ),
        body: Center(
            child: SizedBox(
                width: 375,
                child: ListView(
                    children: [
                      HeroImage(),
                      SizedBox(height: 10),
                      HeroTitle(widget.name),
                      SizedBox(height: 20),
                      Organizer(widget.organizingGroup, widget.docID),
                      SizedBox(height: 20),
                      Date(widget.date),
                      SizedBox(height: 20),
                      Location(widget.location),
                      SizedBox(height: 20),
                      HostedBy(widget.organizingIndividuals),
                      SizedBox(height: 20),
                      PeopleGoing(numPeople: numPeople + difference),
                      SizedBox(height: 20),
                      About(widget.description),
                      SizedBox(height: 20),
//                      Contact(),
//                      SizedBox(height: 20),
//                      Comments(),
//                      SizedBox(height: 20),
                    ]))));
  }
}

class HeroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/canoe.jpg',
              width: 400.0, height: 180.0, fit: BoxFit.cover))
    );
  }
}

class HeroTitle extends StatelessWidget {
  HeroTitle(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28))
    );
  }
}
class Organizer extends StatefulWidget {
  Organizer(this.organizingGroup, this.groupID);
  final String organizingGroup, groupID;
  OrganizerState createState() => OrganizerState();
}
 class OrganizerState extends State<Organizer>{


  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//      IconPlusData(
//          icon: "http://via.placeholder.com/350x150",
//          data: organizingGroup),
    Container(
      width: 200,
      child: GestureDetector(
        child: Text(widget.organizingGroup),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return OrgPage(orgID: widget.organizingGroup);
          }));
        },
      )
    ),
      SizedBox(width: 20),
      joinGroup(widget.organizingGroup),
    ]);
  }
}


class Date extends StatelessWidget {
  Date(this.date);
  final String date;
  @override
  Widget build(BuildContext context) {
    return IconPlusData(
        icon: Icons.access_time, data: date);
  }
}

class Location extends StatelessWidget {
  Location(this.location);
  final String location;
  @override
  Widget build(BuildContext context) {
    return IconPlusData(
        icon: Icons.location_on, data: location);
  }

}
class HostedBy extends StatefulWidget {
  HostedBy(this.hosts);
  final List<String> hosts;
  HostedByState createState() => HostedByState();
}
class HostedByState extends State<HostedBy>{
  Future<Widget> buildList() async {
    List<Widget> list = [Text("Hosted by: ")];
    print("Here are the hosts" + widget.hosts.toString());
    for (var i = 0; i < widget.hosts.length; i++) {
      if (i == 0) {
        await Firestore.instance.collection("users").document(widget.hosts[i]).get().then((
            snapshot) {
          if (snapshot.exists) {
            list.add(
                Text(snapshot.data['name'].toString())
            );
          }
          else {
            print("No such user");
          }
        });
      }
      else {
        await Firestore.instance.collection("users").document(widget.hosts[i]).get().then((
            snapshot) {
          if (snapshot.exists) {
            list.add(
                Text(snapshot.data['name'].toString())
            );
          }
          else {
            print("No such user");
          }
        });
      }
    }
    return Row(children:list);
  }

    @override
    Widget build(BuildContext context) {
      Future<Widget> list = buildList();
      return FutureBuilder<Widget>(
        future: list, // async work
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading....');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return snapshot.data;
          }
        },
      );
    }
  }



class PeopleGoing extends StatelessWidget {
  final int numPeople;
  PeopleGoing({this.numPeople});
  @override
  Widget build(BuildContext context) {
    if (numPeople != 1) {
      return Text(numPeople.toString() + " people are going");
  }
    else {
      return Text(numPeople.toString() + " person is going");
    }
//    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//      Text(numPeople.toString() + " people are going"),
//      SizedBox(height: 10),
//      SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          child: Row(mainAxisSize: MainAxisSize.min, children: [
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
//            SizedBox(width: 20),
//            Icon(
//              Icons.arrow_forward,
//              color: Colors.black,
//              size: 30.0,
//            )
//          ]))
//    ]);
  }
}

class About extends StatelessWidget {
  final String description;
  About(this.description);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("About", style: Theme.of(context).textTheme.title),
      Text(description),
      //Text("Here are some words describing what the event is about. Here are some words describing what the event is about. Here are some words describing what the event is about. "),
      //Text("\nread more", style: TextStyle(color: Colors.deepOrange))
    ]);
  }
}

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Contact", style: Theme.of(context).textTheme.title),
      SizedBox(height: 10),
      IconPlusData(
          icon: Icons.email, data: "Doub's Life"),
      IconPlusData(
          icon: Icons.email, data: "Doug@gmail.com")
    ]);
  }
}

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Comments", style: Theme.of(context).textTheme.title),
      SizedBox(height: 10),
      CreateComment(),
      PastComment(),
      PastComment(),
      SizedBox(height: 20),
      Center(
        child: RaisedButton(
            child: Row(children: [
              Text("See All"),
              Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 20.0,
              )
            ]),
            onPressed: () {},
          ),

      )

    ]);
  }
}

class CreateComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          CircleImage(iconUrl: "http://via.placeholder.com/350x150"),
          SizedBox(width: 10),
          Flexible(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a public comment'
                ),
              )
          )
        ]
    );
  }
}
class PastComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleImage(iconUrl: "http://via.placeholder.com/350x150"),
              SizedBox(width: 10),
              PastCommentData(name: "Doug Miller", time: "15 hours ago", description: "This looks so exciting! However, is it in a state park? I'm really passionate about nature and can't wait to meet everyone!"),
            ]
        ),
        SizedBox(height: 30)

      ]
    );
  }
}
class PastCommentData extends StatelessWidget {
  final String name, time, description;
  PastCommentData({this.name, this.time, this.description});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Text(name),
                  Text(" - ", style: TextStyle(color: Colors.black54)),
                  Text(time, style: TextStyle(color: Colors.black54))
                ]
            ),
            SizedBox(height: 10),
            Text(description)


          ]
      )
    );
  }
}

class IconPlusData extends StatelessWidget {
  final String data;
  final IconData icon;
  IconPlusData({this.icon, this.data});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //CircleImage(iconUrl: icon),
      Icon(
        icon,
        color: Colors.grey,
        size: 24.0,
        semanticLabel: 'Text to announce in accessibility modes',
      ),
      SizedBox(width: 10),
      Text(data, style: Theme.of(context).textTheme.body1)

    ]);
  }
}

class CircleImage extends StatelessWidget {
  final String iconUrl;
  CircleImage({this.iconUrl});
  @override
  Widget build(BuildContext context) {
    double _size = 30.0;
    return Container(
          width: _size,
          height: _size,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: new NetworkImage(iconUrl)))
    );
  }
}
