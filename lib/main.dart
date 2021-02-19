import 'dart:io';
import 'package:final_todo_app/Models/database_service.dart';
import 'package:final_todo_app/Models/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Models/subTodo.dart';
import 'package:provider/provider.dart';

final databaseService = new DatabaseService();

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
                  var subListWidgets = data[index]
                      .subIdList
                      .map((subItem) => Card(
                            child: CheckboxListTile(
                              title: Text(subItem.text),
                              value: subItem.complete,
                              onChanged: (bool value) {
                                databaseService.updateSubTodo(
                                    data[index], subItem..complete = value);
                                setState(() {});
                              },
                            ),
                          ))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Text(data[index].text,
                            style: TextStyle(
                              decoration:
                                  databaseService.isSubTodoDone(data[index])
                                      ? TextDecoration.lineThrough
                                      : null,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: new LinearPercentIndicator(
                          width: 350.0,
                          lineHeight: 18.0,
                          percent: databaseService
                                  .calculateSubTodoAffect(data[index]) /
                              100,
                          center: Text(
                            databaseService
                                .calculateSubTodoAffectString(data[index]),
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
                ).then((value) {
                  setState(() {

                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class AddTodoWidget extends StatefulWidget {
  @override
  _AddTodoWidget createState() => _AddTodoWidget();
}

class _AddTodoWidget extends State<AddTodoWidget> {
  @override
  int subTodoId = 0;
  var todo = new Todo();
  TextEditingController controller = TextEditingController();

  Widget build(BuildContext context) {
    final widgets = todo.subIdList.map((subItem) => Text(subItem.text, style: TextStyle(color: Colors.black, fontSize: 20,), )).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Todo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blueGrey,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter a todo'),
              cursorColor: Colors.amber,
            ),
            padding: EdgeInsets.all(10),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets
            ),
          ),
          Expanded(child: Container()),
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
                TextEditingController subTodoController = TextEditingController();
                TextEditingController subTodoAffectController = TextEditingController();
                showModalBottomSheet(context: context, builder: (context){
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        TextField(controller: subTodoController, decoration: InputDecoration(hintText: 'Name')),

                        TextField(controller: subTodoAffectController, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Affect'),),
                        FlatButton(child: Text('Add SubTodo'), onPressed: (){
                          todo.subIdList.add(SubTodo()..id=(subTodoId++).toString()..text=subTodoController.text..effectOnTodo= int.parse(subTodoAffectController.text)..complete=false);
                          setState(() {

                          });
                          Navigator.of(context).pop();
                        }, color: Colors.red, minWidth: double.infinity,)
                      ],
                    ),
                  );
                });
              },
              child: Text('Add a Todo'),
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
          FlatButton(
              onPressed: () {
                todo.id = databaseService.getMaxTodoId().toString();
                todo.text = controller.text;
                databaseService.add(todo);
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent)
        ],
      ),
    );
  }
}
