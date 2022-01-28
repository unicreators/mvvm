
[![pub package](https://img.shields.io/pub/v/mvvm.svg)](https://pub.dev/packages/mvvm)



A Flutter MVVM (Model-View-ViewModel) implementation. It uses property-based data binding to establish a connection between the ViewModel and the View, and drives the View changes through the ViewModel.
  
  

一个 Flutter 的 MVVM(Model-View-ViewModel) 实现。 它使用基于属性 (property) 的数据绑定在视图模型 (ViewModel) 与视图 (View) 之间建立关联，并通过视图模型 (ViewModel) 驱动视图 (View) 变化。 
  
##   

[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)  & [Example](./example/lib/example_login.dart) 


 
```dart
import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

// ViewModel
class Demo1ViewModel extends ViewModel {
  Demo1ViewModel() {
    registryProperty(#time, BindableProperty.$value(initial: DateTime.now()));
    start();
  }

  start() {
    Timer.periodic(const Duration(seconds: 1),
        (_) => setValue<DateTime>(#time, DateTime.now()));
  }
}

// View
class Demo1View extends View<Demo1ViewModel> {
  Demo1View() : super(Demo1ViewModel());

  format(DateTime dt) => "${dt.hour}:${dt.minute}:${dt.second}";

  @override
  Widget build(BuildContext context) {
    return Center(
        // binding
        child: $.watchFor<DateTime>(#time,
            builder: (context, time, child) =>
                Text(format(time), textDirection: TextDirection.ltr)));
  }
}

// run
void main() => runApp(Demo1View());

```


![mvvm](./img.png)


## APIs

### ViewContext ($.*)

#### Properties

* [model](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/model.html)

#### Methods

* [watch](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/watch.html)
* [watchFor](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/watchFor.html)
* [watchAny](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/watchAny.html)
* [watchAnyFor](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/watchAnyFor.html)
* [watchAnyForMap](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/watchAnyForMap.html)
* [merge](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/merge.html)
* [mergeMap](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/mergeMap.html)
* [$cond](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$cond.html)
* [$condFor](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$condFor.html)
* [$if](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$if.html)
* [$ifFor](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$ifFor.html)
* [$switch](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$switch.html)
* [$switchFor](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextLogicalHelperMixin/$switchFor.html)
* [builder0](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/builder0.html)
* [builder1](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/builder1.html)
* [builder2](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/builder2.html)
* [b0](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/b0.html)
* [b1](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/b1.html)
* [b2](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextBuilderHelperMixin/b2.html)

*override*

* [viewInit](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/viewInit.html)
* [viewReady](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/viewReady.html)
* [dispose](https://pub.dev/documentation/mvvm/latest/mvvm/ViewContextWatchHelperMixin/dispose.html)

### ViewModel

#### Methods

* [registryProperty](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/registryProperty.html)
* [getProperty](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/getProperty.html)
* [requireProperty](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/requireProperty.html)
* [getPropertyOf](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/getPropertyOf.html)
* [requirePropertyOf](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/requirePropertyOf.html)
* [getProperties](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/getProperties.html)
* [propertyValue](https://pub.dev/documentation/mvvm/latest/mvvm/ValueViewModelMixin/propertyValue.html)
* [propertyAdaptive](https://pub.dev/documentation/mvvm/latest/mvvm/AdaptiveViewModelMixin/propertyAdaptive.html)
* [propertyAsync](https://pub.dev/documentation/mvvm/latest/mvvm/AsyncViewModelMixin/propertyAsync.html)
* [requireValue](./APIs.md#requirevalue)
* [getValue](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/getValue.html)
* [setValue](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/setValue.html)
* [setValues](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/setValues.html)
* [updateValue](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/updateValue.html)
* [notify](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/notify.html)

*override*

* [viewInit](https://pub.dev/documentation/mvvm/latest/mvvm/ValueViewModelMixin/viewInit.html)
* [viewReady](https://pub.dev/documentation/mvvm/latest/mvvm/ValueViewModelMixin/viewReady.html)
* [dispose](https://pub.dev/documentation/mvvm/latest/mvvm/BindableObject/dispose.html)


### View

#### Properties

* [$](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/$.html)
* [model](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/model.html)
* [$model](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/$model.html)

#### Methods

* [setState](https://pub.dev/documentation/mvvm/latest/mvvm/ViewWidget/setState.html)

*override*

* [init](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/init.html)
* [ready](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/ready.html)
* [dispose](https://pub.dev/documentation/mvvm/latest/mvvm/ViewBase/dispose.html)



[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)



## License

[MIT](LICENSE)