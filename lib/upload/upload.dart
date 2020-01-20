import 'package:club_app/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:club_app/main.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Create Event')),
          leading: Text(""),
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
        body: UploadEvent());
  }
}

class UploadEvent extends StatefulWidget {
  UploadEventState createState() => UploadEventState();
}
String organizingGroup, category;
bool notAdmin = false;
class UploadEventState extends State<UploadEvent> {
  String eventName, description, location, time;
  var organizingIndividuals = ['words', 'morewords'];
  var attendees = new Map<String, String>();
  final _formKey = GlobalKey<FormState>();

  //Input date and time
  DateTime selectedDate = DateTime.now();
  final now = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final lastMidnight = new DateTime(now.year, now.month, now.day - 2);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: lastMidnight,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TimeOfDay selectedTime = new TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      //print('Time selected: ${selectedTime.toString()}');
      setState(() {
        selectedTime = picked;
        //print(selectedTime);
      });
    }
  }

  Future<Null> _selectDateAndTime(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var textController = new TextEditingController();
    textController.text = "${selectedDate.toLocal()}".split(' ')[0] +
        " " +
        selectedTime.toString().substring(10, 15);

    var _currentSelectedValue;
    var categoryList = ["Tech", "Culture", "Sustainability"];
    var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
//    if (notAdmin) {
//      return Text("You are not an administrator of any groups");
//    }
//    else {
      return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
              right: 80,
              left: 80,
            ),
            child: ListView(
              children: <Widget>[
//

                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Event Name'),
                  onSaved: (value) => eventName = value,
                ),
                InkWell(
                  onTap: () {
                    _selectDateAndTime(
                        context); // Call Function that has showDatePicker()
                  },
                  child: IgnorePointer(
                    child: new TextFormField(
                      controller: textController,

                      decoration: new InputDecoration(
                          hintText: 'Date and Time'),
                      //maxLength: 10,
                      // validator: validateDob,
                      onSaved: (String val) {
                        time = "${selectedDate.toLocal()}".split(' ')[0] +
                            " " +
                            selectedTime.toString().substring(10, 15);
                      },
                    ),
                  ),
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

//              TextFormField(
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return 'Please enter some text';
//                  }
//                  return null;
//                },
//                decoration: InputDecoration(labelText: 'Organizing Group'),
//                onSaved: (value) => organizingGroup = uid,
//              ),
                BuildForm(),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration:
                  InputDecoration(labelText: 'Organizing Individuals'),
                  onSaved: (value) => organizingIndividuals = [uid],
                ),
                BuildCategoryForm(),
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
                RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        _formKey.currentState.save();

                        addData();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Home();
                          },
                        ));

//                            .then((doc) {
//                          docID = doc.documentID.toString();
//                        });
                      }
                    })
              ],
            ),
          ));
    //}
  }

  void addData() async{
    final db = Firestore.instance;
    final myEventDoc =
    await db.collection("events").add({
      'eventName': eventName,
      'organizingGroup': organizingGroup,
      'organizingIndividuals': organizingIndividuals,
      'participatingIndividuals': [],
      'description': description,
      'location': location,
      'time': time,
      'category': category
    });
    db.collection("groups").document(organizingGroup).updateData({
      'eventList': FieldValue.arrayUnion([myEventDoc.documentID])
    });
  }
}
class BuildForm extends StatefulWidget {
  BuildFormState createState() => BuildFormState();
}
class BuildFormState extends State<BuildForm>{
  var _currentSelectedValue;

  var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'No Data...',
          );
        } else {
          DocumentSnapshot ds = snapshot.data;

          List<String> categoryList = new List<String>.from(ds['groupAdmin']);
//          if (categoryList.length ==0) {
//            setState(() {
//              notAdmin = true;
//            });
//          }
//          else {
//            setState(() {
//              notAdmin = false;
//            });
//          }
          return FormField<String>(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Please select hosting group',
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
                          //print(_currentSelectedValue);
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
              onSaved: (value) {
                organizingGroup = _currentSelectedValue;
              }

          );
        }
      },
    );
  }
//  List<String> list;
//  List<String>  buildGroupList(groupIDs)  {
//    list = new List();
//    for (int i = 0; i < groupIDs.length; i ++) {
//      futureString(groupIDs, i);
//    }
//    print(list.toString());
//    return list;
//  }
//  Future<String> futureString(groupIDs, i) async {
//
//    Firestore.instance.collection("groups").document(groupIDs[i]).get().then((DocumentSnapshot ds) {
//      String name = ds.data["groupName"];
//      list.add("" + name);
//    });
//    return "Hello";
//  }
}


class BuildCategoryForm extends StatefulWidget {
  BuildCategoryFormState createState() => BuildCategoryFormState();
}
class BuildCategoryFormState extends State<BuildCategoryForm> {
  var _currentSelectedValue;
  var categoryList = ["Technology", "Culture", "Sustainability"];
  var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                labelStyle: textStyle,
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 36.0),
                hintText: 'Please select category',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            isEmpty: _currentSelectedValue == null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentSelectedValue,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _currentSelectedValue = newValue;
                    state.didChange(newValue);
                    //print(_currentSelectedValue);
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
        onSaved: (value) {
          category = _currentSelectedValue;
        }
    );
  }
}

