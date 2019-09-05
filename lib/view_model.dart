///
/// yichen <d.unicreators@gmail.com>
///

part of './mvvm.dart';

/// ViewModel
///
abstract class ViewModel extends ViewModelBase {}

/// ViewModelBase
///
abstract class ViewModelBase extends _ViewModelBase
    with ValueViewModelMixin, AdaptiveViewModelMixin {}

abstract class _ViewModelBase extends BindableObject {}
