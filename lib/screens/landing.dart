import 'package:flutter/material.dart';
import 'package:test2/modals/user.model.dart';
import 'package:test2/screens/userbio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/screens/usertransaction.dart';

class Landing extends StatefulWidget {
  final String userId;
  Landing(this.userId);

  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentIndex = 0;
  UserTransaction _transaction;
  UserBio _userBio;
  List<Widget> landingWidgets = [];
  User _user;
  bool _isLoading = true;
  @override
  initState() {
    super.initState();
    _user = null;
    // widget gets the user ID from the barcode scan.
    // from this init state get the user data from firestore and cache it here and pass it to usr bio.
    Firestore.instance
        .collection('users')
        .document(widget.userId)
        .get()
        .then((user) {
      _user = User.fromMap(user.data);
      _transaction = new UserTransaction(user);
      _userBio = new UserBio(user);
      landingWidgets = [_transaction, _userBio];
      print('some result has come back');
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _moveToTransaction() {}

  void _moveToUserBio() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading ? Text('Loading..!') : Text(_user.userName),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.green,
        child: _isLoading ? Text('loading') : landingWidgets[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.help_outline), title: Text('Transactions')),
          BottomNavigationBarItem(
              icon: Icon(Icons.high_quality), title: Text('Bio')),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                _moveToTransaction();
                break;

              default:
                {
                  _moveToUserBio();
                  break;
                }
            }
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
