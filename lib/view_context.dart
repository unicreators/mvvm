// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ViewContext
///
class ViewContext<TViewModel extends ViewModelBase>
    extends _ViewContextBase<TViewModel>
    with
        ViewContextWatchHelperMixin,
        ViewContextLogicalHelperMixin,
        ViewContextBuilderHelperMixin,
        ViewContextAdaptorHelperMixin {
  /// ViewContext
  ViewContext(TViewModel model) : super(model);
}

class _ViewContextBase<TViewModel extends ViewModelBase> {
  final TViewModel _model;
  final bool nullBuilderToEmptyWidget;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get model => _model;

  _ViewContextBase(this._model, {this.nullBuilderToEmptyWidget = true});

  ValueListenable<TValue> _propertyValueListenable<TValue>(
          Object propertyKey) =>
      model?.getValueListenable<TValue>(propertyKey);
  Iterable<ValueListenable<TValue>> _propertiesValueListenables<TValue>(
          Iterable<Object> propertyKeys) =>
      model?.getValueListenables<TValue>(propertyKeys);

  // 获取 [propertyKey] 对应属性的值
  TValue getValueFor<TValue>(Object propertyKey) =>
      model.getValue<TValue>(propertyKey);

  /// 设置 [propertyKey] 对应属性的值,
  /// [value] 指定属性值
  /// [valueCheck] 指定是否对值进行检查,
  ///   当其值为 `true` 时, 多次设置相同值将不会触发值变更通知
  ///   默认为 `false`
  void setValueFor<TValue>(Object propertyKey, TValue value,
          {bool valueCheck = false}) =>
      model.setValue<TValue>(propertyKey, value, valueCheck: valueCheck);

  /// 注册绑定属性
  ///
  /// [propertyKey] 指定属性键
  /// [valueNotifier] 指定值变更通知器
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  @protected
  void registryProperty<TValue>(
      Object propertyKey, ValueNotifier<TValue> valueNotifier,
      {PropertyValueChanged<TValue> valueChanged}) {
    model.registryProperty(BindableProperty.create<TValue>(
        propertyKey, valueNotifier,
        valueChanged: valueChanged));
  }

  ///
  /// 生成一个空 [Widget] 构建方法
  ValueWidgetBuilder _emptyWidgetBuilder() =>
      (_, dynamic __, ___) => const SizedBox.shrink();

  dynamic _ensureValue<TValue>(
          TValue fromValue, dynamic Function(TValue) convert) =>
      convert == null ? fromValue : convert(fromValue);

  ValueWidgetBuilder<TValue> _builderSelector<TValue>(
          ValueWidgetBuilder<TValue> Function(TValue) selector) =>
      (context, value, child) =>
          (selector(value) ?? _emptyWidgetBuilder())(context, value, child);

  ///
  /// 绑定到指定 [propertyKey]
  ///
  /// 当值发生变化时, 使用 [builder] 构建 [Widget]
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  @protected
  Widget buildFor<TValue>(Object propertyKey,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      build<TValue>(_propertyValueListenable(propertyKey),
          builder: builder, child: child);

  ///
  /// 绑定到指定 [valueListenable]
  ///
  /// 当值发生变化时, 使用 [selector] 选择器中提供的构建方法构建 [Widget]
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  @protected
  Widget buildFromSelector<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> Function(TValue) selector,
          Widget child}) =>
      build<TValue>(valueListenable,
          builder: _builderSelector(selector), child: child);

  ///
  /// 绑定到指定 [valueListenable]
  ///
  /// 当值发生变化时, 使用 [builder] 构建 [Widget]
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  @protected
  Widget build<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder, Widget child}) =>
      ValueListenableBuilder<TValue>(
          valueListenable: valueListenable,
          builder: builder ??
              (nullBuilderToEmptyWidget ? _emptyWidgetBuilder() : null),
          child: child);
}
