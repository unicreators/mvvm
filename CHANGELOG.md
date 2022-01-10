## 0.3.0
* 增加在视图 `View` 中创建属性功能，见 `$.adaptTo`、`$.wrapTo` 方法
* 增加 `前置属性` 功能，用于解决在视图 `View` 中`属性创建`位置后于`属性使用`问题
* 增加 `$.merge`、`$.mergeMap`方法，用于将多个 `ValueListenable` 合并成一个
* 增加 `$.watchAnyForMap` 方法，用于监视多个 `ValueListenable` 变化并将值合并为键值集合
* 移除了 `BindableProperty` 中 `Key` 属性
* 代码优化

## 0.2.1
* Null safety support

## 0.2.0
* Null safety support

## 0.1.9
* Optimized code

## 0.1.8
* Fix (Flutter v1.12.13+hotfix.8) error

## 0.1.7
* Update documentation
* Update APIs.md

## 0.1.6+1
* Update APIs.md

## 0.1.6
* Optimized code

## 0.1.5+1
* Update README.md

## 0.1.5
* View context `ViewContext` adds `dispose`, `viewInit`, `viewReady` methods
* View model `ViewModel` adds `dispose`, `viewInit`, `viewReady` methods
* View `View` adds `dispose` and `ready` methods, the original `buildCore` method is renamed to `build`, and the original `initView` method is renamed to `init`

## 0.1.4+1
* Add property key `propertyKey` to find the property `Property` is not found exception
* Added task in view context `ViewContext`
* View `View` adds "process pipeline"
* Update example

## 0.1.4
* The binding property `BindableProperty` adds a callback method after the `valueChanged` property value is changed
* View context `ViewContext` adds `adapt` method, which is used to dynamically create binding properties adapted to `Widget` in `View`
* View context `ViewContext` adds `getValueFor` and `setValueFor` methods, which are used to manually obtain or set bound property values ​​in `View`
* Update example, README.md

## 0.1.3+4
* Add `resetOnBefore` parameter of `AsyncViewModelProperty` class

## 0.1.3+3
* Optimized code

## 0.1.3+2
* Code optimization
* Update example

## 0.1.3+1
* Optimized code

## 0.1.3
* Update documentation
* Add `analysis_options.yaml`
* The `property(..)` method in `ViewModel` is renamed to `propertyValue(..)`, the `propertyAdaptive` method removes the `TAdapteeValue` generic parameter
* `TAdaptee` generic parameter constraint adjustment in `ValueNotifierAdapter`
* Update example
* Update README.md

## 0.1.2+1
* Add documentation

## 0.1.2
* Split view context `ViewContext`
* Update sample code

## 0.1.1
* Project information changes

## 0.1.0
* Initial project