import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/database.dart';

import '../models/task.dart';

class ShowTasks extends StatelessWidget {
  const ShowTasks({Key? key, required this.taskList}) : super(key: key);
  final Future<List<Task>> taskList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: taskList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return taskListBuilder(snapshot.data!);
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Oops! Some error has occurred"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget taskListBuilder(List<Task> taskList) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final db = Provider.of<DB>(context, listen: false);
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[100],
          ),
          child: CheckboxListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
            secondary: IconButton(
              onPressed: () async {
                await db.delete(taskList[index]);
              },
              icon: const Icon(Icons.close),
            ),
            isThreeLine: true,
            value: taskList[index].checkbox == 1 ? true : false,
            onChanged: (value) async {
              taskList[index].checkbox = taskList[index].checkbox == 1 ? 0 : 1;
              await db.updateCheckBox(taskList[index]);
            },
            title: Text(taskList[index].title),
            subtitle: Text(taskList[index].content),
          ),
        );
      },
    );
  }
}
