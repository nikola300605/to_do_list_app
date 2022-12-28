import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/model/todo.dart';

class ToDoDatabase {
  List toDoList = [];
  final _myBox = Hive.box("ToDoListBox1");

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void createInitialData() {
    toDoList = [
      ToDo(id: "1", todoText: "Here you can put your daily tasks."),
      ToDo(
          id: "2",
          todoText:
              "To add a task press the plus button, to delete press the delete button."),
      ToDo(id: "3", todoText: "Check off a task by pressing on it.")
    ];
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }

  Box getValuesofBox() {
    return _myBox;
  }
}
