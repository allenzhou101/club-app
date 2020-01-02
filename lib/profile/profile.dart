import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Username"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                    onPressed: () {}
              )
            ],
          ),
            body: InnerProfile()
        )
    );
  }
}

class InnerProfile extends StatefulWidget {
  InnerProfileState createState() => InnerProfileState();
}

class InnerProfileState extends State<InnerProfile> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        MyBio(),
        Divider(),
        MyGroups(),
        Divider(),
        MyInterests(),
        Divider(),
        MyFriends(),
        Divider(),
        MyFriendsAreDoing(),
        //Divider(),
        //SuggestedFriends()
      ],
    );

  }
}

class MyBio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
            ),
          ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text("First Name Last Name"),
           Text("A short description")
         ],
        ),
        IconButton(
            icon: Icon(Icons.edit),
          onPressed: (){}
        )
      ],
    );
  }
}

class MyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
    Text("Groups - 6"),
            Text("Join New Groups")
    ]
        ),
        GroupFormat(),
        GroupFormat(),
        GroupFormat(),
      ],
    );
  }
}
class GroupFormat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        right: 0,
        bottom: 20,
        left: 0,
      ),
      child: Row(
        children: <Widget>[
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black
              )
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Group Name"),
              Text("Number of members")
            ],
          ),
        ],
      )
    );
  }
}
class MyInterests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Interests - 11"),
              Text("Edit Interests")
            ]
        ),
        Text("Outdoors"),
        Text("Indoors"),
        Text("Hiking"),
        Text("Software"),
        Text("Reading"),
        Text("Weekend Getaways"),
        Text("Outdoors"),
        Text("Indoors"),
        Text("Hiking"),
        Text("Software"),
        Text("Weekend Getaways"),
      ],
    );
  }
}
class MyFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Friends - 31"),
              Text("See All Friends")
            ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.rectangle)),
                Text("Name"),
                Text("A Brief Description")
              ],
            ),
            Column(
              children: <Widget>[
                Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.rectangle)),
                Text("Name"),
                Text("A Brief Description")
              ],
            ),
            Column(
              children: <Widget>[
                Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.rectangle)),
                Text("Name"),
                Text("A Brief Description")
              ],
            ),
          ],
        )
      ],
    );
  }
}
class MyFriendsAreDoing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("What are my friends doing?"),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
        FriendUpdate(),
      ],
    );
  }
}
class FriendUpdate extends StatelessWidget {
  var howRecent = "5w";
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 0,
          bottom: 20,
          left: 0,
        ),
        child: Row(
          children: <Widget>[
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black
                )
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text("Someone commented on a post: I can't wait to see you all tomorrow! " + howRecent),

            ),
          ],
        )
    );
  }
}

//
//class SuggestedFriends extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        Text("Suggested for You"),
//        FriendSuggestion(),
//      ],
//    );
//  }
//}
//class FriendSuggestion extends StatefulWidget {
//  FriendSuggestionState createState() => FriendSuggestionState();
//}
//class FriendSuggestionState extends State<FriendSuggestion> {
//  @override
//  Widget build(BuildContext context) {
//    return Text("Hello");
//  }
//}