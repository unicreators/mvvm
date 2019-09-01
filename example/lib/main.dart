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
        home: Page(),
      );
}

/// Model
///
class User {
  String name;
  int age;
  User(this.name, this.age);
}

/// Service
///
class RemoteService {
  Future<User> findUser(String name) async {
    return Future.delayed(
        Duration(seconds: 3), () => User("$name •ªª•", DateTime.now().second));
  }
}

/// ViewModel
///
class PageViewModel extends ViewModel with AsyncViewModelMixin {
  final RemoteService service;

  final TextEditingController nameCtrl = TextEditingController();

  ///
  /// define property keys
  static const Object AnyProperty = Object();
  static const String NameProperty = "name";
  static const String AgeProperty = "age";
  static const String AsyncProperty = "async";

  PageViewModel(this.service, {String name}) {
    ///
    /// define property
    property<String>(AnyProperty, initial: "jerry");
    property<int>(AgeProperty, initial: -1);
    property<String>("time", initial: "");

    ///
    /// define adaptive property
    propertyAdaptive(
        NameProperty,
        nameCtrl,

        ///
        /// value convert
        (v) => v.text,
        (a, v) => a.text = v,
        initial: name);

    ///
    /// define Future property
    propertyAsync(
        AsyncProperty,

        ///
        /// async method
        () => service.findUser(this.name),

        ///
        /// data handle on success
        handle: (user) => age = user.age);

    // time
    var pad = (int v) => "$v".padLeft(2, "0");
    Timer.periodic(const Duration(seconds: 1), (_) {
      var now = DateTime.now();
      setValue<String>(
          "time", "${pad(now.hour)}:${pad(now.minute)}:${pad(now.second)}");
    });
  }

  ///
  /// valueListenable shortcut
  ValueNotifier<String> get anyValueListenable =>
      getPropertyValueListenable<String>(AnyProperty);

  ///
  /// property shortcut
  String get name => getValue<String>(NameProperty);
  set name(String value) => setValue<String>(NameProperty, value);

  int get age => getValue<int>(AgeProperty);
  set age(int value) => setValue<int>(AgeProperty, value);

  ///
  /// invoke asyc shortcut
  find() => invoke(AsyncProperty);

  final _names = ["tom", "lucy", "lily", "jerry", "pony"];
  int _index = 0;

  prev() {
    if (_index < 1)
      _index = _names.length - 1;
    else
      _index--;
    anyValueListenable.value = _names[_index];
  }

  next() {
    if (_index == (_names.length - 1))
      _index = 0;
    else
      _index++;
    anyValueListenable.value = _names[_index];
  }
}

/// View
///
class Page extends View<PageViewModel> {
  Page() : super(PageViewModel(RemoteService(), name: "tom"));

  @override
  void initView() {}

