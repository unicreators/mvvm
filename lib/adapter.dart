// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// CustomValueNotifier
class CustomValueNotifier<TValue> extends ValueNotifier<TValue> {
  final ValueGetter<TValue> _valueGetter;
  final ValueSetter<TValue> _valueSetter;

  /// CustomValueNotifier
  CustomValueNotifier(
      ValueGetter<TValue> valueGetter, ValueSetter<TValue> valueSetter,
      {TValue initial})
      : assert(valueGetter != null && valueSetter != null),
        _valueGetter = valueGetter,
        _valueSetter = valueSetter,
        super(initial);

  @protected
  @override
  TValue get value => _valueGetter();

  @protected
  @override
  set value(TValue v) {
    if (value != v) _valueSetter(v);
    // force notify
    notifyListeners();
  }
}

/// ValueNotifierAdapter
class ValueNotifierAdapter<TValue, TAdaptee extends Listenable>
    extends CustomValueNotifier<TValue> {
  final TAdaptee _adaptee;

  /// ValueNotifierAdapter
  ValueNotifierAdapter(
      TAdaptee adaptee,
      TValue Function(TAdaptee) adapteeValueGetter,
      void Function(TAdaptee, TValue) adapteeValueSetter,
      {TValue initial})
      : assert(adaptee != null &&
            adapteeValueGetter != null &&
            adapteeValueSetter != null),
        _adaptee = adaptee,
        super(() => adapteeValueGetter(adaptee),
            (v) => adapteeValueSetter(adaptee, v),
            initial: initial) {
    _adaptee.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _adaptee.removeListener(notifyListeners);
    super.dispose();
  }
}

/// ValueNotifierJoinAdapter
///
class ValueNotifierJoinAdapter<TValue> extends ValueNotifier<Iterable<TValue>> {
  final Iterable<ValueListenable> _valueListenables;

  /// ValueNotifierJoinAdapter
  ValueNotifierJoinAdapter(this._valueListenables)
      : assert(_valueListenables != null),
        super(null) {
    _valueChange();
    _valueListenables.forEach(((vn) => vn?.addListener(_valueChange)));
  }

  Iterable<TValue> _getValues() =>
      _valueListenables.map<TValue>((vn) => vn?.value as TValue);

  void _valueChange() => value = _getValues();

  @override
  void dispose() {
    _valueListenables.forEach(((vn) => vn.removeListener(_valueChange)));
    super.dispose();
  }
}
