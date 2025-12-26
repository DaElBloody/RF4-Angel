#SingleInstance, force
#Include Data/shinsoverlayclass.ahk

SetWorkingDir %A_ScriptDir%

RF4_window := "ahk_exe rf4_x64.exe"

overlay := new ShinsOverlayClass(RF4_window)

; Basiswert in Millisekunden
pressTime := 500 ; 0,5 Sekunden
extendPause :=  500   ; 0 Sekunden
randomRange := 50    ; maximale Abweichung (+/- ms)

JiggTime := 1650
TwitchTime := 350
PilkTime := 1000

running := false      ; Loop-Status
toggle := false
toggle1 := true
toggle2 := false
settimer, main, 10
Count := 0
cook := false
spot1X := 0
spot1Y := 0

main:
    if (overlay.BeginDraw())
    {
        ;overlay.FillRectangle(overlay.realX +overlay.realWidth//2 -150,overlay.realY,300,30,0xAA000000)
        overlay.DrawText("Tastenbelegung: F1-Menu on/off | F2-Jiggen | F3-Einholen | F4-Twitchen | F5-Pilken | F6-Display on/off | F7-Exit | Ende-Autowalk" ,0,10,20,0x39FF1, "Arial", "aCenter")
        overlay.DrawText("Einholzeit: " + pressTime,0,40,20,0x39FF14, "Arial", "aCenter")
        overlay.DrawText("Pausenzeit: " + extendPause,0,60,20,0x39FF14, "Arial", "aCenter")
        overlay.DrawText("Randomtime: " + randomRange,0,80,20,0x39FF14, "Arial", "aCenter")

        if (running)
            overlay.DrawText("Jig an: " Newtime,0,100,20,0xff0734, "Arial", "aCenter")
        if (toggle)
            overlay.DrawText("Einholen an",0,100,20,0xff0734, "Arial", "aCenter")
        if (toggle2)
            overlay.DrawText("Spinning an: " Newtime,0,100,20,0xff0734, "Arial", "aCenter")
        if (toggle3)
            overlay.DrawText("Pilken an: " Newtime,0,100,20,0xff0734, "Arial", "aCenter")
        if (!toggle and !running and !toggle2 and !toggle3)
            overlay.DrawText("Off",0,100,20,0x39FF14, "Arial", "aCenter")
        if (cook)
            overlay.DrawText("Loop an",0,120,20,0xff0734, "Arial", "aCenter")
        if (walk)
            overlay.DrawText("Autowalk an",0,120,20,0xff0734, "Arial", "aCenter")

        overlay.EndDraw() ;must always call EndDraw() to finish drawing

    }
return

MenuUI:
    Gui, Main:New
    Gui +AlwaysOnTop
    Gui, Main:Font, s8 bold, Tahoma
    Gui, Main:Add, Text, x20 y20 w120 h20 , Jigging Time
    Gui, Main:Add, Button, x120 y20 w80 h15 gsetJig, Set Time
    Gui, Main:Add, Edit, x20 y35 w200 h20 Center vjig, %JiggTime%
    Gui, Main:Add, Text, x20 y60 w120 h20, Twitch Time
    Gui, Main:Add, Button, x120 y60 w80 h15 gsetTwitch, Set Time
    Gui, Main:Add, Edit, x20 y75 w200 h20 Center vtwitch, %TwitchTime%
    Gui, Main:Add, Text, x20 y100 w120 h20, Pilk Time
    Gui, Main:Add, Button, x120 y100 w80 h15 gsetPilk, Set Time
    Gui, Main:Add, Edit, x20 y115 w200 h20 Center vpilk, %PilkTime%
    Gui, Main:Add, Text, x20 y140 w120 h20, Pause Time
    Gui, Main:Add, Button, x120 y140 w80 h15 gsetPause, Set Time
    Gui, Main:Add, Edit, x20 y155 w200 h20 Center vpauseui, %extendPause%
    Gui, Main:Add, Text, x20 y195 w120 h20, PositionX: %spot1X%
    Gui, Main:Add, Text, x20 y207 w120 h20, PositionY: %spot1Y%
    Gui, Main:Add, Text, x20 y220 w120 h20, Key to Start: Pos1
    Gui, Main:Add, Button, x120 y195 w80 h40 gsetClick, Set Click Position
    
    Gui, Main:Show, , RF4 Tool
Return

setJig:
    GuiControlGet, jig,Main:
    JiggTime := jig
    Gui, Main:Destroy
    sleep 100
    Gosub, MenuUI
Return

setTwitch:
    GuiControlGet, twitch,Main:
    TwitchTime := twitch
    Gui, Main:Destroy
    sleep 100
    Gosub, MenuUI
Return

setPilk:
    GuiControlGet, pilk,Main:
    PilkTime := pilk
    Gui, Main:Destroy
    sleep 100
    Gosub, MenuUI
Return

setPause:
    GuiControlGet, pauseui,Main:
    extendPause := pauseui
    Gui, Main:Destroy
    sleep 100
    Gosub, MenuUI
Return

setClick:
    ToolTip , Click on the first spot...
    KeyWait, LButton, D
    MouseGetPos, spot1X, spot1Y
    Sleep 200
    ToolTip , Spots selection completed, press F4 to start fishing!
    SetTimer, RemoveToolTip, -2500
Return

; -----------------------------
; Toggle Schleife mit F2
; -----------------------------
F1::
    menuon := !menuon
    if (menuon)
        Gosub, MenuUi
    Else
        Gui, Main:Destroy

Return

~F2::
    if (toggle2){
        SetTimer, PressLoop2, Off
        toggle2 := false
    }
    running := !running
    if (running) {
        pressTime := JiggTime
        SetTimer, StopTimer, 100
        SetTimer, PressLoop, %pressTime%

        ;ToolTip, Timer gestartet (%pressTime% ms ± %randomRange% ms)
    } else {
        SetTimer, PressLoop, Off
        ;ToolTip, Timer gestoppt
    }
    if(toggle)
        toggle := false
;SetTimer, RemoveToolTip, -1500
return

~F3::
    if (running){
        SetTimer, PressLoop, Off
        running := false
    }
    if (toggle2){
        SetTimer, PressLoop2, Off
        toggle2 := false
    }
    toggle := !toggle
    if (toggle) {
        ; Taste gedrückt halten
        Send, {PgDn down}
        ;ToolTip, Einholen an.
    } else {
        ; Taste loslassen
        Send, {PgDn up}
        ;ToolTip, Einholen aus.
    }
Return

F4::
    if (running){
        SetTimer, PressLoop, Off
        running := false
    }
    toggle2 := !toggle2
    if (toggle2) {
        pressTime := TwitchTime
        SetTimer, StopTimer, 100
        SetTimer, PressLoop2, %pressTime%
        ;ToolTip, Timer gestartet (%pressTime% ms ± %randomRange% ms)
    } else {
        SetTimer, PressLoop2, Off

        ;ToolTip, Timer gestoppt
    }
    if(toggle)
        toggle := false
Return

F5::
    if (running){
        SetTimer, PressLoop, Off
        running := false
    }
    toggle3 := !toggle3
    if (toggle3) {
        pressTime := PilkTime
        SetTimer, StopTimer, 100
        SetTimer, PressLoop3, %pressTime%
        ;ToolTip, Timer gestartet (%pressTime% ms ± %randomRange% ms)
    } else {
        SetTimer, PressLoop3, Off

        ;ToolTip, Timer gestoppt
    }
    if(toggle)
        toggle := false
Return

; -----------------------------
; Die Schleifenaktion
; -----------------------------
PressLoop:
    ; Zufällige Haltezeit berechnen
    Random, holdTime, % pressTime - randomRange, % pressTime + randomRange
    if (holdTime < 50)
        holdTime := 50

    ; Zufällige Pausenzeit berechnen
    Random, pauseTime, % pressTime - randomRange, % pressTime + randomRange
    if (pauseTime < 50)
        pauseTime := 50

    ; Taste halten
    Send, {PgDn down}
    Sleep, %holdTime%
    Send, {PgDn up}

    ; Pause nach dem Halten
    Newtime := pauseTime + extendPause
    Sleep, %Newtime%
;ToolTip, %Newtime%
;SetTimer, RemoveToolTip, -1500
return

PressLoop2:
    ; Zufällige Haltezeit berechnen
    Random, holdTime2, % pressTime - randomRange, % pressTime + randomRange

    ; Zufällige Pausenzeit berechnen
    Random, pauseTime2, % extendPause - randomRange, % extendPause + randomRange

    ; Taste halten
    Send, {PgDn down}
    Sleep, %holdTime2%
    Send, {PgDn up}

    Newtime := pauseTime2
    Sleep, %Newtime%
return

PressLoop3:
    ; Zufällige Haltezeit berechnen
    Random, holdTime2, % pressTime - randomRange, % pressTime + randomRange

    ; Zufällige Pausenzeit berechnen
    Random, pauseTime2, % extendPause - randomRange, % extendPause + randomRange

    ; Taste halten
    Send, {PgUp down}
    Sleep, %holdTime2%
    Send, {PgUp up}

    Newtime := pauseTime2
    Sleep, %Newtime%
return

StopTimer:
    GetKeyState, state, RButton
    if(state = "D")
    {
        SetTimer, PressLoop, Off
        if (running)
            JiggTime := pressTime
        running := false

        SetTimer, PressLoop2, Off
        if (toggle2)
            TwitchTime := pressTime
        toggle2 := false

        SetTimer, PressLoop3, Off
        if (toggle3)
            PilkTime := pressTime
        toggle3 := false
    }
    GetKeyState, state, LButton
    if(state = "D")
    {
        SetTimer, PressLoop, Off
        if (running)
            JiggTime := pressTime
        running := false

        SetTimer, PressLoop2, Off
        if (toggle2)
            TwitchTime := pressTime
        toggle2 := false

        SetTimer, PressLoop3, Off
        if (toggle3)
            PilkTime := pressTime
        toggle3 := false
    }

return

; -----------------------------
; Basiszeit erhöhen (Strg + Pfeil hoch)
; -----------------------------
^Up::
    pressTime += 25
;ToolTip, Basisdauer: %pressTime% ms ± %randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; Basiszeit verringern (Strg + Pfeil runter)
; -----------------------------
^Down::
    pressTime -= 25
    if (pressTime < 25)
        pressTime := 25
;ToolTip, Basisdauer: %pressTime% ms ± %randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; Basiszeit erhöhen (Alt+ Pfeil hoch)
; -----------------------------
!Up::
    pressTime += 100

return

!Down::
    pressTime -= 100
    if (pressTime < 100)
        pressTime := 0
return

; -----------------------------
; Basiszeit erhöhen (Alt + Pfeil hoch)
; -----------------------------
!Right::
    randomRange += 25
;ToolTip, Abweichung: ±%randomRange% ms
;SetTimer, RemoveToolTip, -1500
;ToolTip, Abweichung: ±%randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; Basiszeit verringern (Alt + Pfeil runter)
; -----------------------------
!Left::
    randomRange -= 25
    if (randomRange < 0)
        randomRange := 0
;ToolTip, Abweichung: ±%randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

; -----------------------------
; Random-Abweichung einstellen (Strg + Pfeil links/rechts)
; -----------------------------
^Left::
    extendPause -= 100
    if (extendPause < 50)
        extendPause := 50
;ToolTip, Pausendauer: %extendPause% ms ± %randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

^Right::
    extendPause += 100
;ToolTip, Pausendauer: %extendPause% ms ± %randomRange% ms
;SetTimer, RemoveToolTip, -1500
return

^R::
    Reload
Return

; -----------------------------
; Tooltip ausblenden
; -----------------------------
RemoveToolTip:
    ToolTip
return

; -----------------------------
; Skript komplett beenden mit ESC
; -----------------------------
F7::ExitApp

~Numpad0::
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~1::
    running := false
    toggle := false1
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~Numpad1::
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
        Send, 1
    }
    running := false
    toggle := false1
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~!Numpad1::
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
        Send, 1
    }
    running := false
    toggle := false1
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    sleep, 500
    Send, {Shift Down}
    sleep 50
    Send, {PgDn Down}
    Sleep, 500
    Send, {Shift Up}
    ;Send, ^{Click Right}
    Send, {PgDn up}
