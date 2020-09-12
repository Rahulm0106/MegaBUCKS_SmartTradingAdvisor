import 'package:flutter/material.dart';
import 'package:smart_trading_advisor/assets/app_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_trading_advisor/screens/home.dart';

class Terms extends StatefulWidget {
  static const routeName = '/terms';
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  FirebaseUser newUser;
  bool isloggedin = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((newUser) {
      if (newUser == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.newUser = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  // ignore: must_call_super
  void initState() {
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder("Terms & Conditions"),
      bottomNavigationBar: BottomNav(),
      body: !isloggedin
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                Container(
                  height: 300,
                  child: Image(
                    image: AssetImage("images/logo.png"),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
    );
  }
}
