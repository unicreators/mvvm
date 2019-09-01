///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// View
///
///

abstract class View<TViewModel extends ViewModel>
    extends ViewBase<TViewModel, ViewContext<TViewModel>> {
  View(TViewModel model)
      : assert(model != null),
        super(ViewContext<TViewModel>(model));
}

abstract class ViewBase<TViewModel extends ViewModel,
    TViewContext extends ViewContext<TViewModel>> extends StatelessWidget {
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

  @protected
  Widget buildCore(BuildContext context);

  @protected
  void initView(BuildContext context) {}
}
