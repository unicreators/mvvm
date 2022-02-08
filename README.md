
[![pub package](https://img.shields.io/pub/v/mvvm.svg)](https://pub.dev/packages/mvvm)



A Flutter MVVM (Model-View-ViewModel) implementation. It uses property-based data binding to establish a connection between the ViewModel and the View, and drives the View changes through the ViewModel.
  
  

一个 Flutter 的 MVVM(Model-View-ViewModel) 实现。 它使用基于属性 (property) 的数据绑定在视图模型 (ViewModel) 与视图 (View) 之间建立关联，并通过视图模型 (ViewModel) 驱动视图 (View) 变化。 


```dart
import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

// ViewModel
class Demo1ViewModel extends ViewModel {
  late final timer$ = BindableProperty.$tick(
      duration: const Duration(milliseconds: 10),
      onTick: (tick) =>
          tick % 100 == 0 ? setValue<String>(#text, "${tick ~/ 100}") : null,
      statusChanged: (_) => setValue<bool>(#started, _.started),
      autostart: true,
      initial: 0);

  Demo1ViewModel() {
    registerProperty(#started, BindableProperty.$value(initial: false));
    registerProperty(#text, BindableProperty.$value(initial: "-"));
  }
}

// View
class Demo1View extends View<Demo1ViewModel> {
  format(int value) => "${value % 100}";

  @override
  Demo1ViewModel createViewModel() => Demo1ViewModel();

  @override
  Widget build(ViewBuildContext context, Demo1ViewModel model) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      $watch<int>(model.timer$,
          builder: (context, value, child) =>
              Text(format(value), textDirection: TextDirection.ltr)),
      context.$watchFor<String>(#text,
          builder: (context, value, child) => Text(
                value,
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 24),
              )),
      const SizedBox(height: 20),
      GestureDetector(
          onTap: model.timer$.toggle,
          child: context.$watchFor<bool>(#started,
              builder: (context, value, child) => Text(value ? "STOP" : "START",
                  textDirection: TextDirection.ltr)))
    ]);
  }
}

// run
void main() => runApp(Demo1View());

```

[![Watch the video](https://i1.hdslb.com/bfs/archive/6ac49f7c0e6ef2f4cbef1b09ecb3f033eb7f9e39.jpg@600w_375h)](https://www.bilibili.com/video/BV18r4y1Y7dP)

[:arrow_forward: https://www.bilibili.com/video/BV18r4y1Y7dP](https://www.bilibili.com/video/BV18r4y1Y7dP)


## Example

- [Login](./example/lib/example_login.dart) 
- [Bindable](./example/lib/example_bind.dart) 
- [Timer](https://github.com/unicreators/mvvm_examples)


## APIs

[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)


## License

[MIT](LICENSE)