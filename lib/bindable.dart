///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// BindableObject
///
abstract class BindableObject {
  final _properties = <Object, BindableProperty<dynamic>>{};

  ///
  /// 获取所有已注册的属性
  @protected
  Iterable<MapEntry<Object, BindableProperty<dynamic>>> get properties =>
      _properties.entries;

  ///
  /// 注册一个属性
  @protected
  BindableProperty<TValue> registryProperty<TValue>(
      BindableProperty<TValue> property) {
    assert(property != null);
    _properties[property.key] = property;
    return property;
  }

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  @protected
  Iterable<BindableProperty<dynamic>> getProperties(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map(getProperty);

  ///
  /// 获取指定 [propertyKey] 对应的属性
  @protected
  BindableProperty<TValue> getProperty<TValue>(Object propertyKey) =>
      _properties[propertyKey] as BindableProperty<TValue>;

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  @protected
  BindableProperty<TValue>
      getPropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
          Object propertyKey) {
    var property = getProperty<TValue>(propertyKey);
    if (property is TProperty) return property;
    return null;
  }

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
  ValueListenable<TValue> getValueListenable<TValue>(Object propertyKey) =>
      getProperty<TValue>(propertyKey)?._valueNotifier;

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性的 [ValueListenable]
  @protected
  ValueListenable<TValue>
      getValueListenableOf<TValue, TProperty extends BindableProperty<TValue>>(
              Object propertyKey) =>
          getPropertyOf<TValue, TProperty>(propertyKey)?._valueNotifier;

  ///
  /// 获取指定 [propertyKeys] 对应的属性 [ValueListenable] 集合
  @protected
  Iterable<ValueListenable<TValue>> getValueListenables<TValue>(
          Iterable<Object> propertyKeys) =>
      propertyKeys.map(getValueListenable);
}

/// BindableProperty
///
abstract class BindableProperty<TValue> {
  /// key
  final Object key;
  final ValueNotifier<TValue> _valueNotifier;

  /// BindableProperty
  BindableProperty(this.key, this._valueNotifier
      /* , {TValue initial} */)
      : assert(key != null && _valueNotifier != null);

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
