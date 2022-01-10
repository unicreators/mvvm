// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

/// AdaptiveBindableProperty
///
class AdaptiveBindableProperty<TValue, TAdaptee extends Listenable>
    extends CustomBindableProperty<TValue> {
  /// adaptee
  final TAdaptee adaptee;

  /// AdaptiveViewModelProperty
  AdaptiveBindableProperty(
      this.adaptee,
      TValue Function(TAdaptee) getAdapteeValue,
      void Function(TAdaptee, TValue) setAdapteeValue,
      {PropertyValueChanged<TValue>? valueChanged,
      TValue? initial})
      : super(
            () => getAdapteeValue(adaptee), (v) => setAdapteeValue(adaptee, v),
            valueChanged: valueChanged, initial: initial) {
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
/// 具备适配属性的 [ViewModel]
mixin AdaptiveViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个适配属性
  ///
  /// [propertyKey] 指定属性键
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  /// [getAdapteeValue] 指定从被适配者获取值的方法
  /// [setAdapteeValue] 指定设置被适配者值的方法
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  BindableProperty<TValue>
      propertyAdaptive<TValue, TAdaptee extends Listenable>(
              Object propertyKey,
              TAdaptee adaptee,
              TValue Function(TAdaptee) getAdapteeValue,
              void Function(TAdaptee, TValue) setAdapteeValue,
              {PropertyValueChanged<TValue>? valueChanged,
              TValue? initial}) =>
          registryProperty(
              propertyKey,
              AdaptiveBindableProperty<TValue, TAdaptee>(
                  adaptee, getAdapteeValue, setAdapteeValue,
                  valueChanged: valueChanged, initial: initial));
}