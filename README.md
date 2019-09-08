  

A Flutter MVVM (Model-View-ViewModel) implementation. It uses property-based data binding to establish a connection between the ViewModel and the View, and drives the View changes through the ViewModel.
  
  

一个 Flutter 的 MVVM(Model-View-ViewModel) 实现。 它使用基于属性 (property) 的数据绑定在视图模型 (ViewModel) 与视图 (View) 之间建立关联，并通过视图模型 (ViewModel) 驱动视图 (View) 变化。 
  
##   
 
[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)  & [Example](./example/lib/login/main.dart) 


 
```dart
import 'package:flutter/widgets.dart';
import 'package:mvvm/mvvm.dart';
import 'dart:async';

// ViewModel
class Demo1ViewModel extends ViewModel {

  Demo1ViewModel() {
      // define bindable property
      propertyValue<String>(#time, initial: "");
      // timer
      start();
  }

  start() {
      Timer.periodic(const Duration(seconds: 1), (_) {
        var now = DateTime.now();
        // call setValue
        setValue<String>(#time, "${now.hour}:${now.minute}:${now.second}");
      });
  }
}

// View
class Demo1View extends View<Demo1ViewModel> {
  Demo1View() : super(Demo1ViewModel());

  @override
  Widget buildCore(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 100),
        padding: EdgeInsets.all(40),

        // binding
        child: $.watchFor<String>(#time, 
            builder: $.builder1((t) => 
              Text(t, textDirection: TextDirection.ltr))));
  }
}

// run
void main() => runApp(Demo1View());

```


![mvvm](./img.png)


## APIs

### ViewContext ($.*)

#### Methods

**`watch<TValue>(ValueListenable<TValue> valueListenable, { ValueWidgetBuilder<TValue> builder, Widget child }) → Widget`**

绑定到指定 `valueListenable`, 当 `valueListenable` 值发生变化时, 使用 `builder` 构建 `Widget`

- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watch<String>($Model.prop1,
    builder: $.builder1((value) => Text(value)));
}
```


**`watchFor<TValue>(Object propertyKey, { ValueWidgetBuilder<TValue> builder, Widget child }) → Widget`**

绑定到指定属性, 当 `propertyKey` 对应属性值发生变化时, 使用 `builder` 构建 `Widget`

- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watchFor<String>(#account,
    builder: $.builder1((value) => Text(value)));
}
```

**`watchAny(Iterable<ValueListenable> valueListenable, { ValueWidgetBuilder<Iterable> builder, Widget child }) → Widget`**

绑定到指定 `valueListenable` 集合, 当任一 `valueListenable` 值发生变化时, 使用 `builder` 构建 `Widget`

- `builder` 方法中 `TValue` 将被包装为 `Iterable<dynamic>`
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watchAny([$Model.prop1, $Model.prop2],
    builder: $.builder1((values) => Text(values[0])));
}
```


**`watchAnyFor(Iterable<Object> prepertyKeys, { ValueWidgetBuilder<Iterable> builder, Widget child }) → Widget`**

绑定到指定属性集合, 当任一 `propertyKeys` 对应属性值发生变化时, 使用 `builder` 构建 `Widget`

- `builder` 方法中 `TValue` 将被包装为 `Iterable<dynamic>`
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watchAnyFor(const [#account, #password],
    builder: $.builder1((values) => Text(values[0])));
}
```



**`builder0(Widget builder()) → ValueWidgetBuilder`**

生成 `Widget` 构建方法

- 通过 `builder` 指定一个无参的 `Widget` 构建方法

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watch<String>($Model.prop1,
    builder: $.builder0(() => Text("hello!")));
}
```



**`builder1<TValue>(Widget builder(TValue)) → ValueWidgetBuilder<TValue>`**

生成 `Widget` 构建方法

- 通过 `builder` 指定一个接收 `TValue` 的 `Widget` 构建方法

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watch<String>($Model.prop1,
    builder: $.builder1((value) => Text(value)));
}
```


**`builder2<TValue>(Widget builder(TValue, Widget)) → ValueWidgetBuilder<TValue>`**

生成 `Widget` 构建方法

- 通过 `builder` 指定一个接收 `TValue`, `Widget` 的 `Widget` 构建方法

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.watch<String>($Model.prop1,
    builder: $.builder2((value, child) => Column(children:[Text("$value"), child]),
    child: Text("child"));
}
```


**`$cond<TValue>(ValueListenable<TValue> valueListenable, { ValueWidgetBuilder<TValue> $true, ValueWidgetBuilder<TValue> $false, Widget child, bool valueHandle(TValue) }) → Widget`**

绑定到指定 `valueListenable`, 当 `valueListenable` 值发生变化时, 若值判定结果为 `true` 则使用 `$true` 构建 `Widget`, 否则使用 `$false` 构建 `Widget`

- 当值类型不为 `bool` 时, 非 `null` 即被判定为 `true`, 否则判定为 `false` 
- 可通过指定 `valueHandle` 对值进行处理 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$cond<int>($Model.prop1,
    $true: $.builder0(() => Text("tom!")),
    $false: $.builder0(() => Text("jerry!")),
    valueHandle: (value) => value == 1);
}
```


