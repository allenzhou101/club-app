import 'package:flutter/material.dart';

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
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            EventCard(name: "Texas Grower's Farm Day", date: "Sat, Dec 7"),
            SizedBox(width: 20),
            EventCard(name: "Texas Grower's Farm Day", date: "Sat, Dec 7"),
            SizedBox(width: 20),
            EventCard(name: "Texas Grower's Farm Day", date: "Sat, Dec 7")
          ]))
    ]);
  }
}

class EventCard extends StatelessWidget {
  final String name, date;

  EventCard({this.name: "", this.date: ""});

  @override
  Widget build(context) {
    return SizedBox(
        width: 200,
        child: Column(children: [
          Image.asset('assets/images/lanterns.jpg'),
          ListTile(
            title: Text(name),
            subtitle: Text('Fri, Nov 29'),
          )
        ]));
  }
}

class FeaturedCard extends StatelessWidget {
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
