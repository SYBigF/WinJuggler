#Requires AutoHotkey v2.0

class WinCycler {
    static LastIndex := Map()

    static Cycle() {
        activeHwnd := WinGetID("A")
        if !activeHwnd
            return

        exeName := WinGetProcessName(activeHwnd)
        idList := WinGetList("ahk_exe " exeName)

        WinList := []
        for hwnd in idList {
            if !(WinGetStyle(hwnd) & 0x10000000)
                continue
            if WinGetTitle(hwnd) = "" || WinGetTitle(hwnd) = "Program Manager"
                continue
            WinList.Push(hwnd)
        }

        if WinList.Length < 2
            return

        ArraySort(WinList)

        if !WinCycler.LastIndex.Has(exeName)
            WinCycler.LastIndex[exeName] := 1

        idx := ArrayIndexOf(WinList, activeHwnd)
        if idx
            WinCycler.LastIndex[exeName] := idx + 1

        if WinCycler.LastIndex[exeName] > WinList.Length
            WinCycler.LastIndex[exeName] := 1

        target := WinList[WinCycler.LastIndex[exeName]]
        WinCycler.LastIndex[exeName]++

        WinActivate(target)
    }
}
