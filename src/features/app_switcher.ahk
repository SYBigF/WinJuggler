#Requires AutoHotkey v2.0

class AppSwitcher {
    static Switch(exeName, exePath) {
        idList := WinGetList("ahk_exe " exeName)

        if idList.Length = 0 {
            AppSwitcher.open(exePath)
            return
        }

        try
            active := WinGetID("A")
        catch
            active := 0

        WinList := []
        for hwnd in idList {
            try {
                if !(WinGetStyle(hwnd) & 0x10000000)
                    continue
                if AdaptExplorer.checkExplorer(exeName, hwnd)
                    continue
                WinList.Push(hwnd)
            } catch {
                continue
            }
        }

        ArraySort(WinList)

        isActiveAppWin := ArrayIndexOf(WinList, active)

        if (isActiveAppWin) {
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

    static open(exePath) {
        Run exePath
    }

    static MakeSitchHandler(exeName, exePath) {
        return (*) => AppSwitcher.Switch(exeName, exePath)
    }

    static MakeOpenHandler(exePath) {
        return (*) => AppSwitcher.open(exePath)
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

        try
            hwnd := WinGetID("A")
        catch
            return

        if hwnd = AppWinFocuseRecorder.LastRecordedHwnd
            return

        try
            exeName := WinGetProcessName(hwnd)
        catch
            return

        if AdaptExplorer.checkExplorer(exeName, hwnd)
                return

        AppWinFocuseRecorder.LastRecordedHwnd := hwnd
        AppWinFocuseRecorder.LastFocused[exeName] := hwnd
    }
}