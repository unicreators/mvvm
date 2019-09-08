// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// View
///
abstract class View<TViewModel extends ViewModel>
    extends ViewBase<TViewModel, ViewContext<TViewModel>> {
  /// View
  View(TViewModel model)
      : assert(model != null),
        super(ViewContext<TViewModel>(model));
}

/// ViewBase
abstract class ViewBase<TViewModel extends ViewModel,
    TViewContext extends ViewContext<TViewModel>> extends StatelessWidget {
  /// ViewBase
  ViewBase(this._context);

  final TViewContext _context;

  ///
  /// 视图模型 [ViewModel]
  TViewModel get $Model => _context.model;

  ///
  /// 视图上下文 [ViewContext]
  TViewContext get $ => _context;

  @override
  Widget build(BuildContext context) {
    initView(context);
    return buildCore(context);
  }

  /// buildCore
  @protected
  Widget buildCore(BuildContext context);

  /// initView
  @protected
  void initView(BuildContext context) {}
}
