// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/home_layout/cubit/cubit.dart';
import 'package:todo_app/home_layout/cubit/states.dart';
import 'package:todo_app/shared/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  void intialBottomSheet() {
    titleController.text = "";
    timeController.text = "";
    dateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..CreateDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TodoCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.deepPurple[900],
                title: Text(
                  'Todo App',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepPurple[900],
                onPressed: () {
                  if (cubit.isShow) {
                    if (formkey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                      Navigator.pop(context);
                      cubit.ChangeFab(isShow: false, fabIcon: Icons.edit);
                      intialBottomSheet();
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DefFormField(
                                        lable: 'Task Title',
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                        icon: Icons.title,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Task musn't be Empty";
                                        }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    DefFormField(
                                        lable: 'Task Time',
                                        controller: timeController,
                                        ontap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text =
                                                value!.format(context);
                                          });
                                        },
                                        keyboardType: TextInputType.none,
                                        icon: Icons.watch_later_outlined,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Time musn't be Empty";
                                        }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    DefFormField(
                                        ontap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(
                                                      DateTime.now().year + 1))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        lable: 'Task Date',
                                        controller: dateController,
                                        keyboardType: TextInputType.none,
                                        icon: Icons.calendar_month_outlined,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return "Date musn't be Empty";
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.ChangeFab(isShow: false, fabIcon: Icons.edit);
                          intialBottomSheet();
                        });
                    cubit.ChangeFab(isShow: true, fabIcon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.ChangeScreen(index);
                },
                backgroundColor: Colors.deepPurple[900],
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white38,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived')
                ],
                currentIndex: cubit.screenIndex,
              ),
              body: cubit.Screens[cubit.screenIndex],
            );
          }),
    );
  }
}
