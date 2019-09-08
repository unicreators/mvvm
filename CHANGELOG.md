## 0.1.4
* 绑定属性 `BindableProperty` 增加 `valueChanged` 属性值变更后回调方法
* 视图上下文 `ViewContext` 增加 `adapt` 辅助方法, 用于在 `View` 中动态创建适配到 `Widget` 的绑定属性
* 视图上下文 `ViewContext` 增加 `getValueFor`、`setValueFor` 辅助方法, 用于在 `View` 中手动获取或设置绑定属性值
* 代码优化、完善文件头信息
* 更新 example、README.md

## 0.1.3+4
* 增加 `AsyncViewModelProperty` 类 `resetOnBefore` 参数功能

## 0.1.3+3
* 代码优化

## 0.1.3+2
* 代码优化
* 更新 example

## 0.1.3+1
* 代码优化

## 0.1.3
* 完善代码注释文档
* 增加 `analysis_options.yaml`
* `ViewModel` 中 `property(..)` 方法重命名为 `propertyValue(..)`, `propertyAdaptive` 方法去除 `TAdapteeValue` 泛型参数
* `ValueNotifierAdapter` 中 `TAdaptee` 泛型参数约束调整
* 更新 example
* 更新 README.md

## 0.1.2+1
* 增加代码注释文档

## 0.1.2
* 拆分视图上下文 `ViewContext` 功能 
* 更新示例程序

## 0.1.1
* 项目信息变更

## 0.1.0 
* 初始项目
