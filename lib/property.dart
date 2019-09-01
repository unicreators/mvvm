///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModelProperty
///
///

class ViewModelProperty<TValue> {
  final Object propertyKey;
  final ValueNotifier<TValue> _valueNotifier;

  ViewModelProperty(this.propertyKey, this._valueNotifier, {TValue initial})
      : assert(propertyKey != null && _valueNotifier != null);

  //ValueNotifier<TValue> get valueNotifier => _valueNotifier;

  @protected
  TValue get value => _valueNotifier.value;
  @protected
  set value(TValue v) => _valueNotifier.value = v;
}

mixin ValueViewModelMixin on _ViewModelBase {
  ViewModelProperty<TValue> property<TValue>(Object key, {TValue initial}) =>
      registryProperty(ViewModelProperty(key, ValueNotifier(initial)));
}
