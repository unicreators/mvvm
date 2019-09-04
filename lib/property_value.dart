///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModelProperty
///
///
class ViewModelProperty<TValue> extends Property<TValue> {
  /// ViewModelProperty
  ViewModelProperty(Object propertyKey, ValueNotifier<TValue> valueNotifier)
      : super(propertyKey, valueNotifier);
}

mixin ValueViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个值属性
  ///
  /// [propertyKey] 指定属性键
  /// [initial] 指定初始值
  ///
  Property<TValue> propertyValue<TValue>(Object propertyKey,
          {TValue initial}) =>
      registryProperty(ViewModelProperty<TValue>(
          propertyKey, ValueNotifier<TValue>(initial)));
}
