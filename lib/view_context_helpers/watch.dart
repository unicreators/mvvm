// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

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
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watch<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue> builder, Widget? child}) =>
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
  /// Widget build(BuildContext context) {
  ///   return $.watchFor<String>(#account,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watchFor<TValue>(Object propertyKey,
          {required ValueWidgetBuilder<TValue> builder, Widget? child}) =>
      watch(getProperty<TValue>(propertyKey), builder: builder, child: child);

  ///
  /// 绑定到指定 [valueListenables] 集合, 当任一 [valueListenables] 值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watchAny([$Model.prop1, $Model.prop2],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAny<TValue>(Iterable<ValueListenable<TValue>?> valueListenables,
          {required ValueWidgetBuilder<Iterable<TValue>> builder,
          Widget? child}) =>
      build(MergingValueListenable<TValue>(valueListenables),
          builder: builder, child: child);

  ///
  /// 绑定到指定属性集合, 当任一 [prepertyKeys] 对应属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watchAnyFor(const [#account, #password],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAnyFor<TValue>(Iterable<Object> prepertyKeys,
          {required ValueWidgetBuilder<Iterable<TValue>> builder,
          Widget? child}) =>
      watchAny(getProperties<TValue>(prepertyKeys),
          builder: builder, child: child);
}

/// MergingValueListenable
///
class MergingValueListenable<TValue> extends ValueNotifier<Iterable<TValue>> {
  Iterable<ValueListenable<TValue>>? _valueListenables;
  Listenable? _mergingValueListenable;

  /// MergingValueListenable
  MergingValueListenable(Iterable<ValueListenable<TValue>?> _valueListenables)
      : super([]) {
    this._valueListenables = _valueListenables
        .where((l) => l != null)
        .cast<ValueListenable<TValue>>();
    _valueChange();
    _mergingValueListenable = Listenable.merge(this._valueListenables!.toList())
      ..addListener(_valueChange);
  }

  Iterable<TValue> _getValues() =>
      _valueListenables!.map<TValue>((vn) => vn.value);

  void _valueChange() => value = _getValues();

  @override
  void dispose() {
    _mergingValueListenable!.removeListener(_valueChange);
    super.dispose();
  }
}
