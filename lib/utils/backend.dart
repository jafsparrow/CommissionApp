import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/modals/user.model.dart';

abstract class Backend {
  Future<dynamic> addTrasaction() {}
  Future<dynamic> updateTransaction() {}
  Future<dynamic> deleteTransaction() {}
  // for the user bio update.
  Future<dynamic> addQrCode(String userId, String qrCode) {}
  Future<void> deleteQrCode(String userId, String qrCode) {}
  Future<QuerySnapshot> getUser(String barcodeId) {}

  Future<dynamic> addUser(String username, String mobile) {}

  Future<QuerySnapshot> findUsers() {}

  Future<void> updateUserData(String userId, String field, String value) {}
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

  @override
  Future addQrCode(String userId, String qrCode) {
    Map<String, String> data = {"code": qrCode};
    // return userDBCollection.document(userId).collection('barcodes').add(data);

    return userDBCollection.document(userId).updateData({
      'qrCodes': FieldValue.arrayUnion([qrCode])
    });
  }

  @override
  Future<void> deleteQrCode(String userId, String qrCode) {
    return userDBCollection.document(userId).updateData({
      'qrCodes': FieldValue.arrayRemove([qrCode])
    });
    // return userDBCollection
    //     .document(userId)
    //     .collection('barcodes')
    //     .document(barcodeDocId)
    //     .delete();
  }

  @override
  Future<QuerySnapshot> getUser(String barcodeId) {
    return Firestore.instance
        .collection('users')
        .where('qrCodes', arrayContains: barcodeId)
        .getDocuments();
  }

  @override
  Future addUser(String username, String mobile) {
    DateTime _today = DateTime.now();
    Map<String, dynamic> newUser = {
      "name": username,
      "phone": mobile,
      "addedDate": _today,
      "qrCodes": []
    };
    return userDBCollection.add(newUser);
  }

  @override
  Future<QuerySnapshot> findUsers() {
    return userDBCollection.orderBy('addedDate').getDocuments();
  }

  @override
  Future<void> updateUserData(String userId, String field, String value) async {
    // return userDBCollection.document(userId).updateData({field: value});
    print(userId);
    print(field);
    print(value);
    final DocumentReference postRef = userDBCollection.document(userId);
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        var currentData =
            postSnapshot.data[field] != null ? postSnapshot.data[field] : 0;
        await tx.update(postRef, <String, dynamic>{
          'totalPoint': currentData + double.parse(value.toString())
        });
      }
    });
  }
}

// the array uinion did not add duplicate strings to the array in firestore.don't know why .. need a tutorial on this. firstore letting me
// to have duplicates
// @override
// Future addQrCode(String userId, String qrCode) {
//   Map<String, String> data = {"qrCodes": qrCode};
//   return userDBCollection.document(userId).updateData({
//     'qrCodes': FieldValue.arrayUnion([data['qrCodes']])
//   });
// }
