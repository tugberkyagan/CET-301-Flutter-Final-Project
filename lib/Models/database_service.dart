import 'package:final_todo_app/Models/subTodo.dart';
import 'package:final_todo_app/Models/todo.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static List<Todo> _sources;

  DatabaseService() {
    _sources = [];
    _sources = [
      Todo()
        ..complete = false
        ..text = 'Aybery'
        ..id = '1'
        ..subIdList = [
          SubTodo()
            ..id = '1.1'
            ..complete = false
            ..effectOnTodo = 10
            ..text = 'wqe',
          SubTodo()
            ..id = '1.2'
            ..complete = false
            ..effectOnTodo = 30
            ..text = 'qwesad'
        ],
      Todo()
        ..complete = false
        ..text = 'tugbery'
        ..id = '2'
        ..subIdList = [
          SubTodo()
            ..id = '1.1'
            ..complete = false
            ..effectOnTodo = 10
            ..text = 'wqe',
          SubTodo()
            ..id = '1.2'
            ..complete = false
            ..effectOnTodo = 30
            ..text = 'qwesad'
        ]
    ];
  }

  void add(Todo todo) {
    _sources.add(todo);
  }

  void addSubTodo(Todo todo, SubTodo subTodo) {
    _sources.where((element) => element == todo).first.subIdList.add(subTodo);
  }

  void update(Todo todo) {
    _sources = _sources.map((_todo) {
      return _todo.id == todo.id ? todo : _todo;
    }).toList();
  }

  void updateSubTodo(Todo todo, SubTodo subTodo) {
    var _todo = _sources.firstWhere((element) => element.id == todo.id);
    _todo.subIdList = _todo.subIdList.map((_subTodo) {
      return _subTodo.id == subTodo.id ? subTodo : _subTodo;
    }).toList();
  }

  void delete(Todo todo) {
    _sources.remove(todo);
  }

  void deleteSubTodo(Todo todo, SubTodo subTodo) {
    _sources
        .where((element) => element == todo)
        .first
        .subIdList
        .remove(subTodo);
  }

  List<Todo> getTodoList() {
    return _sources;
  }

  List<SubTodo> getsubTodoList(Todo todo) {
    return _sources.where((element) => element == todo).first.subIdList;
  }

  String calculateSubTodoAffectString(Todo todo) {
    return calculateSubTodoAffect(todo).toString();
  }

  int calculateSubTodoAffect(Todo todo) {
    var _todo = _sources.firstWhere((element) => element.id == todo.id);
    var totalAffect = 0;
    _todo.subIdList.forEach((element) =>
        !element.complete ? totalAffect += element.effectOnTodo : 0);
    return 100 - totalAffect;
  }
  bool isSubTodoDone(Todo todo){
    if(calculateSubTodoAffect(todo) == 100) return true;
    else return false;
  }
}
