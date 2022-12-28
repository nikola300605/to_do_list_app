// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/model/todo.dart';
import 'package:to_do_list_app/screens/home.dart';

void main() async {
  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());

  //open the box
  var box = await Hive.openBox('ToDoListBox1');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo app",
      home: Home(),
    );
  }
}
