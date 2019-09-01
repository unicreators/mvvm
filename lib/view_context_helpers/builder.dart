///
/// yichen <d.unicreators@gmail.com>
///

part of '../mvvm.dart';

/// ViewContextBuilderHelperMixin
///

mixin ViewContextBuilderHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder0(() => Text("hello!")));
  /// }
  /// ```
  ValueWidgetBuilder builder0(Widget Function() builder) =>
      (context, value, child) => builder();

  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder1<TValue>(
          Widget Function(TValue) builder) =>
      (context, value, child) => builder(value);

  ///
  /// ```dart
  /// @override
  /// Widget buildCore(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder2((value, child) => Column(children:[Text("$value"), child]),
  ///     child: Text("child"));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder2<TValue>(
          Widget Function(TValue, Widget) builder) =>
      (context, value, child) => builder(value, child);
}
