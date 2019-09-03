///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextWatchHelperMixin
///

mixin ViewContextWatchHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// 绑定到指定 [valueListenable], 当 [valueListenable] 值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watch<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      build(valueListenable, builder: builder, child: child);

  ///
  /// 绑定到指定属性, 当 [propertyKey] 对应属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchFor<String>("account",
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watchFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      watch(_propertyValueListenable<TValue>(propertyKey),
          builder: builder, child: child);

  ///
  /// 绑定到指定 [valueListenable] 集合, 当任一 [valueListenable] 值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<dynamic>]
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchAny([$Model.prop1, $Model.prop2],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAny(Iterable<ValueListenable> valueListenable,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      build(ValueNotifierJoinAdapter(valueListenable),
          builder: builder, child: child);

  ///
  /// 绑定到指定属性集合, 当任一 [prepertyKeys] 对应属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<dynamic>]
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchAnyFor(const ["account", "password"],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAnyFor(Iterable<Object> prepertyKeys,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      watchAny(_propertiesValueListenable(prepertyKeys),
          builder: builder, child: child);
}
