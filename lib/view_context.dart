// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
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

class _ViewContextBase<TViewModel extends ViewModelBase>
    implements ViewListener {
  static final ValueWidgetBuilder _emptyWidgetBuilder =
      (_, dynamic __, ___) => const SizedBox.shrink();

  final TViewModel _model;

  /// 任务集合
  ///
  /// 任务将在 `一切就绪` 后执行
  ///   `一切就绪` 是指当前实例已被关联到视图 [View],
  ///   并且视图 [View] 已经就绪
  ///
  List<VoidCallback>? _tasks;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get model => _model;

  _ViewContextBase(this._model);

  @protected
  BindableProperty<TValue>? getProperty<TValue>(Object propertyKey,
          {bool? required}) =>
      model.getProperty<TValue>(propertyKey, required: required ?? false);

  @protected
  BindableProperty<TValue>?
      getPropertyOf<TValue, TProperty extends BindableProperty<TValue>>(
              Object propertyKey,
              {bool? required}) =>
          model.getPropertyOf<TValue, TProperty>(propertyKey,
              required: required ?? false);

  @protected
  BindableProperty<TValue> requireProperty<TValue>(Object propertyKey) =>
      getProperty<TValue>(propertyKey, required: true)!;

  @protected
  BindableProperty<TValue> ensureProperty<TValue>(Object propertyKey,
      {TValue? initialValue}) {
    var property = getProperty<TValue>(propertyKey);
    if (property == null) {
      if (initialValue != null) {
        property = PreBindableProperty(initialValue: initialValue);
        registryProperty(propertyKey, property);
      } else
        model.throwNotfoundPropertyError(propertyKey);
    }
    return property!;
  }

  @protected
  Iterable<BindableProperty<TValue>?> getProperties<TValue>(
          Iterable<Object> propertyKeys,
          {bool? required}) =>
      model.getProperties<TValue>(propertyKeys, required: required ?? false);

  @protected
  Iterable<BindableProperty<TValue>> requireProperties<TValue>(
          Iterable<Object> propertyKeys) =>
      getProperties<TValue>(propertyKeys, required: true).cast();

  /// 注册绑定属性
  ///
  /// [property] 指定属性
  ///
  @protected
  void registryProperty<TValue>(
          Object key, BindableProperty<TValue> property) =>
      model.registryProperty(key, property);

  ValueWidgetBuilder<TValue> _builderSelector<TValue>(
          ValueWidgetBuilder<TValue>? Function(TValue) selector) =>
      (context, value, child) =>
          (selector(value) ?? _emptyWidgetBuilder)(context, value, child);

  ///
  /// 绑定到指定 [valueListenable] 当值发生变化时, 使用 [selector] 选择器中提供的构建方法构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///
  @protected
  Widget buildFromSelector<TValue>(ValueListenable<TValue> valueListenable,
          {required ValueWidgetBuilder<TValue>? Function(TValue) selector,
          Widget? child}) =>
      build<TValue>(valueListenable,
          builder: _builderSelector(selector), child: child);

  ///
  /// 绑定到指定 [valueListenable] 当值发生变化时, 使用 [builder] 构建 [Widget]
  ///
  /// [child] 用于向构建方法中传入 [Widget]
  ///
  ///
  @protected
  Widget build<TValue>(ValueListenable<TValue> valueListenable,
          {ValueWidgetBuilder<TValue>? builder, Widget? child}) =>
      ValueListenableBuilder<TValue>(
          valueListenable: valueListenable,
          builder: builder ?? _emptyWidgetBuilder,
          child: child);

  /// 视图 [View] 将要初始化时执行此方法
  void _viewInit(BuildContext context) {
    viewInit(context);
    _model.viewInit(context);
  }

  /// 视图 [View] 已准备就绪后执行此方法
  void _viewReady(BuildContext context) {
    viewReady(context);
    _execTasks();
    _model.viewReady(context);
  }

  /// 添加任务 [VoidCallback]
  @protected
  void addTask(VoidCallback task) {
    (_tasks ??= [])..add(task);
  }

  /// 移除任务 [VoidCallback]
  @protected
  void removeTask(VoidCallback task) {
    if (containsTask(task)) _tasks!.remove(task);
  }

  /// 是否存在指定任务 [VoidCallback]
  @protected
  bool containsTask(VoidCallback task) {
    return _tasks == null || !_tasks!.contains(task) ? false : true;
  }

  /// 执行所有任务
  void _execTasks() {
    if (_tasks != null && _tasks!.isNotEmpty) {
      for (var task in _tasks!) {
        task();
      }
    }
  }

  void _dispose() {
    _tasks = null;
    model.dispose();
    dispose();
  }

  /// 关联的视图 [View] 初始化前调用此方法
  @protected
  @override
  void viewInit(BuildContext context) {}

  /// 关联的视图 [View] 准备就绪后调用此方法
  @protected
  @override
  void viewReady(BuildContext context) {}

  /// dispose
  @protected
  void dispose() {}
}
