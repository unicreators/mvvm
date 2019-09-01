///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

class ValueNotifierAdapter<TFromValue, TToValue,
        TAdaptee extends ValueNotifier<TFromValue>>
    extends ValueNotifier<TToValue> {
  final TAdaptee _adaptee;
  final TToValue Function(TAdaptee) _toValue;
  final void Function(TAdaptee, TToValue) _fromValue;

  ValueNotifierAdapter(this._adaptee, this._toValue, this._fromValue,
      {TToValue initial})
      : assert(_adaptee != null && _toValue != null && _fromValue != null),
        super(null) {
    this._adaptee.addListener(notifyListeners);
    // emit
    this.value = initial;
  }

  @protected
  TToValue get value => _toValue(_adaptee);
  @protected
  set value(TToValue v) => value != v ? _fromValue(_adaptee, v) : null;

  @override
  void dispose() {
    this._adaptee.removeListener(notifyListeners);
    super.dispose();
  }
}

class ValueNotifierJoinAdapter<TValue> extends ValueNotifier<List<TValue>> {
  final Iterable<ValueNotifier<TValue>> _valueNotifiers;

  ValueNotifierJoinAdapter(this._valueNotifiers)
      : assert(_valueNotifiers != null),
        super(null) {
    _valueNotifiers.forEach((vn) => vn.addListener(_valueChange));
  }

  _getValues() => _valueNotifiers.map((vn) => vn.value);

  void _valueChange() {
    value = _getValues();
    notifyListeners();
  }

  @override
  void dispose() {
    _valueNotifiers.forEach((vn) => vn.removeListener(_valueChange));
    super.dispose();
  }
}
