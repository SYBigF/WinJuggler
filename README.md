# WinJuggler

一个基于 **AutoHotkey v2** 的轻量级窗口管理工具。可以为常用应用设置切换键，并实现同一应用的多窗口循环切换。

## ✨ 功能特性

### 🪟 1. 应用切换（App Switcher）

- 快捷键一键启动或激活应用  
- 如果已运行且在后台 → 自动切到上次使用的窗口  
- 如果已在前台 → 最小化所有该应用窗口  
- 支持从配置文件动态注册任意应用

### 🔁 2. 多窗口循环切换（Win Cycler）

- 对同一应用的多个窗口进行轮换（如浏览器、编辑器）  
- 类似精准版 Alt+Tab，但不混入其他应用

### ⚙️ 3. 外部配置（config.ini）

- 所有快捷键、应用路径全部写在 `config.ini`  
- 无需修改代码即可扩展应用列表  
- 支持自定义多个快速启动键位

### 🧩 4. 模块化架构（可扩展）

项目按功能拆分为多个模块：

- `AppSwitcher` — 应用切换  
- `WinCycler` — 多窗口轮换  
- `HotkeyLoader` — 自动读取配置并绑定热键
- `ConfigManager` — 配置文件管理

便于长期维护，也方便二次开发。

## 📦 环境要求

- Windows 10 / 11  
- **AutoHotkey v2**（必须是 v2，v1 不兼容）  
  下载地址：[https://www.autohotkey.com/](https://www.autohotkey.com/)

## ⚙️ config.ini 配置指南

`config.ini` 允许用户完全通过文本配置行为。

```ini
[Hotkeys]
WinCycler=!` ; 多窗口循环切换（WinCycler）

[Apps]
F1=
F2=
F3=
F4=
F5=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
F6=
F7=
F8=
```

### 常用符号

| 符号 | 说明  |
|------|-------|
| ^    | Ctrl  |
| !    | Alt   |
| +    | Shift |
| #    | Win   |

例如：
`!` 表示 `Alt`，`!+` 就是 `Alt +`

#### 应用切换列表

格式：热键=程序完整路径

```ini
F5=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
```

## ▶️ 使用方法

1. 安装 AutoHotkey v2，下载项目并保持目录结构不变运行`src/WinJuggler.ahk`（或直接下载并打开`WinJuggler.exe`）；
2. 打开并编辑 `config.ini`，等待弹窗显示新配置加载完成；
3. 按 F5
   - 如果应用未运行 → 启动
   - 如果已运行 → 切换到上次窗口
   - 如果已在前台 → 最小化所有窗口
4. 按 `Alt + ``（配置可改）
   - 在同一应用的多个窗口间循环切换

## 🛠️ TODO

- [ ] 为 config.ini 添加 UI
- [ ] 适配文件资源管理器
