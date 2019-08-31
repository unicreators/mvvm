//////////////////////////////////////////
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
  AsyncViewModelProperty<TValue> propertyAsync<TValue>(
          Object key, AsyncValueGetter<TValue> futureGetter,
          {TValue Function(TValue) handle, TValue initial}) =>
      registryProperty(AsyncViewModelProperty<TValue>(key, futureGetter,
          handle: handle, initial: initial));

  void Function() getInvoke(Object key) {
    var property = getProperty(key);
    if (property is AsyncViewModelProperty) return property.invoke;
    return null;
  }

  void invoke(Object key) => getInvoke(key)?.call();
  void Function() link(Object key) => getInvoke(key);
}
