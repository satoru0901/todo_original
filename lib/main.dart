import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_list.dart';
import 'package:todo_app/todo_list_done.dart';

import 'bottom_navigation_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 表示するページをリスト形式で宣言します
  List<Widget> _pageList = <Widget>[
    TodoListPage(),
    DoneTodoListPage(),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      // テーマはなんでも大丈夫です
      theme: ThemeData(
        textTheme: TextTheme(),
      ),
      home: ChangeNotifierProvider<BottomNavigationModel>(
        create: (_) => BottomNavigationModel(),
        child:
            Consumer<BottomNavigationModel>(builder: (context, model, child) {
          return Scaffold(
            // 今選択している番号のページを呼び出します。
            body: _pageList[model.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              // 選択中のアイコンを更新しています。
              currentIndex: model.currentIndex,

              // ここからが肝です。
              onTap: (index) {
                // indexで今タップしたアイコンの番号にアクセスできます。
                model.currentIndex =
                    index; // indexをモデルに渡したときに notifyListeners(); を呼んでいます。
              },
              items: [
                // フッターアイコンの要素を並べています 最低2個以上必要みたいです。
                BottomNavigationBarItem(
                  // アイコンとラベルは自由にカスタムしてください。
                  icon: Icon(Icons.face),
                  label: 'TODOリスト',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline),
                  label: 'DONE',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
