#Requires AutoHotkey v2.0

class HotkeyLoader {
    static RegisteredHotkeys := []

    static Load() {
        winCycleKeyVal := ConfigManager.Read("Hotkeys", "WinCycler", "")
        winCycleKey := ConfigManager.ParseFriendlyHotkey(winCycleKeyVal)
        HotkeyLoader.BindHotkey(winCycleKey, (*) => WinCycler.Cycle())

        forceOpenKeyVal := ConfigManager.Read("Hotkeys", "ForceOpen", "")
        forceOpenKey := ConfigManager.ParseFriendlyHotkey(forceOpenKeyVal)
        apps := ConfigManager.ReadSection("Apps")
        for hkVal, exePath in apps {
            if (hkVal = "" || exePath = "")
                continue
            hk := ConfigManager.ParseFriendlyHotkey(hkVal)
            if (exePath != "" && !FileExist(exePath)) {
                TrayTip("应用路径无效", hk ": " exePath " 不存在", Icon := 3)
                continue
            }
            exeName := ConfigManager.ExtractExeName(exePath)
            handler := AppSwitcher.MakeSitchHandler(exeName, exePath)
            HotkeyLoader.BindHotkey(hk, handler)

            forceOpenhk := forceOpenKey hk
            handler := AppSwitcher.MakeOpenHandler(exePath)
            HotkeyLoader.BindHotkey(forceOpenhk, handler)
        }

        replaceHotKeys := ConfigManager.ReadSection("HKReplace")
        for hkVal, replaceHotKeyVal in replaceHotKeys{
            hk := ConfigManager.ParseFriendlyHotkey(hkVal)
            replaceHotKey := ConfigManager.ParseFriendlyHotkey(replaceHotKeyVal)
            handler := HotkeyLoader.MakeReplaceHotKeyHandler(replaceHotKey)
            HotkeyLoader.BindHotkey(hk, handler)
        }
    }

    static replaceHotKey(hk) {
        Send(hk)
    }

    static MakeReplaceHotKeyHandler(hk) {
        return (*) => HotkeyLoader.replaceHotKey(hk)
    }

    static BindHotkey(hk, func) {
        if (hk = "")
            return

        try {
            Hotkey(hk, func)
            HotkeyLoader.RegisteredHotkeys.Push(hk)
        } catch {
            TrayTip("无效热键", "Hotkey: " hk " 无法绑定", Icon := 3)
        }
    }
}
