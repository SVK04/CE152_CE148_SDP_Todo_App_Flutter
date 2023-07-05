class Todo {
  int? id;
  late String title;
  late String description;
  late String category;
  late String todoDate;
  int? isFinished;



  Map<String, dynamic> todoMap() {
    var mapping = Map<String, dynamic>();
    if (id != null) {
      mapping['id'] = id;
    }
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['todoDate'] = todoDate;
    mapping['isFinished'] = isFinished;

    return mapping;
  }
}
