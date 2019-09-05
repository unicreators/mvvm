///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ValueViewModelProperty
///
class ValueViewModelProperty<TValue> extends BindableProperty<TValue> {
  /// ValueProperty
  ValueViewModelProperty(Object propertyKey, TValue value)
      : super(propertyKey, ValueNotifier<TValue>(value));

  /// create
  ValueViewModelProperty.create(Object propertyKey, {TValue initial})
      : this(propertyKey, initial);
}

mixin ValueViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个值属性
  ///
  /// [propertyKey] 指定属性键
  /// [initial] 指定初始值
  ///
  BindableProperty<TValue> propertyValue<TValue>(Object propertyKey,
          {TValue initial}) =>
      registryProperty(ValueViewModelProperty<TValue>(propertyKey, initial));
}
