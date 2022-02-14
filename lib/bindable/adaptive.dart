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
  ///
  AdaptiveBindableProperty(this.adaptee,
      {required TValue Function(TAdaptee) valueGetter,
      void Function(TAdaptee, TValue)? valueSetter,
      PropertyValueChanged<TValue>? valueChanged})
      : super(
            valueGetter: () => valueGetter(adaptee),
            valueSetter:
                valueSetter == null ? null : (v) => valueSetter(adaptee, v),
            valueChanged: valueChanged) {
    adaptee.addListener(_valueChanged);
  }

  // check value
  void _valueChanged() => notifyListeners();

  @override
  void dispose() {
    adaptee.removeListener(_valueChanged);
    super.dispose();
  }
}
