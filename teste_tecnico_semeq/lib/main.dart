import 'package:flutter/material.dart';
import 'package:teste_tecnico_semeq/repositories/login_repository.dart';
import 'package:teste_tecnico_semeq/views/login/login_bloc.dart';
import 'package:teste_tecnico_semeq/views/login/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Pratico ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginView(LoginBloc(LoginRepository())),
    );
  }
}

