import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test2/modals/user.model.dart';
import 'package:test2/utils/backend.dart';
import 'package:test2/utils/barcode.dart';

import 'package:url_launcher/url_launcher.dart';

class UserBio extends StatefulWidget {
  _UserBioState createState() => _UserBioState();
  DocumentSnapshot _user;
  UserBio(this._user);
}

class _UserBioState extends State<UserBio> {
  User _userData;
  String firestoreUserId;
  FirestoreBackend _backend = new FirestoreBackend();
  BarcodeScanUtility scanner = new BarcodeScanUtility();
  int _count = 0;
  @override
  void initState() {
    super.initState();
    firestoreUserId = widget._user.documentID;
    print(widget._user.data['totalPoint']);
    _userData = User.fromMap(widget._user.data);
    print(_userData.totalPoint);
  }

  Future<DocumentSnapshot> getBarcode() async {
    DocumentSnapshot qn = await Firestore.instance
        .collection('users')
        .document(firestoreUserId)
        .get();
    return qn;
  }

  _launchURL(phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          scanner.scanQrCode().then((barcode) {
            _backend.addQrCode(firestoreUserId, barcode).then((onValue) {
              _count++;
              setState(() {});
            });
          });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200.0,
            child: userBio(),
          ),
          Expanded(
            child: _buildBarCodeList(),
          )
        ],
      ),
    );
  }

  Widget userBio() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    child: Icon(Icons.account_circle),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _userData.phoneNumber,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          _launchURL(_userData.phoneNumber);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _scoreDisplay(_userData.totalPoint.toString(), 'Points'),
                _scoreDisplay(_userData.totalCards.toString(), 'Cards'),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildBarCodeList() {
    return FutureBuilder(
      future: getBarcode(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading..!'));
        }
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        return ListView.builder(
          itemCount: snapshot.data['qrCodes'].length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _backend
                      .deleteQrCode(
                          firestoreUserId, snapshot.data['qrCodes'][index])
                      .then((value) {
                    setState(() {});
                  });
                },
              ),
              title: Text(snapshot.data['qrCodes'][index]),
            );
          },
        );
      },
    );
  }

  _scoreDisplay(String score, String type) {
    return Column(
      children: <Widget>[
        Text(
          score,
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          type,
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
}
