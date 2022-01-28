## 0.3.0
* 增加 `前置属性`，实现在视图 `View` 中预先使用不存在的键 `BindableProperty`
* 增加 `$.merge`、`$.mergeMap`方法，用于将多个 `ValueListenable` 合并成一个
* 增加 `$.watchAnyForMap` 方法，用于监视多个 `ValueListenable` 变化并将值合并为键值集合
* 移除了 `BindableProperty` 中 `Key` 属性
* 代码优化

## 0.2.0
* 空安全支持

## 0.1.9
* 优化代码 

## 0.1.8
* 修复(Flutter v1.12.13+hotfix.8)编译错误 

## 0.1.7
* 完善代码注释文档
* 完善 APIs.md

## 0.1.6+1
* 完善 APIs.md

## 0.1.6
* 代码优化
* 增加测试代码

## 0.1.5+1
* 更新 README.md

## 0.1.5
* 视图上下文 `ViewContext` 增加 `dispose`、`viewInit`、`viewReady` 方法
* 视图模型 `ViewModel` 增加 `dispose`、`viewInit`、`viewReady` 方法
* 视图 `View` 增加 `dispose`、`ready` 方法, 原有 `buildCore` 方法更名为 `build`, 原有 `initView` 方法更名为 `init`
* 代码优化
* 增加列表示例 `example/lib/example_list.dart`

## 0.1.4+1
* 增加属性键 `propertyKey` 查找属性 `Property` 未找到时异常
* 视图上下文 `ViewContext` 中增加任务功能
* 视图 `View` 增加"流程管线"
* 代码优化
* 更新 example

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