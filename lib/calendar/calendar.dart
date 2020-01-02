import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("My Calendar", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
      CalendarEvent(),
    ]);
  }
}

class CalendarEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 8
      ),
        child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("8:30 AM", style: TextStyle(color: Colors.deepOrange)),
          Text("Concrete Canoe Paddle Day", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Concrete Canoe Team"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on),
              Text("Lady Bird Lake")
            ]
          ),
          SizedBox(height: 15),
          Divider()
        ]));
  }
}
