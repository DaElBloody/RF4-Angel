#singleinstance force
#Requires AutoHotkey v2.0

#Include Data/ShinsOverlayClass_v2.ahk

winTitle := 'ahk_exe rf4_x64.exe'

overlay := ShinsOverlayClass(winTitle, 0)

settimer(main, 10)

;========== SetKeys ===========

global KeyL := "PgDn"
global KeyR := "PgUp"

;==== Zeiten zum ändern ======

JiggTime := 500
JiggPause := 2500
TwitchTime := 350
TwitchPause := 1500
PilkTime := 500
PilkPause := 1500
randomRange := 50

;=============================

interval := 100

help := false
toggle1 := false
toggle2 := false
toggle3 := false
toggle4 := false
toggle5 := false
walk := false
toggleS := 0
newtime := 0
Count := 0
cook := false
PressTime := "off"
Pausetime := "off"

numon := false
menuon := false
;global numont := (numon = "1") ? "on" : "off"
;global menuont := (menuon = "1") ? "on" : "off"

main() {
    global
    numont := (walk = "1") ? "on" : "off"
    menuont := (help = "1") ? "on" : "off"
    global toggle1
    global toggle2
    global toggle3
    global toggle4
    global toggle5
    global Pausetime
    global PressTime

    if (overlay.BeginDraw())
    ;overlay.FillRectangle(overlay.realX +overlay.realWidth//2 -150,overlay.realY,300,30,0xAA000000)
        overlay.DrawText("Tastenbelegung: F1-Help " menuont " | F2-Jiggen | F3-Twitchen | F4-Pilken | F5-Einholen afk | F6-Einholen aktiv | F7-Autowalk " numont " | F8-Exit ",
            0, 10, 20, 0x39FF1, "Arial", "aCenter")

    ;if (toggle1)
    ;overlay.DrawText("Jig an: ", 0, 100, 20, 0xff0734, "Arial", "aCenter")
    if (toggle2) {
        overlay.DrawText("Jig an: ", 0, 100, 20, 0xff0734, "Arial", "aCenter")
        PressTime := JiggTime
        Pausetime := JiggPause
    }
    if (toggle3) {
        overlay.DrawText("Twitchen an: ", 0, 100, 20, 0xff0734, "Arial", "aCenter")
        PressTime := TwitchTime
        Pausetime := TwitchPause
    }
    if (toggle4) {
        overlay.DrawText("Pilken an: ", 0, 100, 20, 0xff0734, "Arial", "aCenter")
        PressTime := PilkTime
        Pausetime := PilkPause
    }
    if (toggle5)
        overlay.DrawText("Einholen an", 0, 100, 20, 0xff0734, "Arial", "aCenter")
    if (walk)
        overlay.DrawText("Autowalk an", 0, 120, 20, 0xff0734, "Arial", "aCenter")
    if (!toggle1 and !toggle2 and !toggle3 and !toggle4 and !toggle5)
        overlay.DrawText("Off", 0, 100, 20, 0x39FF14, "Arial", "aCenter")
    if (cook)
        overlay.DrawText("Loop an", 0, 120, 20, 0xff0734, "Arial", "aCenter")
    if (toggleS)
        overlay.DrawText("Shift an", 0, 140, 20, 0xff0734, "Arial", "aCenter")
    if (help) {
        overlay.DrawText("|| Str + ↑ Einholzeit erhöhen || Str + ↓ Einholzeit verringern ||", 0, 100, 20, 0xff0734,
            "Arial", "aCenter")
        overlay.DrawText("|| Str + → Pausenzeit erhöhen || Str + ← Pausenzeit verringern ||", 0, 120, 20, 0xff0734,
            "Arial", "aCenter")
        overlay.DrawText("|| F9 Reload Script ||", 0, 140, 20, 0xff0734, "Arial", "aCenter")
    }

    overlay.DrawText("Einholzeit: " PressTime, 0, 40, 20, 0x39FF14, "Arial", "aCenter")
    overlay.DrawText("Pausenzeit: " Pausetime, 0, 60, 20, 0x39FF14, "Arial", "aCenter")
    overlay.DrawText("Randomtime: " randomRange, 0, 80, 20, 0x39FF14, "Arial", "aCenter")

    overlay.EndDraw() ;must always call EndDraw() to finish drawing

   
    stateR := GetKeyState("RButton")
    if (stateR) {
        if !WinActive(winTitle)
            return
        SetTimer(DoRightClick, 0)
        SetTimer(DoLeftClickJigg, 0)
        SetTimer(DoLeftClickTwitch, 0)
        toggle2 := false
        toggle3 := false
        toggle4 := false

        if (toggle5) {
            toggle5 := false
            Send '{' KeyL '  up}'
        }
    }
    stateL := GetKeyState("LButton")
    if (stateL) {
        if !WinActive(winTitle)
            return
        SetTimer(DoRightClick, 0)
        SetTimer(DoLeftClickJigg, 0)
        SetTimer(DoLeftClickTwitch, 0)
        toggle2 := false
        toggle3 := false
        toggle4 := false

        if (toggle5) {
            toggle5 := false
            Send '{' KeyL '  up}'
        }
    }
}

F1:: {
    global help := !help
    global toggle1 := !toggle1
}

F2:: {
    global interval
    global toggle2 := !toggle2
    if (toggle2)
        SetTimer DoLeftClickJigg, interval
    else
        SetTimer DoLeftClickJigg, 0
}

F3:: {
    global toggle3 := !toggle3
    if (toggle3)
        SetTimer DoLeftClickTwitch, interval
    else
        SetTimer DoLeftClickTwitch, 0
}

F4:: {
    global interval
    global toggle4 := !toggle4
    if (toggle4)
        SetTimer DoRightClick, interval
    else
        SetTimer DoRightClick, 0
}

#HotIf WinExist(winTitle)
F5:: {
    global toggle5 := !toggle5
    if toggle5 {

        ControlClick "x100 y200", winTitle, , "Left", 1, "D"
    }
    else
        ControlClick "x100 y200", winTitle, , "Left", 1, "U"
}
#HotIf

F6:: {
    WinActivate (winTitle)
    global KeyL
    global toggle5 := !toggle5
    if toggle5 {
        Send '{' KeyL ' down}'
    }
    else
        Send '{' KeyL ' up}'
}

F7:: {
    global walk := !walk
    if walk
        Send "{W down}"
    else
        Send "{W up}"
}

F8:: ExitApp

#HotIf WinExist(winTitle)
DoRightClick() {
    static busy := false

    Presstime := Random(PilkTime - randomRange, PilkTime + randomRange)
    Pausetime := Random(PilkPause - randomRange, PilkPause + randomRange)

    if (busy) {
        ToolTip 'return'
        return
    }

    busy := true
    SetControlDelay(Presstime)
    ControlClick "x100 y200", winTitle, , "Right"
    Sleep Pausetime
    busy := false
}
#HotIf

#HotIf WinExist(winTitle)
DoLeftClickJigg() {
    static busy := false

    Presstime := Random(JiggTime - randomRange, JiggTime + randomRange)
    Pausetime := Random(JiggPause - randomRange, JiggPause + randomRange)

    if (busy) {
        ToolTip 'return'
        return
    }

    busy := true
    SetControlDelay(Presstime)
    ControlClick "x100 y200", winTitle, , "Left"
    Sleep Pausetime
    busy := false
}
#HotIf

#HotIf WinExist(winTitle)
DoLeftClickTwitch() {
    static busy := false

    Presstime := Random(JiggTime - randomRange, JiggTime + randomRange)
    Pausetime := Random(JiggPause - randomRange, JiggPause + randomRange)

    if (busy) {
        ToolTip 'return'
        return
    }

    busy := true
    SetControlDelay(Presstime)
    ControlClick "x100 y200", winTitle, , "Left"
    Sleep Pausetime
    busy := false
}
#HotIf

F9:: {
    ToolTip "🔄 Script wird neu geladen..."
    Sleep 500
    Reload
}

^Up:: {
    if (toggle2) {
        global JiggTime := JiggTime + 25
    }
    if (toggle3) {
        global TwitchTime := TwitchTime + 25
    }
    if (toggle4) {
        global PilkTime := PilkTime + 25
    }
}

^Down:: {
    if (toggle2) {
        global JiggTime := JiggTime - 25
        if (JiggTime < 25)
            JiggTime := 0
    }
    if (toggle3) {
        global TwitchTime := TwitchTime - 25
        if (TwitchTime < 25)
            TwitchTime := 0
    }
    if (toggle4) {
        global PilkTime := PilkTime - 25
        if (PilkTime < 25)
            PilkTime := 0
    }
}

^Right:: {
    if (toggle2) {
        global JiggPause := JiggPause + 25
    }
    if (toggle3) {
        global TwitchPause := TwitchPause + 25
    }
    if (toggle4) {
        global PilkPause := PilkPause + 25
    }
}

^Left:: {
    if (toggle2) {
        global JiggPause := JiggPause - 25
        if (JiggPause < 25)
            JiggPause := 0
    }
    if (toggle3) {
        global TwitchPause := TwitchPause - 25
        if (TwitchPause < 25)
            TwitchPause := 0
    }
    if (toggle4) {
        global PilkPause := PilkPause - 25
        if (PilkPause < 25)
            PilkPause := 0
    }
}
