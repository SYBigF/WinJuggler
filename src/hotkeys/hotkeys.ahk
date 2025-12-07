#Requires AutoHotkey v2.0

class HotkeyLoader {
    static RegisteredHotkeys := []

    static Load() {
        toggleWinKey := HotkeyLoader.Read("Hotkeys", "WinCycler", "")
        HotkeyLoader.BindHotkey(toggleWinKey, (*) => WinCycler.Cycle())

        forceOpenKey := HotkeyLoader.Read("Hotkeys", "ForceOpen", "")

        apps := HotkeyLoader.ReadSection("Apps")
        for hk, exePath in apps {
            if (exePath != "" && !FileExist(exePath)) {
                TrayTip("应用路径无效", hk ": " exePath " 不存在", Icon := 3)
                continue
            }
            exeName := HotkeyLoader.ExtractExeName(exePath)
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

    static Read(section, key, default := "") {
        return IniRead(ConfigManager.configPath, section, key, default)
    }

    static ReadSection(section) {
        result := Map()
        try
            raw := IniRead(ConfigManager.configPath, section)
        catch
            return result
        lines := StrSplit(raw, "`n", "`r")

        for line in lines {
            if InStr(line, "=") {
                pair := StrSplit(line, "=")
                key := Trim(pair[1])
                val := Trim(pair[2])
                result[key] := val
            }
        }
        return result
    }

    static ExtractExeName(path) {
        SplitPath(path, , , &ext, &name)
        return name "." ext
    }
}
