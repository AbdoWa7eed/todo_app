// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/home_layout/cubit/cubit.dart';
import 'package:todo_app/home_layout/cubit/states.dart';
import 'package:todo_app/shared/components.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      builder: (context, state) {
        return ScreenBuilder(context, TodoCubit.get(context).newTasks,
            'No Tasks Yet , Add Some', "TasksScreen");
      },
      listener: (context, state) {},
    );
  }
}
