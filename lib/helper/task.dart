class Task {
  int? id;
  String? title;
  String? body;
  String? date;
  String? time;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.date,
    this.time,
    this.repeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'repeat': repeat,
    };
  }

  Task.fromMap(Map<String, dynamic> task) {
    id = task['id'];
    title = task['title'];

    date = task['date'];
    time = task['time'];

    repeat = task['repeat'];
  }
}
