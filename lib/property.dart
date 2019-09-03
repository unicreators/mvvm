///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModelProperty
///
///

class ViewModelProperty<TValue> {
  /// propertyKey
  final Object propertyKey;
  final ValueNotifier<TValue> _valueNotifier;

  /// ViewModelProperty
  ViewModelProperty(this.propertyKey, this._valueNotifier
      /* , {TValue initial} */)
      : assert(propertyKey != null && _valueNotifier != null);

  //ValueNotifier<TValue> get valueNotifier => _valueNotifier;

  ///
  /// 获取值
  @protected
  TValue get value => _valueNotifier.value;

  ///
  /// 设置值
  @protected
  set value(TValue v) => _valueNotifier.value = v;
}

mixin ValueViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个值属性
  ///
  /// [propertyKey] 指定属性键
  /// [initial] 指定初始值
  ///
  ViewModelProperty<TValue> propertyValue<TValue>(Object propertyKey,
          {TValue initial}) =>
      registryProperty(ViewModelProperty(propertyKey, ValueNotifier(initial)));
}
