# Class Reference

本章节说明项目中主要类、枚举、Provider 的职责，避免后续开发时不知道类的用途。

---

## App Layer Classes

| Class / File              | 作用                                                         |
| ------------------------- | ------------------------------------------------------------ |
| `Application`             | App 根组件，负责挂载 `MaterialApp`、主题、路由等应用级配置。 |
| `ApplicationBootstrapper` | 应用启动引导器，负责统一执行启动前初始化任务。               |
| `ApplicationInitTask`     | 启动任务模型，用于描述一个初始化任务。                       |
| `ApplicationInitializer`  | 初始化任务执行器，负责按顺序执行多个启动任务。               |
| `BootstrapContext`        | 启动上下文，用于在初始化阶段传递全局依赖或配置。             |
| `runAppHandle`            | App 启动封装函数，用于统一处理异常、初始化和运行 App。       |
| `ApplicationConfig`       | 应用配置类，统一管理 App 名称、接口地址、环境配置等。        |
| `AppEnvironment`          | 应用环境枚举，区分 `development`、`staging`、`production`。  |
| `AppEnvironmentX`         | 环境枚举扩展，用于获取环境名称、是否生产环境等辅助信息。     |
| `globalKeyNavigatorKey`   | 全局导航 Key，用于在非 Widget 场景下执行页面跳转。           |
| `PageScope`               | 页面级依赖作用域，用于在页面树中传递页面状态或依赖。         |
| `AppNavigator`            | 应用导航管理器，统一封装页面跳转、返回、替换等导航操作。     |
| `AppRouter`               | 应用导航管理路由                                             |
| `AppPageRoute`            | 自定义页面路由，统一页面切换动画和路由行为。                 |
| `RouteObserverService`    | 路由监听服务，用于监听页面进入、退出、切换等生命周期。       |
| `RouteNames`              | 路由名称常量类，统一管理页面路由字符串。                     |
| `AppTheme`                | 应用主题类，统一管理亮色主题、暗色主题、颜色和字体样式。     |

---

## Core / Device Classes

| Class               | 作用                                                             |
| ------------------- | ---------------------------------------------------------------- |
| `DeviceInfoService` | 设备信息服务，统一获取设备型号、系统版本、App 版本、包名等信息。 |

---

## Core / Network Classes

| Class / File              | 作用                                                            |
| ------------------------- | --------------------------------------------------------------- |
| `DioClientHolder`         | Dio 实例持有器，负责创建、配置、缓存和复用 Dio 实例。           |
| `HttpClient`              | 网络请求客户端，统一封装 GET、POST、PUT、DELETE 等请求。        |
| `NetworkMonitor`          | 网络状态监听器，用于监听当前设备是否联网。                      |
| `Reachability`            | 网络可达状态枚举，包含 `unknown`、`online`、`offline`。         |
| `NetworkState`            | 网络状态模型，用于描述当前网络连接状态。                        |
| `ResponseErrorHandler`    | HTTP 响应错误处理器，统一处理接口错误、状态码异常等问题。       |
| `RequestHeaders`          | 请求头管理类，统一生成 Token、语言、版本号、设备信息等 Header。 |
| `RequestMethod`           | 请求方法枚举，包含 GET、POST、PUT、DELETE、HEAD、UPLOAD。       |
| `request`                 | 通用请求方法，用于根据请求参数统一发起网络请求。                |
| `OfflineQueueInterceptor` | 离线请求拦截器，当网络不可用时拦截请求并加入离线队列。          |
| `OfflineQueueManager`     | 离线队列管理器，负责请求入队、重试、清理和恢复发送。            |
| `OfflineQueueState`       | 离线队列状态模型，用于描述队列数量、处理中状态等信息。          |
| `OfflineQueueStorage`     | 离线队列本地存储服务，负责把离线请求保存到本地。                |
| `OfflineRequest`          | 离线请求模型，保存请求地址、参数、Header、请求方法等信息。      |
| `QueuePriority`           | 离线请求优先级枚举，区分高、中、低优先级。                      |
| `QueueCategory`           | 离线请求分类枚举，例如用户操作、同步、统计、日志等。            |
| `IdempotencyKeyGenerator` | 幂等 Key 生成器，用于生成唯一请求标识，避免重复提交。           |

---

## Core / Network Providers

| Provider                      | 作用                                            |
| ----------------------------- | ----------------------------------------------- |
| `dioProvider`                 | Riverpod Provider，用于全局提供 Dio 实例。      |
| `dioInterceptorsProvider`     | Riverpod Provider，用于注册 Dio 拦截器。        |
| `networkMonitorProvider`      | Riverpod Provider，用于提供网络监听服务。       |
| `networkStateProvider`        | Riverpod StreamProvider，用于监听网络状态变化。 |
| `offlineQueueManagerProvider` | Riverpod Provider，用于提供离线队列管理器。     |
| `offlineQueueStateProvider`   | Riverpod StreamProvider，用于监听离线队列状态。 |
| `offlineQueueStorageProvider` | Riverpod Provider，用于提供离线队列存储服务。   |

