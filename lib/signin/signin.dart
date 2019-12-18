import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(title: 'Sign In'),
    );
  }
}

class SignInPage extends StatefulWidget {
  SignInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
      child: SafeArea(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                //Image.asset('assets/login_icon.png'),
                SizedBox(height: 20.0),
                Text('UT CLUBS LOGIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40)),
              ],
            ),
            SizedBox(height: 120.0),
            TextField(
              decoration: InputDecoration(
                  labelText: 'UT EID',
                  filled: false,
                  labelStyle: TextStyle(color: Colors.white),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white))),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                filled: false,
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 24.0),
            Center(
                child: RaisedButton(
                  child: Text('SIGN IN', style: TextStyle(color: Colors.orange[800])),
                  onPressed: () {},
                  color: Colors.white
            ))
          ])),
    ));
  }
}
