// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// View
///
abstract class View<TViewModel extends ViewModel> extends ViewWidget<TViewModel>
    with ValueWidgetBuilderMixin {
  /// View
  const View({Key? key}) : super(key: key);
}

///
/// ViewWidget
///
abstract class ViewWidget<TViewModel extends ViewModel> extends StatefulWidget {
  /// ViewWidget
  ///
  const ViewWidget({Key? key}) : super(key: key);

  @protected
  @override
  @nonVirtual
  State<ViewWidget> createState() =>
      _ViewWidgetState<TViewModel>(createViewModel());

  @override
  @nonVirtual
  StatefulElement createElement() => ViewElement<TViewModel>(this);

  ///
  @protected
  @factory
  TViewModel createViewModel();

  ///
  @protected
  Widget build(ViewBuildContext<TViewModel> context, TViewModel model);

  ///
  @protected
  @mustCallSuper
  void didChangeDependencies(TViewModel model) {}

  ///
  @protected
  @mustCallSuper
  void activate(TViewModel model) {}

  ///
  @protected
  @mustCallSuper
  void deactivate(TViewModel model) {}

  ///
  @protected
  @mustCallSuper
  void didUpdateWidget(
      covariant ViewWidget<TViewModel> oldWidget, TViewModel model) {}
}

/// ViewBuildContext
///
abstract class ViewBuildContext<TViewModel extends ViewModel>
    implements
        BuildContext,
        BindableObject,
        BindableObjectMixin,
        BindableObjectValueMixin,
        BindableObjectWidgetBuilderMixin {
  /// setState
  ///
  void setState(VoidCallback fn);

  /// ViewModel
  ///
  TViewModel get model;
}

/// ViewElement
///
class ViewElement<TViewModel extends ViewModel>
    extends ViewElementBase<TViewModel>
    with
        BindableObjectMixin,
        BindableObjectValueMixin,
        BindableObjectWidgetBuilderMixin,
        ValueWidgetBuilderMixin {
  /// ViewElement
  ViewElement(ViewWidget<TViewModel> widget) : super(widget);
}

/// ViewElementBase
///
abstract class ViewElementBase<TViewModel extends ViewModel>
    extends StatefulElement implements ViewBuildContext<TViewModel> {
  /// ViewElementBase
  ///
  ViewElementBase(ViewWidget widget) : super(widget);

  @protected
  @override
  _ViewWidgetState<TViewModel> get state =>
      super.state as _ViewWidgetState<TViewModel>;

  /// ViewModel
  ///
  @override
  TViewModel get model => state.model;

  /// setState
  ///
  @override
  void setState(VoidCallback fn) => state._setState(fn);

  ///
  /// 获取指定 [propertyKey] 对应的属性
  ///
  /// [propertyKey] 属性键
  ///
  /// [required] 指定 [propertyKey] 对应属性是否必须存在,
  ///   其值为 `true` 时, 如 [propertyKey] 对应属性不存在则抛出异常
  ///   默认值为 `false`
  ///
  @override
  BindableProperty<TValue>? getProperty<TValue>(Object propertyKey,
          {bool required = false}) =>
      model.getProperty<TValue>(propertyKey, required: required);

  ///
  /// 注册一个绑定属性
  ///
  /// [propertyKey] 指定属性键
  ///
  /// [property] 指定绑定属性
  ///
  @override
  BindableProperty<TValue> registerProperty<TValue>(
          Object propertyKey, BindableProperty<TValue> property) =>
      model.registerProperty(propertyKey, property);
}

class _ViewWidgetState<TViewModel extends ViewModel>
    extends State<ViewWidget<TViewModel>> {
  final TViewModel _model;
  _ViewWidgetState(TViewModel model) : _model = model;

  TViewModel get model => _model;

  @override
  Widget build(BuildContext context) =>
      widget.build(context as ViewBuildContext<TViewModel>, model);

  @override
  void deactivate() {
    widget.deactivate(model);
    super.deactivate();
  }

  @override
  void activate() {
    widget.activate(model);
    super.activate();
  }

  @override
  void didChangeDependencies() {
    widget.didChangeDependencies(model);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ViewWidget<TViewModel> oldWidget) {
    widget.didUpdateWidget(oldWidget, model);
    super.didUpdateWidget(oldWidget);
  }

  void _setState(VoidCallback fn) => setState(fn);

  @override
  void initState() {
    model.init();
    super.initState();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}

/// ValueListenableConditionalBuilder
///
class ValueListenableConditionalBuilder<T> extends ValueListenableBuilder<T> {
  ///
  final bool Function(T value) on;

  /// ValueListenableConditionalBuilder
  ///
  const ValueListenableConditionalBuilder({
    Key? key,
    required ValueListenable<T> valueListenable,
    required ValueWidgetBuilder<T> builder,
    required this.on,
    Widget? child,
  }) : super(
            key: key,
            valueListenable: valueListenable,
            builder: builder,
            child: child);

  @override
  State<StatefulWidget> createState() =>
      _ValueListenableConditionalBuilderState<T>();
}

class _ValueListenableConditionalBuilderState<T>
    extends State<ValueListenableConditionalBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ValueListenableConditionalBuilder<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    var value = widget.valueListenable.value;
    if (widget.on(value))
      setState(() {
        this.value = value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