  @override
  Widget buildCore(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100, bottom: 60),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                $.watchFor("time",
                    builder: $.builder1((t) => Text(t,
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 48)))),
                SizedBox(height: 10),
                TextField(
                  controller: $Model.nameCtrl,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$.watchFor(name):",
                        style: TextStyle(color: Colors.grey)),

                    ///
                    /// $.watchFor
                    $.watchFor(PageViewModel.NameProperty,

                        ///
                        /// $.builder*
                        builder: $.builder1((value) => Text("$value"))),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: RaisedButton(
                        child: $.watchFor(PageViewModel.AsyncProperty,

                            ///
                            /// $.builder*
                            builder: $.builder2(
                                (AsyncSnapshot snapshot, child) =>
                                    snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                              strokeWidth: 2,
                                            ))
                                        : child),
                            child: Text("remote")),

                        ///
                        /// $Model.link
                        onPressed: $Model.link(PageViewModel.AsyncProperty))),

                Expanded(child: SizedBox.shrink()),
                Text("age", style: TextStyle(color: Colors.grey, fontSize: 22)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                        child: Text("-"),
                        onPressed: () {
                          ///
                          /// $Model.prop
                          $Model.age--;
                        }),
                    $.watchFor(PageViewModel.AgeProperty,
                        builder: $.builder1((value) => Text("$value",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 26)))),
                    RaisedButton(
                        child: Text("+"),
                        onPressed: () {
                          ///
                          /// $Model.prop
                          $Model.age++;
                        })
                  ],
                ),
                SizedBox(height: 40),

                ///
                /// binding for (propertyKey)
                ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$.\$condFor(age):",
                        style: TextStyle(color: Colors.grey)),

                    ///
                    /// $.$condFor
                    $.$condFor(PageViewModel.AgeProperty,
                        valueHandle: (v) => v < 3,
                        $true: $.builder0(() => Text("(age < 3) == true")),
                        $false: $.builder0(() => Text("(age < 3) == false"))),
                  ],
                ),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$.\$ifFor(age):",
                          style: TextStyle(color: Colors.grey)),

                      ///
                      /// $.$ifFor
                      $.$ifFor(PageViewModel.AgeProperty,
                          valueHandle: (v) => v < 3,
                          builder: $.builder0(() => Text("age < 3")))
                    ]),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$.\$switchFor(age):",
                          style: TextStyle(color: Colors.grey)),

                      ///
                      /// $.$switchFor
                      $.$switchFor(PageViewModel.AgeProperty,
                          options: {
                            1: $.builder0(() => Text("case 1")),
                            3: $.builder0(() => Text("case 3"))
                          },
                          defalut: $.builder0(() => Text("case default")))
                    ]),
                SizedBox(height: 40),

                ///
                /// binding (valueListenable)
                ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(child: Text("<"), onPressed: $Model.prev),

                    ///
                    /// $.watch
                    $.watch($Model.anyValueListenable,
                        builder: $.builder1((value) => Text("$value",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 26)))),
                    RaisedButton(child: Text(">"), onPressed: $Model.next)
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$.\$cond(valueListenable):",
                        style: TextStyle(color: Colors.grey)),

                    ///
                    /// $.$cond
                    $.$cond($Model.anyValueListenable,
                        valueHandle: (v) => v == "jerry",
                        $true: $.builder0(() => Text("mouse")),
                        $false: $.builder0(() => Text("other"))),
                  ],
                ),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$.\$if(valueListenable):",
                          style: TextStyle(color: Colors.grey)),

                      ///
                      /// $.$if
                      $.$if($Model.anyValueListenable,
                          valueHandle: (v) => v == "lily",
                          builder: $.builder0(() => Text("lily")))
                    ]),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$.\$switch(valueListenable):",
                          style: TextStyle(color: Colors.grey)),

                      ///
                      /// $.switch
                      $.$switch($Model.anyValueListenable,
                          options: {
                            "tom": $.builder1(
                                (value) => Text("case $value: bad $value!")),
                            "jerry": $.builder1(
                                (value) => Text("case $value: hello mouse.."))
                          },
                          defalut: $.builder1(
                              (value) => Text("case default: $value")))
                    ]),
              ],
            )));
  }
}

/// Custom ViewContext
///
class PageViewContext<TViewModel extends ViewModelBase>
    extends ViewContext<TViewModel> {
  PageViewContext(TViewModel viewModel) : super(viewModel);

  /// custom
  ///
  Widget hello() {
    /// use super.*
    ///
    return Text("hello!");
  }

  ///
  /// more..
  ///
}

/// View
///
class Page1 extends ViewBase<PageViewModel, PageViewContext<PageViewModel>> {
  ///
  /// inject PageViewContext
  Page1()
      : super(PageViewContext<PageViewModel>(
            PageViewModel(RemoteService(), name: "tom")));

  @override
  void initView() {}

  @override
  Widget buildCore(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100, bottom: 60),
            padding: EdgeInsets.all(20),

            ///
            /// use custom method..
            child: $.hello()));
  }
}
