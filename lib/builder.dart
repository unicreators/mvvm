// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ValueWidgetBuilderMixin
///
mixin ValueWidgetBuilderMixin {
  static final ValueWidgetBuilder _ =
      (_, dynamic __, ___) => const SizedBox.shrink();

  ///
  /// 绑定到指定 [ValueListenable] 当值发生变化时, 使用 [selector] 选择器中提供的构建方法构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///
  Widget $select<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue>? Function(TValue) selector,
          Widget? child}) =>
      $build<TValue>(valueListenable,
          builder: (context, value, child) =>
              (selector(value) ?? _)(context, value, child));

  ///
  /// 构建 [Widget]
  ///
  /// 当指定 [ValueListenable] 值发生变更时, 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  @protected
  Widget $build<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue> builder, Widget? child}) =>
      ValueListenableBuilder<TValue>(
          valueListenable: valueListenable, builder: builder, child: child);

  ///
  /// 构建 [Widget]
  ///
  /// 当指定 [ValueListenable] 值发生变更时, 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  @protected
  Widget $buildOn<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue> builder,
          required bool Function(TValue value) on,
          Widget? child}) =>
      ValueListenableConditionalBuilder(
          valueListenable: valueListenable,
          builder: builder,
          on: on,
          child: child);

  ///
  /// 构建多个 [Widget]
  ///
  /// [valueListeneables] 指定 [ValueListenable] 集合
  /// 当 [ValueListenable] 值发生变更时, 使用 [builder] 构建 [Widget]
  ///
  /// [childBuilder] 用于构建向 [builder] 中传入的 [Widget]
  ///
  @protected
  List<Widget> $multi<TValue>(
          Iterable<ValueListenable<TValue>> valueListeneables,
          {required Widget Function(
                  BuildContext context,
                  TValue value,
                  Widget? child,
                  int index,
                  ValueListenable<TValue> valueListeneable)
              builder,
          Widget? Function(int index)? childBuilder}) =>
      List.generate(valueListeneables.length, (index) {
        var element = valueListeneables.elementAt(index);
        return $build<TValue>(element,
            builder: (context, value, child) =>
                builder(context, value, child, index, element),
            child: childBuilder?.call(index));
      });

  ///
  /// 绑定到指定 [ValueListenable], 当 [valueListenable] 值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// final bp$ = BindableProperty.$value(initial: "hello.");
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $watch<String>(bp$,
  ///     builder: (context, value, child) => Text(value));
  /// }
  /// ```
  Widget $watch<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue> builder, Widget? child}) =>
      $build(valueListenable, builder: builder, child: child);

  ///
  /// 绑定到指定 [ValueListenable] 集合, 当 [valueListenables] 中
  /// 任一 [ValueListenable] 值发生变化时, 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// final bp1$ = BindableProperty.$value(initial: "hello1.");
  /// final bp2$ = BindableProperty.$value(initial: "hello2.");
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $any<String>(const [bp1$, b2$],
  ///     builder: (context, values, child) => Text(values[0]));
  /// }
  /// ```
  Widget $any<TValue>(Iterable<ValueListenable<TValue>> valueListenables,
          {required ValueWidgetBuilder<Iterable<TValue>> builder,
          Widget? child}) =>
      $build(MergeBindableProperty<TValue>(valueListenables),
          builder: builder, child: child);

  ///
  /// 绑定到指定 [Map] 键集合, 当 [map] 中任一 [ValueListenable] 值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Map<Object, TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// final bp1$ = BindableProperty.$value(initial: "hello1.");
  /// final bp2$ = BindableProperty.$value(initial: "hello2.");
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $anyMap<String>(const {
  ///     #account: bp1$, #password: bp2$ },
  ///     builder: (context, values, child) =>
  ///         Text("${values[#account]} - ${values[#password]}"));
  /// }
  /// ```
  Widget $anyMap<TValue>(Map<Object, ValueListenable<TValue>> map,
          {required ValueWidgetBuilder<Map<Object, TValue>> builder,
          Widget? child}) =>
      $build(MergeMapBindableProperty<TValue>(map),
          builder: builder, child: child);

  ///
  /// 绑定到指定 [ValueListenable], 当 [valueListenable] 值发生变化时,
  /// 若值判定结果为 `true` 则使用 [$true] 构建 [Widget], 否则使用 `$false` 构建 [Widget]
  ///
  ///   当值类型不为 [bool] 时, 非 `null` 即被判定为 `true`, 否则为 `false`
  ///   可通过指定 [valueHandle] 对值进行处理
  ///   [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// final bp1$ = BindableProperty.$value(initial: 1);
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $cond<int>(bp1$,
  ///     $true: (context, value, child) => Text("tom!"),
  ///     $false: (context, value, child) => Text("jerry!"),
  ///     valueHandle: (value) => value == 1);
  /// }
  /// ```
  Widget $cond<TValue>(ValueListenable<TValue> valueListenable,
      {ValueWidgetBuilder<TValue>? $true,
      ValueWidgetBuilder<TValue>? $false,
      Widget? child,
      bool Function(TValue)? valueHandle}) {
    assert($true != null || $false != null);
    return $select<TValue>(valueListenable,
        selector: (value) => (valueHandle != null
                ? valueHandle(value)
                : (value is bool ? value : true))
            ? $true?.call
            : $false?.call,
        child: child);
  }

  ///
  /// 绑定到指定 [ValueListenable], 当 [valueListenable] 值发生变化时,
  /// 若值判定结果为 `true` 则使用 [builder] 构建 [Widget], 否则不构建 [Widget]
  ///
  ///   当值类型不为 [bool] 时, 非 `null` 即被判定为 `true`, 否则为 `false`
  ///   可通过指定 [valueHandle] 对值进行处理
  ///   [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// final bp1$ = BindableProperty.$value(initial: 1);
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $if<int>(bp1$,
  ///     builder: (context, value, child) => Text("tom!"),
  ///     valueHandle: (value) => value == 1);
  /// }
  /// ```
  Widget $if<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue> builder,
          Widget? child,
          bool Function(TValue)? valueHandle}) =>
      $cond(valueListenable,
          $true: builder, child: child, valueHandle: valueHandle);

  ///
  /// 绑定到指定 [ValueListenable], 当 [valueListenable] 值发生变化时,
  /// 其值做为 `key` 到 [options] 中查找对应 [Widget] 构建方法,
  /// 若未找到则使用 [default] 构建, 如 [default] 为 `null` 则不构建 [Widget]
  ///
  /// 如值与 [options] 中 `key` 类型不同, 可通过指定 [valueToKey] 进行转换
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// final bp1$ = BindableProperty.$value(initial: 1);
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $switch<String, int>(bp1$,
  ///     options: const {
  ///                "1.": (context, value, child) => Text("$value"),
  ///                "2.": (context, value, child) => Text("2") },
  ///     default: (context, value, child) => Text("default"),
  ///     valueToKey: (value) => "${value}.");
  /// }
  /// ```
  Widget $switch<TKey, TValue>(ValueListenable<TValue> valueListenable,
          {Map<TKey, ValueWidgetBuilder<TValue>>? options,
          ValueWidgetBuilder<TValue>? defalut,
          Widget? child,
          TKey Function(TValue)? valueToKey}) =>
      (options == null || options.isEmpty)
          ? $build(valueListenable, builder: defalut ?? _, child: child)
          : $select(valueListenable,
              selector: (TValue value) =>
                  options[valueToKey != null ? valueToKey(value) : value] ??
                  defalut?.call,
              child: child);
}

/// BindableObjectWidgetBuilderMixin
///
mixin BindableObjectWidgetBuilderMixin
    on BindableObjectMixin, ValueWidgetBuilderMixin {
  ///
  /// 绑定到指定属性, 当 [propertyKey] 对应属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $watchFor<String>(#account,
  ///     builder: (context, value, child) => Text(value));
  /// }
  /// ```
  Widget $watchFor<TValue>(Object propertyKey,
          {required ValueWidgetBuilder<TValue> builder,
          Widget? child,
          TValue? initialValue}) =>
      $watch(ensureProperty<TValue>(propertyKey, initialValue: initialValue),
          builder: builder, child: child);

  ///
  /// 绑定到指定属性集合, 当任一 [prepertyKeys] 对应属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Iterable<TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $anyFor(const [#account, #password],
  ///     builder: (context, values, child) => Text(values[0])));
  /// }
  /// ```
  Widget $anyFor<TValue>(Iterable<Object> prepertyKeys,
          {required ValueWidgetBuilder<Iterable<TValue>> builder,
          Widget? child}) =>
      $any(requireProperties<TValue>(prepertyKeys),
          builder: builder, child: child);

  ///
  /// 绑定到指定属性集合, 当任一 [prepertyKeyMap] 中对应的绑定属性值发生变化时,
  /// 使用 [builder] 构建 [Widget]
  ///
  /// [builder] 方法中 `TValue` 将被包装为 [Map<Object, TValue>]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $anyMapFor<String>(const {
  ///     #account: MapBehavior(toKey: #account1), #password: null },
  ///     builder: (context, values, child) =>
  ///         Text("${values[#account1]} - ${values[#password]}"));
  /// }
  /// ```
  Widget $anyMapFor<TValue>(Map<Object, MapBehavior<TValue>?> prepertyKeyMap,
          {required ValueWidgetBuilder<Map<Object, TValue>> builder,
          Widget? child}) =>
      $build(
          MergeMapBindableProperty<TValue>(prepertyKeyMap.map((key, value) =>
              MapEntry(value?.toKey ?? key,
                  ensureProperty(key, initialValue: value?.initialValue)))),
          builder: builder,
          child: child);

  ///
  /// 绑定到指定属性, 当 [propertyKey] 对应属性值发生变化时,
  /// 若值判定结果为 `true` 则使用 [$true] 构建 [Widget], 否则使用 `$false` 构建 [Widget]
  ///
  ///   当值类型不为 [bool] 时, 非 `null` 即被判定为 `true`, 否则为 `false`
  ///   可通过指定 [valueHandle] 对值进行处理
  ///   [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $condFor<String>(#account,
  ///     $true: (context, value, child) => Text("tom!"),
  ///     $false: (context, value, child) => Text("jerry!"),
  ///     valueHandle: (value) => value == "tom");
  /// }
  /// ```
  Widget $condFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue>? $true,
          ValueWidgetBuilder<TValue>? $false,
          Widget? child,
          bool Function(TValue)? valueHandle,
          TValue? initialValue}) =>
      $cond<TValue>(
          ensureProperty<TValue>(propertyKey, initialValue: initialValue),
          $true: $true,
          $false: $false,
          child: child,
          valueHandle: valueHandle);

  ///
  /// 绑定到指定属性, 当 [propertyKey] 对应属性值发生变化时,
  /// 若值判定结果为 `true` 则使用 [builder] 构建 [Widget], 否则不构建 [Widget]
  ///
  ///   当值类型不为 [bool] 时, 非 `null` 即被判定为 `true`, 否则为 `false`
  ///   可通过指定 [valueHandle] 对值进行处理
  ///   [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $ifFor<String>(#account,
  ///     builder: (context, value, child) => Text("tom!"),
  ///     valueHandle: (value) => value == "tom");
  /// }
  /// ```
  Widget $ifFor<TValue>(Object propertyKey,
          {required ValueWidgetBuilder<TValue> builder,
          Widget? child,
          bool Function(TValue)? valueHandle,
          TValue? initialValue}) =>
      $if(ensureProperty<TValue>(propertyKey, initialValue: initialValue),
          builder: builder, child: child, valueHandle: valueHandle);

  ///
  /// 绑定到指定属性, 当 [propertyKey] 对应属性值发生变化时,
  /// 其值做为 `key` 到 [options] 中查找对应 [Widget] 构建方法,
  /// 若未找到则使用 [default] 构建, 如 [default] 为 `null` 则不构建 [Widget]
  ///
  /// 如值与 [options] 中 `key` 类型不同, 可通过指定 [valueToKey] 进行转换
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $switchFor<String, int>(#account,
  ///     options: { "tom": (context, value, child) => Text("${value}! cat"),
  ///                "jerry": (context, value, child) => Text("mouse") },
  ///     default: (context, value, child) => Text("default"));
  /// }
  /// ```
  Widget $switchFor<TKey, TValue>(Object propertyKey,
          {Map<TKey, ValueWidgetBuilder<TValue>>? options,
          ValueWidgetBuilder<TValue>? defalut,
          Widget? child,
          TKey Function(TValue)? valueToKey,
          TValue? initialValue}) =>
      $switch<TKey, TValue>(
          ensureProperty<TValue>(propertyKey, initialValue: initialValue),
          options: options,
          defalut: defalut,
          child: child,
          valueToKey: valueToKey);
}

///
/// 映射行为
///
class MapBehavior<TValue> {
  ///
  /// 指定结果键
  ///
  /// - 结果值将被映射到指定键
  ///
  final Object? toKey;

  ///
  /// 指定初始值
  ///
  /// - 当使用属性键未能找到已注册的绑定属性时，则使用此值创建一个
  ///
  final TValue? initialValue;

  ///
  /// 创建映射行为
  ///
  MapBehavior({this.toKey, this.initialValue});

  ///
  /// 创建映射行为
  ///
  factory MapBehavior.toKey({required Object toKey}) =>
      MapBehavior(toKey: toKey);
}
