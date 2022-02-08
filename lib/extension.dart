// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/*
/// BindablePropertyExtension
extension BindablePropertyExtension<TValue> on TValue {
  ///
  /// 创建值绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  ValueBindableProperty<TValue> $value(
          {PropertyValueChanged<TValue>? valueChanged}) =>
      ValueBindableProperty<TValue>(initial: this, valueChanged: valueChanged);

  ///
  /// 创建具有周期性的绑定属性
  ///
  /// [duration] 指定周期间隔时长
  ///
  /// [tickToValue] 指定将 `tick` 转换为值的方法
  ///
  /// [initialTick] 指定初始 `tick` 值，默认为 `0`
  ///
  /// [autostart] 是否自动开始，默认为 `false`
  ///
  /// [repeat] 指定重复次数，其值为 `null` 或 `0` 时为不限次数，默认为 `null`
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  PeriodicBindableProperty<TValue> $periodic(
          {required Duration duration,
          required TValue Function(int tick) tickToValue,
          int initialTick = 0,
          bool autostart = false,
          int? repeat,
          PropertyValueChanged<TValue>? valueChanged}) =>
      PeriodicBindableProperty(
          duration: duration,
          tickToValue: tickToValue,
          initial: this,
          initialTick: initialTick,
          autostart: autostart,
          repeat: repeat,
          valueChanged: valueChanged);
}
*/

/// ListenableBindablePropertyExtension
extension ListenableBindablePropertyExtension<TAdaptee extends Listenable>
    on TAdaptee {
  ///
  /// 创建适配绑定属性
  ///
  /// [valueGetter] 指定从被适配者获取值的方法
  ///
  /// [valueSetter] 指定设置被适配者值的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  AdaptiveBindableProperty<TValue, TAdaptee> $adaptive<TValue>(
          {required TValue Function(TAdaptee) valueGetter,
          required void Function(TAdaptee, TValue) valueSetter,
          PropertyValueChanged<TValue>? valueChanged,
          TValue? initial}) =>
      AdaptiveBindableProperty(this,
          valueGetter: valueGetter,
          valueSetter: valueSetter,
          valueChanged: valueChanged,
          initial: initial);
}

/// MergeBindablePropertyExtension
extension MergeBindablePropertyExtension<TValue>
    on Iterable<ValueListenable<TValue>> {
  ///
  /// 创建合并的绑定属性
  ///
  /// 将多个 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的值集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  MergeBindableProperty<TValue> $merge(
          {PropertyValueChanged<Iterable<TValue>>? valueChanged}) =>
      MergeBindableProperty<TValue>(this, valueChanged: valueChanged);
}

/// MergeMapBindablePropertyExtension
extension MergeMapBindablePropertyExtension<TValue>
    on Map<Object, ValueListenable<TValue>> {
  ///
  /// 创建合并的绑定属性，并为每个结果值指定键
  ///
  /// 将多个指定键的 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的键值集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  MergeMapBindableProperty<TValue> $mergeMap(
          {PropertyValueChanged<Map<Object, TValue>>? valueChanged}) =>
      MergeMapBindableProperty<TValue>(this, valueChanged: valueChanged);
}

/// MultiBindablePropertyExtension
extension MultiBindablePropertyExtension<TValue> on Iterable<TValue> {
  ///
  /// 将值 [TValue] 集合转换为绑定属性 [BindableProperty] 集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  List<BindableProperty<TValue>> $multi(
          {PropertyValueChanged<TValue>? valueChanged}) =>
      map((value) => BindableProperty.$value<TValue>(
          initial: value, valueChanged: valueChanged)).toList();
}
