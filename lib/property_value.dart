// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ValueViewModelProperty
///
class ValueViewModelProperty<TValue> extends BindableProperty<TValue> {
  ValueViewModelProperty._(
      Object propertyKey, ValueNotifier<TValue> valueNotifier,
      {PropertyValueChanged<TValue> valueChanged})
      : super(propertyKey, valueNotifier, valueChanged: valueChanged);

  /// ValueViewModelProperty
  ValueViewModelProperty(Object propertyKey,
      {PropertyValueChanged<TValue> valueChanged, TValue value})
      : this._(propertyKey, ValueNotifier<TValue>(value),
            valueChanged: valueChanged);

  /// ValueViewModelProperty.from
  ValueViewModelProperty.from(
      Object propertyKey, ValueNotifier<TValue> valueNotifier,
      {PropertyValueChanged<TValue> valueChanged})
      : this._(propertyKey, valueNotifier, valueChanged: valueChanged);
}

mixin ValueViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个值属性
  ///
  /// [propertyKey] 指定属性键
  /// [valueChanged] 指定属性值变更后的回调方法
  /// [initial] 指定初始值
  ///
  BindableProperty<TValue> propertyValue<TValue>(Object propertyKey,
          {PropertyValueChanged<TValue> valueChanged, TValue initial}) =>
      registryProperty(ValueViewModelProperty<TValue>(propertyKey,
          valueChanged: valueChanged, value: initial));
}
