import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/todo_list.dart';

class UapdatePage extends StatefulWidget {
  UapdatePage({this.document});
  final DocumentSnapshot document;

  @override
  _UapdatePageState createState() => _UapdatePageState();
}

class _UapdatePageState extends State<UapdatePage> {
  var task;
  var subtask;

  TextEditingController _taskController;
  TextEditingController _subtaskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.document['task']);
    _subtaskController =
        TextEditingController(text: widget.document['subtask']);
    task = _taskController.text;
    subtask = _subtaskController.text;
  }

  @override
  void dispose() {
    _taskController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update_TODO'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Taskを編集'),
          ),
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: ' Taskを追加'),
            onChanged: (text) {
              task = text;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('詳細を編集'),
          ),
          TextField(
            controller: _subtaskController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: '詳細を記載'),
            onChanged: (text) {
              subtask = text;
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.system_update_alt_rounded,
              color: Colors.white,
            ),
            label: const Text('update'),
            onPressed: () async {
              try {
                await updateforFirebase(widget.document.id);
                await openShowDialog(context, task);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoListPage()),
                );
              } catch (e) {
                await openShowDialogError(context, e.toString());
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoListPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future updateforFirebase(String id) {
    if (task.isEmpty) {
      throw ('taskを更新してください');
    }
    FirebaseFirestore.instance.collection('todo').doc(id).update({
      'task': task,
      'subtask': subtask,
    });
  }

  Future openShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("更新完了"),
          content: Text("『$message』に更新しました。"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Future openShowDialogError(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
