// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 值绑定属性
///
class ValueBindableProperty<TValue> extends BindableProperty<TValue> {
  ///
  /// 创建一个值绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  ValueBindableProperty(
      {PropertyValueChanged<TValue>? valueChanged, required TValue initial})
      : _value = initial,
        super(valueChanged: valueChanged);

  TValue _value;

  @override
  TValue get value => _value;

  @override
  set value(TValue value) {
    if (_value == value) return;
    _value = value;
    notifyListeners();
  }
}

///
/// 值绑定属性
///
mixin ValueBindablePropertyMixin on BindableObject {
  ///
  /// 创建并注册值绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  BindableProperty<TValue> propertyValue<TValue>(Object propertyKey,
          {PropertyValueChanged<TValue>? valueChanged,
          required TValue initial}) =>
      registerProperty(
          propertyKey,
          ValueBindableProperty<TValue>(
              valueChanged: valueChanged, initial: initial));
}
