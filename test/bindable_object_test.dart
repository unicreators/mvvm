import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/mvvm.dart';

class MyBindableObject extends BindableObject {}

void main() {
  group('BindableObject', () {
    test('初始化', () {
      expect(MyBindableObject().properties, isEmpty);
    });

    test('registryProperty', () {
      var bp = BindableProperty.create<int>(#key, initial: 0);
      var bo = MyBindableObject()..registryProperty(bp);
      expect(bo.properties.length, 1);
      expect(bo.getProperty<int>(#key), bp);
    });

    test('getProperty', () {
      var bp = BindableProperty.create<int>(#key, initial: 0);
      expect((MyBindableObject()..registryProperty(bp)).getProperty<int>(#key),
          bp);
    });
  });
}
