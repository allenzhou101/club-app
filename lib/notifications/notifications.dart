import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: PushNotifications()
        )
    );
  }
}
class PushNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.orange[400],
                Colors.orange[600],
                Colors.orange[700],
                Colors.orange[800]
              ],
            ),
          ),
        child:Center(
          child: Container(
            width: 390,
              child: Column(
                  children: [
                    SizedBox(height: 200),
                    Text("Hey!",
                        style: TextStyle(color: Colors.white, fontSize: 80)),
                    Text("Mind enabling push notifications?",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("You can set reminders to help you remember when your events are happening. These can be changed later in settings",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center),
                    Container(
                        child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: EdgeInsets.all(15),
                            children: [
                              RaisedButton(
                                color: Colors.orange,
                                child: Text('Maybe Later', style: TextStyle(color: Colors.white)), //`Text` to display
                                onPressed: () {
                                  //Code to execute when Floating Action Button is clicked
                                  //...
                                },
                              ),
                              SizedBox(width: 25, height: 200),
                              RaisedButton(
                                color: Colors.white,
                                child: Text('Sure', style: TextStyle(color: Colors.deepOrange)), //`Text` to display
                                onPressed: () {
                                  //Code to execute when Floating Action Button is clicked
                                  //...
                                },
                              )
                            ]
                        )

                    )
                  ]
              )
          )
        )
    );
  }
}
