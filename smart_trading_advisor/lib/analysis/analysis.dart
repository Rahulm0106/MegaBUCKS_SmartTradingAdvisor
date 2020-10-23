import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_trading_advisor/analysis/moreinfo.dart';
import 'package:smart_trading_advisor/assets/app_layout.dart';
import 'package:smart_trading_advisor/start/startup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Analysis extends StatefulWidget {
  static const routeName = '/analysis';
  final String url;
  Analysis({Key key, @required this.url}) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState(url);
}

class _AnalysisState extends State<Analysis> {
  String url;
  _AnalysisState(this.url);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  FirebaseUser newUser;
  bool isloggedin = false;

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
    return !isloggedin
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: appBarBuilder("Analysis"),
            bottomNavigationBar: BottomNav(),
            body: Builder(builder: (BuildContext context) {
              return WebView(
                initialUrl: 'http://10.0.2.2:5000/api?Symbol=$url',
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (String url) {
                  print('Page started loading');
                },
                onPageFinished: (String url) {
                  print('Page finished loading');
                },
                gestureNavigationEnabled: true,
              );
            }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoreInfo(
                              url: url,
                            )));
              },
              child:
                  const Icon(Icons.info_outline_rounded, color: Colors.white),
            ),
          );
  }
}
