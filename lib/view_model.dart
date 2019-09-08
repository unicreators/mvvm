// Copyright (c) 2019 yichen <d.unicreators@gmail.com>. All rights reserved.
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

abstract class _ViewModelBase extends BindableObject {}