**`$condFor<TValue>(Object propertyKey, { ValueWidgetBuilder<TValue> $true, ValueWidgetBuilder<TValue> $false, Widget child, bool valueHandle(TValue) }) → Widget`**

绑定到指定属性, 当 `propertyKey` 对应属性值发生变化时, 若值判定结果为 `true` 则使用 `$true` 构建 `Widget`, 否则使用 `$false` 构建 `Widget`

- 当值类型不为 `bool` 时, 非 `null` 即被判定为 `true`, 否则判定为 `false` 
- 可通过指定 `valueHandle` 对值进行处理 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$condFor<String>(#account,
    $true: $.builder0(() => Text("tom!")),
    $false: $.builder0(() => Text("jerry!")),
    valueHandle: (value) => value == "tom");
}
```

&nbsp;

**`$if<TValue>(ValueListenable<TValue> valueListenable, { ValueWidgetBuilder<TValue> builder, Widget child, bool valueHandle(TValue) }) → Widget`**

绑定到指定 `valueListenable`, 当值发生变化时, 若值判定结果为 `true` 时使用 `builder` 构建 `Widget` 否则不构建 `Widget`

- 当值类型不为 `bool` 时, 非 `null` 即被判定为 `true`, 否则判定为 `false` 
- 可通过指定 `valueHandle` 对值进行处理 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$if<int>($Model.prop1,
    builder: $.builder0(() => Text("tom!")),
    valueHandle: (value) => value == 1);
}
```



**`$ifFor<TValue>(Object propertyKey, { ValueWidgetBuilder<TValue> builder, Widget child, bool valueHandle(TValue) }) → Widget`**

绑定到指定属性, 当 `propertyKey` 对应属性值发生变化时, 若值判定结果为 `true` 时使用 `builder` 构建 `Widget` 否则不构建 `Widget`

- 当值类型不为 `bool` 时, 非 `null` 即被判定为 `true`, 否则判定为 `false` 
- 可通过指定 `valueHandle` 对值进行处理 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$ifFor<String>(#account,
    builder: $.builder0(() => Text("tom!")),
    valueHandle: (value) => value == "tom");
}
```


**`$switch<TKey, TValue>(ValueListenable<TValue> valueListenable, { Map<TKey, ValueWidgetBuilder<TValue>> options, ValueWidgetBuilder<TValue> defalut, Widget child, TKey valueToKey(TValue) }) → Widget`**

绑定到指定 `valueListenable`, 当 `valueListenable` 值发生变化时, 其值做为 `key` 到 `options` 中查找对应 `Widget` 构建方法, 若未找到则使用 `default` 构建, 如 `default` 为 `null` 则不构建 `Widget`

- 如值与 `options` 中 `key` 类型不同, 可通过指定 `valueToKey` 进行转换 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$switch<String, int>($Model.prop1,
    options: { "1.": $.builder1((value) => Text("$value")),              
               "2.": $.builder0(() => Text("2")) },
    default: $.builder0(() => Text("default")),
    valueToKey: (value) => "${value}.");
}
```



**`$switchFor<TKey, TValue>(Object propertyKey, { Map<TKey, ValueWidgetBuilder<TValue>> options, ValueWidgetBuilder<TValue> defalut, Widget child, TKey valueToKey(TValue) }) → Widget`**

绑定到指定属性, 当 `propertyKey` 对应属性值发生变化时, 其值做为 `key` 到 `options` 中查找对应 `Widget` 构建方法, 若未找到则使用 `default` 构建, 如 `default` 为 `null` 则不构建 `Widget`

