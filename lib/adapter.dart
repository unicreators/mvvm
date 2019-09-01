///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

class ValueNotifierAdapter<TAdapteeValue, TValue,
        TAdaptee extends ValueNotifier<TAdapteeValue>>
    extends ValueNotifier<TValue> {
  final TAdaptee _adaptee;
  final TValue Function(TAdaptee) _getAdapteeValue;
  final void Function(TAdaptee, TValue) _setAdapteeValue;

  ValueNotifierAdapter(
      this._adaptee, this._getAdapteeValue, this._setAdapteeValue,
      {TValue initial})
      : assert(_adaptee != null &&
            _getAdapteeValue != null &&
            _setAdapteeValue != null),
        super(null) {
    this._adaptee.addListener(notifyListeners);
    // emit
    this.value = initial;
  }

  @protected
  TValue get value => _getAdapteeValue(_adaptee);
  @protected
  set value(TValue v) => value != v ? _setAdapteeValue(_adaptee, v) : null;

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
