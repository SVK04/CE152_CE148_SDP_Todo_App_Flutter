import 'package:flutter/material.dart';
import 'package:todolistapp/models/todo.dart';
import 'package:todolistapp/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todolistapp/services/todo_service.dart';

import '../models/snackbar.dart';

class TodoScreen extends StatefulWidget {
  // const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();

  var todoDateController = TextEditingController();

  var todoDescriptionController = TextEditingController();

  var _selectedValue;

  var _categories = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        todoDateController.text = DateFormat('MM-dd-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Todo Title',
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Todo Description',
              ),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Todo Date',
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: Text('Category'),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var todoObject = Todo();
                todoObject.title = todoTitleController.text;
                todoObject.description = todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if (result > 0) {
                  print(result);
                  GlobalSnackBar.show(context, 'Added');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
