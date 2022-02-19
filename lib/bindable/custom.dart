// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 自定义的绑定属性
///
class CustomBindableProperty<TValue> extends WriteableBindableProperty<TValue> {
  final ValueGetter<TValue> _valueGetter;
  final ValueSetter<TValue>? _valueSetter;

  ///
  /// 自定义的绑定属性
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  ///
  CustomBindableProperty(
      {required ValueGetter<TValue> valueGetter,
      ValueSetter<TValue>? valueSetter,
      PropertyValueChanged<TValue>? valueChanged})
      : _valueGetter = valueGetter,
        _valueSetter = valueSetter,
        super(valueChanged: valueChanged);

  @override
  TValue get value => _valueGetter();

  @override
  set value(TValue value) {
    if (this.value == value) return;
    _valueSetter?.call(value);
    notifyListeners();
  }
}
