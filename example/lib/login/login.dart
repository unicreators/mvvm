import './service.dart';
import 'package:mvvm/mvvm.dart';
import 'package:flutter/material.dart';

// ViewModel
class LoginViewModel extends ViewModel with AsyncViewModelMixin {
  final RemoteService service;

  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  LoginViewModel(this.service) {
    propertyAdaptive<String, TextEditingController>(
        #userName, userNameCtrl, (v) => v.text, (a, v) => a.text = v,
        initial: "");

    propertyAdaptive<String, TextEditingController>(
        #password, passwordCtrl, (v) => v.text, (a, v) => a.text = v,
        initial: "");

    propertyAsync<User>(
        #login, () => service.login(userNameCtrl.text, passwordCtrl.text),
        onStart: () =>
            // clear prev error.
            setValue<AsyncSnapshot<User>>(#login, AsyncSnapshot.nothing()));
  }

  bool get inputValid =>
      userNameCtrl.text.length > 2 && passwordCtrl.text.length > 2;
}

// View
class LoginView extends View<LoginViewModel> {
  LoginView() : super(LoginViewModel(RemoteService()));

  @override
  void initView(BuildContext context) {}

  @override
  Widget buildCore(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100, bottom: 30),
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: $Model.userNameCtrl,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'UserName',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: $Model.passwordCtrl,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
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
                            child: child,
                            onPressed: $Model.inputValid
                                ? $Model.link(#login)
                                : null)),
                        child: $.watchFor(#login,
                            builder: $.builder2(
                                (AsyncSnapshot snapshot, child) =>
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? _buildWaitingWidget()
                                        : child),
                            child: Text("login")))),
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
