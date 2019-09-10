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

  /// 任务集合
  ///
  /// 任务将在 `一切就绪` 后执行
  ///   `一切就绪` 是指当前实例已被关联到视图 [View],
  ///   并且视图 [View] 已经就绪
  ///
  List<VoidCallback> _tasks;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get model => _model;

  _ViewContextBase(this._model);

  ValueListenable<TValue> _propertyValueListenable<TValue>(
          Object propertyKey) =>
      model?.getValueListenable<TValue>(propertyKey, requiredProperty: true);
  Iterable<ValueListenable<TValue>> _propertiesValueListenables<TValue>(
          Iterable<Object> propertyKeys) =>
      model?.getValueListenables<TValue>(propertyKeys, requiredProperty: true);

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
  /// [nullBuilderToEmptyWidget] 当 [selector] 返回 `null` 时,
  /// 是否将其转换为一个返回空 [Widget] 的构造器, 默认为 `false`
  ///
  @protected
  Widget buildFromSelector<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> Function(TValue) selector,
          Widget child,
          bool nullBuilderToEmptyWidget = false}) =>
      build<TValue>(valueListenable,
          builder: _builderSelector(selector),
          child: child,
          nullBuilderToEmptyWidget: nullBuilderToEmptyWidget);

  ///
  /// 绑定到指定 [valueListenable]
  ///
  /// 当值发生变化时, 使用 [builder] 构建 [Widget]
  /// [child] 用于向构建方法中传入 [Widget]
  /// [nullBuilderToEmptyWidget] 当传入的 [builder] 为 `null` 时,
  /// 是否将其转换为一个返回空 [Widget] 的构造器, 默认为 `false`
  ///
  @protected
  Widget build<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue> builder,
          Widget child,
          bool nullBuilderToEmptyWidget = false}) =>
      ValueListenableBuilder<TValue>(
          valueListenable: valueListenable,
          builder: builder ??
              (nullBuilderToEmptyWidget ? _emptyWidgetBuilder() : null),
          child: child);

  /// 视图 [View] 将要初始化时执行此方法
  void _viewInit(BuildContext context) {
    viewInit(context);
  }

  /// 视图 [View] 已准备就绪后执行此方法
  void _viewReady(BuildContext context) {
    viewReady(context);
    _execTasks();
  }

  /// 关联的视图 [View] 初始化前调用此方法
  @protected
  void viewInit(BuildContext context) {}

  /// 关联的视图 [View] 准备就绪后调用此方法
  @protected
  void viewReady(BuildContext context) {}

  /// 添加任务 [VoidCallback]
  @protected
  void addTask(VoidCallback task) {
    if (task != null) (_tasks ??= [])..add(task);
  }

  /// 移除任务 [VoidCallback]
  @protected
  void removeTask(VoidCallback task) {
    if (containsTask(task)) _tasks.remove(task);
  }

  /// 是否存在指定任务 [VoidCallback]
  @protected
  bool containsTask(VoidCallback task) {
    return task == null || _tasks == null || !_tasks.contains(task)
        ? false
        : true;
  }

  /// 执行所有任务
  void _execTasks() {
    if (_tasks != null && _tasks.isNotEmpty) {
      for (var task in _tasks) {
        task();
      }
    }
  }

  /// dispose
  @protected
  @mustCallSuper
  void dispose() {
    _tasks = null;
  }
}
