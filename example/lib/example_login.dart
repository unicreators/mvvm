import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      home: Scaffold(body: LoginView()),
      theme: ThemeData(
          textTheme: TextTheme(
              button: TextStyle(color: Colors.redAccent, fontSize: 48),
              headline1: TextStyle(color: Colors.redAccent, fontSize: 48)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                    fontSize: 20,
                  )))),
    ));

class User {
  String name;
  String displayName;
  User(this.name, this.displayName);
}

// Service
class RemoteService {
  Future<User> login(String userName, String password) async {
    return Future.delayed(Duration(seconds: 3), () {
      if (userName == "tom" && password == "123")
        return User(userName, "$userName cat~");
      throw "mock error.";
    });
  }
}

// ViewModel
class LoginViewModel extends ViewModel {
  final RemoteService _service;

  final $time = BindableProperty.$value(initial: DateTime.now());
  final $userName = AdaptiveBindableProperty<String, TextEditingController>(
    TextEditingController(),
    valueGetter: (tec) => tec.text,
    valueSetter: (tec, v) => tec.text = v,
  );
  final $password = AdaptiveBindableProperty<String, TextEditingController>(
    TextEditingController(),
    valueGetter: (tec) => tec.text,
    valueSetter: (tec, v) => tec.text = v,
  );
  late final $login = AsyncBindableProperty<User>(
      () => _service.login($userName.value, $password.value));

  LoginViewModel(this._service) {
    Timer.periodic(
        const Duration(seconds: 1), (_) => $time.value = DateTime.now());
  }

  bool get inputValid =>
      $userName.value.length > 2 && $password.value.length > 2;
}

// View
class LoginView extends View<LoginViewModel> {
  LoginView() : super();

  @override
  LoginViewModel createViewModel() => LoginViewModel(RemoteService());

  pad(int v) => "$v".padLeft(2, "0");
  format(DateTime dt) => "${pad(dt.hour)}:${pad(dt.minute)}:${pad(dt.second)}";

  @override
  Widget build(BuildContext context, LoginViewModel model) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            $watch<DateTime>(model.$time,
                builder: (context, time, child) => Text(format(time),
                    style: Theme.of(context).textTheme.headline1)),
            SizedBox(height: 10),
            TextField(
              controller: model.$userName.adaptee,
              decoration: InputDecoration(labelText: 'UserName'),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: model.$password.adaptee,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              $if(model.$login,
                  valueHandle: (AsyncSnapshot snapshot) => snapshot.hasError,
                  builder: (context, AsyncSnapshot snapshot, child) => Text(
                      "${snapshot.error}",
                      style: TextStyle(color: Colors.redAccent))),
              SizedBox(height: 10),
              $any<String>(
                [model.$userName, model.$password],
                builder: (context, _, child) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed:
                            model.inputValid ? model.$login.invoke : null,
                        child: child)),
                child: $watch(model.$login,
                    builder: (context, AsyncSnapshot snapshot, child) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? _buildWaitingWidget()
                            : child!,
                    child: Text("login")),
              ),
              SizedBox(height: 10),
              $if<AsyncSnapshot<User>>(model.$login,
                  valueHandle: (AsyncSnapshot snapshot) => snapshot.hasData,
                  builder: (context, AsyncSnapshot<User> snapshot, child) =>
                      Text("${snapshot.data?.displayName}",
                          style: TextStyle(color: Colors.blueAccent)))
            ])
          ],
        ));
  }

  Widget _buildWaitingWidget() => SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ));
}
