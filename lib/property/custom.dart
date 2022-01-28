// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 自定义的绑定属性
///
class CustomBindableProperty<TValue> extends BindableProperty<TValue> {
  final ValueGetter<TValue> _valueGetter;
  final ValueSetter<TValue> _valueSetter;

  ///
  /// 自定义的绑定属性
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  CustomBindableProperty(
      {required ValueGetter<TValue> valueGetter,
      required ValueSetter<TValue> valueSetter,
      PropertyValueChanged<TValue>? valueChanged,
      TValue? initial})
      : _valueGetter = valueGetter,
        _valueSetter = valueSetter,
        super(valueChanged: valueChanged, initial: initial ?? valueGetter()) {
    if (initial != null) {
      // no notify
      _valueSetter(initial);
    }
  }

  @override
  TValue get value => _valueGetter();

  @override
  set value(TValue v) {
    if (super.value != v) {
      if (value != v) _valueSetter(v);
      super.value = v;
    }
  }
}
