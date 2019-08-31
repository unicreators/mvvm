//////////////////////////////////////////
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewContext
///

class ViewContext<TViewModel extends ViewModelBase> {
  final TViewModel _model;
  TViewModel get model => _model;

  ViewContext(this._model);

  ValueNotifier<TValue> _propertyValueListenable<TValue>(Object propertyKey) =>
      model.getPropertyValueListenable<TValue>(propertyKey);
  Iterable<ValueNotifier> _propertiesValueListenable(
          Iterable<Object> propertyKeys) =>
      model.getPropertiesValueListenable(propertyKeys);

  ///
  /// ////////////////////////////
  /// BINDING
  ///

  ///
  /// ```dart
  /// $.watch<String>($Model.prop1,
  ///   builder: $.builder1((value) => Text(value)))
  /// ```
  Widget watch<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      build(valueListenable, builder: builder, child: child);

  ///
  /// ```dart
  /// $.watchFor<String>("account",
  ///   builder: $.builder1((value) => Text(value)))
  /// ```
  Widget watchFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      watch(_propertyValueListenable<TValue>(propertyKey),
          builder: builder, child: child);

  ///
  /// ```dart
  /// $.watchAny(const [$Model.prop1, $Model.prop2],
  ///   builder: $.builder1((values) => Text(values[0])))
  /// ```
  Widget watchAny(Iterable<ValueListenable> valueListenable,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      build(ValueNotifierJoinAdapter(valueListenable),
          builder: builder, child: child);

  ///
  /// ```dart
  /// $.watchAnyFor(const ["account", "password"],
  ///   builder: $.builder1((values) => Text(values[0])))
  /// ```
  Widget watchAnyFor(Iterable<Object> prepertyKeys,
          {ValueWidgetBuilder<Iterable<dynamic>> builder, Widget child}) =>
      watchAny(_propertiesValueListenable(prepertyKeys),
          builder: builder, child: child);

  ///
  /// ////////////////////////////
  /// LOGICAL
  ///

  ///
  /// ```dart
  /// $.$cond<int>($Model.prop1,
  ///   $true: $.builder0(() => Text("tom!")),
  ///   $false: $.builder0(() => Text("jerry!")),
  ///   valueHandle: (value) => value == 1
  /// )
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
  /// $.$condFor<String>("account",
  ///   $true: $.builder0(() => Text("tom!")),
  ///   $false: $.builder0(() => Text("jerry!")),
  ///   valueHandle: (value) => value == "tom"
  /// )
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
  /// $.$if<int>($Model.prop1,
  ///   builder: $.builder0(() => Text("tom!")),
  ///   valueHandle: (value) => value == 1
  /// )
  /// ```
  Widget $if<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder,
          Widget child,
          bool Function(TValue) valueHandle}) =>
      $cond(valueListenable,
          $true: builder, child: child, valueHandle: valueHandle);

  ///
  /// ```dart
  /// $.$ifFor<String>("account",
  ///   builder: $.builder0(() => Text("tom!")),
  ///   valueHandle: (value) => value == "tom"
  /// )
  /// ```
  Widget $ifFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder,
          Widget child,
          bool Function(TValue) valueHandle}) =>
      $if(_propertyValueListenable<TValue>(propertyKey),
          builder: builder, child: child, valueHandle: valueHandle);

  ///
  /// ```dart
  /// $.$switch<String, int>($Model.prop1,
  ///   options: const { "1.": $.builder1((value) => Text("$value")), "2.": $.builder0(() => Text("2")) },
  ///   default: $.builder0(() => Text("default")),
  ///   valueToKey: (value) => "${value}."
  /// )
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
  /// $.$switchFor<String, int>("account",
  ///   options: const { "tom": $.builder1((value) => Text("${value}! cat")), "jerry": $.builder0(() => Text("mouse")) },
  ///   default: $.builder0(() => Text("default"))
  /// )
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

  ///
  /// ////////////////////////////
  /// BUILDER
  ///

  ///
  /// ```dart
  /// $.watch<String>($Model.prop1,
  ///   builder: $.builder0(() => Text("hello!")))
  /// ```
  ValueWidgetBuilder builder0(Widget Function() builder) =>
      (context, value, child) => builder();

  ///
  /// ```dart
  /// $.watch<String>($Model.prop1,
  ///   builder: $.builder1((value) => Text(value)))
  /// ```
  ValueWidgetBuilder<TValue> builder1<TValue>(
          Widget Function(TValue) builder) =>
      (context, value, child) => builder(value);

  ///
  /// ```dart
  /// $.watch<String>($Model.prop1,
  ///   builder: $.builder2((value, child) => Column(children:[Text("$value"), child]),
  ///   child: Text("child")
  /// )
  /// ```
  ValueWidgetBuilder<TValue> builder2<TValue>(
          Widget Function(TValue, Widget) builder) =>
      (context, value, child) => builder(value, child);

  /// more $.*
  /// ////////////////////////////
  ///

  ValueWidgetBuilder _emptyWidgetBuilder() => (_, __, ___) => SizedBox.shrink();

  dynamic _ensureValue<TValue>(
          TValue fromValue, dynamic Function(TValue) convert) =>
      convert == null ? fromValue : convert(fromValue);

  ValueWidgetBuilder<TValue> _builderSelector<TValue>(
          ValueWidgetBuilder<TValue> Function(TValue) selector) =>
      (context, value, child) =>
          (selector(value) ?? _emptyWidgetBuilder())(context, value, child);

  @protected
  Widget buildFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      build<TValue>(_propertyValueListenable(propertyKey),
          builder: builder, child: child);

  @protected
  Widget build<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      ValueListenableBuilder<TValue>(
          valueListenable: valueListenable, builder: builder, child: child);
}
