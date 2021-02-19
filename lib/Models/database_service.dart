import 'package:final_todo_app/Models/subTodo.dart';
import 'package:final_todo_app/Models/todo.dart';

class DatabaseService {
  static List<Todo> _sources;

  DatabaseService() {
    _sources = [];
    _sources = [
      Todo()
        ..complete = false
        ..text = 'Cet 301 Todo App'
        ..id = '1'
        ..subList = [
          SubTodo()
            ..id = '1'
            ..complete = false
            ..effectOnTodo = 10
            ..text = 'Main Screen',
          SubTodo()
            ..id = '2'
            ..complete = false
            ..effectOnTodo = 30
            ..text = 'Database Service'
        ],
      Todo()
        ..complete = false
        ..text = 'Cet 341'
        ..id = '2'
        ..subList = [
          SubTodo()
            ..id = '1'
            ..complete = false
            ..effectOnTodo = 10
            ..text = 'Concept Map Homework',
          SubTodo()
            ..id = '2'
            ..complete = false
            ..effectOnTodo = 30
            ..text = 'Storyboard Homework'
        ]
    ];
  }

  void add(Todo todo) {
    _sources.add(todo);
  }

  void addSubTodo(Todo todo, SubTodo subTodo) {
    _sources.where((element) => element == todo).first.subList.add(subTodo);
  }


  void update(Todo todo) {
    _sources = _sources.map((_todo) {
      return _todo.id == todo.id ? todo : _todo;
    }).toList();
  }

  void updateSubTodo(Todo todo, SubTodo subTodo) {
    var _todo = _sources.firstWhere((element) => element.id == todo.id);
    _todo.subList = _todo.subList.map((_subTodo) {
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
        .subList
        .remove(subTodo);
  }

  int getMaxTodoId(){
    _sources.sort((a,b) => int.parse(b.id).compareTo(int.parse(a.id)));
    return int.parse(_sources.first.id) + 1;
  }

  List<Todo> getTodoList() {
    return _sources;
  }

  List<SubTodo> getsubTodoList(Todo todo) {
    return _sources.where((element) => element == todo).first.subList;
  }

  String calculateSubTodoAffectString(Todo todo) {
    return calculateSubTodoAffect(todo).toString();
  }

  int calculateSubTodoAffect(Todo todo) {
    var _todo = _sources.firstWhere((element) => element.id == todo.id);
    var totalAffect = 0;
    _todo.subList.forEach((element) =>
        !element.complete ? totalAffect += element.effectOnTodo : 0);
    return 100 - totalAffect;
  }
  bool isSubTodoDone(Todo todo){
    return calculateSubTodoAffect(todo) == 100 ? true : false;
  }
}
