// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/constants/colors.dart';
import 'package:to_do_list_app/screens/edit_profile.dart';
import 'package:to_do_list_app/widgets/DateInput.dart';
import 'package:to_do_list_app/widgets/TextInput.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                CImage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextInput(
                      textController: nameController,
                    ),
                    TextInput(textController: surnameController)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DateInput(
                      textField: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          hintText: "Enter your date",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyy').format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditProfile()));
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: tdBlack),
      backgroundColor: tdBgColor,
      elevation: 0,
    );
  }

  Widget CImage() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 300,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset('assets/images/avatar.png'),
          ),
        ),
      ),
    );
  }
}
