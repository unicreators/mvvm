///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModel
///
///

abstract class ViewModel extends ViewModelBase {}

abstract class ViewModelBase extends _ViewModelBase
    with ValueViewModelMixin, AdaptiveViewModelMixin {}

abstract class _ViewModelBase {
  final _properties = Map<Object, ViewModelProperty<dynamic>>();

  @protected
  Iterable<MapEntry<Object, ViewModelProperty<dynamic>>> get properties =>
      _properties.entries;

  @protected
  TViewModelProperty
      registryProperty<TViewModelProperty extends ViewModelProperty>(
          TViewModelProperty property) {
    assert(property != null);
    _properties[property.propertyKey] = property;
    return property;
  }

  @protected
  Iterable<ViewModelProperty<dynamic>> getProperties(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map((propertyKey) => getProperty(propertyKey));

  @protected
  ViewModelProperty<TValue> getProperty<TValue>(Object propertyKey) =>
      _properties[propertyKey];

  @protected
  TValue getValue<TValue>(Object propertyKey) =>
      getProperty(propertyKey)?.value;

  @protected
  void setValue<TValue>(Object propertyKey, TValue value) =>
      getProperty(propertyKey)?.value = value;

  @protected
  ValueListenable<TValue> getPropertyValueListenable<TValue>(
          Object propertyKey) =>
      getProperty<TValue>(propertyKey)?._valueNotifier;

  @protected
  Iterable<ValueListenable> getPropertiesValueListenable(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map(getPropertyValueListenable);
}
