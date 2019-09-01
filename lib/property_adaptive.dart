///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// AdaptiveViewModelProperty
///
///

class AdaptiveViewModelProperty<TValue, TAdapteeValue,
        TAdaptee extends ValueNotifier<TAdapteeValue>>
    extends ViewModelProperty<TValue> {
  AdaptiveViewModelProperty(
      Object key,
      TAdaptee adaptee,
      TValue Function(TAdaptee) getAdapteeValue,
      void Function(TAdaptee, TValue) setAdapteeValue,
      {TValue initial})
      : super(
            key,
            ValueNotifierAdapter<TAdapteeValue, TValue, TAdaptee>(
                adaptee, getAdapteeValue, setAdapteeValue,
                initial: initial));
}

mixin AdaptiveViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个适配属性
  ///
  ///   `key` 指定属性键
  ///   `adaptee` 被适配者
  ///   `getAdapteeValue` 指定从被适配者获取值的方法
  ///   `setAdapteeValue` 指定设置被适配者值的方法
  ///
  AdaptiveViewModelProperty<TValue, TAdapteeValue, TAdaptee> propertyAdaptive<
              TValue,
              TAdapteeValue,
              TAdaptee extends ValueNotifier<TAdapteeValue>>(
          Object key,
          TAdaptee adaptee,
          TValue Function(TAdaptee) getAdapteeValue,
          void Function(TAdaptee, TValue) setAdapteeValue,
          {TValue initial}) =>
      registryProperty(
          AdaptiveViewModelProperty<TValue, TAdapteeValue, TAdaptee>(
              key, adaptee, getAdapteeValue, setAdapteeValue,
              initial: initial));
}
