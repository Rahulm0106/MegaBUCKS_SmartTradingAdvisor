import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                        physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
