import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/Model/Task.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  String? newTitle;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Taskly!"),
          elevation: 5,
          backgroundColor: Colors.red,
          toolbarHeight: deviceHeight * 0.1,
        ),
        body: _taskView(),
        floatingActionButton: _fab(),
      ),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox("tasks"),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            _box = _snapshot.data;
            return _taskList();
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        });
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]);
        return ListTile(
          title: Text(
            task.title,
            style: task.isChecked
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 20,
                    color: Colors.red)
                : const TextStyle(fontSize: 20),
          ),
          subtitle: Text(task.subtitle),
          trailing: Icon(
            task.isChecked
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined,
            color: Colors.red,
          ),
          onTap: () {
            task.isChecked = !task.isChecked;
            _box!.putAt(_index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
        );
      },
      itemCount: tasks.length,
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.red,
      onPressed: _popUpTask,
      label: const Text("New Task"),
      icon: const Icon(Icons.add),
    );
  }

  void _popUpTask() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text(
              "Add New Task",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (_value) {
                    setState(() {
                      newTitle = _value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    primary: Colors.red,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (newTitle != null) {
                      var task = Task(
                        newTitle!,
                        DateTime.now().toString().substring(0, 19),
                        false,
                      );
                      _box!.add(task.toMap());
                      setState(() {
                        newTitle = null;
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text("SUBMIT"),
                ),
              ],
            ),
          );
        });
  }
}
