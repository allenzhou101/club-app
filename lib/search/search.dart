import 'package:flutter/material.dart';
import 'package:club_app/main.dart';


class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: SearchWrapper());
  }
}

class SearchWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PrimaryColor,
          title: Text("Search App"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
       // drawer: Drawer(),
        body: SearchInner());
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = [
    "Southlake",
    "Austin",
    "El Paso",
    "Houston",
    "Dallas",
    "Amarillo",
    "Corpus Christi"
  ];

  final recentCities = ["Southlake", "Dallas"];
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
          color: Colors.red,
          child: Center(
            child: Text(query),
          )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
            },
            leading: Icon(Icons.location_city),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]))),
        itemCount: suggestionList.length);
  }
}

class SearchInner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: ListView(children: [
      SizedBox(height: 40),
      SearchBy(category: "time"),
      SearchBy(category: "mood"),
      SearchBy(category: "interest"),
              FindThings()
    ])));
  }
}

class SearchBy extends StatefulWidget {
  final String category;
  SearchBy({this.category: ""});
  @override
  SearchByState createState() => SearchByState();
}

class SearchByState extends State<SearchBy> {
  String questionType;
  String responseType;
  @override
  Widget build(BuildContext context) {
    if (widget.category == "time") {
      questionType = "I'd like to go out";
      responseType = "Anytime";
    }
    else if (widget.category == "mood") {
      questionType = "I'm in the mood for";
      responseType = "Anything";
    }
    else if (widget.category == "interest"){
      questionType = "My interests are";
      responseType = "Anything";
    }
    else {
      questionType = "Oops";
      responseType = "The programmer messed up. ";
    }
    return Container(
        child: Center(
            child: Column(children: [
              Text(questionType),
              RaisedButton(
                  color: Colors.white, child: Text(responseType), onPressed: () {}),
              Text("")
            ])));

  }
}

class FindThings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: RaisedButton(
                color: Colors.orange,
                child: Text("Find things to do",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {})));
  }
}




class CustomBarWidget extends StatelessWidget {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: 160.0,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              child: Center(
                child: Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print("your menu action here");
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print("your menu action here");
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          print("your menu action here");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
