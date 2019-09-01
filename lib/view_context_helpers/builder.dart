///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextBuilderHelperMixin
///

mixin ViewContextBuilderHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// 生成 [Widget] 构建方法
  /// 
  ///   通过 `builder` 指定一个无参的 [Widget] 构建方法 
  /// 
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder0(() => Text("hello!")));
  /// }
  /// ```
  ValueWidgetBuilder builder0(Widget Function() builder) =>
      (context, value, child) => builder();

  ///
  /// 生成 [Widget] 构建方法
  /// 
  ///   通过 `builder` 指定一个接收 [TValue] 的 [Widget] 构建方法 
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder1<TValue>(
          Widget Function(TValue) builder) =>
      (context, value, child) => builder(value);

  ///
  /// 生成 [Widget] 构建方法
  /// 
  ///   通过 `builder` 指定一个接收 `value` [TValue], `child` [Widget] 的 [Widget] 构建方法 
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder2((value, child) => Column(children:[Text("$value"), child]),
  ///     child: Text("child"));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder2<TValue>(
          Widget Function(TValue, Widget) builder) =>
      (context, value, child) => builder(value, child);
}
