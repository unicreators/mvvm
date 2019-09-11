import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: LoginView()));

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

  LoginViewModel(this._service) {
    propertyValue<DateTime>(#time, initial: DateTime.now());
    // timer
    start();

    propertyAdaptive<String, TextEditingController>(
        #userName, userNameCtrl, (v) => v.text, (a, v) => a.text = v,
        valueChanged: (v, k) => print("$k: $v"), initial: "");

    propertyAsync<User>(
        #login, () => _service.login(userNameCtrl.text, passwordCtrl.text),
        valueChanged: (v, k) => print("$k: $v"));
  }

  bool get inputValid =>
      userNameCtrl.text.length > 2 && passwordCtrl.text.length > 2;

  final _pad = (int v) => "$v".padLeft(2, "0");
  String format(DateTime dt) =>
      "${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}";

  start() {
    Timer.periodic(const Duration(seconds: 1),
        (_) => setValue<DateTime>(#time, DateTime.now()));
  }
}

// View
class LoginView extends View<LoginViewModel> {
  LoginView() : super(LoginViewModel(RemoteService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100, bottom: 30),
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $.watchFor<DateTime>(#time,
                    builder: $.builder1((t) => Text($Model.format(t),
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 48)))),
                SizedBox(height: 30),
                TextField(
                  controller: $Model.userNameCtrl,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'UserName',
                  ),
                ),
                SizedBox(height: 10),
                $.adapt<String>(#password,
                    builder: (emit) => TextField(
                          onChanged: (v) => emit(),
                          obscureText: true,
                          controller: $Model.passwordCtrl,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                    valueGetter: () => $Model.passwordCtrl.text,
                    valueSetter: (v) => $Model.passwordCtrl.text = v,
                    valueChanged: (v, k) => print("$k: $v")),
                SizedBox(height: 10),
                $.$ifFor(#login,
                    valueHandle: (AsyncSnapshot snapshot) => snapshot.hasError,
                    builder: $.builder1((AsyncSnapshot snapshot) {
                      return Text("${snapshot.error}",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16));
                    })),
                Container(
                    margin: EdgeInsets.only(top: 80),
                    width: double.infinity,
                    child: $.watchAnyFor<String>(const [#userName, #password],
                        builder: $.builder2((_, child) => RaisedButton(
                            onPressed: $Model.inputValid
                                ? $Model.link(#login, resetOnBefore: true)
                                : null,
                            child: child,
                            color: Colors.blueAccent,
                            textColor: Colors.white)),
                        child: $.watchFor(#login,
                            builder: $.builder2(
                                (AsyncSnapshot snapshot, child) =>
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? _buildWaitingWidget()
                                        : child),
                            child: Text("login")))),
                SizedBox(height: 20),
                $.$ifFor<AsyncSnapshot<User>>(#login,
                    valueHandle: (AsyncSnapshot snapshot) => snapshot.hasData,
                    builder: $.builder1((AsyncSnapshot<User> snapshot) => Text(
                        "${snapshot.data?.displayName}",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 20))))
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
