import 'package:flutter/foundation.dart';

class Job {
  Job({
    @required this.name,
    @required this.ratePerHour,
  })  : assert(name != null),
        assert(ratePerHour != null);
  final String name;
  final int ratePerHour;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "ratePerHour": ratePerHour,
    };
  }
}
