import 'package:flutter/material.dart';
import 'package:todolistapp/services/todo_service.dart';

import '../models/todo.dart';

class TodosByCategory extends StatefulWidget {
  // const TodosByCategory({Key? key}) : super(key: key);
  final String category;
  TodosByCategory({required this.category});
  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = <Todo>[];
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        elevation: 8,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // ignore: dead_null_aware_expression
                            children: <Widget>[Text(_todoList[index].title)],
                          ),
                          subtitle: Text(_todoList[index].description),
                          trailing: Text(_todoList[index].todoDate),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
