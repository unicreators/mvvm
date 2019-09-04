///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ValueNotifierAdapter
class ValueNotifierAdapter<TValue, TAdaptee extends Listenable>
    extends ValueNotifier<TValue> {
  final TAdaptee _adaptee;
  final TValue Function(TAdaptee) _getAdapteeValue;
  final void Function(TAdaptee, TValue) _setAdapteeValue;

  /// ValueNotifierAdapter
  ValueNotifierAdapter(
      this._adaptee, this._getAdapteeValue, this._setAdapteeValue,
      {TValue initial})
      : assert(_adaptee != null &&
            _getAdapteeValue != null &&
            _setAdapteeValue != null),
        super(null) {
    _adaptee.addListener(notifyListeners);
    // emit
    value = initial;
  }

  @protected
  @override
  TValue get value => _getAdapteeValue(_adaptee);
  @protected
  @override
  set value(TValue v) => value != v ? _setAdapteeValue(_adaptee, v) : null;

  @override
  void dispose() {
    _adaptee.removeListener(notifyListeners);
    super.dispose();
  }
}

/// ValueNotifierJoinAdapter
///
class ValueNotifierJoinAdapter extends ValueNotifier<Iterable<dynamic>> {
  final Iterable<ValueListenable> _valueListenables;

  /// ValueNotifierJoinAdapter
  ValueNotifierJoinAdapter(this._valueListenables)
      : assert(_valueListenables != null),
        super(null) {
    _valueChange();
    _valueListenables.forEach(((vn) => vn?.addListener(_valueChange)));
  }

  Iterable<dynamic> _getValues() =>
      _valueListenables.map<dynamic>((vn) => vn?.value);

  void _valueChange() => value = _getValues();

  @override
  void dispose() {
    _valueListenables.forEach(((vn) => vn.removeListener(_valueChange)));
    super.dispose();
  }
}
