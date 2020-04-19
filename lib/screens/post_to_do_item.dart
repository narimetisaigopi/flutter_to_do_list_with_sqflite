import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_to_do_list/models/to_do_model.dart';
import 'package:my_to_do_list/utilities/db_helper.dart';

class PostToDoItem extends StatefulWidget {
  ToDoModel toDoModel;
  String appBarTitle;

  PostToDoItem(this.toDoModel, this.appBarTitle);
  @override
  _PostToDoItemState createState() =>
      _PostToDoItemState(this.toDoModel, this.appBarTitle);
}

class _PostToDoItemState extends State<PostToDoItem> {
  ToDoModel toDoModel;
  String appBarTitle;

  var _statusesList = ["Pending", "Completed"];
  var selectedStatus = "Pending";

  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  _PostToDoItemState(this.toDoModel, this.appBarTitle);

  @override
  void initState() {
    selectedStatus = toDoModel.status.length == 0 ? "Pending" : toDoModel.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _titleEditingController.text = toDoModel.title;
    _descriptionEditingController.text = toDoModel.description;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            DropdownButton(
              value: selectedStatus,
                items: _statusesList.map((item) {
                  return DropdownMenuItem(child: Text(item), value: item);
                }).toList(),
                onChanged: (item){
                  setState(() {
                    selectedStatus = item;
                  });
                }),
                SizedBox(height: 20,),
                TextField(
                  controller: _titleEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    labelText: 'Title',
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: _descriptionEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                    labelText: 'Description',
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: (){
                      validate();
                  },child: Text(appBarTitle,style: TextStyle(color: Colors.white),),),
                )

          ],
        ),
      ),
    );
  }

  validate(){
    toDoModel.title = _titleEditingController.text;
    toDoModel.description = _descriptionEditingController.text;
    toDoModel.status = selectedStatus;
    toDoModel.date = DateFormat.yMMMd().format(DateTime.now());

    DataBaseHelper dataBaseHelper = DataBaseHelper();

    if(toDoModel.id == null)
      dataBaseHelper.insert(toDoModel);
    else
      dataBaseHelper.updateItem(toDoModel);

    Navigator.pop(context,true);
  }

}
