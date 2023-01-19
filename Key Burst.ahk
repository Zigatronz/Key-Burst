
; AHK v2.O-a138-7538f26f

#Include Lib\Config.ahk
#Include Lib\UI.ahk
#Include Lib\Burst.ahk

A_WorkingDir := A_ScriptDir
UI := MainUI()
global Burst := BurstObj()
global config := ConfigObj()
UI.Show()
Burst.Run()
return
