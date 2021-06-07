import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_list.dart';
import 'main_model.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ADD_TODO'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Taskを追加'),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: ' Taskを追加'),
                onChanged: (text) {
                  model.task = text;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('詳細を記載'),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: '詳細を記載'),
                onChanged: (text) {
                  model.subtask = text;
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.library_add,
                  color: Colors.white,
                ),
                label: const Text('ADD'),
                onPressed: () async {
                  try {
                    await model.addToFirebase();
                    await openShowDialog(context, model.task);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodoListPage()),
                    );
                  } catch (e) {
                    await openShowDialogError(context, e.toString());
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  //ここから画面関係ない
  Future openShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("追加完了"),
          content: Text("『$message』を追加しました。"),
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
