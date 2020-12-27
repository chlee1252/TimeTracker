import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // FirestoreService cannot create outside of this file.
  // Ensure only one object of FirestoreService created.
  FirestoreService._();
  static final instance = FirestoreService._();
  
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print("$path: $data");
    await reference.setData(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
    )
        .toList());
  }
}