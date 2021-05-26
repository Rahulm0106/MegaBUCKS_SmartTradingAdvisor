import 'package:flutter/material.dart';
import 'package:smart_trading_advisor/assets/app_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_trading_advisor/screens/stocklist.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoreInfo extends StatefulWidget {
  static const routeName = '/moreinfo';
  final String url;
  MoreInfo({Key key, @required this.url}) : super(key: key);
  @override
  _MoreInfoState createState() => _MoreInfoState(url);
}

class _MoreInfoState extends State<MoreInfo> {
  String url;
  _MoreInfoState(this.url);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  FirebaseUser newUser;
  bool isloggedin = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((newUser) {
      if (newUser == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyStocksList()));
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
      appBar: appBarBuilder("More Info"),
      bottomNavigationBar: BottomNav(),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'http://10.0.2.2:5000/error?Symbol=$url',
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {
            print('Page started loading $url');
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
          Navigator.of(context).pop(true);
          url = '';
        },
        child: const Icon(Icons.bar_chart, color: Colors.white),
      ),
    );
  }
}
