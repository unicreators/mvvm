///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// AsyncViewModelProperty
///
///

class AsyncViewModelProperty<TValue>
    extends ViewModelProperty<AsyncSnapshot<TValue>> {
  Object _callbackIdentity;

  final AsyncValueGetter<TValue> futureGetter;
  final TValue Function(TValue) _handle;
  AsyncViewModelProperty(Object key, this.futureGetter,
      {TValue Function(TValue) handle, TValue initial})
      : _handle = handle,
        super(
            key,
            ValueNotifier(
                AsyncSnapshot<TValue>.withData(ConnectionState.none, initial)));

  ///
  /// 发起请求
  /// 
  @protected
  void invoke() {
    if (futureGetter == null) return;
    var future = futureGetter();
    if (future == null) return;
    final Object callbackIdentity = Object();
    _callbackIdentity = callbackIdentity;
    future.then<void>((TValue data) {
      if (_callbackIdentity == callbackIdentity)
        value = AsyncSnapshot<TValue>.withData(
            ConnectionState.done, _handle == null ? data : _handle(data));
    }, onError: (Object error) {
      if (_callbackIdentity == callbackIdentity)
        value = AsyncSnapshot<TValue>.withError(ConnectionState.done, error);
    });
    value = value.inState(ConnectionState.waiting);
  }
}

mixin AsyncViewModelMixin on ViewModelBase {
  ///
  /// 创建一个异步请求 [Future] 属性
  ///
  ///   `key` 指定属性键
  ///   `futureGetter` 用于获取 [Future] 的方法
  ///   `handle` 指定当请求成功时对结果处理的方法
  ///   `initial` 初始值
  ///
  AsyncViewModelProperty<TValue> propertyAsync<TValue>(
          Object key, AsyncValueGetter<TValue> futureGetter,
          {TValue Function(TValue) handle, TValue initial}) =>
      registryProperty(AsyncViewModelProperty<TValue>(key, futureGetter,
          handle: handle, initial: initial));

  ///
  /// 获取指定 `propertyKey` 对应异步请求属性的请求发起方法
  ///
  ///   `propertyKey` 对应属性必须为 [AsyncViewModelProperty] 否则返回 `null`
  ///   调用其返回的方法将发起异步请求
  ///
  void Function() getInvoke(Object propertyKey) {
    var property = getProperty(propertyKey);
    if (property is AsyncViewModelProperty) return property.invoke;
    return null;
  }

  ///
  /// 发起指定 `propertyKey` 对应的异步请求
  ///
  ///   `propertyKey` 对应属性必须为 [AsyncViewModelProperty] 否则空操作
  ///   调用其返回的方法将发起异步请求
  ///
  void invoke(Object key) => getInvoke(key)?.call();

  ///
  /// 获取指定 `propertyKey` 对应异步请求发起链接
  ///   其实质为 `getInvoke` 的快捷操作
  ///
  void Function() link(Object key) => getInvoke(key);
}
