// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of '../mvvm.dart';

/// ViewContextBuilderHelperMixin
///

mixin ViewContextBuilderHelperMixin<TViewModel extends ViewModelBase>
    on _ViewContextBase<TViewModel> {
  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个无参的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder0(() => Text("hello!")));
  /// }
  /// ```
  ValueWidgetBuilder builder0(Widget Function() builder) =>
      (context, dynamic value, child) => builder();

  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个无参的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.b0(() => Text("hello!")));
  /// }
  /// ```
  ValueWidgetBuilder b0(Widget Function() builder) => builder0(builder);

  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个接收 [TValue] 的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder1((value) => Text(value)));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder1<TValue>(
          Widget Function(TValue) builder) =>
      (context, value, child) => builder(value);

  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个接收 [TValue] 的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.b1((value) => Text(value)));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> b1<TValue>(Widget Function(TValue) builder) =>
      builder1(builder);

  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个接收 [TValue], [Widget] 的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.builder2((value, child) =>
  ///                   Column(children:[Text("$value"), child]),
  ///     child: Text("child"));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> builder2<TValue>(
          Widget Function(TValue, Widget?) builder) =>
      (context, value, child) => builder(value, child);

  ///
  /// 生成 [Widget] 构建方法
  ///
  /// 通过 [builder] 指定一个接收 [TValue], [Widget] 的 [Widget] 构建方法
  ///
  /// ```dart
  /// // example
  /// @override
  /// Widget build(BuildContext context) {
  ///   return $.watch<String>($Model.prop1,
  ///     builder: $.b2((value, child) =>
  ///                   Column(children:[Text("$value"), child]),
  ///     child: Text("child"));
  /// }
  /// ```
  ValueWidgetBuilder<TValue> b2<TValue>(
          Widget Function(TValue, Widget?) builder) =>
      builder2(builder);
}
