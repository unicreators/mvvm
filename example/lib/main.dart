import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';

void main() => runApp(MaterialApp(
      title: 'Flutter MVVM Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter MVVM Demo Home Page'),
    ));

class MyHomePageViewModel extends ViewModel {
  final timer$ = BindableProperty.$tick(
      duration: const Duration(milliseconds: 10), autostart: true, initial: 0);

  @override
  init() {
    registerProperty(#counter, BindableProperty.$value(initial: 0));
  }

  void incrementCounter() {
    updateValue<int>(#counter, (value) => value + 1);
  }
}

class MyHomePage extends View<MyHomePageViewModel> {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  MyHomePageViewModel createViewModel() => MyHomePageViewModel();

  pad(int value) => '$value'.padLeft(2, '0');

  @override
  Widget build(ViewBuildContext context, MyHomePageViewModel model) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          $watch<int>(model.timer$,
              builder: (context, value, child) =>
                  Text('${pad(value ~/ 100)}.${pad(value % 100)}')),
          const Text('You have pushed the button this many times:'),
          model.$watchFor<int>(#counter,
              builder: (context, value, child) =>
                  Text('$value', style: Theme.of(context).textTheme.headline4))
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: model.incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add)));
  }
}
