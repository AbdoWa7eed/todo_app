// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/archived_screen/archived_screen.dart';
import 'package:todo_app/home_layout/cubit/cubit.dart';
import 'package:todo_app/tasks_screen/tasks_screen.dart';

Widget DefFormField(
    {required String lable,
    required TextEditingController controller,
    required TextInputType keyboardType,
    IconData? icon,
    ValueChanged<String>? onsubmit,
    GestureTapCallback? ontap,
    required FormFieldValidator<String>? validator}) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      labelText: lable,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(),
    ),
    onFieldSubmitted: onsubmit,
    onTap: ontap,
    validator: validator,
  );
}

Widget ItemShape(Map element, String MyScreen, BuildContext context) {
  return Dismissible(
    key: Key('${element['id']}'),
    onDismissed: (direction) {
      TodoCubit.get(context).DeleteFromDatabase(id: element['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 40,
          child: Text(
            '${element['time']}',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${element['title']}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('${element['date']}',
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        if (MyScreen == "TasksScreen") ...[
          IconButton(
              color: Colors.white70,
              onPressed: () {
                TodoCubit.get(context)
                    .UpdateDatabase(status: 'Done', id: element['id']);
              },
              icon: Icon(Icons.check_box_rounded)),
          SizedBox(
            width: 10,
          ),
          IconButton(
              color: Colors.white70,
              onPressed: () {
                TodoCubit.get(context)
                    .UpdateDatabase(status: 'Archived', id: element['id']);
              },
              icon: Icon(Icons.archive))
        ] else if (MyScreen == "ArchivedScreen") ...[
          Expanded(
            child: IconButton(
                color: Colors.white70,
                onPressed: () {
                  TodoCubit.get(context)
                      .UpdateDatabase(status: 'Done', id: element['id']);
                },
                icon: Icon(Icons.check_box_rounded)),
          ),
        ] else ...[
          Expanded(
            child: IconButton(
                color: Colors.white70,
                onPressed: () {
                  TodoCubit.get(context)
                      .UpdateDatabase(status: 'Archived', id: element['id']);
                },
                icon: Icon(Icons.archive)),
          )
        ],
      ]),
    ),
  );
}

Widget ScreenBuilder(context, List<Map> screen, String txt, String MyScreen) {
  return ConditionalBuilder(
      condition: screen.isNotEmpty,
      fallback: (context) {
        return Center(
          child: Container(
            width: double.infinity,
            color: Colors.deepPurple[800],
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.white38,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                txt,
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ]),
          ),
        );
      },
      builder: (context) {
        return Container(
            color: Colors.deepPurple[800],
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ItemShape(screen[index], MyScreen, context);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 0.5,
                      color: Colors.deepPurple[900],
                    ),
                  );
                },
                itemCount: screen.length));
      });
}
