import 'package:flutter/foundation.dart';

class Task {
  String title, subtitle;
  bool isChecked;

  Task(
    this.title,
    this.subtitle,
    this.isChecked,
  );

  factory Task.fromMap(Map task) {
    return Task(
      task["title"],
      task["subtitle"],
      task["isChecked"],
    );
  }

  Map toMap() {
    return {
      "title": title,
      "subtitle": subtitle,
      "isChecked": isChecked,
    };
  }
}
