import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:club_app/main.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:club_app/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/create_group/create_group.dart';
import 'package:club_app/orgpage/orgpage.dart';

class ProfilePage extends StatelessWidget {
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
            body: Padding(
              padding: EdgeInsets.only(
                left: 14, right: 14
              ),
                child:InnerProfile()
            )
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
//        MyInterests(),
//        Divider(),
//        MyFriends(),
//        Divider(),
//        MyFriendsAreDoing(),
        //Divider(),
        //SuggestedFriends()
      ],
    );

  }
}

final databaseReference = Firestore.instance;
int interestCount;
void createUserRecord() async {
  await databaseReference.collection("users").document(uid).setData({
    'name': name
  });
//
//  Firestore.instance
//      .collection('users')
//      .where("name", isEqualTo: "Anthony Zhou")
//      .snapshots()
//      .listen((data) =>
//      data.documents.forEach((doc) {
//        interestCount = doc["interests"];
//        print(interestCount);
//      }));
//  await databaseReference.collection("users").document(uid).collection("myEvents").document("Post #1").setData({
//    'location': 'Dallas'
//  });

}
class MyBio extends StatelessWidget {
  //messing with the database
//  void deleteData() {
//    try {
//      databaseReference
//          .collection('users')
//          .document('aOwdecyWpJnxSwwmtydN')
//          .delete();
//    } catch (e) {
//      print(e.toString());
//    }
//  }
//  void createRecord() async {
//    await databaseReference.collection("users")
//        .document("1")
//        .setData({
//      'title': 'Mastering Flutter',
//      'description': 'Programming Guide for Dart'
//    });
//
//    DocumentReference ref = await databaseReference.collection("users")
//        .add({
//      'title': 'Flutter in Action',
//      'description': 'Complete Programming Guide to learn Flutter'
//    });
//    print(ref.documentID);
//  }
  //finished messing with the database
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
          Container(
            width: 50,
            height: 50,
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage(imageUrl)
//              )
//            ),
          ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text(name.toString()),
           Text(email.toString()),
           Text("A short description"),
           RaisedButton(
             child: Text("Sign Out"),
             onPressed: () {
               signOutGoogle();
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
             }
           ),
//

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

class MyGroups extends StatefulWidget{
  MyGroupsState createState() => MyGroupsState();
}
class MyGroupsState extends State<MyGroups> {

  Widget buildGroupList = Column(children: <Widget>[Text("No groups")],);

  MyGroupsState() {
    buildStreamList().then((val) => setState(() {
      buildGroupList = val;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
    Text("Groups - 6"),
            GestureDetector(
              child: Text("Start New Group", style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return CreateGroup();
                  }
                ));
              }
            )
    ]
        ),
        buildGroupList,
      ],
    );
  }
    Future<Widget> buildStreamList() async {
    List<Widget> list = [Text("No groups yet")];
    List<String> adminList = [];
    List<String> myGroups = [];
    await Firestore.instance.collection("users").document(uid).get().then((DocumentSnapshot ds) {
      if (!ds.exists) {
        return Text("Nothing here to see");
      }
      else {
        if (ds['groupAdmin'] != null && ds['groupAdmin'].length > 0) {
          adminList = new List<String>.from(ds['groupAdmin']);
          list = [];
        }
        if (ds['myGroups'] != null && ds['myGroups'] > 0) {
          myGroups = new List<String>.from(ds['myGroups']);
          list = [];
        }
      }
    });
    for (var i = 0; i < adminList.length; i++) {
      await list.add(
          Text(adminList[i])
//        StreamBuilder(
//          stream: Firestore.instance.collection('groups').document(adminList[i]).snapshots(),
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              var ds = snapshot.data;
//              return Container(
//                  width: 200,
//                  child: GestureDetector(
//                    child: Text(ds['groupName'].toString()),
//                    onTap: () {
//                      Navigator.of(context).push(
//                          MaterialPageRoute(builder: (context) {
//                            return OrgPage(orgID: adminList[i]);
//                          }));
//                    },
//                  )
//              );
//            }
//            else {
//              return Text("Loading");
//            }
//          }
//        )
      );
    }
    for (var i = 0; i < myGroups.length; i++) {
      await list.add(
//          StreamBuilder(
//              stream: Firestore.instance.collection('groups').document(myGroups[i]).snapshots(),
//              builder: (context, snapshot) {
//                if (snapshot.hasData) {
//                  var ds = snapshot.data;
//                  return Container(
//                      width: 200,
//                      child: GestureDetector(
//                        child: Text(ds['groupName'].toString()),
//                        onTap: () {
//                          Navigator.of(context).push(
//                              MaterialPageRoute(builder: (context) {
//                                return OrgPage(orgID: adminList[i]);
//                              }));
//                        },
//                      )
//                  );
//                }
//                else {
//                  return Text("Loading");
//                }
//              }
//          )
      Text(myGroups[i])
      );
    }
      if (list == null || list == []) {
        return Text("Loading");
      }
      else {
        return Column(
          children: list,
        );
      }
    }
  }

class GroupFormat extends StatelessWidget {
  String groupName, memberCount;
  GroupFormat({this.groupName, this.memberCount});
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
              Text(groupName),
              Text(memberCount)
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