///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextWatchHelperMixin
///

mixin ViewContextWatchHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watch<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      build(valueListenable, builder: builder, child: child);

  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchFor<String>("account",
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  Widget watchFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      watch(_propertyValueListenable<TValue>(propertyKey),
          builder: builder, child: child);

  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchAny(const [$Model.prop1, $Model.prop2],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAny(Iterable<ValueListenable> valueListenable,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      build(ValueNotifierJoinAdapter(valueListenable),
          builder: builder, child: child);

  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watchAnyFor(const ["account", "password"],
  ///     builder: $.builder1((values) => Text(values[0])));
  /// }
  /// ```
  Widget watchAnyFor(Iterable<Object> prepertyKeys,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      watchAny(_propertiesValueListenable(prepertyKeys),
          builder: builder, child: child);
}
