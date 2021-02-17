import 'package:final_todo_app/Models/subTodo.dart';
import 'package:flutter/material.dart';

class Todo {
  bool complete;
  String id;
  String text;
  List<SubTodo> subIdList;

  Todo(){
    subIdList = [];
  }
}
