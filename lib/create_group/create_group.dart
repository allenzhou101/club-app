import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_app/profile/profile.dart';
import 'package:club_app/login/sign_in.dart';
class CreateGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Create Group')),
//              leading: GestureDetector(
//                  child: Padding(
//                      padding: EdgeInsets.only(top: 20), child: Text("Cancel")),
//                  onTap: () {}),
//              actions: <Widget>[
//                GestureDetector(
//                    child: Padding(
//                        padding: EdgeInsets.only(top: 20),
//                        child: Text("Share")),
//                    onTap: () {})
//              ],
        ),
        body: CreateGroup());
  }
}

class CreateGroup extends StatefulWidget {
  CreateGroupState createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  String groupName, description, location, category;
  var interests = [];
  //var organizingIndividuals = ['words', 'morewords'];
  //var members = [];
  //var attendees = new Map<String, String>();
  final _formKey = GlobalKey<FormState>();


  var categoryList = [
    "Outdoors",
    "Tech",
    "Health",
    "Sports",
    "Learning",
    "Rent",
    "Art",
    "Language & Culture",
    "Books",
    "Social",
    "Career & Business",
    "Engineering"
  ];
  var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  var _currentSelectedValue;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
            right: 80,
            left: 80,
          ),
          child: ListView(
            children: <Widget>[

              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Group Name'),
                onSaved: (value) => groupName = value,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => location = value,
              ),


              TextFormField(
                style: new TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value,
              ),
              TextFormField(
                style: new TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Interests'),
                onSaved: (value) => interests = [value],
              ),


              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelStyle: textStyle,
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Please select category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedValue == null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _currentSelectedValue = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: categoryList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                onSaved: (value) => category = _currentSelectedValue,
              ),


              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                      _formKey.currentState.save();

                      final db = Firestore.instance;

                      var map = {
                        'groupName': groupName,
                        'description': description,
                        'location': location,
                        'category': category,
                        'interests': interests,
                        'eventList': [],
                        'members': []
                      };

                      createOrderMessage(map);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ProfilePage();
                        },
                      ));

//                            .then((doc) {
//                          docID = doc.documentID.toString();
//                        });
//

                    }
                  })
            ],
          ),
        ));
  }
  void  createOrderMessage(map) async {
    final order = await Firestore.instance.collection('groups').add(map);
    var docID = order.documentID;
    Firestore.instance.collection("users").document(uid).updateData({
      'groupAdmin': FieldValue.arrayUnion([docID])
    });
  }
}
