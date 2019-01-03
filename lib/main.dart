import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/screens/landing.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:test2/utils/backend.dart';
import 'package:test2/utils/barcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakker Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bakker Shop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String qrCode = '';
  DocumentSnapshot _userDocSnapshot = null;
  bool _searching = false;

  void readQr() async {}
  FirestoreBackend _backend = new FirestoreBackend();
  BarcodeScanUtility scanner = new BarcodeScanUtility();
  _findUserFromBarcode() async {
    try {
      _searching = true;
      String qrCode = await scanner.scanQrCode();
      if (qrCode.length > 0) {
        print(qrCode);
        _backend.getUser(qrCode).then((docs) {
          setState(() {
            _searching = false;
            _userDocSnapshot = docs.documents[0];
          });
        });
      } else {
        print('something wrong in getting qr code');
      }
    } catch (e) {
      // print(e);
      print('error happened');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {},
          )
        ],
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _searching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _userList(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _findUserFromBarcode();
        },
        tooltip: 'scan',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _userList() {
    return _userDocSnapshot != null
        ? ListTile(
            title: Text(_userDocSnapshot.data['name']),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Landing(_userDocSnapshot.documentID)));
            },
          )
        : Center(
            child: Text('Please tap on search button to scan qr code'),
          );
  }
}
