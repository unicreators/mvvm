///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewContext
///
///

class ViewContext<TViewModel extends ViewModelBase>
    extends _ViewContextBase<TViewModel>
    with
        ViewContextWatchHelperMixin,
        ViewContextLogicalHelperMixin,
        ViewContextBuilderHelperMixin {
  ViewContext(TViewModel model) : super(model);
}

class _ViewContextBase<TViewModel extends ViewModelBase> {
  final TViewModel _model;
  TViewModel get model => _model;

  _ViewContextBase(this._model);

  ValueNotifier<TValue> _propertyValueListenable<TValue>(Object propertyKey) =>
      model.getPropertyValueListenable<TValue>(propertyKey);
  Iterable<ValueNotifier> _propertiesValueListenable(
          Iterable<Object> propertyKeys) =>
      model.getPropertiesValueListenable(propertyKeys);

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
