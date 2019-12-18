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
    return Center(
      child: Container(
        child:Center(
          child: Column(
            children: [
              Text("Hey!"),
              Text("Mind enabling push notifications?"),
              Text("You can set reminders to help you remember when your events are happening. These can be changed later in settings"),
              Container(
                  child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: EdgeInsets.all(15),
                      children: [
                      RaisedButton(
                        color: Colors.orange,
                        child: Text('Maybe Later'), //`Text` to display
                        onPressed: () {
                          //Code to execute when Floating Action Button is clicked
                          //...
                        },
                      ),
                   //     SizedBox(width: 25),
                      RaisedButton(
                        color: Colors.orange,
                        child: Text('Sure'), //`Text` to display
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
