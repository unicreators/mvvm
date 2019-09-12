import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm/mvvm.dart';

void main() {
  group('BindableValueNotifier', () {
    test('初始化', () {
      expect(BindableValueNotifier<int>(0).value, 0);
      expect(BindableValueNotifier<int>(null).value, null);
    });

    test('值变更后应发出通知', () {
      var count = 0;
      expect(
          (BindableValueNotifier<int>(0)
                ..addListener(() {
                  count++;
                })
                ..value = 1)
              .value,
          1);
      expect(count, 1);
    });

    test('设置值与原值相同时应不发出通知', () {
      var count = 0;
      expect(
          (BindableValueNotifier<int>(0)
                ..addListener(() {
                  count++;
                })
                ..value = 0)
              .value,
          0);
      expect(count, 0);
    });

    test('强制发出通知', () {
      var count = 0;
      BindableValueNotifier<int>(0)
        ..addListener(() {
          count++;
        })
        ..value = 0
        ..notify()
        ..notify();
      expect(count, 2);
    });

    test('可添加多个监听', () {
      var count = 0;
      var counter = () {
        count++;
      };
      expect(
          1,
          (BindableValueNotifier<int>(0)
                ..addListener(counter)
                ..addListener(counter)
                ..value = 1)
              .value);
      expect(count, 2);
    });

    test('可取消监听', () {
      var count = 0;
      var counter = () {
        count++;
      };
      BindableValueNotifier<int>(0)
        ..addListener(counter)
        ..value = 0
        ..notify()
        ..notify()
        ..removeListener(counter)
        ..notify();
      expect(count, 2);
    });
  });
}
