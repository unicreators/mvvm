// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

/// BindableObject
///
mixin BindableObject1 {
  Map<Object, BindableProperty<dynamic>>? _properties;

  ///
  /// 获取所有已注册的属性
  @visibleForTesting
  @protected
  Iterable<MapEntry<Object, BindableProperty<dynamic>>> get properties =>
      _properties?.entries ?? [];

  ///
  /// 注册一个属性
  BindableProperty<TValue> registerProperty<TValue>(
      Object propertyKey, BindableProperty<TValue> property) {
    (_properties ??= <Object, BindableProperty<dynamic>>{})[propertyKey] =
        property;
    return property;
  }

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  ///
  /// [required] 指定 [propertyKeys] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKeys] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @protected
  Iterable<BindableProperty<TValue>?> getProperties<TValue>(
          Iterable<Object> propertyKeys,
          {bool required = false}) =>
      propertyKeys.map((k) => getProperty<TValue>(k, required: required));

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  ///
  /// - 如 [propertyKeys] 对应属性不存在则抛出异常
  ///
  @protected
  Iterable<BindableProperty<TValue>> requireProperties<TValue>(
          Iterable<Object> propertyKeys) =>
      getProperties<TValue>(propertyKeys, required: true).cast();

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
    if (required && property == null)
      throw NotfoundPropertyException(propertyKey);
    return property;
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// - 如 [propertyKey] 对应属性不存在则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  @visibleForTesting
  @protected
  BindableProperty<TValue> requireProperty<TValue>(Object propertyKey) =>
      getProperty(propertyKey, required: true)!;

  ///
  /// 确认指定 [propertyKey] 对应的绑定属性
  ///
  /// - 如对应属性不存在，且 [initialValue] 不为 `null` 则使用 [initialValue] 注册一个值绑定属性
  ///   否则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  @protected
  BindableProperty<TValue> ensureProperty<TValue>(Object propertyKey,
      {TValue? initialValue}) {
    var property =
        getProperty<TValue>(propertyKey, required: initialValue == null);
    if (property == null && initialValue != null) {
      property = PreBindableProperty(initialValue: initialValue);
      registerProperty(propertyKey, property);
    }
    return property!;
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
    if (required) throw NotOfTypePropertyException(propertyKey, TProperty);
    return null;
  }

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// - 如 [propertyKey] 对应属性不存在或类型不为 [TProperty] 则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  TProperty
      requirePropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
              Object propertyKey) =>
          getPropertyOf<TValue, TProperty>(propertyKey, required: true)!;

  ///
  /// 获取指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  /// [defaultValue] 当属性不存在时则使用此值, 仅在 [requiredProperty] 为 `false` 时有效
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
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void setValue<TValue>(Object propertyKey, TValue value,
          {bool requiredProperty = true}) =>
      getProperty<TValue>(propertyKey, required: requiredProperty)?.value =
          value;

  ///
  /// 设置指定 [propertyKeys] 对应的属性值
  ///
  /// [propertyKeys] 属性键集合
  ///
  /// [values] 指定属性值集合
  ///
  /// [requiredProperty] 指定 [propertyKeys] 中对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKeys] 中对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void setValues(Iterable<Object> propertyKeys, Iterable<Object?> values,
      {bool requiredProperty = true}) {
    var properties =
            getProperties<dynamic>(propertyKeys, required: requiredProperty),
        index = 0;
    for (var property in properties) {
      var value = values.elementAt(index++);
      if (value == null) continue;
      property?.value = value;
    }
  }

  ///
  /// 发送指定 [propertyKey] 对应的属性值变更通知
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void notify(Object propertyKey, {bool requiredProperty = true}) =>
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
  ///   默认值为 `true`
  ///
  void updateValue<TValue>(Object propertyKey, TValue? Function(TValue) updator,
      {bool requiredProperty = true}) {
    var property = getProperty<TValue>(propertyKey, required: requiredProperty);
    if (property == null) return;
    property.update(updator);
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

/// KeyBindablePropertyProvider
///
abstract class BindableObject {
  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// [propertyKey] 属性键
  ///
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  BindableProperty<TValue>? getProperty<TValue>(Object propertyKey,
      {bool required = false});

  ///
  BindableProperty<TValue> registerProperty<TValue>(
      Object propertyKey, BindableProperty<TValue> property);
}

/// BindableObjectMixin
///
mixin BindableObjectMixin on BindableObject {
  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  ///
  /// [required] 指定 [propertyKeys] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKeys] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  Iterable<BindableProperty<TValue>?> getProperties<TValue>(
          Iterable<Object> propertyKeys,
          {bool required = false}) =>
      propertyKeys.map((k) => getProperty<TValue>(k, required: required));

  ///
  /// 获取指定 [propertyKeys] 对应的属性集合
  ///
  /// - 如 [propertyKeys] 对应属性不存在则抛出异常
  ///
  Iterable<BindableProperty<TValue>> requireProperties<TValue>(
          Iterable<Object> propertyKeys) =>
      getProperties<TValue>(propertyKeys, required: true).cast();

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// - 如 [propertyKey] 对应属性不存在则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  BindableProperty<TValue> requireProperty<TValue>(Object propertyKey) =>
      getProperty(propertyKey, required: true)!;

  ///
  /// 确认指定 [propertyKey] 对应的绑定属性
  ///
  /// - 如对应属性不存在，且 [initialValue] 不为 `null` 则使用 [initialValue] 注册一个值绑定属性
  ///   否则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  ///
  BindableProperty<TValue> ensureProperty<TValue>(Object propertyKey,
      {TValue? initialValue}) {
    var property =
        getProperty<TValue>(propertyKey, required: initialValue == null);
    if (property == null && initialValue != null) {
      property = PreBindableProperty(initialValue: initialValue);
      registerProperty(propertyKey, property);
    }
    return property!;
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
    if (required) throw NotOfTypePropertyException(propertyKey, TProperty);
    return null;
  }

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// - 如 [propertyKey] 对应属性不存在或类型不为 [TProperty] 则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  TProperty
      requirePropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
              Object propertyKey) =>
          getPropertyOf<TValue, TProperty>(propertyKey, required: true)!;
}

