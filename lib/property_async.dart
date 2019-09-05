///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// AsyncViewModelProperty
///
class AsyncViewModelProperty<TValue>
    extends BindableProperty<AsyncSnapshot<TValue>> {
  Object _callbackIdentity;

  final AsyncValueGetter<TValue> _futureGetter;
  final TValue Function(TValue) _handle;

  final void Function() _onStart;
  final void Function() _onEnd;
  final void Function(TValue) _onSuccess;
  final void Function(dynamic) _onError;

  /// AsyncViewModelProperty
  AsyncViewModelProperty(Object key, this._futureGetter,
      {TValue Function(TValue) handle,
      void Function() onStart,
      void Function() onEnd,
      void Function(TValue) onSuccess,
      void Function(dynamic) onError,
      TValue initial})
      : _handle = handle,
        _onStart = onStart,
        _onEnd = onEnd,
        _onSuccess = onSuccess,
        _onError = onError,
        super(
            key,
            ValueNotifier(
                AsyncSnapshot<TValue>.withData(ConnectionState.none, initial)));

  ///
  /// 发起请求
  ///
  @protected
  void invoke() {
    if (_futureGetter == null) return;
    var future = _futureGetter();
    if (future == null) return;

    _onStart?.call();
    final callbackIdentity = Object();
    _callbackIdentity = callbackIdentity;
    future.then<void>((TValue data) {
      if (_callbackIdentity == callbackIdentity) {
        _onSuccess?.call(data);
        value = AsyncSnapshot<TValue>.withData(
            ConnectionState.done, _handle == null ? data : _handle(data));
      }
      _onEnd?.call();
    }, onError: (Object error) {
      if (_callbackIdentity == callbackIdentity) {
        value = AsyncSnapshot<TValue>.withError(ConnectionState.done, error);
        _onError?.call(error);
      }
      _onEnd?.call();
    });
    value = value.inState(ConnectionState.waiting);
  }
}

mixin AsyncViewModelMixin on ViewModelBase {
  ///
  /// 创建一个异步请求 [Future<TValue>] 属性
  ///
  /// [propertyKey] 指定属性键
  /// [futureGetter] 用于获取 [Future<TValue>] 的方法
  /// [handle] 指定请求成功时对结果进行处理的方法
  /// [onStart] 指定请求发起时执行的方法
  /// [onEnd] 指定请求结束时执行的方法
  /// [onSuccess] 指定请求成功时执行的方法
  /// [onError] 指定请求出错时执行的方法
  /// [initial] 初始值
  ///
  BindableProperty<AsyncSnapshot<TValue>> propertyAsync<TValue>(
          Object propertyKey, AsyncValueGetter<TValue> futureGetter,
          {TValue Function(TValue) handle,
          void Function() onStart,
          void Function() onEnd,
          void Function(TValue) onSuccess,
          void Function(dynamic) onError,
          TValue initial}) =>
      registryProperty(AsyncViewModelProperty<TValue>(propertyKey, futureGetter,
          handle: handle, initial: initial));

  ///
  /// 获取指定 [propertyKey] 对应异步请求属性的请求发起方法
  ///
  /// [propertyKey] 对应属性必须为 [AsyncViewModelProperty] 否则返回 `null`
  /// 调用其返回的方法将发起异步请求
  ///
  void Function() getInvoke(Object propertyKey) {
    var property = getProperty<dynamic>(propertyKey);
    if (property is AsyncViewModelProperty) return property.invoke;
    return null;
  }

  ///
  /// 发起指定 [propertyKey] 对应的异步请求
  ///
  /// [propertyKey] 对应属性必须为 [AsyncViewModelProperty] 否则空操作
  /// 调用其返回的方法将发起异步请求
  ///
  void invoke(Object propertyKey) => getInvoke(propertyKey)?.call();

  ///
  /// 获取指定 [propertyKey] 对应异步请求发起链接
  /// 其实质为 [getInvoke] 的快捷操作
  ///
  void Function() link(Object propertyKey) => getInvoke(propertyKey);
}
