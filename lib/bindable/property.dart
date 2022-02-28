// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 属性值改变
typedef PropertyValueChanged<TValue> = void Function(TValue value);

/// 绑定属性
///
abstract class BindableProperty<TValue> extends ChangeNotifier
    implements ValueListenable<TValue> {
  ///
  /// 创建值绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static ValueBindableProperty<TValue> $value<TValue>(
          {required TValue initial,
          PropertyValueChanged<TValue>? valueChanged}) =>
      ValueBindableProperty(initial: initial, valueChanged: valueChanged);

  ///
  /// 创建适配绑定属性
  ///
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  ///
  /// [valueGetter] 指定从被适配者获取值的方法
  ///
  /// [valueSetter] 指定设置被适配者值的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static AdaptiveBindableProperty<TValue, TAdaptee>
      $adaptive<TValue, TAdaptee extends Listenable>(TAdaptee adaptee,
              {required TValue Function(TAdaptee) valueGetter,
              required void Function(TAdaptee, TValue) valueSetter,
              PropertyValueChanged<TValue>? valueChanged,
              TValue? initial}) =>
          AdaptiveBindableProperty(adaptee,
              valueGetter: valueGetter,
              valueSetter: valueSetter,
              valueChanged: valueChanged);

  ///
  /// 创建具备处理异步请求的绑定属性
  ///
  /// [futureGetter] 用于获取 [Future<TValue>] 的方法
  ///
  /// [handle] 指定请求成功时对结果进行处理的方法
  ///
  /// [onStart] 指定请求发起时执行的方法
  ///
  /// [onEnd] 指定请求结束时执行的方法
  ///
  /// [onSuccess] 指定请求成功时执行的方法
  ///
  /// [onError] 指定请求出错时执行的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static AsyncBindableProperty<TValue> $async<TValue>(
          AsyncValueGetter<TValue> futureGetter,
          {TValue Function(TValue)? handle,
          void Function()? onStart,
          void Function()? onEnd,
          void Function(TValue)? onSuccess,
          void Function(dynamic)? onError,
          PropertyValueChanged<AsyncSnapshot<TValue>>? valueChanged,
          TValue? initial}) =>
      AsyncBindableProperty(futureGetter,
          handle: handle,
          onStart: onStart,
          onEnd: onEnd,
          onSuccess: onSuccess,
          onError: onError,
          valueChanged: valueChanged,
          initial: initial);

  ///
  /// 创建自定义绑定属性
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static CustomBindableProperty<TValue> $custom<TValue>(
          {required ValueGetter<TValue> valueGetter,
          required ValueSetter<TValue> valueSetter,
          PropertyValueChanged<TValue>? valueChanged}) =>
      CustomBindableProperty(
          valueGetter: valueGetter,
          valueSetter: valueSetter,
          valueChanged: valueChanged);

  ///
  /// 创建具有周期性的绑定属性
  ///
  /// [duration] 指定周期间隔时长
  ///
  /// [tickToValue] 指定将 `tick` 转换为值的方法
  ///
  /// [initial] 指定初始值
  ///
  /// [initialTick] 指定初始 `tick` 值，默认为 `0`
  ///
  /// [autostart] 是否自动开始，默认为 `false`
  ///
  /// [repeat] 指定重复次数，其值为 `null` 或 `0` 时为不限次数，默认为 `null`
  ///
  /// [onTick] 指定每次 `tick` 的回调方法
  ///
  /// [statusChanged] 指定属性状态变更后的回调方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static PeriodicBindableProperty<TValue> $periodic<TValue>(
          {required Duration duration,
          required TValue Function(int tick) tickToValue,
          required TValue initial,
          int initialTick = 0,
          bool autostart = false,
          int? repeat,
          void Function(int tick)? onTick,
          void Function(PeriodicBindableProperty<TValue>)? statusChanged,
          PropertyValueChanged<TValue>? valueChanged}) =>
      PeriodicBindableProperty(
          duration: duration,
          tickToValue: tickToValue,
          initial: initial,
          initialTick: initialTick,
          autostart: autostart,
          repeat: repeat,
          onTick: onTick,
          statusChanged: statusChanged,
          valueChanged: valueChanged);

  ///
  /// 创建具有周期性的绑定属性
  ///
  /// [duration] 指定周期间隔时长
  ///
  /// [initialTick] 指定初始 `tick` 值，默认为 `0`
  ///
  /// [autostart] 是否自动开始，默认为 `false`
  ///
  /// [repeat] 指定重复次数，其值为 `null` 或 `0` 时为不限次数，默认为 `null`
  ///
  /// [onTick] 指定每次 `tick` 的回调方法
  ///
  /// [statusChanged] 指定属性状态变更后的回调方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static PeriodicBindableProperty<int> $tick(
          {required Duration duration,
          int initial = 0,
          int initialTick = 0,
          bool autostart = false,
          int? repeat,
          void Function(int tick)? onTick,
          void Function(PeriodicBindableProperty<int>)? statusChanged,
          PropertyValueChanged<int>? valueChanged}) =>
      PeriodicBindableProperty(
          duration: duration,
          tickToValue: identity,
          initial: initial,
          initialTick: initialTick,
          autostart: autostart,
          repeat: repeat,
          onTick: onTick,
          statusChanged: statusChanged,
          valueChanged: valueChanged);

  ///
  /// 创建合并的绑定属性
  ///
  /// 将多个 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的值集合
  ///
  /// [valueListenables] 指定将要合并的 [ValueListenable] 集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static MergeBindableProperty<TValue> $merge<TValue>(
          Iterable<ValueListenable<TValue>> valueListenables,
          {PropertyValueChanged<Iterable<TValue>>? valueChanged}) =>
      MergeBindableProperty(valueListenables, valueChanged: valueChanged);

  ///
  /// 创建具有键的合并的绑定属性
  ///
  /// 将多个指定键的 [ValueListenable] 合并成一个新的 [ValueListenable],
  /// 新的 [ValueListenable] 值 `value` 为多个 [ValueListenable] 的键值集合
  ///
  /// [map] 指定将要合并的具有键的 [ValueListenable] 集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static MergeMapBindableProperty<TValue> $mergeMap<TValue>(
          Map<Object, ValueListenable<TValue>> map,
          {PropertyValueChanged<Map<Object, TValue>>? valueChanged}) =>
      MergeMapBindableProperty(map, valueChanged: valueChanged);

  ///
  /// 将值 [TValue] 集合转换为绑定属性 [BindableProperty] 集合
  ///
  /// [values] 要转换的值集合
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static List<BindableProperty<TValue>> $map<TValue>(Iterable<TValue> values,
          {PropertyValueChanged<TValue>? valueChanged}) =>
      _map(values, valueChanged: valueChanged);

  ///
  /// 从指定 [ValueListenable] 转换到一个新的绑定属性
  ///
  /// [valueListenable] 指定来源 [ValueListenable]
  ///
  /// [transformer] 指定属性值变换方法，当此方法返回值非 `null` 时则将此值写入属性
  ///
  /// [initial] 指定初始值
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static BindableProperty<TValue> $transform<TValue, TSValue>(
          ValueListenable<TSValue> valueListenable,
          {required TValue? Function(TSValue value) transformer,
          required TValue initial,
          PropertyValueChanged<TValue>? valueChanged}) =>
      TransformBindableProperty(valueListenable,
          transformer: transformer,
          initial: initial,
          valueChanged: valueChanged);

  ///
  /// 过滤指定 [ValueListenable] 得到一个新的绑定属性
  ///
  /// [valueListenable] 指定来源 [ValueListenable]
  ///
  /// [filter] 指定过滤方法，当此方法返回值为 `true` 时则将此值写入属性
  ///
  /// [initial] 指定初始值
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  static BindableProperty<TValue> $filter<TValue>(
          ValueListenable<TValue> valueListenable,
          {required bool Function(TValue value) filter,
          required TValue initial,
          PropertyValueChanged<TValue>? valueChanged}) =>
      TransformBindableProperty(valueListenable,
          transformer: (TValue value) => filter(value) ? value : null,
          initial: initial,
          valueChanged: valueChanged);

  VoidCallback? _listener;

  /// BindableProperty
  BindableProperty({PropertyValueChanged<TValue>? valueChanged}) {
    if (valueChanged != null) {
      _listener = () => valueChanged(value);
      addListener(_listener!);
    }
  }

  /// 发送通知
  void notify() => notifyListeners();

  /// dispose
  @protected
  @mustCallSuper
  @override
  void dispose() {
    if (_listener != null) removeListener(_listener!);
    super.dispose();
  }

  ///
  /// 从当前绑定属性转换到一个新的绑定属性
  ///
  /// [transform] 指定属性值变换方法，当此方法返回值非 `null` 时则将此值写入属性
  ///
  /// [initial] 指定初始值
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  BindableProperty<T> transform<T>(
          {required T? Function(TValue) transformer,
          required T initial,
          PropertyValueChanged<T>? valueChanged}) =>
      $transform(this,
          transformer: transformer,
          initial: initial,
          valueChanged: valueChanged);
}

