// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 前置绑定属性
///
class PreBindableProperty<TValue> extends ValueBindableProperty<TValue> {
  ///
  /// 前置绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initialValue] 指定初始值
  ///
  PreBindableProperty(
      {PropertyValueChanged<TValue>? valueChanged,
      required TValue initialValue})
      : super(valueChanged: valueChanged, initial: initialValue);
}
