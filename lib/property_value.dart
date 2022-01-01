// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ValueViewModelProperty
///
class ValueViewModelProperty<TValue> extends BindableProperty<TValue> {
  ValueViewModelProperty._(Object propertyKey,
      {PropertyValueChanged<TValue>? valueChanged, required TValue initial})
      : super(propertyKey, valueChanged: valueChanged, initial: initial);

  /// ValueViewModelProperty
  ValueViewModelProperty(Object propertyKey,
      {PropertyValueChanged<TValue>? valueChanged, required TValue value})
      : this._(propertyKey, valueChanged: valueChanged, initial: value);
}

///
/// 具备值属性的 [ViewModel]
mixin ValueViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个值属性
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
      registryProperty(ValueViewModelProperty<TValue>(propertyKey,
          valueChanged: valueChanged, value: initial));
}