---

## Core / Logger Classes

| Class       | 作用                                                          |
| ----------- | ------------------------------------------------------------- |
| `AppLogger` | 应用日志工具类，统一输出 Debug、Info、Warning、Error 等日志。 |

> 项目中不要直接使用 `print()` 输出日志，统一使用 `AppLogger`，方便后续控制 Release 环境日志。

---

## Core / State Classes

| Class / Enum             | 作用                                                       |
| ------------------------ | ---------------------------------------------------------- |
| `BaseBloc<Event, State>` | Bloc 基础类，用于统一扩展 Bloc 的公共能力。                |
| `BaseEvent`              | Bloc 事件基类，所有 Event 可以继承它，方便统一比较和测试。 |
| `BaseState`              | Bloc 状态基类，所有 State 可以继承它，方便统一比较和测试。 |
| `AppProviderObserver`    | Riverpod 状态监听器，用于调试 Provider 创建、更新、销毁。  |

---

## Core / Storage Classes

| Class                | 作用                                               |
| -------------------- | -------------------------------------------------- |
| `PreferencesService` | SharedPreferences 封装服务，统一处理本地数据读写。 |
| `StorageKeys`        | 本地存储 Key 常量类，避免字符串 Key 散落在项目中。 |

---

## Core / Utils Classes

| Class            | 作用                                                                       |
| ---------------- | -------------------------------------------------------------------------- |
| `InputValidator` | 输入校验工具类，用于校验手机号、邮箱、密码、非空等规则。                   |
| `Responsive`     | 响应式尺寸适配工具，根据设计稿宽度自动计算缩放比例，统一适配不同屏幕尺寸。 |

---

## Shared / Form Classes

| Class                | 作用                                                             |
| -------------------- | ---------------------------------------------------------------- |
| `FormViewState`      | 表单整体状态模型，用于描述表单是否加载、是否可提交、错误信息等。 |
| `FormFieldViewState` | 单个表单字段状态模型，用于描述字段值、错误信息、是否必填等。     |
| `AppForm`            | 应用统一表单容器，用于统一表单布局和提交逻辑。                   |
| `AppTextField`       | 应用统一输入框组件，封装输入、校验、错误提示、样式等能力。       |
| `_AppTextFieldState` | `AppTextField` 的内部状态类，负责维护输入框状态。                |

---

## Shared / Feedback Classes

| Class                 | 作用                                                            |
| --------------------- | --------------------------------------------------------------- |
| `AppToast`            | Toast 提示工具类，统一显示成功、失败、警告、普通提示。          |
| `_ToastWidget`        | Toast 内部 UI 组件，负责 Toast 的实际展示样式。                 |
| `LoadingOverlay`      | 全局 Loading 浮层工具，用于接口请求、页面加载、文件上传等场景。 |
| `NetworkStatusBanner` | 网络状态提示条，当网络断开或恢复时显示提示。                    |
| `_OfflineBanner`      | 离线状态提示条内部组件。                                        |

---

## Shared / Gesture Classes

| Class              | 作用                                               |
| ------------------ | -------------------------------------------------- |
| `AppTapArea`       | 通用点击区域组件，封装点击、防抖、触摸反馈等能力。 |
| `_AppTapAreaState` | `AppTapArea` 的内部状态类，负责处理点击状态。      |

---

## Shared / Image Classes

| Class / Enum                | 作用                                                             |
| --------------------------- | ---------------------------------------------------------------- |
| `AppCachedImage`            | 网络缓存图片组件，封装图片加载、缓存、占位图、错误图。           |
| `AdvancedImageCacheManager` | 图片缓存管理器，负责管理网络图片缓存策略。                       |
| `AppImage`                  | 应用统一图片组件，支持资源图片、网络图片、Base64、文件图片等。   |
| `_ImageType`                | 图片类型枚举，用于区分 asset、network、base64、file 等图片来源。 |
| `_AppImageState`            | `AppImage` 的内部状态类，负责判断图片类型并渲染。                |

---

## Shared / Layout Classes

| Class         | 作用                                                              |
| ------------- | ----------------------------------------------------------------- |
| `AppScaffold` | 应用统一页面骨架，封装 Scaffold、AppBar、Body、背景色等通用结构。 |

---

## Shared / Page Classes

| Class | 作用 |
| `BaseRiverpodPage<S, VM extends StateNotifier<S>>` | Riverpod 页面基类，负责绑定 Provider 与 ViewModel，统一页面结构、生命周期管理和状态管理入口。 |
| `BaseRiverpodState<T, S, VM extends StateNotifier<S>>` | Riverpod 页面状态基类，负责页面初始化、Provider 状态读取、ViewModel 获取、页面缓存、导航栏配置以及页面容器构建。 |
| `BaseBlocPage<S, B extends BlocBase<S>>` | Bloc 页面基类，负责创建并注入 Bloc/Cubit，统一页面结构、生命周期管理和状态管理入口。 |
| `BaseBlocState<T, S, B extends BlocBase<S>>` | Bloc 页面状态基类，负责页面初始化、Bloc 获取、状态监听（BlocListener）、状态刷新（BlocBuilder）、页面缓存、导航栏配置以及页面容器构建。 |

