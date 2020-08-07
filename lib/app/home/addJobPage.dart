import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_ticker/app/home/models/job.dart';
import 'package:time_ticker/services/database.dart';
import 'package:time_ticker/widgets/platformExceptionAlertDialog.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => AddJobPage(database: database),
      ),
    );
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  Database get database => widget.database;

  String _name;
  int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;

  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      _createJob();
    }
  }

  Future<void> _createJob() async {
    try {
      final job = Job(name: _name, ratePerHour: _ratePerHour);
      await database.createJob(job);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Operation failed",
        exception: e,
      ).show(context);
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Job Name"),
        validator: (value) => value.isNotEmpty ? null : "Name cannot be empty",
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Rate Per Hour"),
        validator: (value) => value.isNotEmpty ? null : "Hour cannot be empty",
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("New Job"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }
}
