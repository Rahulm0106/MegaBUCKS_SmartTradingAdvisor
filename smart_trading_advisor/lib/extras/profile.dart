import 'package:flutter/material.dart';
import 'package:smart_trading_advisor/assets/app_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_trading_advisor/start/startup.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  // String _email, _password;

  // bool _isHidden = true;

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

  // Future<void> changeEmail(String email) async {
  //   FirebaseUser user = await _auth.currentUser();
  //   user.updateEmail(email).then((_) {
  //     debugPrint("Succesfull changed email");
  //   }).catchError((error) {
  //     debugPrint("email can't be changed" + error.toString());
  //   });
  //   return null;
  // }

  Future<void> changePassword(String password) async {
    FirebaseUser user = await _auth.currentUser();
    user.updatePassword(password).then((_) {
      debugPrint("Succesfull changed password");
    }).catchError((error) {
      debugPrint("Password can't be changed" + error.toString());
    });
    return null;
  }

  Future<void> deleteUser() async {
    FirebaseUser user = await _auth.currentUser();
    user.delete().then((_) {
      debugPrint("Succesfull user deleted");
    }).catchError((error) {
      debugPrint("user can't be delete" + error.toString());
    });
    return null;
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
      appBar: appBarBuilder("Profile"),
      body: SingleChildScrollView(
        child: Container(
          child: !isloggedin
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Container(
                      height: 200,
                      child: Image(
                        image: AssetImage("images/logo.png"),
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: Center(
                        child: data(),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  StreamBuilder<DocumentSnapshot> data() {
    return StreamBuilder(
      stream: db.collection('user').document(newUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> documentFields = snapshot.data.data;
          return Column(
            children: <Widget>[
              RichText(
                  text: TextSpan(
                text: 'Name:',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                text:
                    '${documentFields['first-name']} ${documentFields['last-name']}',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(62, 72, 184, 1.0)),
              )),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                text: 'Email: ',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      text: '${documentFields['email']}',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(62, 72, 184, 1.0)))),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(
                        email: documentFields['email']);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Forgot Password'),
                            content: Text(
                                'An email with your password verification link has been successfully sent to you registered email ID, please click on the link to generate a new password...'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('ERROR'),
                            content: Text('$e'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  }
                },
                child: Container(
                  child: Text('Reset Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  width: 150,
                  alignment: Alignment.center,
                ),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // RaisedButton(
              //   padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
              //   onPressed: () async {
              //     try {
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text('Reset Email'),
              //               // content: Text(
              //               //     'An email with your password verification link has been successfully sent to you registered email ID, please click on the link to generate a new password...'),
              //               content: Form(
              //                 key: _formKey,
              //                 child: TextFormField(
              //                     validator: (value) {
              //                       Pattern pattern =
              //                           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              //                       RegExp regex = new RegExp(pattern);
              //                       if (value.isEmpty || !regex.hasMatch(value))
              //                         return 'Enter Valid Email Id!!!';
              //                       else
              //                         return null;
              //                     },
              //                     decoration: InputDecoration(
              //                         hintText: 'Email',
              //                         prefixIcon: Icon(Icons.email)),
              //                     onSaved: (value) => _email = value),
              //               ),
              //               actions: <Widget>[
              //                 FlatButton(
              //                     onPressed: () async {
              //                       if (_formKey.currentState.validate()) {
              //                         _formKey.currentState.save();

              //                         try {
              //                           // changeEmail(_email);
              //                           if (newUser != null) {
              //                             var firebaseUser =
              //                                 await _auth.currentUser();
              //                             firebaseUser.updateEmail(_email);
              //                             email(firebaseUser, _email);
              //                           }
              //                           Navigator.of(context).pop();
              //                         } catch (e) {
              //                           showDialog(
              //                               context: context,
              //                               builder: (BuildContext context) {
              //                                 return AlertDialog(
              //                                   title: Text('Error'),
              //                                   content: Text(
              //                                       '$e\n\nUnable to change your email'),
              //                                   actions: <Widget>[
              //                                     FlatButton(
              //                                         onPressed: () {
              //                                           Navigator.of(context)
              //                                               .pop();
              //                                         },
              //                                         child: Text('OK'))
              //                                   ],
              //                                 );
              //                               });
              //                         }
              //                       }
              //                     },
              //                     child: Text('OK'))
              //               ],
              //             );
              //           });
              //     } catch (e) {
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text('ERROR'),
              //               content: Text('$e'),
              //               actions: <Widget>[
              //                 FlatButton(
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                     child: Text('OK'))
              //               ],
              //             );
              //           });
              //     }
              //   },
              //   child: Container(
              //     child: Text('Reset Email',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 20.0,
              //             fontWeight: FontWeight.bold)),
              //     width: 150,
              //     alignment: Alignment.center,
              //   ),
              //   color: Colors.black,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20.0),
              //   ),
              // )
            ],
          );
        } else {
          return Text('Some Error');
        }
      },
    );
  }

  void email(FirebaseUser firebaseUser, String _email) {
    db
        .collection("user")
        .document(firebaseUser.uid)
        .updateData({"email": _email});
  }
}
