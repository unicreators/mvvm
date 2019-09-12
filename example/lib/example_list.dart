import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: ExampleListView()));

class User {
  String name;
  String displayName;
  User(this.name, this.displayName);
}

// Service
class RemoteService {
  Future<List<User>> find() async {
    var n = Random(DateTime.now().millisecond).nextInt(20);
    print('$n');
    return Future.value(List.generate(n, (i) => User('name-$i', 'name-$i')));
  }
}

// ViewModel
class ExampleListViewModel extends ViewModel with AsyncViewModelMixin {
  final RemoteService _service;

  ExampleListViewModel(this._service) {
    propertyAsync<List<User>>(#items, () => _service.find(),
        valueChanged: (v, k) => print("$k: ${v.data?.length}"), initial: []);
  }

  @override
  void viewReady(BuildContext context) {
    // load
    invoke(#items);
  }

  void changeFirst() {
    updateValue<AsyncSnapshot<List<User>>>(#items, (_items) {
      if (_items.hasData &&
          _items.data.length > 0 &&
          _items.data[0].name != 'test') {
        _items.data[0].name = 'test';
        return true;
      }
      return false;
    });

    /* // or
    var _items = getValue<AsyncSnapshot<List<User>>>(#items);
    if (_items.hasData && _items.data.length > 0) {
      _items.data[0].name = 'test';
      notify(#items);
    } */
  }
}

// View
class ExampleListView extends View<ExampleListViewModel> {
  ExampleListView() : super(ExampleListViewModel(RemoteService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
            child: Column(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                        onPressed: $Model.link(#items), child: Text('load'))),
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                        onPressed: $Model.changeFirst, child: Text('change'))),
                Expanded(
                    child: $.watchFor<AsyncSnapshot<List<User>>>(#items,
                        builder: $.builder1((snapshot) => ListView(
                            children: snapshot.data
                                ?.map((item) =>
                                    ListTile(title: Text('${item.name}')))
                                ?.toList()))))
              ],
            )));
  }
}
