// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// ViewModel
///
abstract class ViewModel extends ViewModelBase {}

/// ViewModelBase
///
abstract class ViewModelBase extends _ViewModelBase
    with ValueViewModelMixin, AdaptiveViewModelMixin {}

abstract class _ViewModelBase extends BindableObject with ViewListener {
  /// 关联的视图 [View] 初始化前调用此方法
  @protected
  @override
  void viewInit(BuildContext context) {}

  /// 关联的视图 [View] 准备就绪后调用此方法
  @protected
  @override
  void viewReady(BuildContext context) {}

  /* @protected
  void attachView(BuildContext context, ViewWidget view) {}

  @protected
  void detachView(BuildContext context, ViewWidget view) {} */
}
