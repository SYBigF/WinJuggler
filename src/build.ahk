; =====================================================
; build.ahk — 自动编译脚本
; 编译 WinJuggler 主工程
; 用法: 双击运行即可
; =====================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; ======== 路径配置 ========
g_RootDir  := A_ScriptDir "\.."        ; 主目录 (WinJuggler 根目录)
g_OutDir   := g_RootDir "\release"
g_IconFile := g_RootDir "\assets\app.ico"
g_Ahk2Exe  := ""
g_AhkBase  := ""

; ======== 从 config/config.ini 读取工具路径 ========
try {
    g_Ahk2Exe := IniRead(g_RootDir "\config\config.ini", "General", "Ahk2ExePath")
    g_AhkBase := IniRead(g_RootDir "\config\config.ini", "General", "AhkBasePath")
}
if (g_Ahk2Exe = "Your Ahk2Exe.exe Path" || g_Ahk2Exe = "" || g_AhkBase = "Your AutoHotkey64.exe Path" || g_AhkBase = "") {
    MsgBox("❌ 请先在 config\config.ini 的 [General] 节中配置 Ahk2ExePath 和 AhkBasePath")
    ExitApp
}
if !FileExist(g_Ahk2Exe) {
    MsgBox("❌ 找不到 Ahk2Exe.exe，请检查 config.ini 中的 Ahk2ExePath`n" g_Ahk2Exe)
    ExitApp
}
if !FileExist(g_AhkBase) {
    MsgBox("❌ 找不到 AutoHotkey64.exe，请检查 config.ini 中的 AhkBasePath`n" g_AhkBase)
    ExitApp
}

DirCreate(g_OutDir)

total := 0
success := 0
failed := ""

; ---------- 编译主工程（带图标） ----------
outName := g_OutDir "\WinJuggler.exe"
total++
result := CompileAhk(g_RootDir "\src\WinJuggler.ahk", outName, g_IconFile)
if (result = "") {
    success++
} else {
    failed .= "WinJuggler.ahk`n"
}

; ---------- 复制配置文件（去掉编译用的 [General]） ----------
try {
    FileCopy(g_RootDir "\config\config.ini", g_OutDir "\config.ini", 1)
    IniDelete(g_OutDir "\config.ini", "General")
}

; ======== 结果报告 ========
summary := Format("编译完成！`n`n成功: {} / {}", success, total)
if (failed != "") {
    summary .= "`n`n失败:`n" failed
}
MsgBox(summary)
ExitApp

; ======== 编译函数 ========
CompileAhk(inFile, outFile, iconFile := "") {
    global g_Ahk2Exe, g_AhkBase

    if !FileExist(inFile)
        return "源文件不存在: " inFile

    try {
        cmd := Format('"{1}" /in "{2}" /out "{3}" /base "{4}"'
            , g_Ahk2Exe, inFile, outFile, g_AhkBase)

        if (iconFile != "" && FileExist(iconFile))
            cmd .= Format(' /icon "{1}"', iconFile)

        RunWait(cmd, , "Hide")

        if FileExist(outFile)
            return ""
        else
            return "输出文件未生成"
    } catch Error as e {
        return e.Message
    }
}
