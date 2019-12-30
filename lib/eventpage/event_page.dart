import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';

//use Hero() Widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        // Use the old theme but apply the following three changes
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
            body1: TextStyle(fontSize: 18)

    )),
      home: EventInner(),
    );
  }
}

class EventInner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () {},
            color: Colors.deepOrange,
            textColor: Colors.white,
            child: Text('Register'),
          ),
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
                      HeroTitle(),
                      SizedBox(height: 20),
                      Organizer(),
                      SizedBox(height: 20),
                      Date(),
                      SizedBox(height: 20),
                      Location(),
                      SizedBox(height: 20),
                      PeopleGoing(numPeople: 14),
                      SizedBox(height: 20),
                      About(),
                      SizedBox(height: 20),
                      Contact(),
                      SizedBox(height: 20),
                      Comments(),
                      SizedBox(height: 20),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("title describing the event",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28))
    );
  }
}

class Organizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconPlusData(
          icon: "http://via.placeholder.com/350x150",
          data: "Name of Organization"),
      SizedBox(width: 20),
      RaisedButton(child: Text("Follow"), onPressed: () {}),
    ]);
  }
}


class Date extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconPlusData(
        icon: "http://via.placeholder.com/350x150", data: "Date");
  }
}

class Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconPlusData(
        icon: "http://via.placeholder.com/350x150", data: "Location");
  }
}

class PeopleGoing extends StatelessWidget {
  final int numPeople;
  PeopleGoing({this.numPeople});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(numPeople.toString() + " people are going"),
      SizedBox(height: 10),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            CircleImage(iconUrl: 'http://via.placeholder.com/350x150'),
            SizedBox(width: 20),
            Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 30.0,
            )
          ]))
    ]);
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("About", style: Theme.of(context).textTheme.title),
      Text("Here are some words describing what the event is about. Here are some words describing what the event is about. Here are some words describing what the event is about. "),
      Text("\nread more", style: TextStyle(color: Colors.deepOrange))
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
          icon: "http://via.placeholder.com/350x150", data: "Doub's Life"),
      IconPlusData(
          icon: "http://via.placeholder.com/350x150", data: "Doug@gmail.com")
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
  final String icon, data;
  IconPlusData({this.icon, this.data});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleImage(iconUrl: icon),
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
                  fit: BoxFit.cover, image: new NetworkImage(iconUrl))));
  }
}
