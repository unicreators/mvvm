// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 合并的绑定属性
///
/// - 将多个 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 的值集合
///
class MergeBindableProperty<TValue>
    extends _MergingBindableProperty<Iterable<TValue>> {
  final List<TValue> _realValue = [];
  late final UnmodifiableListView<TValue> _value;

  ///
  /// 创建合并的绑定属性
  ///
  /// 将多个 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的值集合
  ///
  /// [listenables] 指定将要合并的 [ValueListenable] 集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  MergeBindableProperty(Iterable<ValueListenable<TValue>> listenables,
      {PropertyValueChanged<Iterable<TValue>>? valueChanged})
      : super(valueChanged: valueChanged) {
    _value = UnmodifiableListView(_realValue);
    for (var vl in listenables) {
      var index = _realValue.length;
      var listener = () {
        _realValue[index] = vl.value;
        notifyListeners();
      };
      _realValue.add(vl.value);
      vl.addListener(listener);
      disposeFn(() => vl.removeListener(listener));
    }
  }

  @override
  Iterable<TValue> get value => _value;
}

///
/// 具有键的合并的绑定属性
///
/// - 将多个具有键的 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 对应的键值集合
///
class MergeMapBindableProperty<TValue>
    extends _MergingBindableProperty<Map<Object, TValue>> {
  final Map<Object, TValue> _realValue = {};
  late final UnmodifiableMapView<Object, TValue> _value;

  ///
  /// 创建具有键的合并的绑定属性
  ///
  /// 将多个指定键的 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的键值集合
  ///
  /// [map] 指定将要合并的具有键的 [ValueListenable] 集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  MergeMapBindableProperty(Map<Object, ValueListenable<TValue>> map,
      {PropertyValueChanged<Map<Object, TValue>>? valueChanged})
      : super(valueChanged: valueChanged) {
    _value = UnmodifiableMapView(_realValue);
    for (var kv in map.entries) {
      var key = kv.key, vl = kv.value;
      var listener = () {
        _realValue[key] = vl.value;
        notifyListeners();
      };
      vl.addListener(listener);
      _realValue[key] = vl.value;
      disposeFn(() => vl.removeListener(listener));
    }
  }

  @override
  Map<Object, TValue> get value => _value;
}

abstract class _MergingBindableProperty<TValue>
    extends BindableProperty<TValue> {
  final List<void Function()> _disposeFns = [];

  _MergingBindableProperty({PropertyValueChanged<TValue>? valueChanged})
      : super(valueChanged: valueChanged);

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
