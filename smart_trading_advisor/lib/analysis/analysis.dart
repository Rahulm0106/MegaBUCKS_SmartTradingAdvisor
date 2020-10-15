import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_trading_advisor/assets/app_layout.dart';
import 'package:smart_trading_advisor/start/startup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Analysis extends StatefulWidget {
  static const routeName = '/analysis';
  final String stockanalysis;
  Analysis({Key key, @required this.stockanalysis}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState(stockanalysis);
}

class _AnalysisState extends State<Analysis> {
  String stockanalysis;
  _AnalysisState(this.stockanalysis);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  FirebaseUser newUser;
  bool isloggedin = false;
  var jsonResponse;

  Future<void> getQuotes() async {
    String url = "http://10.0.2.2:500/api?Symbol=$stockanalysis";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
      });
      print(jsonResponse);
    } else {
      jsonResponse = response.statusCode;
      print("Request failed with status: ${response.statusCode}");
    }
  }

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((newUser) {
      if (newUser == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Start()));
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
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder("Analysis"),
      body: Container(
        child: !isloggedin
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
                  Container(
                    child: Center(
                      child: RichText(
                          text: TextSpan(
                        text: stockanalysis,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    child: Center(
                      child: RichText(
                          text: TextSpan(
                        text: jsonResponse,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
