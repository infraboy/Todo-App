class Task {
  int id;
  int checkbox;
  String title, content;

  Task(
      {required this.id,
      required this.checkbox,
      required this.title,
      required this.content});

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "CHECKBOX": checkbox,
      "TITLE": title,
      "CONTENT": content,
    };
  }
}
