import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_ticker/app/home/models/job.dart';
import 'package:time_ticker/services/apiPath.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.uid,
  }) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) async => await _setData(
        path: APIPath.job(uid, "job_abc"),
        data: job.toMap(),
      );

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print("$path: $data");
    await reference.setData(data);
  }
}
