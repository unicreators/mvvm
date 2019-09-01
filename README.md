  
  
A Flutter MVVM (Model-View-ViewModel) implementation. It uses property-based data binding, establishes a connection between the ViewModel and the View, and drives the View through the ViewModel.
  
  

一个 Flutter 的 MVVM(Model-View-ViewModel) 实现。 它使用基于属性 (property) 的数据绑定，在视图模型 (ViewModel) 与视图 (View) 之间建立连接，并通过视图模型 (ViewModel) 驱动视图 (View) 变化。 
  
##   
 
[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)  & [Full example](./example/lib/main.dart) 


 
```dart
import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

/// define ViewModel
class Demo1ViewModel extends ViewModel {
  Demo1ViewModel() {

    /// define bindable property
    property<String>("time", initial: "");

    Timer.periodic(const Duration(seconds: 1), (_) {
      var now = DateTime.now();
      setValue<String>("time", "${now.hour}:${now.minute}:${now.second}");
    });
  }
}

/// define View
class Demo1 extends View<Demo1ViewModel> {
  Demo1() : super(Demo1ViewModel());

  @override
  Widget buildCore(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 100),
        padding: EdgeInsets.all(40),
        
        /// binding
        child: $.watchFor("time", 
            builder: $.builder1((t) => Text("$t", textDirection: TextDirection.ltr))));
  }
}

/// run
void main() => runApp(Demo1());

```




![mvvm](./img.png)



## 使用


### 1. 创建视图模型(ViewModel)

新的视图模型类需从 [ViewModel](./lib/view_model.dart) 类继承

```dart
class PageViewModel extends ViewModel {
    /// ..
}
```

在构造方法中使用 super.property 方法创建需要绑定支持的属性([ModelViewProperty](./lib/property.dart))

```dart
class PageViewModel extends ViewModel {

    /// 
    /// property key
    static const Object AnyProperty = Object();

    PageViewModel() {
        property<String>(AnyProperty, initial: "jerry");
    }

    ///
    /// shortcut
    String get any => getValue<String>(AnyProperty);
    set any(String value) => setValue<String>(AnyProperty, value);

}
```


### 2. 创建视图(View)

新的视图类需从 [View](./lib/view.dart) 类继承，并指定使用刚刚创建的视图模型

```dart
class Page extends View<PageViewModel> {
    Page() : super(PageViewModel());
}
```

在新的视图类中重写 Widget BuildCore(BuildContext) 方法，并在方法内使用 `$` ([ViewContext](./lib/view_context.dart)) 和 `$Model` ([ViewModel](./lib/view_model.dart)) 辅助属性构建视图 Widget 

```dart

class Page extends View<PageViewModel> {
  Page() : super(PageViewModel());

  @override
  Widget buildCore(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                        child: Text("prev"),
                        onPressed: () {
                          ///
                          /// 设置新值，触发变更
                          /// $Model 为我们定义的ViewModel实例
                          $Model.any = "prev";
                        }),

                    ///
                    /// 使用属性键(propertyKey)对属性进行绑定
                    /// $ 为视图上下文(ViewContext)实例
                    /// 详见 $.* 用法
                    $.watchFor(PageViewModel.AnyProperty,

                        ///
                        /// 定义当值变化时如何变更widget
                        /// 详见 $.builder* 用法
                        builder: $.builder1((value) => Text("$value",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 26)))),
                    RaisedButton(
                        child: Text("next"),
                        onPressed: () {
                          ///
                          /// 设置新值，触发变更
                          $Model.any = "next";
                        })
                  ],
                )
              ],
            )));
  }
}
```



### 3. 使用视图

应用新的视图


```dart
/// main.dart
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
        ///
        /// 创建视图实例
        home: Page(),
      );
}
```



  
   

## License

[MIT](LICENSE)