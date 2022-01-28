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
    if (required && property == null)
      throw NotfoundPropertyException(propertyKey);
    return property;
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
  BindableProperty<TValue> requireProperty<TValue>(Object propertyKey) =>
      getProperty(propertyKey, required: true)!;

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
      {bool requiredProperty = false}) {
    var property = getProperty<TValue>(propertyKey, required: requiredProperty);
    if (property is TProperty) return property;
    if (requiredProperty)
      throw NotOfTypePropertyException(propertyKey, TProperty);
    return null;
  }

  ///
  /// 获取指定 [propertyKey] 对应 [TProperty] 类型属性
  ///
  /// - 如 [propertyKey] 对应属性不存在或类型不为 [TProperty] 则抛出异常
  ///
  /// [propertyKey] 属性键
  ///
  TProperty requirePropertyOf<TValue,
          TProperty extends BindableProperty<TValue>>(Object propertyKey) =>
      getPropertyOf<TValue, TProperty>(propertyKey, requiredProperty: true)!;

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
    var oldValue = property.value, newValue = updator(oldValue);
    if (newValue != null) {
      /// 如新值不为null，则表示需要发出变更通知
      ///
      /// - 当新值与旧值不同，则交由property内部处理是否发出通知
      /// - 否则强制发出变更通知
      ///
      if (newValue != oldValue)
        property.value = newValue;
      else
        property.notify();
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
  ///
  /// 创建值绑定属性
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static BindableProperty<TValue> $value<TValue>(
          {required TValue initial,
          PropertyValueChanged<TValue>? valueChanged}) =>
      ValueBindableProperty(initial: initial, valueChanged: valueChanged);

  ///
  /// 创建适配绑定属性
  ///
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  ///
  /// [valueGetter] 指定从被适配者获取值的方法
  ///
  /// [valueSetter] 指定设置被适配者值的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static AdaptiveBindableProperty<TValue, TAdaptee>
      $adaptive<TValue, TAdaptee extends Listenable>(TAdaptee adaptee,
              {required TValue Function(TAdaptee) valueGetter,
              required void Function(TAdaptee, TValue) valueSetter,
              PropertyValueChanged<TValue>? valueChanged,
              TValue? initial}) =>
          AdaptiveBindableProperty(adaptee,
              valueGetter: valueGetter,
              valueSetter: valueSetter,
              valueChanged: valueChanged,
              initial: initial);

  ///
  /// 创建具备处理异步请求的绑定属性
  ///
  /// [futureGetter] 用于获取 [Future<TValue>] 的方法
  ///
  /// [handle] 指定请求成功时对结果进行处理的方法
  ///
  /// [onStart] 指定请求发起时执行的方法
  ///
  /// [onEnd] 指定请求结束时执行的方法
  ///
  /// [onSuccess] 指定请求成功时执行的方法
  ///
  /// [onError] 指定请求出错时执行的方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static AsyncBindableProperty<TValue> $async<TValue>(
          AsyncValueGetter<TValue> futureGetter,
          {TValue Function(TValue)? handle,
          void Function()? onStart,
          void Function()? onEnd,
          void Function(TValue)? onSuccess,
          void Function(dynamic)? onError,
          PropertyValueChanged<AsyncSnapshot<TValue>>? valueChanged,
          TValue? initial}) =>
      AsyncBindableProperty(futureGetter,
          handle: handle,
          onStart: onStart,
          onEnd: onEnd,
          onSuccess: onSuccess,
          onError: onError,
          valueChanged: valueChanged,
          initial: initial);

  ///
  /// 创建自定义绑定属性
  ///
  /// [valueGetter] 指定获取值方法
  ///
  /// [valueSetter] 指定设置值方法
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  /// [initial] 指定初始值
  ///
  static CustomBindableProperty<TValue> $custom<TValue>(
          {required ValueGetter<TValue> valueGetter,
          required ValueSetter<TValue> valueSetter,
          PropertyValueChanged<TValue>? valueChanged,
          TValue? initial}) =>
      CustomBindableProperty(
          valueGetter: valueGetter,
          valueSetter: valueSetter,
          valueChanged: valueChanged,
          initial: initial);

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
