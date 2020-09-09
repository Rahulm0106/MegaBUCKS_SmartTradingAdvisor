import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // _drawer() {
  //   new Drawer(
  //     child: new ListView(
  //       padding: const EdgeInsets.all(0.0),
  //       children: <Widget>[
  //         new UserAccountsDrawerHeader(
  //             accountName: new Text("Place Holder"),
  //             accountEmail:
  //                 new Text("placeholde@email.com"), // ("${newUser.email}"),
  //             currentAccountPicture: new CircleAvatar(
  //               backgroundColor: Colors.red,
  //             )),
  //         new ListTile(
  //           title: new Text('Settings'),
  //           trailing: new Icon(Icons.settings),
  //           onTap: () {
  //             debugPrint("Settings");
  //           },
  //         ),
  //         new ListTile(
  //           title: new Text('FAQs'),
  //           trailing: new Icon(Icons.question_answer),
  //           onTap: () {
  //             debugPrint("FAQs");
  //           },
  //         ),
  //         new ListTile(
  //           title: new Text('Terms & Conditions'),
  //           trailing: new Icon(Icons.list),
  //           onTap: () {
  //             debugPrint("T and C");
  //           },
  //         ),
  //         new ListTile(
  //           title: new Text('My Stocks'),
  //           trailing: new Icon(Icons.library_books),
  //           onTap: () {
  //             debugPrint("My Stocks");
  //           },
  //         ),
  //         new ListTile(
  //           title: new Text('Logout'),
  //           trailing: new Icon(Icons.logout),
  //           onTap: () async {
  //             _auth.signOut();
  //             debugPrint('logout');
  //           },
  //         ),
  //         new ListTile(
  //           title: new Text('Page Close'),
  //           trailing: new Icon(Icons.close),
  //           onTap: () => Navigator.of(context).pop(),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
              icon: Icon(Icons.circle), onPressed: () => debugPrint("Tapped"))
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
                  // RaisedButton(
                  //   padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  //   onPressed: signOut,
                  //   child: Text('Signout',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold)),
                  //   color: Colors.orange,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //   ),
                  // )
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
                  Icons.list,
                  color: Colors.white,
                ),
                title: Text("Menu"))
          ],
          onTap: (int index) {
            if (index == 4) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        color: Color(0xff232f34),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                          ),
                          SizedBox(
                              height: (56 * 6).toDouble(),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    color: Color(0xff344955),
                                  ),
                                  child: Stack(
                                    alignment: Alignment(0, 0),
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        top: -36,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              border: Border.all(
                                                  color: Color(0xff232f34),
                                                  width: 10)),
                                          child: Center(
                                            child: ClipOval(
                                              child: Image.network(
                                                "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
                                                fit: BoxFit.cover,
                                                height: 36,
                                                width: 36,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: ListView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                "Inbox",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.inbox,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Starred",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.star_border,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Sent",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Trash",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Spam",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.error,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Drafts",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Icon(
                                                Icons.mail_outline,
                                                color: Colors.white,
                                              ),
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))),
                          Container(
                            height: 56,
                            color: Color(0xff4a6572),
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

// class Dashboard extends StatelessWidget {
//   static const routeName = '/home';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text("Dashboard", style: TextStyle(color: Colors.black)),
//         elevation: 0.0,
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.circle), onPressed: () => debugPrint("Tapped"))
//         ],
//       ),
//
//       backgroundColor: Colors.white,
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             InkWell(
//               child: Text(
//                 "Tap Me",
//                 style: TextStyle(fontSize: 25),
//               ),
//               onTap: () => debugPrint("tapped..."),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// showMenu(context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.0),
//               topRight: Radius.circular(16.0),
//             ),
//             color: Color(0xff232f34),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Container(
//                 height: 36,
//               ),
//               SizedBox(
//                   height: (56 * 6).toDouble(),
//                   child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16.0),
//                           topRight: Radius.circular(16.0),
//                         ),
//                         color: Color(0xff344955),
//                       ),
//                       child: Stack(
//                         alignment: Alignment(0, 0),
//                         overflow: Overflow.visible,
//                         children: <Widget>[
//                           Positioned(
//                             top: -36,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(50)),
//                                   border: Border.all(
//                                       color: Color(0xff232f34), width: 10)),
//                               child: Center(
//                                 child: ClipOval(
//                                   child: Image.network(
//                                     "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
//                                     fit: BoxFit.cover,
//                                     height: 36,
//                                     width: 36,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             child: ListView(
//                               physics: NeverScrollableScrollPhysics(),
//                               children: <Widget>[
//                                 ListTile(
//                                   title: Text(
//                                     "Inbox",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.inbox,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Starred",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.star_border,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Sent",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.send,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Trash",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.delete_outline,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Spam",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.error,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Drafts",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   leading: Icon(
//                                     Icons.mail_outline,
//                                     color: Colors.white,
//                                   ),
//                                   onTap: () {},
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ))),
//               Container(
//                 height: 56,
//                 color: Color(0xff4a6572),
//               )
//             ],
//           ),
//         );
//       });
// }
