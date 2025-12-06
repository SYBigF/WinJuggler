#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir A_ScriptDir

TraySetIcon(A_ScriptDir "\..\assets\app.ico")

#Include "./core/array_utils.ahk"

#Include "./features/config_manager.ahk"
#Include "./features/app_switcher.ahk"
#Include "./features/win_cycler.ahk"

#Include "./hotkeys/hotkeys.ahk"

ConfigManager.EnsureConfig()

ConfigWatcher.Start()

HotkeyLoader.Load()

AppWinFocuseRecorder.Init()
