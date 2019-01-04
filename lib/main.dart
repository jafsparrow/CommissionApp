import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/screens/landing.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:test2/screens/usermanage.dart';
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
        primarySwatch: Colors.orange,
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
  String qrCode = '';
  DocumentSnapshot _userDocSnapshot = null;
  bool _searching = false;

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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Landing(_userDocSnapshot.documentID)));
          });
        });
      } else {
        setState(() {
          _searching = false;
        });
        print('something wrong in getting qr code');
      }
    } catch (e) {
      // print(e);
      setState(() {
        _searching = false;
      });
      print('error happened');
    }
  }

  _moveToUserDetailPage(DocumentSnapshot userDoc) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Landing(userDoc.documentID)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => UserManagement()));
            },
          )
        ],
      ),

      body: Container(
        height: double.infinity,
        child: _userList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _searching
            ? null
            : () {
                _findUserFromBarcode();
              },
        tooltip: 'scan',
        child: Container(
          child: _searching
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(
                  Icons.search,
                  color: Colors.white,
                ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _userList() {
    return StreamBuilder(
      stream: _backend.userDBCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _userListView(snapshot.data.documents);
      },
    );
  }

  _userListView(List<DocumentSnapshot> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        return _userView(docs[index]);
      },
    );
  }

  _userView(DocumentSnapshot userDocumentSnapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        elevation: 5.0,
        child: Container(
          child: ListTile(
            title: Text(userDocumentSnapshot.data['name']),
            leading: CircleAvatar(
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange,
            ),
            subtitle: Text('Total Points'),
            onLongPress: () => _moveToUserDetailPage(userDocumentSnapshot),
          ),
          width: double.infinity,
        ),
      ),
    );
  }
}
