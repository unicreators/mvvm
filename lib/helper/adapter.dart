// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 触发器
typedef AdaptTrigger<TValue> = void Function({TValue value});

/// ViewContextAdaptorHelperMixin
///

mixin ViewContextAdaptorHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// 使用适配构造器创建绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [builder] 用于构建 [Widget], 在 [builder] 方法中使用回调参数发送属性值变化通知
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值改变后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.adaptTo<String>(#name,
  ///     builder: (notify) => TextField(
  ///       onChanged: notify, controller: $model.nameCtrl),
  ///     valueGetter: () => $model.nameCtrl.text,
  ///     valueSetter: (v) => $model.nameCtrl.text = v);
  /// }
  /// ```
  Widget adaptTo<TValue>(Object propertyKey,
      {required Widget Function(AdaptTrigger<TValue> notify) builder,
      required ValueGetter<TValue> valueGetter,
      required ValueSetter<TValue> valueSetter,
      PropertyValueChanged<TValue>? valueChanged,
      TValue? initial}) {
    var property =
        getPropertyOf<TValue, PreBindableProperty<TValue>>(propertyKey);
    if (property == null) {
      property = CustomBindableProperty<TValue>(valueGetter, valueSetter,
          valueChanged: valueChanged, initial: initial);
      registryProperty(propertyKey, property);
    }
    return builder(
        ({TValue? value}) => property!.value = value ?? valueGetter.call());
  }

  ///
  /// 将指定 [Listenable] 包装成新的绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [from] 指定要包装的 [Listenable]
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值改变后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return TextField(
  ///     obscureText: true,
  ///     controller: $.wrapTo<String, TextEditingController>(
  ///         #p1, TextEditingController(),
  ///         valueGetter: (target) => target.text,
  ///         valueSetter: (target, value) => target.text = value),
  ///     decoration: InputDecoration(labelText: 'Password')
  ///   );
  /// }
  /// ```
  TFrom wrapTo<TValue, TFrom extends Listenable>(Object propertyKey, TFrom from,
      {required TValue Function(TFrom) valueGetter,
      required void Function(TFrom, TValue) valueSetter,
      PropertyValueChanged<TValue>? valueChanged,
      TValue? initial}) {
    var pre = getPropertyOf<TValue, PreBindableProperty<TValue>>(propertyKey),
        property = AdaptiveBindableProperty<TValue, TFrom>(
            from,
            (from) => valueGetter(from),
            (from, value) => valueSetter(from, value),
            valueChanged: valueChanged,
            initial: initial);
    if (pre == null) {
      registryProperty(propertyKey, property);
    } else {
      property.addListener(() => pre.value = property.value);
    }
    return from;
  }
}
