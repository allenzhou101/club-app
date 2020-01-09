import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'explore/explore.dart';
import 'calendar/calendar.dart';
import 'profile/profile.dart';
import 'package:club_app/search/search.dart';
import 'package:club_app/eventpage/event_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login/login.dart';
import 'login/interests.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
//        Scaffold( Center(
//          child: Column(
//            children: [
//              MaterialButton(
//                onPressed: () => null,
//                color: Colors.white,
//                textColor: Colors.black,
//                child: Text('Login with Google'),
//              ),
//              MaterialButton(
//                onPressed: () => null,
//                color: Colors.red,
//                textColor: Colors.white,
//                child: Text('Sign out'),
//              )
//            ],
//          ),
//        ),
     // ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ExplorePage(),
    SearchPage(),
    CalendarPage(),
    ProfilePage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Explore UT Clubs')),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today),
              title: new Text('Calendar'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text('Profile'),
            ),
          ]),
    );
  }


}



