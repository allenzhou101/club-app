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

class UploadEventState extends State<UploadEvent> {
  String eventName, organizingGroup, description, location, time, category;
  var organizingIndividuals = ['words', 'morewords'];
  var attendees = new Map<String, String>();
  final _formKey = GlobalKey<FormState>();

  //Input date and time
  DateTime selectedDate = DateTime.now();
  final now = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final lastMidnight = new DateTime(now.year, now.month, now.day - 1);

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

                    decoration: new InputDecoration(hintText: 'Date and Time'),
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

              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Organizing Group'),
                onSaved: (value) => organizingGroup = uid,
              ),
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
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration:
                    InputDecoration(labelText: 'Organizing Individuals'),
                onSaved: (value) => category = value,
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
              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                      _formKey.currentState.save();

                      final db = Firestore.instance;
                      var docID;
                      final myEventDoc =
                          Firestore.instance.collection("events").add({
                        'eventName': eventName,
                        'organizingGroup': organizingGroup,
                        'organizingIndividuals': organizingIndividuals,
                        'participatingIndividuals': [],
                        'description': description,
                        'location': location,
                        'time': time,
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Home();
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
}
