import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_trading_advisor/assets/my_flutter_app_icons.dart';
import 'package:smart_trading_advisor/screens/startup.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Dashboard", style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(MyFlutterApp.image2vector),
              onPressed: () => debugPrint("Tapped"))
        ],
      ),
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
                    alignment: Alignment.center,
                    child: Text(
                      "Hello!!! you are Logged in as ${newUser.email}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_books,
                  color: Colors.white,
                ),
                title: Text("Stocks")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                title: Text("Fav")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text("Add")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                title: Text("Menu"))
          ],
          onTap: (int index) {
            if (index == 4) {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                              height: (56 * 4).toDouble(),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                      color: Colors.grey,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 4,
                                      )),
                                  child: Stack(
                                    alignment: Alignment(0, 0),
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        child: ListView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                "Settings",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              leading: Icon(
                                                Icons.settings,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                debugPrint("Settings");
                                              },
                                            ),
                                            ListTile(
                                              title: Text(
                                                "FAQs",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              leading: Icon(
                                                Icons.question_answer,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                debugPrint("FAQ");
                                              },
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Terms & Conditions",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              leading: Icon(
                                                Icons.list,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                debugPrint("T&C");
                                              },
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              leading: Icon(
                                                Icons.logout,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                debugPrint("Logout");
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))),
                          Container(
                            height: 56,
                            color: Colors.transparent,
                          )
                        ],
                      ),
                    );
                  });
            } else {
              debugPrint("Tapped Item: $index");
            }
          },
        ),
      ),
    );
  }
}