- 如值与 `options` 中 `key` 类型不同, 可通过指定 `valueToKey` 进行转换 
- `child` 用于向构建方法中传入 `Widget`

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.$switchFor<String, int>(#account,
    options: { "tom": $.builder1((value) => Text("${value}! cat")),                    
               "jerry": $.builder0(() => Text("mouse")) },
    default: $.builder0(() => Text("default"));
}
```

**`adapt<TValue>(Object propertyKey, {Widget Function(void Function({TValue value})) builder, ValueGetter<TValue> valueGetter, ValueSetter<TValue> valueSetter, PropertyValueChanged<TValue> valueChanged, TValue initial )) → Widget`**

创建一个适配属性, 使用 `builder` 构建 `Widget`, 在 `builder` 方法中使用参数回调触发属性值变化通知
 
- `valueGetter` 指定从 `Widget` 获取值方法
- `valueSetter` 指定属性值变更时将该值设置回 `Widget` 方法
- `valueChanged` 指定属性值变更后的回调方法
- `initial` 指定初始值

```dart
// example
@override
Widget buildCore(BuildContext context) {
  return $.adapt<String>(#name,
      builder: (emit) => TextField(
        onChanged: (v) => emit(), controller: $Model.nameCtrl),
      valueGetter: () => $Model.nameCtrl.text,
      valueSetter: (v) => $Model.nameCtrl.text = v);
}
```



### ViewModel

#### Methods


**`propertyValue<TValue>(Object propertyKey, { PropertyValueChanged<TValue> valueChanged, TValue initial }) → ViewModelProperty<TValue>`**

创建一个值属性

- `propertyKey` 指定属性键 
- `valueChanged` 指定属性值变更后的回调方法
- `initial` 指定初始值

```dart
// example
class PageViewModel extends ViewModel {
    PageViewModel() {
        propertyValue<String>(#name, initial: "tom");
    }
}
```



**`propertyAdaptive<TValue, TAdaptee extends Listenable>(Object propertyKey, TAdaptee adaptee, TValue getAdapteeValue(TAdaptee), void setAdapteeValue(TAdaptee, TValue), { PropertyValueChanged<TValue> valueChanged, TValue initial }) → AdaptiveViewModelProperty<TValue, TAdaptee>`**

创建一个适配属性

- `propertyKey` 指定属性键 
- `adaptee` 被适配者实例，适配者必须继承自 `Listenable`
- `getAdapteeValue` 指定从被适配者获取值的方法
- `setAdapteeValue` 指定设置被适配者值的方法
- `valueChanged` 指定属性值变更后的回调方法
- `initial` 指定初始值

```dart
// example
class PageViewModel extends ViewModel {
    final TextEditingController _nameCtrl = TextEditingController();
    PageViewModel() {
        propertyAdaptive<String, TextEditingController>(
            #name, _nameCtrl,
            (v) => v.text,
            (a, v) => a.text = v,
            initial: name);
    }

    // TextField used
    TextEditingController get nameCtrl => _nameCtrl;
}
```



**`propertyAsync<TValue>(Object propertyKey, AsyncValueGetter<TValue> futureGetter, { TValue handle(TValue), PropertyValueChanged<TValue> valueChanged, TValue initial }) → AsyncViewModelProperty<TValue>`**

创建一个异步请求属性
*要使用此属性的 `ViewModel` 需要 `with` 到 `AsyncViewModelMixin`*

- `propertyKey` 指定属性键 
- `futureGetter` 用于获取 `Future<TValue>` 的方法
- `handle` 指定请求成功时对结果进行处理的方法
- `onStart` 指定请求发起时执行的方法
- `onEnd` 指定请求结束时执行的方法
- `onSuccess` 指定请求成功时执行的方法
- `onError` 指定请求出错时执行的方法
- `valueChanged` 指定属性值变更后的回调方法
- `initial` 指定初始值

```dart
// example
class User {
  String name;
  User(this.name);
}

class RemoteService {
    Future<User> findUser() async {
        return Future.delayed(
        Duration(seconds: 3), () => User("tom_${DateTime.now().second}"));
    }
}

class PageViewModel extends ViewModel with AsyncViewModelMixin {
    final RemoteService _service;
    PageViewModel(this._service) {
        propertyAsync<User>(
            #findUserAsync,
            () => _service.findUser(),        
            handle: (User user) {
                user.name = "hello, ${user.name}";
                return user;
            });
    }

    // ViewModel used
    find() => invoke(#findUserAsync);
}

class PageView extends View<PageViewModel> {
    PageView(): super(PageViewModel(RemoteService()));

    @override
    Widget buildCore(BuildContext context) {
        return Column(children: [
            $.watchFor(#findUserAsync,
                builder: $.builder2((AsyncSnapshot<User> snapshot, child) =>
                            snapshot.connectionState == ConnectionState.waiting && snapshot.hasData 
                                ? Text("${snapshot.data.name}", textDirection: TextDirection.ltr)
                                : child),
                child: Text("empty", textDirection: TextDirection.ltr)), 
            RaisedButton(
                child: $.watchFor(#findUserAsync,
                    builder: $.builder2((AsyncSnapshot<User> snapshot, child) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? CircularProgressIndicator() : child),
                    child: Text("find", textDirection: TextDirection.ltr)), 
                // or: onPressed: () { $Model.find(); }
                onPressed: $Model.link(#findUserAsync))]);
    }
}
```



[Documentation](https://pub.dev/documentation/mvvm/latest/mvvm/mvvm-library.html)



  
   

## License

[MIT](LICENSE)