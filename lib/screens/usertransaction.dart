import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/modals/transaction.modal.dart';

class UserTransaction extends StatefulWidget {
  DocumentSnapshot _user;
  UserTransaction(this._user);
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  TextEditingController _paintValueController = TextEditingController();
  TextEditingController _electricValueController =
      TextEditingController(text: 'super man is awesome');
  static final formKey = GlobalKey<FormState>();

  String _totalBill;
  String _paintBill;
  String _formHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        // TransactionModal _trasaction = new TransactionModal(
        //     double.parse(_totalBill), double.parse(_paintBill));
        // print(_trasaction);

        DateTime dates = new DateTime.now();
        var datas = {
          'note': 'some note if there is any',
          'billAmount': _totalBill,
          'date': dates
        };
        Firestore.instance
            .collection('transaction')
            .add(datas)
            .then((item) => print('result'));
      } catch (e) {
        print(e);
      }
      //   try {
      //     FirebaseUser user = await FirebaseAuth.instance
      //         .signInWithEmailAndPassword(email: _totalBill, password: _paintBill);
      //     setState(() {
      //       _formHint = 'Success\n\nUser id: ${user.uid}';
      //     });
      //   } catch (e) {
      //     setState(() {
      //       _formHint = 'Sign In Error\n\n${e.toString()}';
      //     });
      //   }
      // } else {
      //   setState(() {
      //     _formHint = '';
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new TextFormField(
                key: new Key('bill'),
                decoration: new InputDecoration(labelText: 'Total Bill amount'),
                validator: (val) =>
                    val.isEmpty ? 'Bill amount can\'t be empty.' : null,
                onSaved: (val) => _totalBill = val,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                key: Key('paint'),
                decoration: InputDecoration(labelText: 'Paint bill amount'),
                // validator: (val) =>
                //     val.isEmpty ? 'paint amount can\'t be empty.' : null,
                onSaved: (val) => _paintBill = val,
                keyboardType: TextInputType.number,
              ),
              RaisedButton(
                  key: Key('Update'),
                  padding: EdgeInsets.all(5.0),
                  child: Text('Update', style: TextStyle(fontSize: 16.0)),
                  onPressed: validateAndSubmit),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.amber,
          child: Center(
            child: Text(
              'Bills',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('transaction').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return new ListTile(
                        title: Text('hellow world'),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
