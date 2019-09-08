// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

typedef PropertyValueChanged<TValue> = void Function(
    TValue value, Object propertyKey);

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
  ///
  /// [value] 指定属性值
  /// [valueCheck] 指定是否对值进行检查,
  ///   当其值为 `true` 时, 多次设置相同值将不会触发值变更通知
  ///   默认为 `false`
  @protected
  void setValue<TValue>(Object propertyKey, TValue value,
      {bool valueCheck = false}) {
    if (valueCheck) {
      var oldValue = getValue<TValue>(propertyKey);
      if (oldValue != value) getProperty<TValue>(propertyKey)?.value = value;
    } else {
      getProperty<TValue>(propertyKey)?.value = value;
    }
  }

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

  /// dispose
  @protected
  @mustCallSuper
  void dispose() {
    if (!_properties.isNotEmpty) return;
    for (var prop in _properties.values) {
      prop.dispose();
    }
  }
}

class _BindableProperty<TValue> extends BindableProperty<TValue> {
  _BindableProperty(Object key, ValueNotifier<TValue> valueNotifier,
      {PropertyValueChanged<TValue> valueChanged})
      : super(key, valueNotifier, valueChanged: valueChanged);
}

/// BindableProperty
///
abstract class BindableProperty<TValue> {
  /// BindableProperty.create
  static BindableProperty<TValue> create<TValue>(
          Object key, ValueNotifier<TValue> valueNotifier,
          {PropertyValueChanged<TValue> valueChanged}) =>
      _BindableProperty(key, valueNotifier, valueChanged: valueChanged);

  /// key
  final Object key;
  final ValueNotifier<TValue> _valueNotifier;
  VoidCallback _listener;

  /// BindableProperty
  BindableProperty(this.key, this._valueNotifier,
      {PropertyValueChanged<TValue> valueChanged})
      : assert(key != null && _valueNotifier != null) {
    if (valueChanged != null) {
      var _listener = () => valueChanged(value, key);
      _valueNotifier.addListener(_listener);
    }
  }

  /// dispose
  @protected
  @mustCallSuper
  void dispose() {
    if (_listener != null) _valueNotifier.removeListener(_listener);
  }

  ///
  /// 获取值
  @protected
  TValue get value => _valueNotifier.value;

  ///
  /// 设置值
  @protected
  set value(TValue v) => _valueNotifier.value = v;
}
