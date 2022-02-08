// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// yichen <d.unicreators@gmail.com>
///

library mvvm;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part './errors.dart';
part './extension.dart';
part './bindable/property.dart';
part './bindable/object.dart';
part './bindable/custom.dart';
part './bindable/pre.dart';
part './bindable/value.dart';
part './bindable/periodic.dart';
part './bindable/adaptive.dart';
part './bindable/async.dart';
part './bindable/merge.dart';
part './builder.dart';

part './view_model.dart';
part './view.dart';

/// identity
TValue identity<TValue>(TValue value) => value;
