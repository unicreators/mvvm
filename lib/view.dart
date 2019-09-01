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

  TViewModel get $Model => _context.model;
  TViewContext get $ => _context;

  @override
  Widget build(BuildContext context) {
    initView();
    return buildCore(context);
  }

  @protected
  Widget buildCore(BuildContext context);

  @protected
  void initView() {}
}
