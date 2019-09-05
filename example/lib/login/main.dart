import 'package:flutter/material.dart';
import './login.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter MVVM',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent,
              textTheme: ButtonTextTheme.primary,
            )),
        home: LoginView(),
      );
}
