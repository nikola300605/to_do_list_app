// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/constants/colors.dart';
import 'package:to_do_list_app/database.dart';
import 'package:to_do_list_app/model/todo.dart';
import 'package:to_do_list_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();
  List _foundToDo = [];
  final _myBox = Hive.box('ToDoListBox1');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // TODO: implement initState

    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _foundToDo = db.toDoList;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box('ToDoListBox').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: _createAppBar(),
      body: Container(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              SearchBar(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text(
                        "Your tasks",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    for (ToDo todo in _foundToDo)
                      ToDoItem(
                        toDo: todo,
                        onToDoChanged: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: createNewTask,
      ),
    );
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          content: Container(
            padding: EdgeInsets.all(8.0),
            height: 150,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        hintText: "Add a new item", border: InputBorder.none),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          elevation: 2,
                          minimumSize: Size(100.0, 40.0)),
                      onPressed: () async {
                        if (_toDoController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(
                              padding: EdgeInsets.all(16),
                              height: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: tdRed),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You can not create an empty task",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Put something in the input bar, then click the plus button",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                            behavior: SnackBarBehavior.floating,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ));
                          Navigator.of(context).pop();
                        } else {
                          _addToDoItem(_toDoController.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          elevation: 2,
                          minimumSize: Size(100.0, 40.0)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleToDoChange(ToDo toDo) {
    setState(() {
      toDo.isDone = !toDo.isDone;
    });
    db.updateDataBase();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      db.toDoList.removeWhere((element) => element.id == id);
    });
    db.updateDataBase();
  }

  void _addToDoItem(String todoText) {
    var toDo = ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        todoText: todoText);
    setState(() {
      db.toDoList.add(toDo);
    });
    _toDoController.clear();
    db.updateDataBase();
  }

  void _runFilter(String keyWords) {
    List result = [];
    if (keyWords.isEmpty) {
      result = db.toDoList;
    } else {
      result = db.toDoList
          .where((element) =>
              element.todoText!.toLowerCase().contains(keyWords.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = result;
    });
  }

  Widget SearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBgColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.png'),
            ),
          )
        ],
      ),
    );
  }
}
