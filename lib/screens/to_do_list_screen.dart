import 'package:flutter/material.dart';
import 'package:my_to_do_list/models/to_do_model.dart';
import 'package:my_to_do_list/utilities/db_helper.dart';

import 'post_to_do_item.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  List<ToDoModel> _todoList = null;

  int count = 0;

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    if(_todoList == null){
      _todoList = new List();
      updateListView();
    }
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(title: Text("To DO List"),),
      body: populateListView(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        navigationToDetailsView(ToDoModel("","","",""),"Add New Item");
      },child: Icon(Icons.add),),
    );
  }

  updateListView() async{
    _todoList = await dataBaseHelper.getModelsFromMapList();

    setState(() {
      _todoList = _todoList;
      count = _todoList.length;
    });
  }

  ListView populateListView(){

    return ListView.builder(
      itemCount: count,
      itemBuilder: (context,index){
        ToDoModel toDoModel = this._todoList[index];
        return Card(
          color: toDoModel.status == "Pending" ? Colors.red : Colors.green,
          child: GestureDetector(
            onTap: (){
              navigationToDetailsView(toDoModel, "Update Item");
            },
            child: ListTile(
              leading: toDoModel.status == "Pending" ? Icon(Icons.warning) : Icon(Icons.done_all),
              title: Text(toDoModel.title),
              subtitle: Text(toDoModel.description),
              trailing: toDoModel.status == "Completed" ? GestureDetector(child: Icon(Icons.delete),onTap: (){
                deleteItem(toDoModel);
              },) : null,
            ),
          ),
        );
    });

  }

  deleteItem(ToDoModel toDoModel) async{
    int result = await dataBaseHelper.delete(toDoModel);

    if(result != 0){
      _globalKey.currentState.showSnackBar(SnackBar(content: Text("Item deleted successfully.")));
      updateListView();
    }
  }

  navigationToDetailsView(ToDoModel toDoModel,String appBarTitle) async{
    bool results = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return PostToDoItem(toDoModel,appBarTitle);
    }));

    if(results){
      // update the list
      updateListView();
    }
  }
}