import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoneTodoListPage extends StatelessWidget {
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
                .where('doneflag', isEqualTo: true)
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
                  return ListTile(
                    title: Text(document['task']),
                    subtitle: Text(document['subtask']),
                    trailing: Wrap(
                      spacing: 0,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () async {
                            //TODO:doneflagをfalseに
                            await updateforFirebase(document.id);
                            await openDoneShowDialog(context, document['task']);
                          },
                        ),
                      ], // space between two icons
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

//ここより画面関係なし

  Future openDoneShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("未完了へ"),
          content: Text("『$message』を未完了にしました。"),
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

  Future updateforFirebase(String id) {
    FirebaseFirestore.instance.collection('todo').doc(id).update({
      'doneflag': false,
    });
  }
}
