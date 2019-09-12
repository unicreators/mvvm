import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/mvvm.dart';

void main() {
  group('BindableProperty', () {
    test('初始化', () {
      expect(() => BindableProperty.create<int>(null), throwsAssertionError);
      expect(BindableProperty.create<int>(#key).key, #key);
    });

    test('值变更后应发出通知', () {
      Object key;
      int value;
      BindableProperty.create<int>(#key, initial: 0, valueChanged: (v, k) {
        key = k;
        value = v;
      })
        ..value = 1;
      expect(key, #key);
      expect(value, 1);
    });

    test('设置值与原值相同时应不发出通知', () {
      Object key;
      int value;
      BindableProperty.create<int>(#key, initial: 1, valueChanged: (v, k) {
        key = k;
        value = v;
      })
        ..value = 1;
      expect(key, null);
      expect(value, null);
    });

    test('强制发出通知', () {
      var count = 0;
      BindableProperty.create<int>(#key, initial: 1,
          valueChanged: (v, k) {
        count++;
      })
        ..notify()
        ..notify();
      expect(count, 2);
    });
  });
}
