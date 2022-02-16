// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 具有周期性的绑定属性
///
class PeriodicBindableProperty<TValue> extends BindableProperty<TValue> {
  final Duration _duration;
  Timer? _timer;
  final TValue _initial;
  final void Function(PeriodicBindableProperty<TValue>)? _statusChanged;
  late final void Function(Timer) _callback;

  final int _initialTick;
  int _tick = 0;

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
  PeriodicBindableProperty(
      {required Duration duration,
      required TValue Function(int tick) tickToValue,
      required TValue initial,
      int initialTick = 0,
      bool autostart = false,
      int? repeat,
      void Function(int tick)? onTick,
      void Function(PeriodicBindableProperty<TValue>)? statusChanged,
      PropertyValueChanged<TValue>? valueChanged})
      : _duration = duration,
        _initial = initial,
        _initialTick = initialTick,
        _tick = initialTick,
        _statusChanged = statusChanged,
        _value = initial,
        super(valueChanged: valueChanged) {
    var _repeat = repeat == null || repeat == 0 ? null : repeat.abs(),
        _fn = (Timer _) {
          _value = tickToValue(++_tick);
          notifyListeners();
          onTick?.call(_tick);
        };
    _callback = _repeat == null
        ? _fn
        : (Timer _) {
            _fn(_);
            if (_.tick == _repeat) stop();
          };
    if (autostart) start();
  }

  /// 是否已开始
  ///
  bool get started => _timer != null;

  /// 开始
  ///
  void start() {
    if (started) return;
    _timer = Timer.periodic(_duration, _callback);
    _statusChanged?.call(this);
  }

  /// 停止
  ///
  void stop() {
    if (!started) return;
    _timer!.cancel();
    _timer = null;
    _statusChanged?.call(this);
  }

  /// 重新开始
  ///
  void restart() {
    stop();
    start();
  }

  /// 开关
  ///
  void toggle() {
    started ? stop() : start();
  }

  /// 重置
  ///
  void reset() {
    stop();
    _tick = _initialTick;
    _value = _initial;
  }

  TValue _value;
  @override
  TValue get value => _value;
}