---

## Shared / Text Classes

| Class           | 作用                                                                   |
| --------------- | ---------------------------------------------------------------------- |
| `AppText`       | 应用统一文本组件，封装字体大小、颜色、行高、对齐方式等常用 Text 配置。 |
| `_AppTextState` | `AppText` 的内部状态类，负责处理文本组件状态。                         |

---

## Feature / Example Classes

| Class         | 作用                                                 |
| ------------- | ---------------------------------------------------- |
| `ExamplePage` | 示例页面，用于展示框架的基础页面结构和组件使用方式。 |

---

## Feature / Riverpod Example Classes

| Class / Provider  | 作用                                                        |
| ----------------- | ----------------------------------------------------------- |
| `counterProvider` | Riverpod 示例 Provider，用于管理计数器状态。                |
| `CounterNotifier` | 计数器状态控制器，负责增加、减少、重置计数。                |
| `CounterPage`     | Riverpod 示例页面，用于展示如何通过 Provider 驱动 UI 刷新。 |

---

## Feature / Bloc Example Classes

| Class                    | 作用                                                     |
| ------------------------ | -------------------------------------------------------- |
| `OrderEvent`             | 订单 Bloc 事件基类，用于描述订单流程中发生的行为。       |
| `CreateOrderRequested`   | 创建订单事件，表示用户触发创建订单操作。                 |
| `PayOrderRequested`      | 支付订单事件，表示用户触发支付操作。                     |
| `CompleteOrderRequested` | 完成订单事件，表示订单流程完成。                         |
| `OrderStatus`            | 订单状态枚举，用于描述订单当前所处阶段。                 |
| `OrderState`             | 订单状态模型，保存当前订单状态、提示信息、错误信息等。   |
| `OrderBloc`              | 订单业务流程控制器，接收事件、处理业务逻辑、输出新状态。 |
| `OrderPage`              | Bloc 示例页面，用于展示如何通过 Bloc 管理复杂业务流程。  |

---

# Bloc Example Workflow

Bloc 适合复杂业务流程，例如订单流程。

```text
用户点击创建订单
        ↓
CreateOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: pendingPayment)
        ↓
UI 刷新为待支付状态
```

支付流程：

```text
用户点击支付
        ↓
PayOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: paid)
        ↓
UI 刷新为支付成功状态
```

完成流程：

```text
订单完成
        ↓
CompleteOrderRequested
        ↓
OrderBloc
        ↓
OrderState(status: completed)
        ↓
UI 刷新为订单完成状态
```

---

# Riverpod Example Workflow

Riverpod 适合轻量状态，例如计数器、主题、用户信息、接口数据。

```text
用户点击按钮
        ↓
CounterNotifier.increment()
        ↓
counterProvider 状态更新
        ↓
ConsumerWidget 自动刷新 UI
```

---

# Responsive Usage

`Responsive` 用于统一管理项目中的尺寸适配，根据设计稿宽度自动计算缩放比例。

## 初始化

```dart
@override
Widget build(BuildContext context) {
  Responsive.init(context);

  return const Scaffold(
    body: ...
  );
}
```

默认设计稿宽度为 **375**。

自定义设计稿：

```dart
Responsive.init(
  context,
  designWidth: 390,
);
```

限制缩放范围：

```dart
Responsive.init(
  context,
  designWidth: 375,
  minScale: 0.85,
  maxScale: 1.25,
);
```

## 使用

```dart
Container(
  width: 120.adapt,
  height: 48.adapt,
  padding: EdgeInsets.all(16.adapt),
  margin: EdgeInsets.symmetric(horizontal: 20.adapt),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.adapt),
  ),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: 16.adapt,
    ),
  ),
)
```

```dart
Icon(
  Icons.home,
  size: 24.adapt,
)
```

## Best Practice

统一使用 `.adapt` 进行尺寸适配：

- width
- height
- padding
- margin
- fontSize
- borderRadius
- iconSize

---

# Class Placement Rules

## 放到 core 的类

满足以下条件时放入 `core`：

- 与 UI 无关
- 与具体业务无关
- 多个模块都需要
- 属于基础设施能力

例如：

```text
HttpClient
PreferencesService
DeviceInfoService
AppLogger
```

---

## 放到 shared 的类

满足以下条件时放入 `shared`：

- 是 UI 组件
- 多个业务页面都会使用
- 不包含具体业务逻辑

例如：

```text
AppText
AppImage
AppTextField
AppToast
LoadingOverlay
```

---

## 放到 features 的类

满足以下条件时放入 `features`：

- 只服务于某个业务模块
- 包含业务状态
- 包含业务页面
- 包含业务流程

例如：

```text
LoginPage
OrderBloc
UserProvider
OrderRepository
```

---

# Important Rule

不要为了“看起来通用”过早把代码放到 `core` 或 `shared`。

推荐原则：

```text
先放 features
真正复用后再抽到 shared 或 core
```
