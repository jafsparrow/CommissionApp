import 'package:flutter/material.dart';
import 'package:test2/utils/backend.dart';

class UserManagement extends StatefulWidget {
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  static final formKey = GlobalKey<FormState>();
  FirestoreBackend _backend = new FirestoreBackend();
  String _username;
  String _phone;
  bool _submitting = false;
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _addUser() {
    if (validateAndSave()) {
      setState(() {
        _submitting = true;
      });
      print('form submitted');
      _backend.addUser(_username, _phone).then((user) {
        _submitting = false;
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder(),
                        hintText: 'User Name',
                        labelText: 'User full name'),
                    onSaved: (val) {
                      _username = val;
                    },
                    validator: (val) =>
                        val.isEmpty ? 'username can\'t be empty.' : null,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(5.0),
                        border: OutlineInputBorder(),
                        hintText: 'Mobile Number',
                        labelText: 'Mobile Number'),
                    onSaved: (val) {
                      _phone = val;
                    },
                    validator: (val) =>
                        val.isEmpty ? 'Mobile can\'t be empty.' : null,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: _submitting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            elevation: 6.0,
                            color: Colors.orange.shade100,
                            child: Text('Add new user'),
                            onPressed: () {
                              _addUser();
                            },
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
