// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

///
/// 具有转换功能的绑定属性
///
class TransformBindableProperty<S, T> extends ValueBindableProperty<T> {
  final ValueListenable<S> _source;
  late final VoidCallback _transformListener;

  ///
  /// 创建一个具有转换功能的绑定属性，该绑定属性监视 [source] 的值变化，当
  /// [source] 值发生变化时使用 [transform] 对值进行转换，
  /// 如转换结果非 `null`，则将结果值写入属性(可能会触发 `notify`)
  ///
  /// [source] 指定源
  ///
  /// [transform] 指定值转换方法，如该方法返回 `null`
  /// 则将该值写入属性(可能会触发 `notify`)
  ///
  /// [initial] 指定初始值
  ///
  /// [valueChanged] 指定属性值变更后的回调方法
  ///
  TransformBindableProperty(ValueListenable<S> source,
      {required T? Function(S) transform,
      required T initial,
      PropertyValueChanged<T>? valueChanged})
      : _source = source,
        super(
            initial: transform(source.value) ?? initial,
            valueChanged: valueChanged) {
    _transformListener = () => set(transform(source.value));
    _source.addListener(_transformListener);
  }

  @override
  void dispose() {
    _source.removeListener(_transformListener);
    super.dispose();
  }
}
