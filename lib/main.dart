import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/home_layout/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
