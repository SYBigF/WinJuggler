#Requires AutoHotkey v2.0

class HotkeyLoader {
    static RegisteredHotkeys := []

    static Load() {
        toggleWinKey := ConfigManager.Read("Hotkeys", "WinCycler", "")
        HotkeyLoader.BindHotkey(toggleWinKey, (*) => WinCycler.Cycle())

        forceOpenKey := ConfigManager.Read("Hotkeys", "ForceOpen", "")

        apps := ConfigManager.ReadSection("Apps")
        for hk, exePath in apps {
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
