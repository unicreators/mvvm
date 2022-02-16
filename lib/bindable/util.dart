// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../../mvvm.dart';

///
/// identity
///
TValue identity<TValue>(TValue value) => value;

///
/// 将值 [TValue] 集合转换为绑定属性 [BindableProperty] 集合
///
/// [values] 要转换的值集合
///
/// [valueChanged] 指定属性值变更后的回调方法
///
List<BindableProperty<TValue>> _map<TValue>(Iterable<TValue> values,
        {PropertyValueChanged<TValue>? valueChanged}) =>
    values
        .map((value) =>
            ValueBindableProperty(initial: value, valueChanged: valueChanged))
        .toList();
