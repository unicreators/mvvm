// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

///
/// 属性值改变
typedef PropertyValueChanged<TValue> = void Function(TValue value);

/// BindableObject
///
abstract class BindableObject {
  Map<Object, BindableProperty<dynamic>>? _properties;

  ///
  /// 获取所有已注册的属性
  @visibleForTesting
  @protected
  Iterable<MapEntry<Object, BindableProperty<dynamic>>> get properties =>
      _properties?.entries ?? [];

  ///
  /// 注册一个属性
  BindableProperty<TValue> registryProperty<TValue>(
      Object propertyKey, BindableProperty<TValue> property) {
    (_properties ??= <Object, BindableProperty<dynamic>>{})[propertyKey] =
        property;
    return property;
  }

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  @protected
  Iterable<BindableProperty<TValue>?> getProperties<TValue>(
          Iterable<Object> propertyKeys,
          {bool required = false}) =>
      propertyKeys.map((k) => getProperty<TValue>(k, required: required));

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// [propertyKey] 属性键
  ///
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @visibleForTesting
  @protected
  BindableProperty<TValue>? getProperty<TValue>(Object propertyKey,
      {bool required = false}) {
    var property = _properties?[propertyKey] as BindableProperty<TValue>?;
    if (required && property == null) {
      throwNotfoundPropertyError(propertyKey);
    }
    return property;
  }

  ///
  void throwNotfoundPropertyError(Object propertyKey) {
    throw FlutterError('''

[Flutter MVVM]

  Property not found. 
    - propertyKey: $propertyKey  
''');
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// - 如对应属性不存在则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  @visibleForTesting
  @protected
  BindableProperty<TValue> property<TValue>(Object propertyKey) {
    return getProperty(propertyKey, required: true)!;
  }

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// [propertyKey] 属性键
  ///
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   且类型必须为 [TProperty],
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在
  ///   或其类型不为 [TProperty], 则抛出异常
  ///   默认值为 `false`
  ///
  TProperty? getPropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
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
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// - 如 [propertyKey] 对应属性不存在或类型不为 [TProperty] 则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  TProperty propertyOf<TValue, TProperty extends BindableProperty<TValue>>(
      Object propertyKey) {
    return getPropertyOf<TValue, TProperty>(propertyKey, required: true)!;
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  /// [defaultValue] 当属性不存在或值为 `null` 时，则使用此值
  ///
  TValue? getValue<TValue>(Object propertyKey,
          {bool requiredProperty = false, TValue? defaultValue}) =>
      getProperty<TValue>(propertyKey, required: requiredProperty)?.value ??
      defaultValue;

  ///
  /// 获取指定 [propertyKey] 对应的属性值
  ///
  /// - 如 [propertyKey] 对应属性不存在则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  TValue requireValue<TValue>(Object propertyKey) =>
      getProperty<TValue>(propertyKey, required: true)!.value;

  ///
  /// 设置指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
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
      var oldValue =
          getValue<TValue>(propertyKey, requiredProperty: requiredProperty);
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
  /// 发送指定 [propertyKey] 对应的属性值变更通知
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  void notify(Object propertyKey, {bool requiredProperty = false}) =>
      getProperty<dynamic>(propertyKey, required: requiredProperty)?.notify();

  ///
  /// 更新指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
  /// [updator] 指定值更新处理器
  ///   当 [updator] 处理器返回 `null` 时将不回写属性值
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  void updateValue<TValue>(
      Object propertyKey, TValue? Function(TValue?) updator,
      {bool requiredProperty = false}) {
    var _oldValue =
            getValue<TValue>(propertyKey, requiredProperty: requiredProperty),
        _newValue = updator(_oldValue);
    if (_newValue != null) {
      setValue(propertyKey, _newValue, requiredProperty: requiredProperty);
    }
  }

  ///
  /// 更新指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
  /// [updator] 指定值更新处理器
  ///   当 [updator] 处理器返回 `null` 时将不回写属性值
  ///
  ///
  void updateRequireValue<TValue>(
      Object propertyKey, TValue? Function(TValue) updator) {
    var _oldValue = requireValue<TValue>(propertyKey),
        _newValue = updator(_oldValue);
    if (_newValue != null) {
      setValue(propertyKey, _newValue);
    }
  }

  /// dispose
  @protected
  @mustCallSuper
  void dispose() {
    if (_properties == null) return;
    if (!_properties!.isNotEmpty) {
      for (var prop in _properties!.values) {
        prop.dispose();
      }
    }
    _properties = null;
  }
}

/// BindableProperty
///
abstract class BindableProperty<TValue> extends ValueNotifier<TValue> {
  VoidCallback? _listener;

  /// BindableProperty
  BindableProperty(
      {PropertyValueChanged<TValue>? valueChanged, required TValue initial})
      : super(initial) {
    if (valueChanged != null) {
      _listener = () => valueChanged(value);
      addListener(_listener!);
    }
  }

  /// dispose
  @protected
  @mustCallSuper
  @override
  void dispose() {
    if (_listener != null) removeListener(_listener!);
    super.dispose();
  }

  /// 发送通知
  void notify() => notifyListeners();
}

/// CustomValueNotifier
class CustomBindableProperty<TValue> extends BindableProperty<TValue> {
  final ValueGetter<TValue> _valueGetter;
  final ValueSetter<TValue> _valueSetter;

  /// CustomValueNotifier
  CustomBindableProperty(
      ValueGetter<TValue> valueGetter, ValueSetter<TValue> valueSetter,
      {PropertyValueChanged<TValue>? valueChanged, TValue? initial})
      : _valueGetter = valueGetter,
        _valueSetter = valueSetter,
        super(valueChanged: valueChanged, initial: initial ?? valueGetter()) {
    if (initial != null) {
      // no notify
      _valueSetter(initial);
    }
  }

  @override
  TValue get value => _valueGetter();

  @override
  set value(TValue v) {
    if (super.value != v) {
      if (value != v) _valueSetter(v);
      super.value = v;
    }
  }
}
