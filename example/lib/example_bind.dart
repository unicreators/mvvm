import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mvvm/mvvm.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(body: Page()));
}

// Model
class User {
  String name;
  int age;
  User(this.name, this.age);
}

// Service
class RemoteService {
  Future<User> findUser(String name) async {
    return Future.delayed(
        Duration(seconds: 3), () => User("$name •ªª•", DateTime.now().second));
  }
}

// ViewModel
//
class PageViewModel extends ViewModel {
  final RemoteService service;

  final TextEditingController nameCtrl = TextEditingController();

  PageViewModel(this.service, {required String name}) {
    // define bindable property
    registerProperty(#any, BindableProperty.$value(initial: "jerry"));
    registerProperty(#age, BindableProperty.$value(initial: -1));
    registerProperty(#time, BindableProperty.$value(initial: DateTime.now()));

    // define adaptive property
    registerProperty(
        #name,
        BindableProperty.$adaptive<String, TextEditingController>(nameCtrl,
            valueGetter: (v) => v.text,
            valueSetter: (a, v) => a.text = v,
            initial: name));

    // define Future property
    registerProperty(
        #getUser,
        BindableProperty.$async<User>(() => service.findUser(this.name),
            onSuccess: (user) => age = user.age));

    // timer
    start();
  }

  pad(int v) => "$v".padLeft(2, "0");
  format(DateTime dt) => "${pad(dt.hour)}:${pad(dt.minute)}:${pad(dt.second)}";

  start() {
    Timer.periodic(const Duration(seconds: 1),
        (_) => setValue<DateTime>(#time, DateTime.now()));
  }

  var _anyValueListenable = ValueNotifier<String>('');
  // valueListenable ref
  ValueListenable<String> get anyValueListenable => _anyValueListenable;

  // property ref
  String get name => requireValue<String>(#name);
  set name(String value) => setValue<String>(#name, value);

  int get age => requireValue<int>(#age);
  set age(int value) => setValue<int>(#age, value);

  // invoke asyc
  find() => invoke(#getUser);

  final _names = ["tom", "lucy", "lily", "jerry", "pony"];
  int _index = 0;

  prev() {
    if (_index < 1)
      _index = _names.length - 1;
    else
      _index--;
    _anyValueListenable.value = _names[_index];
  }

  next() {
    if (_index == (_names.length - 1))
      _index = 0;
    else
      _index++;
    _anyValueListenable.value = _names[_index];
  }
}

// View
//
class Page extends View<PageViewModel> {
  @override
  PageViewModel createViewModel() =>
      PageViewModel(RemoteService(), name: "tom");

  @override
  Widget build(ViewBuildContext context, PageViewModel model) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            model.$watchFor<DateTime>(#time,
                builder: (context, value, child) => Text(model.format(value),
                    style: TextStyle(color: Colors.redAccent, fontSize: 48))),
            SizedBox(height: 10),
            TextField(
              controller: model.nameCtrl,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("model.\$watchFor(name):",
                    style: TextStyle(color: Colors.grey)),
                //
                // model.$watchFor
                model.$watchFor(#name,
                    builder: (context, value, child) => Text("$value")),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: ElevatedButton(
                    child: model.$watchFor(#getUser,
                        builder: (context, AsyncSnapshot snapshot, child) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2,
                                    ))
                                : child!,
                        child: Text("remote")),
                    onPressed: model.link(#getUser))),
            SizedBox(height: 20),
            Text("age", style: TextStyle(color: Colors.grey, fontSize: 22)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                    child: Text("-"),
                    onPressed: () {
                      model.age--;
                    }),
                model.$watchFor(#age,
                    builder: (context, value, child) => Text("$value",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 26))),
                ElevatedButton(
                    child: Text("+"),
                    onPressed: () {
                      model.age++;
                    })
              ],
            ),
            SizedBox(height: 20),

            //
            // binding for (propertyKey)
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("model.\$condFor(age):",
                    style: TextStyle(color: Colors.grey)),
                model.$condFor<int>(#age,
                    valueHandle: (v) => v < 3,
                    $true: (context, value, child) => Text("(age < 3) == true"),
                    $false: (context, value, child) =>
                        Text("(age < 3) == false")),
              ],
            ),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("model.\$ifFor(age):", style: TextStyle(color: Colors.grey)),
              model.$ifFor<int>(#age,
                  valueHandle: (v) => v < 3,
                  builder: (context, value, child) => Text("age < 3"))
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("model.\$switchFor(age):",
                  style: TextStyle(color: Colors.grey)),
              model.$switchFor(#age,
                  options: {
                    1: (context, value, child) => Text("case 1"),
                    3: (context, value, child) => Text("case 3")
                  },
                  defalut: (context, value, child) => Text("case default"))
            ]),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(child: Text("<"), onPressed: model.prev),
                $watch(model.anyValueListenable,
                    builder: (context, value, child) => Text("$value",
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 26))),
                ElevatedButton(child: Text(">"), onPressed: model.next)
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$cond(valueListenable):",
                    style: TextStyle(color: Colors.grey)),
                $cond(model.anyValueListenable,
                    valueHandle: (v) => v == "jerry",
                    $true: (context, value, child) => Text("mouse"),
                    $false: (context, value, child) => Text("other")),
              ],
            ),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("\$if(valueListenable):",
                  style: TextStyle(color: Colors.grey)),
              $if(model.anyValueListenable,
                  valueHandle: (v) => v == "lily",
                  builder: (context, value, child) => Text("lily"))
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("\$switch(valueListenable):",
                  style: TextStyle(color: Colors.grey)),
              $switch(model.anyValueListenable,
                  options: {
                    "tom": (context, value, child) =>
                        Text("case $value: bad $value!"),
                    "jerry": (context, value, child) =>
                        Text("case $value: hello mouse..")
                  },
                  defalut: (context, value, child) =>
                      Text("case default: $value"))
            ]),
          ],
        ));
  }
}
