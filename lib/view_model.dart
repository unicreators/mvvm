///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModel
///
///

abstract class ViewModel extends ViewModelBase {}

/// ViewModelBase
abstract class ViewModelBase extends _ViewModelBase
    with ValueViewModelMixin, AdaptiveViewModelMixin {}

abstract class _ViewModelBase {
  final _properties = <Object, ViewModelProperty<dynamic>>{};

  ///
  /// 获取所有已注册的属性
  @protected
  Iterable<MapEntry<Object, ViewModelProperty<dynamic>>> get properties =>
      _properties.entries;

  ///
  /// 注册一个属性
  @protected
  TViewModelProperty
      registryProperty<TViewModelProperty extends ViewModelProperty<dynamic>>(
          TViewModelProperty property) {
    assert(property != null);
    _properties[property.propertyKey] = property;
    return property;
  }

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  @protected
  Iterable<ViewModelProperty<dynamic>> getProperties(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map(getProperty);

  ///
  /// 获取指定 [propertyKey] 对应的属性
  @protected
  ViewModelProperty<TValue> getProperty<TValue>(Object propertyKey) =>
      _properties[propertyKey] as ViewModelProperty<TValue>;

  ///
  /// 获取指定 [propertyKey] 对应的属性值
  @protected
  TValue getValue<TValue>(Object propertyKey) =>
      getProperty<TValue>(propertyKey)?.value;

  ///
  /// 设置指定 [propertyKey] 对应的属性值
  @protected
  void setValue<TValue>(Object propertyKey, TValue value) =>
      getProperty<TValue>(propertyKey)?.value = value;

  ///
  /// 获取指定 [propertyKey] 对应的属性 [ValueListenable]
  @protected
  ValueListenable<TValue> getPropertyValueListenable<TValue>(
          Object propertyKey) =>
      getProperty<TValue>(propertyKey)?._valueNotifier;

  ///
  /// 获取指定 [propertyKeys] 对应的属性 [ValueListenable] 集合
  @protected
  Iterable<ValueListenable> getPropertiesValueListenable(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map(getPropertyValueListenable);
}
