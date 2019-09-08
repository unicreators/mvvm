// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// AdaptiveViewModelProperty
///
class AdaptiveViewModelProperty<TValue, TAdaptee extends Listenable>
    extends BindableProperty<TValue> {
  /// AdaptiveViewModelProperty
  AdaptiveViewModelProperty(
      Object key,
      TAdaptee adaptee,
      TValue Function(TAdaptee) getAdapteeValue,
      void Function(TAdaptee, TValue) setAdapteeValue,
      {PropertyValueChanged<TValue> valueChanged,
      TValue initial})
      : super(
            key,
            ValueNotifierAdapter<TValue, TAdaptee>(
                adaptee, getAdapteeValue, setAdapteeValue,
                initial: initial),
            valueChanged: valueChanged);
}

mixin AdaptiveViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个适配属性
  ///
  /// [propertyKey] 指定属性键
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  /// [getAdapteeValue] 指定从被适配者获取值的方法
  /// [setAdapteeValue] 指定设置被适配者值的方法
  /// [valueChanged] 指定属性值变更后的回调方法
  /// [initial] 指定初始值
  ///
  BindableProperty<TValue>
      propertyAdaptive<TValue, TAdaptee extends Listenable>(
              Object propertyKey,
              TAdaptee adaptee,
              TValue Function(TAdaptee) getAdapteeValue,
              void Function(TAdaptee, TValue) setAdapteeValue,
              {PropertyValueChanged<TValue> valueChanged,
              TValue initial}) =>
          registryProperty(AdaptiveViewModelProperty<TValue, TAdaptee>(
              propertyKey, adaptee, getAdapteeValue, setAdapteeValue,
              valueChanged: valueChanged, initial: initial));
}
