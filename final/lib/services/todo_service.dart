import 'package:todolistapp/repositories/repository.dart';
import 'package:todolistapp/models/todo.dart';

class TodoService {
  Repository? _repository;

  TodoService() {
    _repository = Repository();
  }

  saveTodo(Todo todo) async {
    return await _repository?.insertData("todos", todo.todoMap());
  }

  readtodos() async {
    return await _repository?.readData("todos");
  }

  readTodosByCategory(category) async {
    return await _repository?.readDataByColumnName(
        "todos", "category", category);
  }
  deleteTodo(int id) async{
    return await _repository?.deleteData("todos", id);
  }
}
