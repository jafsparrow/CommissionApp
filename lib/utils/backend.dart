import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Backend {
  Future<dynamic> addTrasaction() {}
  Future<dynamic> updateTransaction() {}
  Future<dynamic> deleteTransaction() {}
  // for the user bio update.
  Future<dynamic> addQrCode(String userId, String qrCode) {}
  Future<void> deleteQrCode(String userId, String qrCode) {}
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
