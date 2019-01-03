import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test2/modals/user.model.dart';

class UserBio extends StatefulWidget {
  _UserBioState createState() => _UserBioState();
  DocumentSnapshot _user;
  UserBio(this._user);
}

class _UserBioState extends State<UserBio> {
  User _userData;
  List<String> testJ = ["jafar", "aroma"];
  @override
  void initState() {
    super.initState();
    // TODO - init a user data from firestore to show on the screen.
    print('item initialized');
    print(widget._user['qrCodes']);
    _userData = User.fromMap(widget._user.data);
    print(_userData.qrCodes.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text(_userData.userName),
          ),
          Text(_userData.phoneNumber),
          Expanded(
            child: ListView.builder(
              itemCount: _userData.qrCodes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_userData.qrCodes[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
