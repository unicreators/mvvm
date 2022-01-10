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
          {required ValueWidgetBuilder<TValue> builder,
          Widget? child,
          TValue? initialValue}) =>
      watch(ensureProperty<TValue>(propertyKey, initialValue: initialValue),
          builder: builder, child: child);

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
  Widget watchAny<TValue>(Iterable<ValueListenable<TValue>> valueListenables,
          {required ValueWidgetBuilder<Iterable<TValue>> builder,
          Widget? child}) =>
      build(ArrayValueListenable<TValue>(valueListenables),
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
      watchAny(requireProperties<TValue>(prepertyKeys),
          builder: builder, child: child);

  ///
  /// 绑定到指定属性集合, 当任一 [prepertyKeyMap] 中对应的绑定属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Map<Object, TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watchAnyForMap<String>(const {
  ///     #account: null, #password: null },
  ///     builder: (context, values, child) =>
  ///         Text("${values[#account]} - ${values[#password]}"));
  /// }
  /// ```
  Widget watchAnyForMap<TValue>(
          Map<Object, MapBehavior<TValue>?> prepertyKeyMap,
          {required ValueWidgetBuilder<Map<Object, TValue>> builder,
          Widget? child}) =>
      build(
          MapValueListenable<TValue>(prepertyKeyMap.map((key, value) =>
              MapEntry(value?.toKey ?? key,
                  ensureProperty(key, initialValue: value?.initialValue)))),
          builder: builder,
          child: child);

  ///
  /// merge
  ///
  ValueListenable<Iterable<TValue>> merge<TValue>(
      Iterable<ValueListenable<TValue>> listenables) {
    return ArrayValueListenable<TValue>(listenables);
  }

  ///
  /// mergeMap
  ///
  ValueListenable<Map<Object, TValue>> mergeMap<TValue>(
      Map<Object, ValueListenable<TValue>> map) {
    return MapValueListenable<TValue>(map);
  }
}

///
/// 映射行为
///
class MapBehavior<TValue> {
  ///
  /// 指定结果键
  ///
  /// - 结果值将被映射到指定键
  ///
  final Object? toKey;

  ///
  /// 指定初始值
  ///
  /// - 当使用属性键未能找到已注册的绑定属性时，则使用此值创建一个
  ///
  final TValue? initialValue;

  ///
  /// 创建映射行为
  ///
  MapBehavior({this.toKey, this.initialValue});
}

abstract class _MergingValueListenable<TValue> extends ChangeNotifier
    implements ValueListenable<TValue> {
  final List<void Function()> _disposeFns = [];

  @protected
  void disposeFn(void Function() fn) => _disposeFns.add(fn);

  @override
  void dispose() {
    _disposeFns
      ..forEach((r) => r())
      ..clear();
    super.dispose();
  }
}

///
/// ArrayValueListenable
///
/// - 将多个 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 的值集合
///
class ArrayValueListenable<TValue>
    extends _MergingValueListenable<Iterable<TValue>> {
  final List<TValue> _value = [];

  /// ArrayValueListenable
  ArrayValueListenable(Iterable<ValueListenable<TValue>> _listenables) {
    for (var vl in _listenables) {
      var index = _value.length;
      var listener = () {
        _value[index] = vl.value;
        notifyListeners();
      };
      _value.add(vl.value);
      vl.addListener(listener);
      disposeFn(() => vl.removeListener(listener));
    }
  }

  @override
  Iterable<TValue> get value => _value;
}

///
/// MapValueListenable
///
/// - 将多个具有键的 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 对应的键值集合
///
class MapValueListenable<TValue>
    extends _MergingValueListenable<Map<Object, TValue>> {
  final Map<Object, TValue> _value = {};

  /// MapValueListenable
  MapValueListenable(Map<Object, ValueListenable<TValue>> _keyListenables) {
    for (var kv in _keyListenables.entries) {
      var key = kv.key, vl = kv.value;
      var listener = () {
        _value[key] = vl.value;
        notifyListeners();
      };
      vl.addListener(listener);
      _value[key] = vl.value;
      disposeFn(() => vl.removeListener(listener));
    }
  }

  @override
  Map<Object, TValue> get value => _value;
}
