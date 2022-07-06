import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/task.dart';

abstract class DB {
  int page = 1;
  void changePage(int page);
  Stream<bool> get stream;
  Future<void> insert(Task task);
  Future<void> delete(Task task);
  Future<void> updateCheckBox(Task task);
  Future<List<Task>> getTasks({int? checkBox});
}

class SQLite implements DB {
  @override
  int page = 1;

  final StreamController<bool> _controller = StreamController<bool>();
  @override
  Stream<bool> get stream => _controller.stream;

  final Future<Database> _database;
  SQLite(this._database);

  @override
  Future<void> delete(Task task) async {
    final db = await _database;
    try {
      int n =
          await db.delete("TODOLIST", where: "ID = ?", whereArgs: [task.id]);
      if (n > 0) {
        _controller.add(true);
      }
    } catch (e) {
      print("ERROR: " + e.toString());
    }
  }

  @override
  Future<void> insert(Task task) async {
    final db = await _database;
    try {
      db.insert("TODOLIST", task.toMap());
      _controller.add(true);
    } catch (e) {
      print("ERROR: " + e.toString());
    }
  }

  @override
  Future<List<Task>> getTasks({int? checkBox}) async {
    final db = await _database;
    final List<Map<String, dynamic>> list;
    if (checkBox == null) {
      list = await db.query("TODOLIST");
    } else {
      list = await db
          .query("TODOLIST", where: "CHECKBOX = ?", whereArgs: [checkBox]);
    }
    final taskList = list
        .map((task) => Task(
            id: task["ID"],
            checkbox: task["CHECKBOX"],
            title: task["TITLE"],
            content: task["CONTENT"]))
        .toList();
    return taskList;
  }

  @override
  Future<void> updateCheckBox(Task task) async {
    final db = await _database;
    try {
      int n = await db.update(
        "TODOLIST",
        {"CHECKBOX": task.checkbox},
        where: "ID = ?",
        whereArgs: [task.id],
      );
      if (n > 0) {
        _controller.add(true);
      }
    } catch (e) {
      print("ERROR: " + e.toString());
    }
  }

  @override
  void changePage(int page) {
    this.page = page;
    _controller.add(true);
  }
}