/// BindableObjectValueMixin
///
mixin BindableObjectValueMixin on BindableObjectMixin {
  ///
  /// 获取指定 [propertyKey] 对应的属性值
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  /// [defaultValue] 当属性不存在时则使用此值, 仅在 [requiredProperty] 为 `false` 时有效
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
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void setValue<TValue>(Object propertyKey, TValue value,
          {bool requiredProperty = true}) =>
      getProperty<TValue>(propertyKey, required: requiredProperty)?.value =
          value;

  ///
  /// 设置指定 [propertyKeys] 对应的属性值
  ///
  /// [propertyKeys] 属性键集合
  ///
  /// [values] 指定属性值集合
  ///
  /// [requiredProperty] 指定 [propertyKeys] 中对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKeys] 中对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void setValues(Iterable<Object> propertyKeys, Iterable<Object?> values,
      {bool requiredProperty = true}) {
    var properties =
            getProperties<dynamic>(propertyKeys, required: requiredProperty),
        index = 0;
    for (var property in properties) {
      if (property == null) {
        index++;
        continue;
      }
      property.set(values.elementAt(index++));
    }
  }

  ///
  /// 发送指定 [propertyKey] 对应的属性值变更通知
  ///
  /// [propertyKey] 属性键
  ///
  /// [requiredProperty] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `true`
  ///
  void notify(Object propertyKey, {bool requiredProperty = true}) =>
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
  ///   默认值为 `true`
  ///
  void updateValue<TValue>(Object propertyKey, TValue? Function(TValue) updator,
      {bool requiredProperty = true}) {
    var property = getProperty<TValue>(propertyKey, required: requiredProperty);
    if (property == null) return;
    property.update(updator);
  }
}
