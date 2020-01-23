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
String organizingGroup, category, _currentSelectedValue;
bool notAdmin = false;

var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);

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

    var categoryList = ["Tech", "Culture", "Sustainability"];
    var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
//    if (notAdmin) {
//      return Text("You are not an administrator of any groups");
//    }
//    else {
      return StreamBuilder(
        stream: Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else {
            DocumentSnapshot ds = snapshot.data;

            List<String> groupAdminList = new List<String>.from(ds['groupAdmin']);
            if (groupAdminList.length == 0) {
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text("You're not an admin of any groups", style: TextStyle(fontSize: 20))
                ],
              ));
            }
            return FormField<String>(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                builder: (FormFieldState<String> state) {
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
                            BuildGroupForm(groupAdminList: groupAdminList),
//                            TextFormField(
//                              validator: (value) {
//                                if (value.isEmpty) {
//                                  return 'Please enter some text';
//                                }
//                                return null;
//                              },
//                              decoration:
//                              InputDecoration(labelText: 'Organizing Individuals'),
//                              onSaved: (value) => organizingIndividuals = [uid],
//                            ),
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
                },
                onSaved: (value) {
                  organizingGroup = _currentSelectedValue;

                }
            );
          }
        },
      );
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


class BuildGroupForm extends StatefulWidget {
  List<String> groupAdminList;
  BuildGroupForm({this.groupAdminList});
  BuildGroupFormState createState() => BuildGroupFormState();
}
class BuildGroupFormState extends State<BuildGroupForm> {

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
            });

          },
          items: widget.groupAdminList.map((String value) {
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

