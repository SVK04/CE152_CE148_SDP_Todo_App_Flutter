import 'package:flutter/material.dart';
import 'package:todolistapp/models/snackbar.dart';
import 'package:todolistapp/screens/home_screen.dart';
import 'package:todolistapp/services/category_service.dart';

import '../models/category.dart';

class CategoriesScreen extends StatefulWidget {
  // const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var _editCategoryNameController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();
  var category;

  List<Category> _categoryList = <Category>[];
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldMessengerState> _globalKey =
      GlobalKey<ScaffoldMessengerState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.SaveCategory(_category);
                  if (result > 0) {
                    print(result);

                    Navigator.pop(context);
                    GlobalSnackBar.show(context, "Created");
                    getAllCategories();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                      hintText: 'Category Name', labelText: 'Category'),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                      hintText: 'Write Description ', labelText: 'Description'),
                ),
              ]),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    // print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    GlobalSnackBar.show(context, 'Updated');
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                      hintText: 'Category Name', labelText: 'Category'),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                      hintText: 'Write Description ', labelText: 'Description'),
                ),
              ]),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    // print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    GlobalSnackBar.show(context, 'Deleted');
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }
  //
  // _showSuccessSnackBar(message){
  //   var _snackBar = ScaffoldMessenger.of(context).showSnackBar(message);
  //   _globalKey.currentState?.(_snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        title: Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editCategory(
                        context,
                        _categoryList[index].id,
                      );
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name),
                    IconButton(
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
                // subtitle: Text(_categoryList[index].description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
