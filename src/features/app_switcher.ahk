#Requires AutoHotkey v2.0

class AppSwitcher {
    static Switch(exeName, exePath) {
        idList := WinGetList("ahk_exe " exeName)

        if idList.Length = 0 {
            Run exePath
            return
        }

        try
            active := WinGetID("A")
        catch
            active := 0

        WinList := []
        for hwnd in idList {
            try {
                if WinGetStyle(hwnd) & 0x10000000
                    WinList.Push(hwnd)
            } catch {
                continue
            }
        }

        if WinList.Length = 0 {
            Run exePath
            return
        }

        ArraySort(WinList)

        try
            activeExe := WinGetProcessName(active)
        catch
            activeExe := ""

        if activeExe = exeName {
            AppWinFocuseRecorder.IsMinimizing := true
            for hwnd in WinList {
                try WinMinimize(hwnd)
            }
            Sleep 10
            AppWinFocuseRecorder.IsMinimizing := false
            return
        }

        if AppWinFocuseRecorder.LastFocused.Has(exeName) {
            last := AppWinFocuseRecorder.LastFocused[exeName]

            if ArrayIndexOf(WinList, last) {
                try
                    WinActivate(last)
                catch
                    WinActivate(WinList[1])
                return
            }
        }

        WinActivate(WinList[1])
    }

    static Open(exeName, exePath) {
        if !WinExist("ahk_exe " exeName) {
            Run exePath
        }
    }
}

class AppWinFocuseRecorder {
    static LastFocused := Map()
    static LastRecordedHwnd := 0
    static IsMinimizing := false

    static Init() {
        SetTimer(ObjBindMethod(AppWinFocuseRecorder, "RecordLastFocused"), 100)
    }

    static RecordLastFocused(*) {
        if AppWinFocuseRecorder.IsMinimizing
            return

        try hwnd := WinGetID("A")
        catch {
            return
        }

        if hwnd = AppWinFocuseRecorder.LastRecordedHwnd
            return

        AppWinFocuseRecorder.LastRecordedHwnd := hwnd

        try exe := WinGetProcessName(hwnd)
        catch {
            return
        }

        AppWinFocuseRecorder.LastFocused[exe] := hwnd
    }
}