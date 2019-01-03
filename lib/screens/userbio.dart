import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test2/modals/user.model.dart';
import 'package:test2/utils/backend.dart';

class UserBio extends StatefulWidget {
  _UserBioState createState() => _UserBioState();
  DocumentSnapshot _user;
  UserBio(this._user);
}

class _UserBioState extends State<UserBio> {
  User _userData;
  String firestoreUserId;
  FirestoreBackend _backend = new FirestoreBackend();

  @override
  void initState() {
    super.initState();
    firestoreUserId = widget._user.documentID;
    _userData = User.fromMap(widget._user.data);
  }

  Future<List<DocumentSnapshot>> getBarcode() async {
    QuerySnapshot qn = await Firestore.instance
        .collection('users')
        .document(firestoreUserId)
        .collection('barcodes')
        .getDocuments();
    print(qn.documents);
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _backend.addQrCode(firestoreUserId, 'qrcodeSample').then((value) {
            setState(() {
              print('something has to happen');
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
              child: FutureBuilder(
            future: getBarcode(),
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading..!'));
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _backend
                            .deleteQrCode(firestoreUserId,
                                snapshot.data[index].documentID, "sampleCode")
                            .then((onValue) {
                          setState(() {});
                        });
                      },
                    ),
                    title: Text(snapshot.data[index].data['code']),
                  );
                },
              );
            },
          )
              // ListView.builder(
              //   itemCount: _userData.qrCodes.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return ListTile(
              //       trailing: IconButton(
              //         icon: Icon(Icons.delete),
              //         onPressed: () {},
              //       ),
              //       title: Text(_userData.qrCodes[index]),
              //     );
              //   },
              // ),
              )
        ],
      ),
    );
  }

  Widget userBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Center(
          child: Text(
            _userData.phoneNumber,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[Text('Total Points'), Text('100.0')],
            ),
            Column(
              children: <Widget>[
                Text('Total Cards Assigned'),
                Text(_userData.qrCodes.length.toString())
              ],
            )
          ],
        )
      ],
    );
  }
}
