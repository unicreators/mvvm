
[![pub package](https://img.shields.io/pub/v/mvvm.svg)](https://pub.dev/packages/mvvm)



A Flutter MVVM (Model-View-ViewModel) implementation. It uses property-based data binding to establish a connection between the ViewModel and the View, and drives the View changes through the ViewModel.
  
  

一个 Flutter 的 MVVM(Model-View-ViewModel) 实现。 它使用基于属性 (property) 的数据绑定在视图模型 (ViewModel) 与视图 (View) 之间建立关联，并通过视图模型 (ViewModel) 驱动视图 (View) 变化。 


```dart
import 'package:flutter/material.dart';
import 'package:mvvm/mvvm.dart';

/// ViewModel
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

/// View
class MyHomePage extends View<MyHomePageViewModel> {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  MyHomePageViewModel createViewModel() => MyHomePageViewModel();

  pad(int value) => '$value'.padLeft(2, '0');

  @override
  Widget build(BuildContext context, MyHomePageViewModel model) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          $watch<int>(model.timer$,
              builder: (context, value, child) =>
                  Text('${pad(value ~/ 60)}.${pad(value % 100)}')),
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

/// run
void main() => runApp(MaterialApp(
      title: 'Flutter MVVM Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter MVVM Demo Home Page'),
    ));

```

## Examples

- [https://www.bilibili.com/medialist/play/19955860?business=space_series&business_id=2029174 :arrow_forward:](https://www.bilibili.com/medialist/play/19955860?business=space_series&business_id=2029174)
- [https://github.com/unicreators/mvvm_examples](https://github.com/unicreators/mvvm_examples)


## APIs

[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)

### BindableProperty

- $value
- $adaptive
- $async
- $custom
- $periodic
- $tick
- $merge
- $mergeMap
- $pipe
- $filter


### WidgetBuilder

- $watch
- $watchFor
- $any
- $anyFor
- $anyMap
- $anyMapFor
- $cond
- $condFor
- $if
- $ifFor
- $switch
- $switchFor
- $select
- $build


### ViewModel

- registerProperty
- getProperty
- requireProperty
- getPropertyOf
- requirePropertyOf
- getProperties
- requireProperties
- getValue
- requireValue
- setValue
- setValues
- updateValue
- notify


### View

- createViewModel
- build
- didChangeDependencies
- activate
- deactivate
- didUpdateWidget


### ViewBuildContext

- setState
- model




## License

[MIT](LICENSE)