// Copyright (c) 2022 yichen <d.unicreators@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of './mvvm.dart';

/// PropertyException
abstract class PropertyException implements Exception {
  ///
  final Object propertyKey;
  final String _message;

  ///
  PropertyException(this.propertyKey, this._message);

  @override
  String toString() {
    return _message;
  }
}

/// NotfoundPropertyException
class NotfoundPropertyException extends PropertyException {
  /// NotfoundPropertyException
  NotfoundPropertyException(Object propertyKey) : super(propertyKey, '''

[Flutter MVVM]

  Property not found. 
    - propertyKey: $propertyKey  
''');
}

/// NotOfTypePropertyException
class NotOfTypePropertyException extends PropertyException {
  ///
  final Object propertyType;

  /// NotOfTypePropertyException
  NotOfTypePropertyException(Object propertyKey, this.propertyType)
      : super(propertyKey, '''

[Flutter MVVM]

  Property is not $propertyType
    - propertyKey: $propertyKey
''');
}
