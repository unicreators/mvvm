// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

/// PreBindableProperty
///
class PreBindableProperty<TValue> extends ValueBindableProperty<TValue> {
  /// PreBindableProperty
  PreBindableProperty(
      {PropertyValueChanged<TValue>? valueChanged,
      required TValue initialValue})
      : super(valueChanged: valueChanged, initial: initialValue);
}
