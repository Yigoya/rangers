import 'package:flutter/material.dart';
import 'package:rangers/component/form.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController controller = TextEditingController();
  String hint = 'add your task';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            textfield(controller, hint),
            button(() {
              print(controller.text);
            })
          ],
        ),
      ),
    );
  }
}
