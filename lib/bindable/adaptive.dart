// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 适配绑定属性
///
class AdaptiveBindableProperty<TValue, TAdaptee extends Listenable>
    extends CustomBindableProperty<TValue> {
  /// 被适配对象
  final TAdaptee adaptee;

  ///
  /// 创建一个适配绑定属性
  ///
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  ///
  /// [valueGetter] 指定从被适配者获取值的方法
  ///
  /// [valueSetter] 指定设置被适配者值的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  AdaptiveBindableProperty(this.adaptee,
      {required TValue Function(TAdaptee) valueGetter,
      required void Function(TAdaptee, TValue) valueSetter,
      PropertyValueChanged<TValue>? valueChanged,
      TValue? initial})
      : super(
            valueGetter: () => valueGetter(adaptee),
            valueSetter: (v) => valueSetter(adaptee, v),
            valueChanged: valueChanged,
            initial: initial) {
    adaptee.addListener(_valueChanged);
  }

  // check value
  void _valueChanged() => value = value;

  @override
  void dispose() {
    adaptee.removeListener(_valueChanged);
    super.dispose();
  }
}

///
/// 适配绑定属性
///
mixin AdaptiveBindablePropertyMixin on BindableObject {
  ///
  /// 创建并注册适配绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  ///
  /// [valueGetter] 指定从被适配者获取值的方法
  ///
  /// [valueSetter] 指定设置被适配者值的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  BindableProperty<TValue>
      propertyAdaptive<TValue, TAdaptee extends Listenable>(
              Object propertyKey, TAdaptee adaptee,
              {required TValue Function(TAdaptee) valueGetter,
              required void Function(TAdaptee, TValue) valueSetter,
              PropertyValueChanged<TValue>? valueChanged,
              TValue? initial}) =>
          registerProperty(
              propertyKey,
              AdaptiveBindableProperty<TValue, TAdaptee>(adaptee,
                  valueGetter: valueGetter,
                  valueSetter: valueSetter,
                  valueChanged: valueChanged,
                  initial: initial));
}
