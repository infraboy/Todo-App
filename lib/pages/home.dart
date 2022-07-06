import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/drawer_fragments/show_tasks.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/services/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DB>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
        ),
        centerTitle: true,
        title: const Text(
          "Todo List",
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Pacifico",
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Color.fromARGB(255, 138, 201, 255),
                    ]),
              ),
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(-0.05),
                child: Center(
                  child: Text(
                    "Todo List",
                    style: TextStyle(
                      fontFamily: "Pacifico",
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Row(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.check_box),
                Icon(Icons.check_box_outline_blank),
              ]),
              selectedTileColor: Colors.blue[100],
              selected: db.page == 1 ? true : false,
              onTap: () {
                db.changePage(1);
                setState(() {});
                Navigator.pop(context);
              },
              title: const Text("All Tasks"),
            ),
            ListTile(
              leading: const Icon(Icons.check_box),
              selectedTileColor: Colors.blue[100],
              selected: db.page == 2 ? true : false,
              onTap: () {
                db.changePage(2);
                setState(() {});
                Navigator.pop(context);
              },
              title: const Text("Checked Tasks"),
            ),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank),
              selectedTileColor: Colors.blue[100],
              selected: db.page == 3 ? true : false,
              onTap: () {
                db.changePage(3);
                setState(() {});
                Navigator.pop(context);
              },
              title: const Text("Unchecked Tasks"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<bool>(
        stream: db.stream,
        builder: (context, snapshot) {
          try {
            if (db.page == 3) {
              return ShowTasks(taskList: db.getTasks(checkBox: 0));
            } else if (db.page == 2) {
              return ShowTasks(taskList: db.getTasks(checkBox: 1));
            } else {
              return ShowTasks(taskList: db.getTasks());
            }
          } catch (e) {
            print("Error: " + e.toString());
            return const Center(
              child: Text("Oops something went wrong!!"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialogBox(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> showDialogBox(BuildContext context) async {
  final titleController = TextEditingController(),
      detailsController = TextEditingController();
  final db = Provider.of<DB>(context, listen: false);
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: const Text("Add Task"),
        content: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                label: Text("Title"),
                hintText: "Enter the task name",
              ),
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(
                label: Text("Task Details"),
                hintText: "Enter the task details",
              ),
              minLines: 3,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Task task = Task(
                id: DateTime.now().millisecondsSinceEpoch,
                checkbox: 0,
                title: titleController.text,
                content: detailsController.text,
              );
              await db.insert(task);
              Navigator.pop(context);
            },
            child: const Text("Create Task"),
          )
        ],
      );
    },
  );
}
