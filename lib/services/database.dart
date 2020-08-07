import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_ticker/app/home/models/job.dart';
import 'package:time_ticker/services/apiPath.dart';
import 'package:time_ticker/services/firestoreService.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({
    @required this.uid,
  }) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, "job_abc"),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );

}
