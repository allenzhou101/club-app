import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'explore/explore.dart';
import 'calendar/calendar.dart';
import 'profile/profile.dart';
import 'package:club_app/search/search.dart';
import 'package:club_app/upload/upload.dart';
import 'package:club_app/eventpage/event_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login/login.dart';
import 'login/interests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orgpage/orgpage.dart';

const PrimaryColor = Colors.white;
const MyOrange = const Color(0xFFFF9800);
const appBarStyle = TextStyle(color: Colors.black);
const brownOrange = Color(0xFF9C6116);


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
          textTheme:
          Theme.of(context).textTheme.apply(fontFamily: 'Open Sans', bodyColor: Colors.black,  )
//          TextTheme(
//              headline: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,),
//              title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
//              body1: TextStyle(fontSize: 18)
//          ),

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
    //UploadPage(),
    UploadPhoto(),
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
      bottomNavigationBar: buildBottomNavBar(context));
  }
  Widget buildBottomNavBar(context) {
    return BottomNavigationBar(
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
            icon: new Icon(Icons.file_upload),
            title: new Text('Upload'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
        ]);
  }

//Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => SecondRoute())
}
