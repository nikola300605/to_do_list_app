// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TextInput extends StatelessWidget {
  final TextEditingController textController;
  const TextInput({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: textController,
            readOnly: true,
          ),
        ),
      ),
    );
  }
}
