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
  /// 从 [Widget] 创建适配属性
  ///
  /// 使用 [builder] 构建 [Widget], 在 [builder] 方法中使用参数回调触发属性值变化通知
  ///
  /// [valueGetter] 指定从 [Widget] 获取值方法
  ///
  /// [valueSetter] 指定属性值变更时将该值设置回 [Widget] 方法
  ///
  /// [valueChanged] 指定属性值改变后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.adapt<String>(#name,
  ///     builder: (emit) => TextField(
  ///       onChanged: emit, controller: $Model.nameCtrl),
  ///     valueGetter: () => $Model.nameCtrl.text,
  ///     valueSetter: (v) => $Model.nameCtrl.text = v);
  /// }
  /// ```
  Widget adapt<TValue>(Object propertyKey,
      {required Widget Function(AdaptTrigger<TValue> emit) builder,
      required ValueGetter<TValue> valueGetter,
      required ValueSetter<TValue> valueSetter,
      PropertyValueChanged<TValue>? valueChanged,
      TValue? initial}) {
    var _cbp = CustomBindableProperty<TValue>(
        propertyKey, valueGetter, valueSetter,
        valueChanged: valueChanged, initial: initial);
    var widget =
        builder(({TValue? value}) => _cbp.value = value ?? valueGetter.call());
    registryProperty(_cbp);
    return widget;
  }
}
