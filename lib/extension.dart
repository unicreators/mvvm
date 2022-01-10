// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// BindablePropertyExtension
extension BindablePropertyExtension<TValue> on TValue {
  /// toBindableProperty
  BindableProperty<TValue> toBindableProperty(
      {ValueChanged<TValue>? valueChanged}) {
    return ValueBindableProperty<TValue>(
        initial: this, valueChanged: valueChanged);
  }
}
