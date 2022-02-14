// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ViewModel
///
abstract class ViewModel extends ViewModelBase
    with
        BindableObjectMixin,
        BindableObjectValueMixin,
        ValueWidgetBuilderMixin,
        BindableObjectWidgetBuilderMixin,
        AsyncBindablePropertyMixin {}

/// ViewModelBase
///
abstract class ViewModelBase implements BindableObject {
  Map<Object, BindableProperty<dynamic>>? _properties;

  ///
  /// 获取所有已注册的属性
  @visibleForTesting
  @protected
  Iterable<MapEntry<Object, BindableProperty<dynamic>>> get properties =>
      _properties?.entries ?? [];

  ///
  /// 注册一个绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [property] 指定绑定属性
  ///
  @override
  BindableProperty<TValue> registerProperty<TValue>(
      Object propertyKey, BindableProperty<TValue> property) {
    (_properties ??= <Object, BindableProperty<dynamic>>{})[propertyKey] =
        property;
    return property;
  }

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// [propertyKey] 属性键
  ///
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @override
  BindableProperty<TValue>? getProperty<TValue>(Object propertyKey,
      {bool required = false}) {
    var property = _properties?[propertyKey] as BindableProperty<TValue>?;
    if (required && property == null)
      throw NotfoundPropertyException(propertyKey);
    return property;
  }

  ///
  @protected
  @mustCallSuper
  void init() {}

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
