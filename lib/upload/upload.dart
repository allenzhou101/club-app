import 'package:club_app/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:club_app/login/sign_in.dart';
import 'package:club_app/main.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;



class UploadPhoto extends StatefulWidget {
  UploadPhotoState createState() => UploadPhotoState();
}


class UploadPhotoState extends State<UploadPhoto>{
  File _image;
  String _uploadedFileURL;
  @override
  Widget build(BuildContext context) {

    Future chooseFile() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });
      });
    }
    // TODO: implement build
    return Center(
        child: Row(
          children: <Widget>[
            _image != null
                ? Image.asset(
              _image.path,
              height: 50,
            )
                : Container(
              child: Icon(Icons.photo_filter, size: 75)
            ),
            SizedBox(width: 25),

            _image == null
                ? RaisedButton(
              child: Text('Add Event Photo'),
              onPressed: chooseFile,
              color: Colors.cyan,
            )
                : RaisedButton(
                child: Text("Change Event Photo"),
                onPressed: chooseFile
            ),
//            Column(
//              children: <Widget>[
//                RaisedButton(
//                  child: Text("Change Event Photo"),
//                  onPressed: chooseFile
//                ),
//                RaisedButton(
//                  child: Text("Continue"),
//                  color: Colors.orange,
//                  onPressed: () {
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) {
//                          return UploadPage(image: _image, uploadedFileURL: _uploadedFileURL);
//                        }
//                    ));
//                  },
//                )
//              ],
//            ),
//            _image != null
//                ? RaisedButton(
//              child: Text('Upload File'),
//              onPressed: uploadFile,
//              color: Colors.cyan,
//            )
//                : Container(),
//                    _image != null
//                        ? RaisedButton(
//                      child: Text('Clear Selection'),
//                      onPressed: clearSelection,
//                    )
//                        : Container(),
            _uploadedFileURL != null
                ? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),


          ],
        )
    );
  }
}
class UploadPage extends StatelessWidget {
  File image;
  String uploadedFileURL;
  UploadPage({this.image, this.uploadedFileURL});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PrimaryColor,
          title: Text('Create Event'),
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
        body: UploadEvent(image:image, uploadedFileURL: uploadedFileURL));
  }
}

class UploadEvent extends StatefulWidget {
  File image;
  String uploadedFileURL;
  UploadEvent({this.image, this.uploadedFileURL});
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




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var textController = new TextEditingController();
    textController.text = "${selectedDate.toLocal()}".split(' ')[0] +
        " " +
        selectedTime.toString().substring(10, 15);
    Future<Null> _selectDateAndTime(BuildContext context) async {
      await _selectDate(context);
      await _selectTime(context);
    }
    var categoryList = ["Tech", "Culture", "Sustainability"];
    var textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);

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



            return ListView(children: [





              FormField<String>(
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
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
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
                            UploadPhoto(),
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
                                  if (_formKey.currentState.validate() && widget.image != null) {
                                    // If the form is valid, display a Snackbar.
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('Processing Data')));
                                    _formKey.currentState.save();
                                    addData(widget.image, widget.uploadedFileURL);
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
            )]);
          }
        },
      );
  }

  void addData(_image, _uploadedFileURL) async{
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
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
      'category': category,
      'imageURL': _uploadedFileURL
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

