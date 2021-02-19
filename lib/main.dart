import 'package:final_todo_app/Models/database_service.dart';
import 'package:final_todo_app/Models/todo.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Models/subTodo.dart';

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
                  var subListWidgets = data[index]
                      .subList
                      .map((subItem) => Card(
                            child: CheckboxListTile(
                              title: Text(subItem.text),
                              value: subItem.complete,
                              onChanged: (bool value) {
                                databaseService.updateSubTodo(data[index], subItem..complete = value);
                                setState(() {});
                              },
                            ),
                          ))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        Text(data[index].text,
                            style: TextStyle(
                              decoration: databaseService.isSubTodoDone(data[index]) ? TextDecoration.lineThrough : null,
                            )),
                        ElevatedButton(onPressed: (){
                          databaseService.delete(data[index]);
                          setState(() {

                          });
                        }, child: null)
                      ]),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: new LinearPercentIndicator(
                          width: 350.0,
                          lineHeight: 18.0,
                          percent: databaseService.calculateSubTodoAffect(data[index]) / 100,
                          center: Text(
                            databaseService.calculateSubTodoAffectString(data[index]),
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
                  setState(() {});
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
  TextEditingController todoTextController = TextEditingController();

  Widget build(BuildContext context) {
    final addedSubTodoWidget = todo.subList
        .map(
          (subItem) => Row(
            children: [
              Card(
                child: Text(
                  subItem.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Card(
                child: Text(
                  subItem.effectOnTodo.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();

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
              controller: todoTextController,
              textAlign: TextAlign.left,
              decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter a todo'),
              cursorColor: Colors.amber,
            ),
            padding: EdgeInsets.all(10),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: addedSubTodoWidget),
          ),
          Expanded(child: Container()),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blueGrey;
                    return null; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                TextEditingController subTodoTextController = TextEditingController();
                TextEditingController subTodoAffectController = TextEditingController();
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          children: [
                            TextField(controller: subTodoTextController, decoration: InputDecoration(hintText: 'Name')),
                            TextField(
                              controller: subTodoAffectController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: 'Affect'),
                            ),
                            FlatButton(
                              child: Text('Add SubTodo'),
                              onPressed: () {
                                todo.subList.add(SubTodo()
                                  ..id = (subTodoId++).toString()
                                  ..text = subTodoTextController.text
                                  ..effectOnTodo = int.parse(subTodoAffectController.text)
                                  ..complete = false);
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              color: Colors.red,
                              minWidth: double.infinity,
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Text('Add a SubTodo'),
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) return Colors.blueGrey;
                    return null; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ),
          FlatButton(
              onPressed: () {
                todo.id = databaseService.getMaxTodoId().toString();
                todo.text = todoTextController.text;
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
