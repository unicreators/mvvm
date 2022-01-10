// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ViewListener
abstract class ViewListener {
  /// 关联的视图 [View] 初始化前调用此方法
  @protected
  void viewInit(BuildContext context);

  /// 关联的视图 [View] 准备就绪后调用此方法
  @protected
  void viewReady(BuildContext context);
}

/// View
///
abstract class View<TViewModel extends ViewModel>
    extends ViewBase<TViewModel, ViewContext<TViewModel>> {
  /// View
  View(TViewModel model) : super(ViewContext<TViewModel>(model));
}

/// ViewBase
abstract class ViewBase<TViewModel extends ViewModel,
    TViewContext extends ViewContext<TViewModel>> extends ViewWidget {
  /// ViewBase
  ViewBase(this._context);

  final TViewContext _context;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get model => _context.model;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get $model => _context.model;

  ///
  /// 视图上下文 [ViewContext]
  TViewContext get $ => _context;

  @override
  void _buildBefore(BuildContext context) {
    _context._viewInit(context);
    init(context);
  }

  @override
  void _buildAfter(BuildContext context) {
    ready(context);
    _context._viewReady(context);
  }

  @override
  void _dispose() {
    _context._dispose();
  }

  /// dispose
  @protected
  void dispose() {}

  /// init
  @protected
  void init(BuildContext context) {}

  /// ready
  @protected
  void ready(BuildContext context) {}
}

/// ViewWidget
abstract class ViewWidget extends StatefulWidget {
  final _state = _ViewWidgetState();

  /// build
  @protected
  Widget build(BuildContext context);

  void _buildBefore(BuildContext context);
  void _buildAfter(BuildContext context);
  void _dispose();

  /// setState
  @protected
  void setState(VoidCallback fn) => _state._setState(fn);

  @override
  State<StatefulWidget> createState() => _state;
}

class _ViewWidgetState extends State<ViewWidget> {
  @override
  Widget build(BuildContext context) {
    widget._buildBefore(context);
    var _ = widget.build(context);
    widget._buildAfter(context);
    return _;
  }

  void _setState(VoidCallback fn) => setState(fn);

  @override
  void dispose() {
    super.dispose();
    widget._dispose();
  }
}
