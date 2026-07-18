## Catrun（猫爪代办）

Catrun（猫爪代办）：一款基于ArkTS开发的鸿蒙待办任务管理应用，支持分组管理、待办事项增删改查、手机验证码登录等功能。

## 操作预览

<table>
  <tr>
    <td align="center">
      <img src="https://bu.dusays.com/2026/07/18/6a5ae9654f29c.gif" width="180" style="border-radius:12px"><br/>
      <small>注册登录</small>
    </td>
    <td align="center">
      <img src="https://bu.dusays.com/2026/07/18/6a5aea064a745.gif" width="180" style="border-radius:12px"><br/>
      <small>添加与移除</small>
    </td>
    <td align="center">
      <img src="https://bu.dusays.com/2026/07/18/6a5aea00a484a.gif" width="180" style="border-radius:12px"><br/>
      <small>切换账号</small>
    </td>
  </tr>
</table>

## 技术栈
- **开发语言**：ArkTS
- **UI框架**：ArkUI
- **网络请求**：@ohos/axios
- **状态管理**：AppStorage、LocalStorage、@ohos/data.preferences
- **开发环境**：DevEco Studio / HarmonyOS SDK


## 项目结构
```
Caturn/
├── AppScope/                     # 应用级配置
│   ├── app.json5                 # 应用配置
│   └── resources/                # 应用级资源
├── entry/                        # 入口模块
│   └── src/
│       ├── main/
│       │   ├── ets/
│       │   │   ├── entryability/ # Ability 入口
│       │   │   ├── pages/        # 页面
│       │   │   │   ├── Login.ets     # 登录页
│       │   │   │   ├── Index.ets     # 首页/分组页
│       │   │   │   ├── Home.ets      # 主页框架
│       │   │   │   ├── Detail.ets    # 待办详情页
│       │   │   │   └── Mine.ets      # 我的页面
│       │   │   ├── utils/        # 工具类
│       │   │   │   ├── AxiosUtils.ets # Axios 封装
│       │   │   │   ├── AxiosConfig.ets # Axios 配置
│       │   │   │   ├── auth.ets       # 登录相关接口
│       │   │   │   ├── group.ets      # 分组相关接口
│       │   │   │   ├── detail.ets     # 待办相关接口
│       │   │   │   ├── preferences.ets # 持久化工具
│       │   │   │   └── config.ets     # 全局配置
│       │   │   └── common/       # 通用组件
│       │   └── resources/        # 模块资源
│       ├── ohosTest/             # 测试用例
│       └── test/                 # 单元测试
├── hvigor/                       # 构建配置
├── build-profile.json5           # 构建配置
└── README.md                     # 项目说明
```


## 核心配置

`entry/src/main/ets/utils/config.ets` 中配置后端地址：

```typescript
export const IP = 'http://your-server-address:port'
```

`entry/src/main/ets/utils/AxiosConfig.ets` 中可配置超时时间、Content-Type 等：

```typescript
const axiosConfig: AxiosConfig = {
  baseURL: IP,
  timeout: 10000,
  headers: { 'Content-Type': 'application/json' }
}
```

## 核心接口说明

| 模块 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 登录 | POST | /api/catrun/auth/signin_code | 获取验证码 / 验证码登录 |
| 分组 | GET | /api/catrun/group/all | 获取所有分组 |
| 分组 | POST | /api/catrun/group/add | 新增分组 |
| 分组 | DELETE | /api/catrun/group/remove | 移除分组 |
| 待办 | GET | /api/catrun/detail/get | 获取分组下待办 |
| 待办 | POST | /api/catrun/detail/add | 新增待办 |
| 待办 | PUT | /api/catrun/detail/exchange | 更新待办状态 |
| 待办 | DELETE | /api/catrun/detail/remove | 移除待办 |

## 请求鉴权流程

1. 用户登录成功后，后端返回 `accessToken` 和 `refreshToken`。
2. `accessToken` 保存在 `AppStorage` 中，用于内存访问。
3. `refreshToken` 和手机号通过 `preferences` 持久化保存。
4. 每次发起业务请求时，`AxiosUtil` 请求拦截器自动从持久化读取 `refreshToken`，并添加到请求头：

   ```
   Authorization: Bearer <refreshToken>
   ```

5. 后端校验 token 有效后返回数据。

## 核心页面说明

- **Login.ets**：手机号输入、验证码获取、登录成功后保存 token 并跳转到首页。
- **Index.ets**：展示分组列表，支持搜索、新增分组、点击进入分组详情。
- **Home.ets**：应用主框架，包含底部导航。
- **Detail.ets**：展示某个分组下的待办列表，支持新增、完成、移除待办。
- **Mine.ets**：个人中心页面。

## 开发注意事项

1. 首次运行前请确保 `config.ets` 中的后端地址正确。
2. `module.json5` 中已声明必要权限，如 `ohos.permission.INTERNET`。
3. 所有业务接口统一通过 `AxiosUtil.instance` 发起，避免直接使用 axios 实例。
4. 持久化操作封装在 `preferences.ets` 中，业务层通过 `showToken()` 获取当前登录账号和 token。