return

~2::
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~Numpad2::
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
        Send, 2
    }
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~3::
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~Numpad3::
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
        Send, 3
    }
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    Send, {PgDn up}
;ToolTip, Stop.
return

~!Numpad3::
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
        Send, 3
    }
    running := false
    toggle := false
    toggle2 := false
    SetTimer, PressLoop, Off
    SetTimer, PressLoop2, Off
    sleep, 500
    Send, {Shift Down}
    sleep 50
    Send, {PgDn Down}
    Sleep, 500
    Send, {Shift Up}
    ;Send, ^{Click Right}
    Send, {PgDn up}
;ToolTip, Stop.
return

F6::
    toggle1 := !toggle1
    if (toggle1) {
        settimer,main,10
    } else {
        settimer,main,off
        overlay.BeginDraw()
        overlay.EndDraw()
    }
return

End::
    walk := !walk
    if (walk)
        Send {W down}
    Else
        Send {W up}
Return

Home::
    settimer, looper, % (cook:=!cook) ? 2450 : "off"
return

looper:
    If (!WinActive RF4_window)
    {
        WinActivate, %RF4_window%
    }
    MouseMove, spot1X, spot1Y
    MouseClick, Left, spot1X, spot1Y
    sleep 2300
    Send, {Space}
    sleep 100
Return

