// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// MergeBindableProperty
///
/// - 将多个 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 的值集合
///
class MergeBindableProperty<TValue>
    extends _MergingBindableProperty<Iterable<TValue>> {
  final List<TValue> _realValue = [];
  late final UnmodifiableListView<TValue> _value;

  /// MergeBindableProperty
  MergeBindableProperty(Iterable<ValueListenable<TValue>> _listenables,
      {PropertyValueChanged<Iterable<TValue>>? valueChanged})
      : super(initial: [], valueChanged: valueChanged) {
    _value = UnmodifiableListView(_realValue);
    for (var vl in _listenables) {
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
/// MergeMapBindableProperty
///
/// - 将多个具有键的 [ValueListenable] 合并为一个新的 [ValueListenable],
///   当多个 [ValueListenable] 中任一发生变更时即引发新的 [ValueListenable] 变更
///   其值为多个 [ValueListenable] 对应的键值集合
///
class MergeMapBindableProperty<TValue>
    extends _MergingBindableProperty<Map<Object, TValue>> {
  final Map<Object, TValue> _realValue = {};
  late final UnmodifiableMapView<Object, TValue> _value;

  /// MergeMapBindableProperty
  MergeMapBindableProperty(Map<Object, ValueListenable<TValue>> _keyListenables,
      {PropertyValueChanged<Map<Object, TValue>>? valueChanged})
      : super(initial: {}, valueChanged: valueChanged) {
    _value = UnmodifiableMapView(_realValue);
    for (var kv in _keyListenables.entries) {
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
    extends ReadonlyBindableProperty<TValue> {
  final List<void Function()> _disposeFns = [];

  _MergingBindableProperty(
      {required TValue initial, PropertyValueChanged<TValue>? valueChanged})
      : super(initial: initial, valueChanged: valueChanged);

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
