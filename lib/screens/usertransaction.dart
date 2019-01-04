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
  double _paitFraction = 0.1;
  double _mainFactor = 0.25;

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
        if (_paintBill.length == 0) {
          _paintBill = '0';
        }
        double totalBill = double.parse(_totalBill);
        double paintBill = double.parse(_paintBill);
        if (totalBill < paintBill) {
          return;
        }
        formKey.currentState.reset();

        DateTime date = new DateTime.now();
        double points = totalBill * _mainFactor + paintBill * _paitFraction;
        var data = {
          'note': 'some note if there is any',
          'totalBill': _totalBill,
          'paintBill': _paintBill,
          'date': date,
          'points': points
        };
        Firestore.instance
            .collection('users')
            .document(widget._user.documentID)
            .collection('transaction')
            .add(data)
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
        _transactionFrom(),
        Expanded(child: _userTransactions()),
      ],
    );
  }

  _transactionFrom() {
    return Form(
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
            //     _totalBill.isEmpty ? 'total amount can\'t be empty.' : null,
            onSaved: (val) => _paintBill = val,
            keyboardType: TextInputType.number,
          ),
          Center(
            child: RaisedButton(
                key: Key('Update'),
                padding: EdgeInsets.all(5.0),
                child: Text('Update', style: TextStyle(fontSize: 16.0)),
                onPressed: validateAndSubmit),
          ),
        ],
      ),
    );
  }

  _userTransactions() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(widget._user.documentID)
          .collection('transaction')
          .snapshots(),
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
                    title: Text('Bill Amount : ' +
                        document.data['totalBill'].toString()),
                    subtitle: Text(
                        DateTime.parse(document.data['date'].toString())
                            .toString()),
                    trailing: Container(
                        child: document.data['points'] != null
                            ? Text(document.data['points'].toString())
                            : Text('not updated')));
              }).toList(),
            );
        }
      },
    );
  }
}
