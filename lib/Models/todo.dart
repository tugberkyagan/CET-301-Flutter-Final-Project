import 'package:final_todo_app/Models/subTodo.dart';

class Todo {
  bool complete;
  String id;
  String text;
  List<SubTodo> subList;

  Todo(){
    subList = [];
  }
}
