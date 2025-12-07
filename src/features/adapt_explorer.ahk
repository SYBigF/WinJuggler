#Requires AutoHotkey v2.0

class AdaptExplorer {
    static checkExplorer(exeName, hwnd) {
        if exeName && exeName == "explorer.exe" && (WinGetTitle(hwnd) = "" || WinGetTitle(hwnd) = "Program Manager")
            return true
        else
            return false
    }
}