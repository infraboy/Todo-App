import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/pages/home.dart';
import 'package:todo_list/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), "todolist.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE IF NOT EXISTS TODOLIST (ID INTEGER PRIMARY KEY, CHECKBOX INTEGER, TITLE TEXT, CONTENT TEXT)');
    },
    version: 1,
  );
  runApp(
    MaterialApp(
      title: "Todo List",
      home: Provider<DB>(
        create: (_) => SQLite(database),
        child: const Home(),
      ),
    ),
  );
}
