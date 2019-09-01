///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextLogicalHelperMixin
///

mixin ViewContextLogicalHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
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
