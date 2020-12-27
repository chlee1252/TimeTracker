import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_ticker/app/home/addJobChangeModel.dart';
import 'package:time_ticker/app/home/models/job.dart';
import 'package:time_ticker/services/database.dart';
import 'package:time_ticker/widgets/platformAlertDialog.dart';
import 'package:time_ticker/widgets/platformExceptionAlertDialog.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, this.database, @required this.model, this.job})
      : super(key: key);
  final Database database;
  final Job job;
  final AddJobChangeModel model;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => ChangeNotifierProvider<AddJobChangeModel>(
          create: (context) => AddJobChangeModel(),
          child: Consumer<AddJobChangeModel>(
            builder: (context, model, _) => EditJobPage(
              database: database,
              job: job,
              model: model,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _rateFocusNode = FocusNode();

  Database get database => widget.database;
  AddJobChangeModel get model => widget.model;

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _editingComplete() {
    final newFocus = _name.isNotEmpty ? _rateFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      _createJob();
    }
  }

  Future<void> _createJob() async {
    model.toggle();
    try {
      final jobs = await widget.database.jobsStream().first;
      final allNames = jobs.map((job) => job.name).toList();
      if (allNames.contains(_name)) {
        PlatformAlertDialog(
          title: "Name Already in Use",
          content: "Please choose a different name",
          defaultActionText: "OK",
        ).show(context);
      } else {
        final job = Job(name: _name, ratePerHour: _ratePerHour);
        await database.createJob(job);
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Operation failed",
        exception: e,
      ).show(context);
    } finally {
      model.toggle();
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0) ,
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
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        enabled: model.isLoading == false,
        decoration: InputDecoration(
          labelText: "Job Name",
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : "Name cannot be empty",
        onChanged: (value) => _name = value,
        onSaved: (value) => _name = value,
        onEditingComplete: () => _editingComplete(),
      ),
      TextFormField(
        focusNode: _rateFocusNode,
        enabled: model.isLoading == false,
        initialValue: _ratePerHour != null ? "$_ratePerHour" : null,
        decoration: InputDecoration(
          labelText: "Rate Per Hour",
        ),
        validator: (value) => value.isNotEmpty ? null : "Hour cannot be empty",
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.job == null ? "New Job" : "Edit Job"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: !model.isLoading ? _submit : null,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _rateFocusNode.dispose();
    super.dispose();
  }
}
