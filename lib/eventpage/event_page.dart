import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.orange,
        ),
      home: EventInner()
    );
  }
}
class EventInner extends StatefulWidget {
  EventInnerState createState() => EventInnerState();
}
class EventInnerState extends State <EventInner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Organizer(),
        Date(),
        Location()
      ]
    );
  }
}

class Organizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("words");
  }
}
class Date extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("words");
  }
}
class Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("words");
  }
}