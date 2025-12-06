#Requires AutoHotkey v2.0

class ConfigManager {
    static configPath := ""

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

        defaultCfg :=
        (
        "[Hotkeys]`n"
        "WinCycler=!```n"
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
        )

        FileAppend(defaultCfg, ConfigManager.configPath, "UTF-8-RAW")
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
