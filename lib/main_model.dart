import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  String task = '';
  String subtask = '';

  Future addToFirebase() async {
    if (task.isEmpty) {
      throw ('taskを入力してください');
    }
    FirebaseFirestore.instance.collection('todo').add({
      'task': task,
      'subtask': subtask,
      'addtime': DateTime.now(),
      'doneflag': false,
    });
  }
}
