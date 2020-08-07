import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_ticker/app/home/models/job.dart';
import 'package:time_ticker/services/auth.dart';
import 'package:time_ticker/services/database.dart';
import 'package:time_ticker/widgets/platformAlertDialog.dart';
import 'package:time_ticker/widgets/platformExceptionAlertDialog.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure?",
      defaultActionText: "Logout",
      secondaryActionText: "Cancel",
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try{
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: "Blogging", ratePerHour: 10));
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Operation failed",
        exception: e,
      ).show(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }
}
