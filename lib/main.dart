import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/screens/landing.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:test2/utils/backend.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String qrCode = '';
  void readQr() async {}
  FirestoreBackend _backend = new FirestoreBackend();

  Stream<QuerySnapshot> list({int limit, int offset}) {
    Stream<QuerySnapshot> snapshots =
        Firestore.instance.collection('books').snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  // test() {
  //   print('test method');
  //   Firestore.instance
  //       .collection('users')
  //       .where('qrCodes', arrayContains: 'second')
  //       .getDocuments()
  //       .then((docs) {
  //     print('hwllo doc');
  //     print(docs.documents[0].data['name']);
  //   });
  // }

  Future<String> _scanQrCode() async {
    return await new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        .scan();
  }

  _findUserAndMoveToUserProfile() async {
    try {
      String qrCode = await _scanQrCode();
      if (qrCode.length > 0) {
        print(qrCode);
        _backend.getUser(qrCode).then((docs) {
          String userId = docs.documents[0].documentID;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Landing(userId)),
          );
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Text('$qrCode'),
            Expanded(child: BookList())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _incrementCounter();

          _findUserAndMoveToUserProfile();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Landing('test string')),
          // );
        },
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text('some text'),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
