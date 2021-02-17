import 'dart:io';

import 'package:final_todo_app/Models/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'Models/subTodo.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: TodoListWidget(),
  ));
}

class TodoListWidget extends StatefulWidget {
  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final databaseService = new DatabaseService();
  List<String> names = <String>[];
  bool isChecked = false;
  bool isSubChecked = false;

  @override
  Widget build(BuildContext context) {
    var data = databaseService.getTodoList();


    return Scaffold(
      appBar: AppBar(
        title: Text('TodoList'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var totalPoint = 0;
                  var subListWidgets =
                  data[index].subIdList.map((subItem) =>
                      Card(
                        child: CheckboxListTile(
                          title: Text(subItem.text),
                          value: subItem.complete,
                          onChanged: (bool value) {
                            databaseService.updateSubTodo(
                                data[index], subItem..complete = value);
                            setState(() {});
                          },
                        ),
                      )).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Text(data[index].text
                            , style: TextStyle(
                              decoration: databaseService.isSubTodoDone(data[index])? TextDecoration.lineThrough : null,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: new LinearPercentIndicator(
                          width: 350.0,
                          lineHeight: 18.0,
                          percent: databaseService.calculateSubTodoAffect(
                              data[index]) / 100,
                          center: Text(
                            databaseService.calculateSubTodoAffectString(
                                data[index]),
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                        ),
                      ),
                      Column(
                        children: subListWidgets,
                      )
                    ],
                  );
                }),
          ),
          Container(
            child: ElevatedButton(
              child: Text('Add new todo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTodoWidget()),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class AddTodoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Todo"),
      ),
      body: Column(
        children: [
          TextField(
            textAlign: TextAlign.left,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a sub todo'),
            cursorColor: Colors.amber,
          ),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blueGrey;
                    return null; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                AddNewSubTodoInput();
              },
              child: Text('Add a Sub-Todo'),
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blueGrey;
                    return null; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Todo List Screen'),
            ),
          ),
        ],
      ),
    );
  }
}

void AddNewSubTodoInput() {
  print('AddNewSubTodoInput is worked!');
}

void AddTheTodo() {
  print('AddTheTodo is worked!');
}

void OnCheckboxClicked() {
  print('OnCheckboxClicked is worked!');
}
