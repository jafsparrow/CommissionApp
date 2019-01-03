import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Backend {
  Future<dynamic> addTrasaction() {}
  Future<dynamic> updateTransaction() {}
  Future<dynamic> deleteTransaction() {}
}

class FirestoreBackend implements Backend {
  CollectionReference userDBCollection = Firestore.instance.collection('users');
  @override
  Future addTrasaction() async {
    return null;
  }

  @override
  Future deleteTransaction() {
    // TODO: implement deleteTransaction
    return null;
  }

  @override
  Future updateTransaction() {
    // TODO: implement updateTransaction
    return null;
  }
}
