import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/update_page.dart';
import 'list_page.dart';

class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('TODOリスト'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('todo')
                .where('doneflag', isEqualTo: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Dismissible(
                    key: Key(document['task']),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      alignment: AlignmentDirectional.centerStart,
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      // TODO:スワイプ後の削除処理を書く
                      await openShowDialog(context, document['task']);
                      await deleteFromFirebase(document.id);
                    },
                    child: ListTile(
                      title: Text(document['task']),
                      subtitle: Text(document['subtask']),
                      trailing: Wrap(
                        spacing: 0, // space between two icons
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              //TODO:編集画面へ遷移
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UapdatePage(
                                          document: document,
                                        ),
                                    fullscreenDialog: true),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.done_outline),
                            onPressed: () async {
                              //TODO:doneflagをtrueに
                              await updateforFirebase(document.id);
                              await openDoneShowDialog(
                                  context, document['task']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListPage(), fullscreenDialog: true),
              );
            },
          ),
        ),
      ),
    );
  }

//ここより画面関係なし
  Future deleteFromFirebase(String id) async {
    FirebaseFirestore.instance.collection('todo').doc(id).delete();
  }

  Future openShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("削除完了"),
          content: Text("『$message』を削除しました。"),
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

  Future openDoneShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("完了"),
          content: Text("『$message』を完了しました。"),
          actions: <Widget>[
            TextButton(child: Text("OK"), onPressed: () {}),
          ],
        );
      },
    );
  }

  Future updateforFirebase(String id) {
    FirebaseFirestore.instance.collection('todo').doc(id).update({
      'doneflag': true,
    });
  }
}
