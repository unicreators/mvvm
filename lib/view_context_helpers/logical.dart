///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextLogicalHelperMixin
///

mixin ViewContextLogicalHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// 绑定到指定 `valueListenable`
  /// 
  ///   当值发生变化时, 值判定结果为 `true` 时使用 `$true` 构建 [Widget] 
  ///   否则使用 `$false` 构建 [Widget] 
  /// 
  ///   当值类型不为 `bool` 时, 非 `null` 即被叛定为 `true`, 否则为 `false`
  ///   可通过指定 `valueHandle` 对值进行处理
  ///   `child` 用于向构建方法中传入 [Widget]
  /// 
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$cond<int>($Model.prop1,
  ///     $true: $.builder0(() => Text("tom!")),
  ///     $false: $.builder0(() => Text("jerry!")),
  ///     valueHandle: (value) => value == 1);
  /// }
  /// ```
  Widget $cond<TValue>(ValueListenable<TValue> valueListenable,
      {ValueWidgetBuilder<TValue> $true,
      ValueWidgetBuilder<TValue> $false,
      Widget child,
      bool Function(TValue) valueHandle}) {
    assert($true != null || $false != null);

    ///   type    bool_value
    /// --------------------------------
    ///   bool    (raw_value)
    ///   other   (raw_value) != null
    ///
    return build<TValue>(valueListenable, builder: _builderSelector((value) {
      var result = _ensureValue<TValue>(value, valueHandle);
      return ((result is bool) ? result : (result != null))
          ? $true?.call
          : $false?.call;
    }), child: child);
  }

  /// 
  /// 绑定到指定 `propertyKey` 对应的属性
  /// 
  ///   当属性值发生变化时, 值判定结果为 `true` 时使用 `$true` 构建 [Widget] 
  ///   否则使用 `$false` 构建 [Widget] 
  ///
  ///   当值类型不为 `bool` 时, 非 `null` 即被叛定为 `true`, 否则为 `false`
  ///   可通过指定 `valueHandle` 对值进行处理
  ///   `child` 用于向构建方法中传入 [Widget]
  /// 
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$condFor<String>("account",
  ///     $true: $.builder0(() => Text("tom!")),
  ///     $false: $.builder0(() => Text("jerry!")),
  ///     valueHandle: (value) => value == "tom");
  /// }
  /// ```
  Widget $condFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> $true,
          ValueWidgetBuilder<TValue> $false,
          Widget child,
          bool Function(TValue) valueHandle}) =>
      $cond<TValue>(_propertyValueListenable(propertyKey),
          $true: $true, $false: $false, child: child, valueHandle: valueHandle);

  ///
  /// 绑定到指定 `valueListenable`
  /// 
  ///   当值发生变化时, 值判定结果为 `true` 时使用 `builder` 构建 [Widget]
  ///   否则不构建 [Widget] 
  /// 
  ///   当值类型不为 `bool` 时, 非 `null` 即被叛定为 `true`, 否则为 `false`
  ///   可通过指定 `valueHandle` 对值进行处理
  ///   `child` 用于向构建方法中传入 [Widget]
  /// 
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$if<int>($Model.prop1,
  ///     builder: $.builder0(() => Text("tom!")),
  ///     valueHandle: (value) => value == 1);
  /// }
  /// ```
  Widget $if<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder,
          Widget child,
          bool Function(TValue) valueHandle}) =>
      $cond(valueListenable,
          $true: builder, child: child, valueHandle: valueHandle);

  ///
  /// 绑定到指定 `propertyKey`
  /// 
  ///   当值发生变化时, 值判定结果为 `true` 时使用 `builder` 构建 [Widget]
  ///   否则不构建 [Widget] 
  ///   
  ///   当值类型不为 `bool` 时, 非 `null` 即被叛定为 `true`, 否则为 `false`
  ///   可通过指定 `valueHandle` 对值进行处理
  ///   `child` 用于向构建方法中传入 [Widget]
  /// 
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$ifFor<String>("account",
  ///     builder: $.builder0(() => Text("tom!")),
  ///     valueHandle: (value) => value == "tom");
  /// }
  /// ```
  Widget $ifFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder,
          Widget child,
          bool Function(TValue) valueHandle}) =>
      $if(_propertyValueListenable<TValue>(propertyKey),
          builder: builder, child: child, valueHandle: valueHandle);

  ///
  /// 绑定到指定 `valueListenable`
  /// 
  ///   当值发生变化时, 其值做为 `key` 到 `options` 中查找对应构建 [Widget]
  ///   如未找到对应 `key` 则使用 `default` 构建
  ///   如 `default` 为 `null` 则不构建 [Widget]
  /// 
  ///   如值与 `options` 中 `key` 类型不同可通过指定 `valueToKey` 进行转换
  ///   `child` 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$switch<String, int>($Model.prop1,
  ///     options: const { "1.": $.builder1((value) => Text("$value")), "2.": $.builder0(() => Text("2")) },
  ///     default: $.builder0(() => Text("default")),
  ///     valueToKey: (value) => "${value}.");
  /// }
  /// ```
  Widget $switch<TKey, TValue>(ValueListenable<TValue> valueListenable,
          {Map<TKey, ValueWidgetBuilder<TValue>> options,
          ValueWidgetBuilder<TValue> defalut,
          Widget child,
          TKey Function(TValue) valueToKey}) =>
      (options == null || options.length == 0)
          ? build<TValue>(valueListenable, builder: defalut, child: child)
          : build(valueListenable,
              builder: _builderSelector((value) =>
                  options[_ensureValue<TValue>(value, valueToKey)] ??
                  defalut?.call),
              child: child);

  ///
  ///
  /// 绑定到指定 `propertyKey`
  /// 
  ///   当属性值发生变化时, 其值做为 `key` 到 `options` 中查找对应构建 [Widget]
  ///   如未找到对应 `key` 则使用 `default` 构建
  ///   如 `default` 为 `null` 则不构建 [Widget]
  /// 
  ///   如值与 `options` 中 `key` 类型不同可通过指定 `valueToKey` 进行转换
  ///   `child` 用于向构建方法中传入 [Widget]
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.$switchFor<String, int>("account",
  ///     options: const { "tom": $.builder1((value) => Text("${value}! cat")), "jerry": $.builder0(() => Text("mouse")) },
  ///     default: $.builder0(() => Text("default"));
  /// }
  /// ```
  Widget $switchFor<TKey, TValue>(Object propertyKey,
          {Map<TKey, ValueWidgetBuilder<TValue>> options,
          ValueWidgetBuilder<TValue> defalut,
          Widget child,
          TKey Function(TValue) valueToKey}) =>
      $switch<TKey, TValue>(_propertyValueListenable(propertyKey),
          options: options,
          defalut: defalut,
          child: child,
          valueToKey: valueToKey);
}
