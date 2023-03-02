import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/archived_screen/archived_screen.dart';
import 'package:todo_app/done_screen/done_screen.dart';
import 'package:todo_app/home_layout/cubit/states.dart';
import 'package:todo_app/tasks_screen/tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(IntialState());
  List<Widget> Screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];
  List<Map> newTasks = [];
  List<Map> ArchivedTasks = [];
  List<Map> DoneTasks = [];
  List<Map> db = [];
  int screenIndex = 0;
  bool isShow = false;
  IconData fabIcon = Icons.edit;
  static TodoCubit get(context) => BlocProvider.of(context);
  late Database database;
  void ChangeScreen(int index) {
    screenIndex = index;
    emit(ChangeBNBState());
  }

  void ChangeFab({required bool isShow, required IconData fabIcon}) {
    this.isShow = isShow;
    this.fabIcon = fabIcon;
    emit(ChangeFABState());
  }

  void CreateDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE `tasks` (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
          .then((value) {
        print('Database Created');
        print('Table Created');
      }).catchError((onError) {
        print('Error  :$onError');
      });
    }, onOpen: (database) {
      print('Database Open');
    }).then((value) {
      database = value;
      getFromDatabase();
      emit(CreateDatabaseState());
    }).catchError((onError) {
      print('Error :$onError');
    });
  }

  void insertToDatabase(
      {required String title, required String date, required String time}) {
    database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO `tasks`(`title`, `date`, `time` , `status`) VALUES ("$title", "$date", "$time" , "New")')
          .then((value) {
        print('Inserted Sucssefully');
        emit(InsertToDatabaseState());
        getFromDatabase();
      }).catchError((onError) {
        print('Error While Inserting : $onError');
      });
    });
  }

  void getFromDatabase() {
    database.rawQuery('SELECT * FROM `tasks`').then((value) {
      newTasks = [];
      ArchivedTasks = [];
      DoneTasks = [];
      value.forEach((element) {
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          DoneTasks.add(element);
        } else {
          ArchivedTasks.add(element);
        }
        db = value;
      });
    }).then((value) {
      print(db);
      emit(GetFromDatabseState());
    });
  }

  void UpdateDatabase({required String status, required int id}) {
    database.rawUpdate('UPDATE `tasks` SET `status` = ? WHERE id = ?',
        ['$status', id]).then((value) {
      print('Database Updated');
      emit(UpdateDatabseState());
      getFromDatabase();
    });
  }

  void DeleteFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM `tasks` WHERE id = $id').then((value) {
      print('Deleted');
      emit(DeleteFromDatabseState());
      getFromDatabase();
    });
  }
}
