///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// AdaptiveViewModelProperty
///
class AdaptiveViewModelProperty<TValue, TAdaptee extends Listenable>
    extends BindableProperty<TValue> {
  /// AdaptiveViewModelProperty
  AdaptiveViewModelProperty(
      Object key,
      TAdaptee adaptee,
      TValue Function(TAdaptee) getAdapteeValue,
      void Function(TAdaptee, TValue) setAdapteeValue,
      {TValue initial})
      : super(
            key,
            ValueNotifierAdapter<TValue, TAdaptee>(
                adaptee, getAdapteeValue, setAdapteeValue,
                initial: initial));
}

mixin AdaptiveViewModelMixin on _ViewModelBase {
  ///
  /// 创建一个适配属性
  ///
  /// [propertyKey] 指定属性键
  /// [adaptee] 被适配者实例，适配者必须继承自 [Listenable]
  /// [getAdapteeValue] 指定从被适配者获取值的方法
  /// [setAdapteeValue] 指定设置被适配者值的方法
  ///
  BindableProperty<TValue>
      propertyAdaptive<TValue, TAdaptee extends Listenable>(
              Object propertyKey,
              TAdaptee adaptee,
              TValue Function(TAdaptee) getAdapteeValue,
              void Function(TAdaptee, TValue) setAdapteeValue,
              {TValue initial}) =>
          registryProperty(AdaptiveViewModelProperty<TValue, TAdaptee>(
              propertyKey, adaptee, getAdapteeValue, setAdapteeValue,
              initial: initial));
}
