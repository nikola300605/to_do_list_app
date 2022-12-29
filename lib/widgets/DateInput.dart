import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DateInput extends StatelessWidget {
  final textField;
  DateInput({super.key, required this.textField});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Center(child: textField),
      ),
    );
  }
}
