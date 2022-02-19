// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 异步请求绑定属性
///
class AsyncBindableProperty<TValue>
    extends BindableProperty<AsyncSnapshot<TValue>> {
  Object? _callbackIdentity;

  final AsyncValueGetter<TValue> _futureGetter;
  final TValue Function(TValue)? _handle;

  final void Function()? _onStart;
  final void Function()? _onEnd;
  final void Function(TValue)? _onSuccess;
  final void Function(dynamic)? _onError;

  ///
  /// 具备处理异步请求的绑定属性
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
  AsyncBindableProperty(AsyncValueGetter<TValue> futureGetter,
      {TValue Function(TValue)? handle,
      void Function()? onStart,
      void Function()? onEnd,
      void Function(TValue)? onSuccess,
      void Function(dynamic)? onError,
      PropertyValueChanged<AsyncSnapshot<TValue>>? valueChanged,
      TValue? initial})
      : _futureGetter = futureGetter,
        _handle = handle,
        _onStart = onStart,
        _onEnd = onEnd,
        _onSuccess = onSuccess,
        _onError = onError,
        _value = initial == null
            ? AsyncSnapshot<TValue>.nothing()
            : AsyncSnapshot<TValue>.withData(ConnectionState.none, initial),
        super(valueChanged: valueChanged);
  AsyncSnapshot<TValue> _value;

  @override
  AsyncSnapshot<TValue> get value => _value;

  void _setValue(AsyncSnapshot<TValue> value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }
  }

  ///
  /// 发起请求
  ///
  @protected
  void invoke({bool resetOnBefore = true}) {
    if (resetOnBefore) {
      _setValue(AsyncSnapshot<TValue>.nothing());
    }

    var future = _futureGetter();
    _onStart?.call();
    final callbackIdentity = Object();
    _callbackIdentity = callbackIdentity;
    future.then<void>((TValue data) {
      if (_callbackIdentity == callbackIdentity) {
        var _data = _handle == null ? data : _handle!(data);
        _onSuccess?.call(_data);
        _setValue(AsyncSnapshot<TValue>.withData(ConnectionState.done, _data));
      }
      _onEnd?.call();
    }, onError: (Object error) {
      if (_callbackIdentity == callbackIdentity) {
        _setValue(AsyncSnapshot<TValue>.withError(ConnectionState.done, error));
        _onError?.call(error);
      }
      _onEnd?.call();
    });
    _setValue(value.inState(ConnectionState.waiting));
  }
}

///
/// 异步请求绑定属性
///
mixin AsyncBindablePropertyMixin on BindableObjectMixin {
  ///
  /// 获取指定 [propertyKey] 对应异步请求属性的请求发起方法
  ///
  /// [propertyKey] 对应属性必须为 [AsyncBindableProperty] 否则返回 `null`
  ///
  /// [resetOnBefore] 指定发起请求之前是否重置属性值
  ///   当其值为 `true` 时, 发起请求之前属性值将先被重置为 `AsyncSnapshot<TValue>.nothing()`
  ///
  /// 调用其返回的方法将发起异步请求
  ///
  void Function()? getInvoke(Object propertyKey, {bool resetOnBefore = true}) {
    var property = getPropertyOf<dynamic, AsyncBindableProperty>(propertyKey);
    return property != null
        ? () => property.invoke(resetOnBefore: resetOnBefore)
        : null;
  }

  ///
  /// 获取指定 [propertyKey] 对应异步请求属性的请求发起方法
  ///
  /// [propertyKey] 对应属性必须为 [AsyncBindableProperty]
  ///
  /// [resetOnBefore] 指定发起请求之前是否重置属性值
  ///   当其值为 `true` 时, 发起请求之前属性值将先被重置为 `AsyncSnapshot<TValue>.nothing()`
  ///
  /// 调用其返回的方法将发起异步请求
  ///
  void Function() requireInvoke(Object propertyKey,
      {bool resetOnBefore = true}) {
    return getInvoke(propertyKey, resetOnBefore: resetOnBefore)!;
  }

  ///
  /// 发起指定 [propertyKey] 对应的异步请求
  ///
  /// [propertyKey] 对应属性必须为 [AsyncBindableProperty] 否则空操作
  ///
  /// [resetOnBefore] 指定发起请求之前是否重置属性值
  ///   当其值为 `true` 时, 发起请求之前属性值将先被重置为 `AsyncSnapshot<TValue>.nothing()`
  ///
  /// 调用其返回的方法将发起异步请求
  ///
  void invoke(Object propertyKey, {bool resetOnBefore = true}) =>
      getInvoke(propertyKey, resetOnBefore: resetOnBefore)?.call();

  ///
  /// 获取指定 [propertyKey] 对应异步请求发起链接
  ///
  /// [resetOnBefore] 指定发起请求之前是否重置属性值
  ///   当其值为 `true` 时, 发起请求之前属性值将先被重置为 `AsyncSnapshot<TValue>.nothing()`
  ///
  /// 其实质为 [getInvoke] 的快捷操作
  ///
  void Function()? link(Object propertyKey, {bool resetOnBefore = true}) =>
      getInvoke(propertyKey, resetOnBefore: resetOnBefore);
}
