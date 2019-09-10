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
          Iterable<Object> propertyKeys,
          {bool required = false}) =>
      propertyKeys.map(required ? requiredProperty : getProperty);

  ///
  /// 获取指定 [propertyKey] 对应的属性, 如不存在 [propertyKey] 对应属性则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  @protected
  BindableProperty<TValue> requiredProperty<TValue>(Object propertyKey) =>
      getProperty(propertyKey, required: true);

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// [propertyKey] 属性键
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  BindableProperty<TValue> getProperty<TValue>(Object propertyKey,
      {bool required = false}) {
    var property = _properties[propertyKey] as BindableProperty<TValue>;

    if (required && property == null) {
      throw FlutterError('''

[Flutter MVVM]

  Property not found. 
    - propertyKey: $propertyKey  
''');
    }

    return property;
  }

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// [propertyKey] 属性键
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   且类型必须为 [TProperty],
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在
  ///   或其类型不为 [TProperty], 则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  BindableProperty<TValue>
      getPropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
          Object propertyKey,
          {bool required = false}) {
    var property = getProperty<TValue>(propertyKey, required: required);
    if (property is TProperty) return property;
    if (required) {
      throw FlutterError('''

[Flutter MVVM]

  Property is not $TProperty
    - propertyKey: $propertyKey
    ''');
    }
    return null;
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  TValue getValue<TValue>(Object propertyKey,
          {bool requiredProperty = false}) =>
      getProperty<TValue>(propertyKey, required: requiredProperty)?.value;

  ///
  /// 设置指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  /// [value] 指定属性值
  ///
  /// [valueCheck] 指定是否对值进行检查,
  ///   当其值为 `true` 时, 多次设置相同值将不会触发值变更通知
  ///   默认为 `false`
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  void setValue<TValue>(Object propertyKey, TValue value,
      {bool valueCheck = false, bool requiredProperty = false}) {
    if (valueCheck) {
      var oldValue = getValue<TValue>(propertyKey);
      if (oldValue != value) {
        getProperty<TValue>(propertyKey, required: requiredProperty)?.value =
            value;
      }
    } else {
      getProperty<TValue>(propertyKey, required: requiredProperty)?.value =
          value;
    }
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性 [ValueListenable]
  ///
  /// [propertyKey] 属性键
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  ValueListenable<TValue> getValueListenable<TValue>(Object propertyKey,
          {bool requiredProperty = false}) =>
      getProperty<TValue>(propertyKey, required: requiredProperty)
          ?._valueNotifier;

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性的 [ValueListenable]
  ///
  /// [propertyKey] 属性键
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  ValueListenable<TValue> getValueListenableOf<TValue,
              TProperty extends BindableProperty<TValue>>(Object propertyKey,
          {bool requiredProperty = false}) =>
      getPropertyOf<TValue, TProperty>(propertyKey, required: requiredProperty)
          ?._valueNotifier;

  ///
  /// 获取指定 [propertyKeys] 对应的属性 [ValueListenable] 集合
  ///
  /// [propertyKeys] 属性键集合
  /// [requiredProperty] 指定 [propertyKeys] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKeys] 任一对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  Iterable<ValueListenable<TValue>> getValueListenables<TValue>(
          Iterable<Object> propertyKeys,
          {bool requiredProperty = false}) =>
      propertyKeys.map(
          (k) => getValueListenable(k, requiredProperty: requiredProperty));

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
