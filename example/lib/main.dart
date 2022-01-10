import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      home: LoginView(),
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
class LoginViewModel extends ViewModel with AsyncViewModelMixin {
  final RemoteService _service;

  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final time = DateTime.now().toBindableProperty();
  late AdaptiveBindableProperty<String, TextEditingController> userName;
  late AsyncBindableProperty<User> login;

  LoginViewModel(this._service) {
    userName = AdaptiveBindableProperty<String, TextEditingController>(
      userNameCtrl,
      (tec) => tec.text,
      (tec, v) => tec.text = v,
    );

    login = AsyncBindableProperty<User>(
        () => _service.login(userNameCtrl.text, passwordCtrl.text));

    Timer.periodic(
        const Duration(seconds: 1), (_) => time.value = DateTime.now());
  }

  bool get inputValid =>
      userNameCtrl.text.length > 2 && passwordCtrl.text.length > 2;
}

// View
class LoginView extends View<LoginViewModel> {
  LoginView() : super(LoginViewModel(RemoteService()));

  final _pad = (int v) => "$v".padLeft(2, "0");
  String format(DateTime dt) =>
      "${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100, bottom: 30),
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $.watch<DateTime>($model.time,
                    builder: (context, t, _) => Text(format(t),
                        style: Theme.of(context).textTheme.headline1)),
                $.watchAnyForMap<String>({
                  #propertyKey1: MapBehavior(initialValue: '20'),
                  #password: MapBehavior(initialValue: 'passowrd')
                },
                    builder: (context, t, _) => Text(
                        "${t[#propertyKey1]} + ${t[#password]}",
                        style: Theme.of(context).textTheme.headline1)),
                SizedBox(height: 30),
                TextField(
                  controller: $model.userName.adaptee,
                  decoration: InputDecoration(labelText: 'UserName'),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: $.wrapTo<String, TextEditingController>(
                      #propertyKey1, TextEditingController(),
                      valueGetter: (target) => target.text,
                      valueSetter: (target, value) => target.text = value),
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                $.adaptTo<String>(#password,
                    builder: (notify) => TextField(
                          onChanged: (v) => notify(),
                          obscureText: true,
                          controller: $model.passwordCtrl,
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                    valueGetter: () => $model.passwordCtrl.text,
                    valueSetter: (v) => $model.passwordCtrl.text = v,
                    valueChanged: (v) => print("$v"),
                    initial: ''),
                SizedBox(height: 10),
                $.$if($model.login,
                    valueHandle: (AsyncSnapshot snapshot) => snapshot.hasError,
                    builder: $.b1((AsyncSnapshot snapshot) => Text(
                        "${snapshot.error}",
                        style: TextStyle(color: Colors.redAccent)))),
                Container(
                    margin: EdgeInsets.only(top: 80),
                    width: double.infinity,
                    child: $.watchAny<String>(
                        [model.userName, $model.property(#password)],
                        builder: $.b2((_, child) => ElevatedButton(
                            onPressed:
                                $model.inputValid ? $model.login.invoke : null,
                            child: child)),
                        child: $.watch($model.login,
                            builder: $.b2((AsyncSnapshot snapshot, child) =>
                                snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? _buildWaitingWidget()
                                    : child!),
                            child: Text("login")))),
                SizedBox(height: 20),
                $.$if<AsyncSnapshot<User>>($model.login,
                    valueHandle: (AsyncSnapshot snapshot) => snapshot.hasData,
                    builder: $.b1((AsyncSnapshot<User> snapshot) => Text(
                        "${snapshot.data?.displayName}",
                        style: TextStyle(color: Colors.blueAccent))))
              ],
            )));
  }

  Widget _buildWaitingWidget() => SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ));
}