///
/// 可设置值的绑定属性
///
abstract class WriteableBindableProperty<TValue>
    extends BindableProperty<TValue> {
  ///
  /// 创建可设置值的绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  WriteableBindableProperty({PropertyValueChanged<TValue>? valueChanged})
      : super(valueChanged: valueChanged);

  ///
  /// 设置值
  ///
  set value(TValue value);

  ///
  /// 设置属性值
  ///
  /// - 如传入值 `value` 为 `null` 则跳过设置
  ///
  void set(TValue? value) {
    if (value != null) this.value = value;
  }

  ///
  /// 更新属性值
  ///
  /// [updator] 指定值更新处理器
  ///   当 [updator] 处理器返回 `null` 时将不回写属性值
  ///
  /// ```dart
  /// // example
  /// BindableProperty.$value(initial: Item(x: 1, y: 1))
  ///   .update((item) {
  ///       if(item.x != 1) return null;
  ///       item.x = 2;
  ///       return item;
  ///    });
  /// ```
  void update(TValue? Function(TValue value) updator) {
    var _oldValue = value, _newValue = updator(_oldValue);
    if (_newValue != null) {
      /// 如新值不为null，则表示需要发出变更通知
      ///
      /// - 当新值与旧值不同，则交由property内部处理是否发出通知
      /// - 否则强制发出变更通知
      ///
      if (_newValue != _oldValue)
        value = _newValue;
      else
        notify();
    }
  }
}
