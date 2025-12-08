#Requires AutoHotkey v2.0

class ConfigManager {
    static configPath := ""
    
    static defaultCfg := (
        "[Hotkeys]`n"
        "WinCycler=Alt+`n"
        "ForceOpen=Shift`n"
        "`n"
        "[Apps]`n"
        "F1=`n"
        "F2=`n"
        "F3=`n"
        "F4=`n"
        "F5=`n"
        "F6=`n"
        "F7=`n"
        "F8=`n"
        "F9=`n"
        "`n"
        "[HKReplace]`n"
        "Ctrl+F1=Hi! WinJuggler`n"
        "Ctrl+Alt+1={Ctrl+F1}`n"
    )

    static MapModifiers := Map(
        "ALT", "!",
        "CTRL", "^",
        "SHIFT", "+",
        "WIN", "#"
    )

    static GetConfigPath() {
        return A_IsCompiled
            ? A_ScriptDir "\config.ini"
            : A_ScriptDir "\..\config\config.ini"
    }

    static EnsureConfig() {
        ConfigManager.configPath := ConfigManager.GetConfigPath()

        if FileExist(ConfigManager.configPath)
            return ConfigManager.configPath

        SplitPath(ConfigManager.configPath, , &dir)
        DirCreate(dir)

        FileAppend(ConfigManager.defaultCfg, ConfigManager.configPath, "UTF-8-RAW")
    }

    static Read(section, key, default := "") {
        txt := FileRead(ConfigManager.configPath, "UTF-8")

        if SubStr(txt, 1, 1) = Chr(0xFEFF)
            txt := SubStr(txt, 2)

        current := ""

        for line in StrSplit(txt, "`n", "`r") {
            line := Trim(line)

            if (line = "" || SubStr(line, 1, 1) = ";")
                continue

            if RegExMatch(line, "^\[(.+?)\]$", &m) {
                current := m[1]
                continue
            }

            if (current = section && InStr(line, "=")) {
                parts := StrSplit(line, "=")
                if (Trim(parts[1]) = key)
                    return Trim(parts[2])
            }
        }

        return default
    }

    static ReadSection(section) {
        result := Map()

        txt := FileRead(ConfigManager.configPath, "UTF-8")

        if SubStr(txt, 1, 1) = Chr(0xFEFF)
            txt := SubStr(txt, 2)

        current := ""
        buffer := ""

        for line in StrSplit(txt, "`n", "`r") {
            line := Trim(line)

            if (line = "" || SubStr(line, 1, 1) = ";")
                continue

            if RegExMatch(line, "^\[(.+?)\]$", &m) {
                current := m[1]
                continue
            }

            if (current = section) {
                if InStr(line, "=")
                    buffer .= line "`n"
            }
        }

        if (buffer = "")
            return result

        for line in StrSplit(buffer, "`n", "`r") {
            if !InStr(line, "=")
                continue

            parts := StrSplit(line, "=")
            key := Trim(parts[1])
            val := Trim(parts[2])

            result[key] := val
        }

        return result
    }

    static ExtractExeName(path) {
        SplitPath(path, , , &ext, &name)
        return name "." ext
    }

    static ParseFriendlyHotkey(hkText) {
        if hkText = ""
            return ""

        parts := StrSplit(StrReplace(hkText, " ", ""), "+")
        mods := ""
        key := ""

        for part in parts {
            up := StrUpper(part)

            if ConfigManager.MapModifiers.Has(up) {
                mods .= ConfigManager.MapModifiers[up]
                continue
            }

            if RegExMatch(up, "^F([1-9]|1[0-9]|2[0-4])$") {
                key := up
                continue
            }

            if (StrLen(part) = 1) {
                key := part
                continue
            }

            key := part
        }

        return mods . key
    }
}

class ConfigWatcher {
    static LastModified := ""
    static TimerInterval := 1000
    static Cooldown := 1500
    static LastReload := 0

    static Start() {
        ConfigWatcher.LastModified := ConfigWatcher.GetTimestamp()
        SetTimer(ObjBindMethod(ConfigWatcher, "CheckForChanges"), ConfigWatcher.TimerInterval)
    }

    static GetTimestamp() {
        if !FileExist(ConfigManager.configPath)
            return ""
        return FileGetTime(ConfigManager.configPath, "M")
    }

    static CheckForChanges(*) {
        newTime := ConfigWatcher.GetTimestamp()
        if (newTime = "")
            return

        if (newTime != ConfigWatcher.LastModified)
        {
            now := A_TickCount
            if (now - ConfigWatcher.LastReload > ConfigWatcher.Cooldown) {
                ConfigWatcher.LastModified := newTime
                ConfigWatcher.LastReload := now
                ConfigWatcher.ReloadConfig()
            }
        }
    }

    static ReloadConfig() {
        TrayTip("配置已刷新", "config.ini 已重新加载并生效", Icon := 0)
        Reload()
    }
}
