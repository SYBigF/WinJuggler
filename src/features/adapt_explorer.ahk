#Requires AutoHotkey v2.0

class AdaptSpecialAPP {
    static isEmptySpecialAPP(exeName, hwnd) {
        if AdaptSpecialAPP.isEmptyTitelName(hwnd) ||
            AdaptExplorer.isEmptyExplorer(exeName, hwnd) || 
            AdaptWXWork.isEmptyWeMail(exeName, hwnd)
            return true
        else
            return false
    }

    static isEmptyTitelName(hwnd) {
        if WinGetTitle(hwnd) == ""
            return true
        else
            return false
    }

    static openFirstSpecialAPP(idList, exeName) {
        if AdaptExplorer.isExplorer(exeName) && 
            AdaptExplorer.opneFirstExplorer(idList, exeName)
                return true
        if AdaptWXWork.isWXWork(exeName) &&
            AdaptWXWork.callWXWorkFromBehind(idList, exeName)
                return true
        return false
    }
}

class AdaptExplorer {
    static isExplorer(exeName) {
    if exeName == "explorer.exe"
        return true
    else
        return false
    }

    static isEmptyExplorer(exeName, hwnd) {
        if AdaptExplorer.isExplorer(exeName) && (WinGetTitle(hwnd) = "" ||
            WinGetTitle(hwnd) = "Program Manager")
            return true
        else
            return false
    }

    static opneFirstExplorer(idList, exeName) {
        if AdaptExplorer.isExplorer(exeName) {
            emptyCount := 0
            for hwnd in idList {
                if AdaptExplorer.isEmptyExplorer(exeName, hwnd)
                    emptyCount := emptyCount + 1
            }
            if idList.Length == emptyCount
                return true
        }
        return false
    }
}

class AdaptWXWork {
    static isWXWork(exeName) {
        if exeName == "WXWork.exe"
            return true
        else
            return false
    }

    static callWXWorkFromBehind(idList, exeName) {
        if AdaptWXWork.isWXWork(exeName) {
            for hwnd in idList {
                if WinGetTitle(hwnd) == "企业微信"
                    return false
            }
        }
            return true
    }

    static isWeMail(exeName) {
        if exeName == "WeMail.exe"
            return true
        else
            return false
    }

    static isEmptyWeMail(exeName, hwnd) {
        if AdaptWXWork.isWeMail(exeName) && WinGetTitle(hwnd) = "WeMail" 
            return true
        else
            return false
    }
}