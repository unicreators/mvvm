//////////////////////////////////////////
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';


/// AdaptiveViewModelProperty
///
///

class AdaptiveViewModelProperty<TValue, TFromValue,
        TAdaptee extends ValueNotifier<TFromValue>>
    extends ViewModelProperty<TValue> {
  AdaptiveViewModelProperty(
      Object key,
      TAdaptee adaptee,
      TValue Function(TAdaptee) toValue,
      void Function(TAdaptee, TValue) fromValue,
      {TValue initial})
      : super(
            key,
            ValueNotifierAdapter<TFromValue, TValue, TAdaptee>(
                adaptee, toValue, fromValue,
                initial: initial));
}


mixin AdaptiveViewModelMixin on ViewModelBase {
  AdaptiveViewModelProperty<TValue, TFromValue, TAdaptee> propertyAdaptive<
              TValue, TFromValue, TAdaptee extends ValueNotifier<TFromValue>>(
          Object key,
          TAdaptee adaptee,
          TValue Function(TAdaptee) toValue,
          void Function(TAdaptee, TValue) fromValue,
          {TValue initial}) =>
      registryProperty(AdaptiveViewModelProperty<TValue, TFromValue, TAdaptee>(
          key, adaptee, toValue, fromValue,
          initial: initial));
}
