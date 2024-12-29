    #NoEnv 
    #SingleInstance, Force
    #Persistent
    #InstallKeybdHook
    #UseHook
    #KeyHistory, 0
    #HotKeyInterval 1
    #MaxHotkeysPerInterval 127
    traytip,
    SetKeyDelay, -1, 1
    SetControlDelay, -1
    SetMouseDelay, -1
    SetWinDelay, -1
    SendMode, InputThenPlay
    SetBatchLines, -1
    ListLines, Off
    CoordMode, Pixel, Screen, RGB
    CoordMode, Mouse, Screen 
    PID := DllCall("GetCurrentProcessId")
    Process, Priority, %PID%, High
     
    ; Random number generator function
    GetRandom(min, max) {
        Random, output, %min%, %max%
        return output
    }
     
    RandomDelay(min, max) {
        Random, delay, %min%, %max%
        Sleep, delay
    }
     
    ImpreciseMove(value) {
        Random, offset, -1, 1
        return value + offset
    }
     
    ; --- Global Variables ---
    global CrosshairVisible := false    ; Tracks whether the crosshair overlay is visible
    global CrosshairType := "Green Crosshair"  ; Default crosshair type selected
     
    ; --- Global Variables for FOV Overlay ---
    global showOverlay := false          ; Tracks whether the FOV overlay is visible
    global overlaySize := 400            ; Default overlay size (for testing, can be dynamically adjusted)
    global overlayType := "Circle"      ; Default overlay shape ("Circle" or "Square")
    global OverlayHwnd := 0             ; Initialize variable for overlay window handle (Hwnd)
    global OverlayPic := 0              ; Initialize variable for overlay picture control handle (Hwnd)
     
    ; Crosshair GUI Variables
    global CrosshairHwnd               ; Handle for the crosshair overlay GUI window
    global CrosshairHwndPic            ; Handle for the crosshair image (if needed)
     
    ; Declare variables
    monitorCount := 0
    monitorLeft := 0
    monitorTop := 0
    monitorRight := 0
    monitorBottom := 0
     
    iniFile := A_ScriptDir "\settings.ini"
     
    global ZombieCheckmark  ; Declare as global
     
    TargetOffsetX := 0
    TargetOffsetY := 0
    HipFireStrength := 1  ; Adjust based on user settings or GUI control
    lastTargetX := 0
    lastTargetY := 0
    TargetSwitchThreshold := 5  ; Example distance threshold (adjust as needed)
    TriggerbotDistance := 100  ; Example distance for Triggerbot activation
    TriggerbotDelay := 50      ; Delay in ms (adjust to suit your needs)
     
    ; Initialize variables
    triggerActive := false
    paused1 := false
    TriggerBotStatus := "Off"
     
    ; Initialize a variable to track if the GUI is resizable
    isResizable := false
     
    ; Main Settings
    EMCol := 0x43FF00  ; Target color
    ColVn := 50  ; Tolerance for color matching
    ZeroX := A_ScreenWidth / 2  ; Universal resolution
    ZeroY := A_ScreenHeight / 2.18  ; Universal resolution
    CFovX := 78  ; Field of view X
    CFovY := 78  ; Field of view Y
    ScanL := ZeroX - CFovX
    ScanT := ZeroY - CFovY
    ScanR := ZeroX + CFovX
    ScanB := ZeroY + CFovY
    SearchArea := 40  ; Search area around last known position
    SearchArea2 := 50  ; Search area around last known position
     
    ; Variables for prediction
    prevX := 0
    prevY := 0
    lastTime := 0
    smoothing := 0.09  ; Default smoothing value
    predictionMultiplier := 2.5  ; Default prediction multiplier
     
    ; Initialize flags
    isReloading := False
    lastReloadTime := 0
    reloadCooldown := 500 ; Adjust cooldown as needed
     
    ; Target dot settings Zombie Aim snappy checkbox
    LastColor6 := ""  ; Keep track of the last color to check if it changed
    EMCol6 := 0xDF00FF      ; Color of purple diamond
    ColVn6 := 25            ; Tolerance for color match
    ZeroX6 := 955           ; Central aim point
    ZeroY6 := 500           ; Center Y coordinate of aim area
    CFovX6 := 200           ; Field of view width
    CFovY6 := 200           ; Field of view height
    ScanL6 := ZeroX6 - CFovX6
    ScanT6 := ZeroY6 - CFovY6
    ScanR6 := ZeroX6 + CFovX6
    ScanB6 := ZeroY6 + CFovY6
     
    targetX6 := 0
    targetY6 := 0
    toggle6 := false
    Paused6 := false
    EnableAimLoop6State := 0
    targetFound6 := false  ; Initialize targetFound6 here
     
    ; Offset for final aim position relative to the purple diamond
    OffsetX6 := 45    ; Offset right
    OffsetY6 := 50    ; Offset down
     
    ; Zombie Less Sticky settings
    EMCol8 := 0xDF00FF      ; Color of purple diamond
    ColVn8 := 25            ; Tolerance for color match
    ZeroX8 := 955           ; Central aim point
    ZeroY8 := 500           ; Center Y coordinate of aim area
    CFovX8 := 200           ; Field of view width
    CFovY8 := 200           ; Field of view height
    ScanL8 := ZeroX8 - CFovX8
    ScanT8 := ZeroY8 - CFovY8
    ScanR8 := ZeroX8 + CFovX8
    ScanB8 := ZeroY8 + CFovY8
     
    targetX8 := 0
    targetY8 := 0
    toggle8 := false
    Paused8 := false
     
    ; Aim settings
    ZeroXs := A_ScreenWidth / 2.08
    ZeroYs := A_ScreenHeight / 2.18	
    CFovXXs := 40
    CFovYYs := 120
    ScanLs1 := ZeroXs - CFovXXs
    ScanTs1 := ZeroYs - CFovYYs
    ScanRs1 := ZeroXs + CFovXXs
    ScanBs1 := ZeroYs + CFovYYs
     
    toggle1s := false
    Paused1s := false
     
    randX := 0
    randY := 0
    AntiDetectionStrength := 5  ; Adjust this to control how much randomization occurs
     
    ; Offset for final aim position relative to the purple diamond
    OffsetX8 := 45    ; Offset right
    OffsetY8 := 50    ; Offset down
     
    ; Target dot settings
    EMCol9 := 0xEA00FF  
    ColVn9 := 25
    ZeroX9 := A_ScreenWidth / 2.08
    ZeroY9 := A_ScreenHeight / 2.19
    CFovX9 := 120
    CFovY9 := 120
    ScanL9 := ZeroX9 - CFovX9
    ScanT9 := ZeroY9 - CFovY9
    ScanR9 := ZeroX9 + CFovX9
    ScanB9 := ZeroY9 + CFovY9
     
    targetX9 := 0
    targetY9 := 0
    toggle9 := false
    Paused9 := false
     
     
    ; Default Settings for Recoil, Speed, and FOV
    RecoilIntensity := 50  ; Default recoil intensity
    NoRecoilSpeed := 20    ; Default speed for no recoil
    FOVValue := CFovX      ; Initialize FOV with the main FOV value
     
    ZeroX3 := A_ScreenWidth / 2.08
    ZeroY3 := A_ScreenHeight / 2.18	
    CFovXX3 := 40
    CFovYY3 := 120
    ScanL3 := ZeroX3 - CFovXX3
    ScanT3 := ZeroY3 - CFovYY3
    ScanR3 := ZeroX3 + CFovXX3
    ScanB3 := ZeroY3 + CFovYY3
     
    OverlayHwnd := 0  ; Initialize variable for overlay handle
    CrosshairVisible := false
    showOverlay := false
    overlaySize := 400  ; Set a fixed size for testing
    overlayType := "Circle"  ; Set a type for testing (or "Square")
     
    ; Rapid Fire Variables
    RapidFireEnabled := False
    NoRecoilEnabled := False
    action := 0 
    meleeSpamTime := 0
    direction := 0
     
    ; Additional Feature Variables
    AutoSprintEnabled := false
    FastReloadEnabled := false
    QuickScopeEnabled := false
    AntiAimEnabled := false
    HitboxCycleEnabled := false
    AutoReloadEnabled := false
    AutoCrouchEnabled := false
    BunnyHopEnabled := false
    JumpShotEnabled := false
    DropShotEnabled := false
    DropShot2Enabled := false
    CrouchShotEnabled := false
    HoldBreathEnabled := false
    SniperBreathEnabled := false
    AntiAFKEnabled := false
    JitterEnabled := false
    AutoDropEnabled := false 
    AutoStrafeEnabled := false
    MeleeSpamEnabled := false 
    AutoCrouchProneEnabled := false 
    JoshTriggerBotEnabled := false
     
    ; GUI Window
    Gui, +AlwaysOnTop +ToolWindow +E0x20 ; Mouse-through transparency
    Width := 495
    Height := 500
    WinSet, Transparent, 20, ; Transparency of GUI
    Gui, Color, 880808  ; Background color of GUI
    Opacity := 50  ; 20% opacity (range 0-255)
     
    ; GUI Title
    Gui, Font, s7 cD0D0D0 Bold
    Gui, Add, Progress, % "x-1 y-1 w" (Width+110) " h30 Background000000 Disabled hwndHPROG"
    Control, ExStyle, -0x20000, , ahk_id %HPROG%
    Gui, Add, Text, % "x0 y3 w" Width " h15 BackgroundTrans Center 0x550 vCaption gGuiMove", Treason's BO6 Color Aim V3.1 Edit
     
    ; Set transparency level for the GUI window only
    Gui, Show, % "w" Width " h" Height " NA" " x" (A_ScreenWidth - Width) "x0 y500"
    WinSet, Transparent, %Opacity%, ahk_id %hGui%  ; Only make GUI transparent
     
     
    ; Create Tabs
    Gui, Add, Tab2, vMyTabs w500 h650 x0 y30, Main|Sliders and Toggles|Advanced Features|Misc|Extras|Dev|Customize|Settings
     
    ; ---------------- Main Tab ----------------
    Gui, Tab, Main
    Gui, Font, s6
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Main Options
     
    ; Checkboxes with Green Tick
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-275) "r1 vEnableCheckbox gUpdateStatus", ENABLE MULTIPLAYER AIM (F6)
    Gui, Add, Text, x+5 w10 h10 vEnableCheckmark Hidden, X
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-275) "r1 vEnablePredictionCheckbox gUpdateStatus", ENABLE PREDICTION (HOME)
    Gui, Add, Text, x+5 w10 h10 vPredictionCheckmark Hidden, X
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-275) "r1 vEnableAimLoop6 gToggleAimLoop6 gUpdateStatus", ENABLE ZOMBIES AIM (DELETE)
    Gui, Add, Text, x+5 w10 h10 vZombieCheckmark Hidden, X
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-275) "r1 vEnable2Checkbox gToggleEnable2 gUpdateStatus", ENABLE SAI V2 AIM - MULTI
    Gui, Add, Text, x+5 w10 h10 vEnable2Checkmark Hidden, X
     
    ; Add tip label
    Gui, Add, Text, % "x190 y72 w" (Width-14) "r1 c00FF00", ZOMBIES SUPPORTS ADV + EXTRA FEATURES NATIVELY NOW!
    Gui, Add, Button, % "x287 y100 w120 h20 gOpenInstructions", Instructions / Tips
    Gui, Add, Button, % "x290 y130 w100 h20 gOpenHotkeys", HOTKEYS / Tips
     
    ; GUI Color Picker Section
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Target Color (Hex)
    Gui, Add, Edit, % "x8 y+5 w80 r1 vColorHex gUpdateColor", % Format("{:X}", EMCol & 0xFFFFFF)
    GuiControl, +ToolTip, ColorHex, Set target color (click Pick Color to choose)
     
    ; Button to submit the color input
    Gui, Add, Button, % "x+8 y+7 w100 h30 gSubmitColor", Set Color
    GuiControl, +ToolTip, SubmitColor, Submit the color input from the box
     
    ; Second GUI Color Picker Section for Zombies Aim
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Zombie Target Color (Hex)
    Gui, Add, Edit, % "x8 y+5 w80 r1 vZombieColorHex gUpdateZombieColor6", % Format("{:X}", EMCol6 & 0xFFFFFF)  ; Same initial color or a different one if needed
    GuiControl, +ToolTip, ZombieColorHex, Set zombie target color (click Set Zombie Color to choose)
     
    ; Button to submit the zombie color input
    Gui, Add, Button, % "x+8 y+7 w100 h30 gSubmitZombieColor6", Set Zombie Color
    GuiControl, +ToolTip, SubmitZombieColor, Submit the color input from the box
     
    Gui, Add, Text, % "x7 y+10 w" (Width-275) "r1", Current ZeroY Value:
    Gui, Add, Text, % "x+1 w70 r1 vZeroYLabel", % ZeroY
     
    ; Smoothing Control
    Gui, Add, Text, % "x7 y+10 w" (Width-300) "r1", Smoothing (Default is 0.09)
    Gui, Add, Text, % "x+m w" (Width-275) "r1 vSmoothingValue", %smoothing%
    Gui, Add, Button, % "x7 y+5 w" (Width-375) "r1 +0x4000 gDecreaseSmoothing", -
    Gui, Add, Button, % "x+2+m w" (Width-375) "r1 +0x4000 gIncreaseSmoothing", +
     
    ; Prediction Multiplier Control
    Gui, Add, Text, % "x7 y+10 w" (Width-300) "r1", Prediction Multiplier
    Gui, Add, Text, % "x+m w" (Width-275) "r1 vPredictionValue", %predictionMultiplier%
    Gui, Add, Button, % "x7 y+5 w" (Width-375) "r1 +0x4000 gDecreasePrediction", -
    Gui, Add, Button, % "x+2+m w" (Width-375) "r1 +0x4000 gIncreasePrediction", +
     
    ; Color Tolerance Control
    Gui, Add, Text, % "x7 y+10 w" (Width-300) "r1", Color Tolerance
    Gui, Add, Text, % "x+m w" (Width-275) "r1 vToleranceValue", %ColVn%
    Gui, Add, Button, % "x7 y+5 w" (Width-375) "r1 +0x4000 gDecreaseTolerance", -
    Gui, Add, Button, % "x+2+m w" (Width-375) "r1 +0x4000 gIncreaseTolerance", +
     
    ; Target Location
    Gui, Add, Text, % "x7 y+10 w" (Width-300) "r1", Target Location
    Gui, Add, Button, % "x7 y+5 w" (Width-375) "r1 +0x4000 gHeadshotsButton", Head
    Gui, Add, Button, % "x+2+m w" (Width-375) "r1 +0x4000 gChestButton", Chest
    Gui, Add, Button, % "x7 y+5 w" (Width-375) "r1 +0x4000 gBellyButton", Belly
    Gui, Add, Button, % "x+2+m w" (Width-375) "r1 +0x4000 gFeetButton", Feet
     
    ; Finish Main Tab
     
    ; ---------------- Sliders and Toggles Tab ----------------
    Gui, Tab, Sliders and Toggles
     
    ; Rapid Fire Toggle with Indicator
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Rapid Fire Toggle
    Gui, Add, Button, % "x3 y+8 w" (Width-300) "r1 gToggleRapidFire", Toggle
    Gui, Add, Text, % "x7 y+5 w" (Width-14) "r1 vRapidFireStatus c00FF00", ; Indicator for rapid fire
     
    ; No Recoil Intensity Control
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", No Recoil Intensity
    Gui, Add, Slider, % "x7 y+5 w" (Width-40) "h20 r1 Range0-100 vRecoilIntensity gUpdateRecoilIntensity Background880808", 50  ; Set background color
    Gui, Add, Text, % "x+10 w50 r1 vCurrentRecoilIntensity", 50  ; Display current intensity
     
    ; No Recoil Speed Control
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", No Recoil Speed
    Gui, Add, Slider, % "x7 y+5 w" (Width-40) "h20 r1 Range1-100 vNoRecoilSpeed gUpdateNoRecoilSpeed Background880808", 20  ; Set background color
    Gui, Add, Text, % "x+10 w50 r1 vCurrentNoRecoilSpeed", 20  ; Display current speed
     
    ; No Recoil Toggle
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", No Recoil Toggle
    Gui, Add, Button, % "x3 y+8 w" (Width-300) "r1 gToggleNoRecoil", Toggle
    Gui, Add, Text, % "x7 y+5 w" (Width-14) "r1 vNoRecoilStatus c00FF00", ; Indicator for no recoil
     
    ; FOV Control Slider
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Field of View (FOV)
    Gui, Add, Slider, % "x7 y+5 w" (Width-40) "h20 r1 Range30-180 vFOVValue gUpdateFOV Background880808", %CFovX%
    Gui, Add, Text, % "x+10 w50 r1 vCurrentFOV", %CFovX%  ; Display current FOV
    GuiControl, +ToolTip, FOVValue, Adjust the Field of View
     
    ; FOV Overlay Toggle Button and Dropdown for overlay type
    Gui, Add, Button, % "x7 y+20 w50 h30 gToggleFOVOverlay", Toggle FOV Overlay
    GuiControl, +ToolTip, ToggleFOVOverlay, Show or hide the FOV overlay
    Gui, Add, DropDownList, % "x+10 y+5 w100 vOverlayType gUpdateOverlayType", Circle|Square
    GuiControl, +ToolTip, OverlayType, Select the type of FOV overlay
     
    Gui, Add, Button, % "x7 y+20 w50 h30 gToggleCrosshair", Toggle Crosshair Overlay
    GuiControl, +ToolTip, ToggleCrosshair, Show or hide the crosshair overlay
    Gui, Add, DropDownList, % "x+10 y+5 w100 vCrosshairType gUpdateCrosshairType", Green Crosshair|Circle|Square
    GuiControl, +ToolTip, CrosshairType, Select the type of crosshair
     
    ; Finish Sliders and Toggles Tab
     
    ; ---------------- Advanced Features Tab ----------------
    Gui, Tab, Advanced Features
     
    ; Advanced Feature Toggles Section
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Advanced Feature Toggles
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAntiAim gToggleAntiAim", Anti-Aim
    GuiControl, +ToolTip, EnableAntiAim, Toggle anti-aim mode 
     
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableHitboxCycle gToggleHitboxCycle", Cycle Hitbox
    GuiControl, +ToolTip, EnableHitboxCycle, Toggle hitbox cycling 
     
    ; Anti-AFK Feature Checkbox
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAntiAFK gToggleAntiAFK", Anti-AFK
    GuiControl, +ToolTip, EnableAntiAFK, Prevents being marked as AFK by simulating random movements
     
    ; Keyboard & Mouse Enhancements
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Keyboard Enhancements
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAutoReload gToggleAutoReload", Auto Reload
    GuiControl, +ToolTip, EnableAutoReload, Toggle automatic reloading
     
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAutoCrouch gToggleAutoCrouch", Auto Crouch
    GuiControl, +ToolTip, EnableAutoCrouch, Toggle automatic crouching
     
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAutoDrop gToggleAutoDrop", Auto Drop
    GuiControl, +ToolTip, EnableAutoDrop, Toggle automatic dropping
     
    ; Additional Features Text
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Additional Features
     
    ; Additional Features Toggle
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableDropShot gToggleDropShot", Drop Shot
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableJumpShot gToggleJumpShot", Jump Shot
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableDropShot2 gToggleDropShot2", Drop Shot 2
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableCrouchShot gToggleCrouchShot", Crouch Shot
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableHoldBreath gToggleHoldBreath", Hold Breath
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableJitter gToggleJitter", Jitter
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableSniperBreath gToggleSniperBreath", Sniper Breath
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAutoSprint gToggleAutoSprint", Auto Sprint
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableFastReload gToggleFastReload", Fast Reload
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableQuickScope gToggleQuickScope", Quick Scope
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableBunnyHop gToggleBunnyHop", Bunny Hop
     
    ; Extra Aims Text
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Extra Aims (See Hotkeys + Tips)
     
    ; Extra Aims Toggle
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAimLoop8 gToggleAimLoop8", Enable Zombie Aim V2 Less Sticky (PgUp Key)
    Gui, Add, Text, x+10 w10 h10 vZombieCheckmark3 Hidden, ✔  ; Hidden checkmark for Zombie Aim V2
     
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAimLoop9 gToggleAimLoop9", Enable Zombie Aim V1 (PgDn Key)
    Gui, Add, Text, x+10 w10 h10 vZombieCheckmark2 Hidden, ✔  ; Hidden checkmark for Zombie Aim V1
     
    Gui, Add, CheckBox, % "x7 y+5 w" (Width-14) "r1 vEnableAimLoop0 gToggleAimLoop0", Enable Trigger Bot (']' Key to toggle) (Color: EA00FF)
    Gui, Add, Text, x+10 w10 h10 vTriggerBotCheckmark Hidden, ✔  ; Hidden checkmark for Trigger Bot
    ; Finish Advanced Tab
     
    ; ---------------- Misc Tab ----------------
    Gui, Tab, Misc
     
    ; Credits Button
    Gui, Add, Button, % "x7 y400 w" (Width-100) "r1 gShowCredits", Show Credits
     
    ; Zombie Aim and Trigger Bot Buttons
    Gui, Add, Button, % "x7 y125 w120 h20 gOpenZombieAim", Open Zombie Aim
    Gui, Add, Button, % "x7 y102 w120 h20 gOpenTriggerBot", Open Trigger Bot
    Gui, Add, Button, % "x135 y104 w120 h20 gPauseToggle1", Pause/Resume Trigger Bot  ; Pause button
     
    ; Toggle Resizability Button
    Gui, Add, Button, % "x7 y225 w100 h30 gToggleResizable", Toggle Resizability
    Gui, Add, Button, % "x7 y180 w100 h30 gToggleMonitor", Move to Second Monitor
     
    ; Trigger Bot Toggle Section
    Gui, Add, Button, % "x135 y80 w" (Width-300) "r1 gToggleTriggerBot", Trigger Bot Toggle
     
    Gui, Add, Button, % "x7 y80 w120 h20 gOpenZombieAimV2", Open Zombie Aim V2
    Gui, Add, Button, % "x287 y100 w120 h20 gOpenInstructions", Instructions / Tips
    Gui, Add, Button, % "x287 y123 w120 h20 gOpenHotkeys", HOTKEYS / Tips + Settings
     
    ; Close Button
    Gui, Add, Button, % "x7 y146 w100 h30 gClose", Close
    GuiControl, +ToolTip, Close, Close the application
     
    ; Reset Defaults Button
    Gui, Add, Button, % "x107 y146 w100 h30 gResetDefaults", Reset Defaults
    GuiControl, +ToolTip, ResetDefaults, Reset settings to default values
    Gui, Add, Button, % "x207 y146 w100 h30 gSaveSettings", Save Settings
    GuiControl, +ToolTip, SaveSettings, Save current settings to an INI file
    Gui, Add, Button, % "x307 y146 w100 h30 gLoadSettings", Load Settings
    GuiControl, +ToolTip, LoadSettings, Load settings from an INI file
     
    ; Finish Misc Tab
     
    ; ---------------- Extras Tab ----------------
    Gui, Tab, Extras
    Gui, Font, s6
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Extras Options
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Placeholder for future content
     
    ; Josh Trigger Bot Toggle
    Gui, Add, Checkbox, vJoshTriggerBotCheckbox gToggleJoshTriggerBot, Josh Trigger Bot
    Gui, Add, Text, x7 y+5 w250, Enable/Disable Josh Trigger Bot
     
    ; Auto Strafe Toggle
    Gui, Add, Checkbox, vAutoStrafeCheckbox gToggleAutoStrafe, Auto Strafe
    Gui, Add, Text, x7 y+5 w275, Enable/Disable Auto Strafe
     
    ; Auto Crouch/Prone Spam Toggle
    Gui, Add, Checkbox, vAutoCrouchProneCheckbox gToggleAutoCrouchProne, Auto Crouch/Prone Spam
    Gui, Add, Text, x7 y+5 w400, Enable/Disable Auto Crouch/Prone Spam
     
    ; Melee Spam Toggle
    Gui, Add, Checkbox, vMeleeSpamCheckbox gToggleMeleeSpam, Melee Spam
    Gui, Add, Text, x7 y+5 w400, Enable/Disable Melee Spam
     
    ; Finish Extras Tab
     
    ; ---------------- Dev Tab ----------------
    Gui, Tab, Dev
    ; Placeholder for future features
    Gui, Add, Text, % "x7 y70 w" (Width-14) "r1", Developer options will be added here. Treason V3.1 FIXED (Color freeze gui issue, some adv feature nows working that did not before)
     
    ; Finish Dev Tab
     
    ; ---------------- Customize Tab ----------------
    Gui, Tab, Customize
    Gui, Font, s6
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Customize Options
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Placeholder for customization features
     
    ; ---------------- Settings Tab ----------------
    Gui, Tab, Settings
    Gui, Font, s6
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Settings Options
    Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1", Placeholder for settings adjustments
     
     
    ; GUI updates
    GuiControl,, ZeroYLabel, %ZeroY%
    GuiControl,, CFovXLabel, %CFovX%
    GuiControl,, CFovYLabel, %CFovY%
    GuiControl,, SmoothingValue, %smoothing%
    GuiControl,, PredictionValue, %predictionMultiplier%
    GuiControl,, ToleranceValue, %ColVn%
    GuiControl,, RecoilIntensity, %RecoilIntensity%          ; Reset Recoil Intensity in GUI
    GuiControl,, NoRecoilSpeed, %NoRecoilSpeed%              ; Reset No Recoil Speed in GUI
    GuiControl,, FOVValue, %FOVValue%                        ; Reset FOV in GUI
     
    ; Window Region for GUI
    Gui, Add, Text, % "x7 y+15 w" "h5 vP"
    GuiControlGet, P, Pos
    H := PY + PH
    Gui, -Caption
    WinSet, Region, 0-0 w%Width% h%H% r6-6
     
    Loop
    {
        ; Check if the script is enabled
        GuiControlGet, EnableState,, EnableCheckbox
        if (EnableState) {
            targetFound := False
     
            ; Check for target pixel if aiming is enabled
            if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
                ; Search for target pixel in a smaller region around the last known position
                PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea, targetY - SearchArea, targetX + SearchArea, targetY + SearchArea, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX
                    targetY := AimPixelY
                    targetFound := True
                } else {
                    PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                    if (!ErrorLevel) {
                        targetX := AimPixelX
                        targetY := AimPixelY
                        targetFound := True
                    }
                }
     
                if (targetFound) {
                    ; Get current time
                    currentTime := A_TickCount
     
                    ; Calculate the velocity of the target
                    if (lastTime != 0) {
                        deltaTime := (currentTime - lastTime) / 1000.0  ; Convert to seconds
                        velocityX := (targetX - prevX) / deltaTime
                        velocityY := (targetY - prevY) / deltaTime
                    }
     
                    ; Store the current position and time for the next iteration
                    prevX := targetX
                    prevY := targetY
                    lastTime := currentTime
     
                    ; Apply prediction if enabled
                    GuiControlGet, PredictionEnabled,, EnablePredictionCheckbox
                    if (PredictionEnabled && deltaTime != 0) {
                        PredictedX := targetX + Round(velocityX * predictionMultiplier * deltaTime)
                        PredictedY := targetY + Round(velocityY * predictionMultiplier * deltaTime)
                    } else {
                        PredictedX := targetX
                        PredictedY := targetY
                    }
     
                    ; Move the mouse smoothly with strength adjustment
                    AimX := PredictedX - ZeroX
                    AimY := PredictedY - ZeroY
                    DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
                }
            }
    		
            ; Josh Trigger Bot Implementation
            if (JoshTriggerBotEnabled && Sqrt((targetX - ZeroX)**2 + (targetY - ZeroY)**2) < 100) {
                Click  ; Simulate a mouse click when the target is within 100 pixels
                Sleep 50  ; Short delay between clicks
            }
    		
            ; Rapid Fire Implementation
            if (RapidFireEnabled && GetKeyState("LButton", "P")) {
                Click down
                Sleep, 30  ; Short delay for firing rate
                Click up
            }
     
            ; No Recoil Implementation
            if (NoRecoilEnabled && (GetKeyState("LButton", "P") || GetKeyState("RButton", "P"))) {
                if (RecoilIntensity < 0) {
                    RecoilIntensity := 0
                }
                MouseMove, 0, RecoilIntensity, 0, R
                Sleep, NoRecoilSpeed
            }
     
            ; Drop Shot Implementation
            if (DropShotEnabled && GetKeyState("LButton", "P")) {
                Send {C down}  ; Hold down the 'C' key (Crouch)
                 While GetKeyState("LButton", "P") {  ; While the Left Mouse Button (LButton) is held down
                 Sleep, 10  ; Wait for 10 ms before checking again
                }
                Send {C up}  ; Release the 'C' key (Crouch)
            }
     
            ; Jitter Implementation
            if (JitterEnabled && GetKeyState("LButton", "P")) {
                MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
            }
     
            ; Sniper Breath Implementation
            if (SniperBreathEnabled && GetKeyState("RButton", "P")) {
                Send {Shift down}
                Sleep, 1000  ; Hold breath for 1 second
                Send {Shift up}
            }
     
            ; Auto Sprint Implementation
            if (AutoSprintEnabled && GetKeyState("W", "P")) {
                Send {LShift down}
            } else {
                Send {LShift up}
            }
     
            ; Fast Reload Implementation
            if (FastReloadEnabled && GetKeyState("R", "P")) {
                Send {R up}
                Sleep, 50
                Send {R down}
                Sleep, 50
                Send {R up}
            }
     
            ; Quick Scope Implementation
            if (QuickScopeEnabled && GetKeyState("RButton", "P")) {
                Send {RButton down}
                Sleep, 50  ; Adjust time for how long to aim before shooting
                Send {LButton up}
            }
     
            ; Anti-aim functionality
            if (AntiAimEnabled) {
                MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
                Sleep, 50
            }
     
            ; Hitbox Cycle Implementation
            if (HitboxCycleEnabled && (Mod(A_Index, 5) == 0)) {
                target := (target = "Head") ? "Chest" : (target = "Chest") ? "Belly" : (target = "Belly") ? "Feet" : "Head"
                ZeroY := (target = "Head") ? A_ScreenHeight / 2.18 : (target = "Chest") ? A_ScreenHeight / 2.22 : (target = "Belly") ? A_ScreenHeight / 2.30 : A_ScreenHeight / 2.38
                GuiControl,, ZeroYLabel, %ZeroY%
                Sleep, 10000 ; Timer to switch hitbox
            }
     
            ; Auto reload functionality
            if (AutoReloadEnabled) {
                if (!GetKeyState("RButton", "P")) {
                    if (GetKeyState("LButton", "P") && !isReloading && (A_TickCount - lastReloadTime > reloadCooldown)) {
                        Send {R}
                        lastReloadTime := A_TickCount
                        isReloading := True
                        Sleep, 500 ; Adjust the sleep duration as needed
                        isReloading := False
                    }
                }
            }
     
            ; Auto crouch functionality
            if (AutoCrouchEnabled && GetKeyState("LButton", "P")) {
                Send {C}
                Sleep, 50  ; Short delay to prevent spam
            }
     
            ; Bunny Hop Implementation
            if (BunnyHopEnabled && GetKeyState("LButton", "P")) {
                Send {Space down}
                Sleep, 10  ; Adjust timing for hopping
                Send {Space up}
                Sleep, 10
            }
     
            ; Jump Shot
            if (JumpShotEnabled && GetKeyState("LButton", "P")) {
                Send, {Space}
                Sleep, 300  ; Adjust timing as needed
            }
     
            ; Drop Shot 2
            if (DropShot2Enabled && GetKeyState("LButton", "P")) {
                Send, {Ctrl down}
                Sleep, 500
                Send, {Ctrl up}
            }
     
            ; Crouch Shot
            if (CrouchShotEnabled && GetKeyState("LButton", "P")) {
                Send, {C down}
                Sleep, 75
                Send, {C up}
                Sleep, 75
            }
     
            ; Hold Breath
            if (HoldBreathEnabled && GetKeyState("RButton", "P")) {
                Sleep, 110  ; Delay before holding Shift
                Send, {Shift down}
                ; Release Shift when Right Mouse Button is released
                if (!GetKeyState("RButton", "P")) {
                    Send, {Shift up}
                }
            }
     
            ; Auto drop functionality
            if (AutoDropEnabled && GetKeyState("LButton", "P")) {
                Send {C}
                Sleep, 50  ; Short delay to prevent spam
            }
     
            ; Anti-AFK Implementation
            if (AntiAFKEnabled) {
                Random, afkMovementX, -3, 3  ; Random movement in X direction
                Random, afkMovementY, -3, 3  ; Random movement in Y direction
                MouseMove, afkMovementX, afkMovementY, 0, R  ; Move mouse slightly to prevent AFK
     
                ; Perform additional anti-AFK actions
                Random, actionChoice, 1, 3  ; Randomly choose an action
                if (actionChoice == 1) {
                    Send {C down}  ; Crouch
                    Sleep, 100  ; Hold crouch
                    Send {C up}  ; Stand back up
                } else if (actionChoice == 2) {
                    Send {W down}  ; Move forward
                    Sleep, 300  ; Move forward for a short duration
                    Send {W up}  ; Stop moving
                } else if (actionChoice == 3) {
                    Send {D down}  ; Strafe right
                    Sleep, 300  ; Strafe right for a short duration
                    Send {D up}  ; Stop strafing
                }
            }
     
            ; Auto Crouch/Prone spam
            if (AutoCrouchProneEnabled && GetKeyState("LButton", "P")) {
                Random, action, 0, 1  ; 0 for crouch, 1 for prone
                if (action = 0) {
                    Send, {C down}  ; Crouch
                    Sleep, 100
                    Send, {C up}
                } else {
                    Send, {Z down}  ; Go prone
                    Sleep, 100
                    Send, {Z up}
                }
            }
     
            ; Melee Spam
            if (MeleeSpamEnabled && GetKeyState("LButton", "P")) {
                Random, meleeSpamTime, 150, 250
                Send, {V}  ; Press Melee/Knife button
                Sleep, meleeSpamTime
            }
     
            ; Auto Strafe
            if (AutoStrafeEnabled && GetKeyState("LButton", "P")) {
                Random, direction, 0, 1  ; 0 for left, 1 for right
                if (direction = 0) {
                    Send, {A down}  ; Move Left
                    Sleep, 50
                    Send, {A up}
                } else {
                    Send, {D down}  ; Move Right
                    Sleep, 50
                    Send, {D up}
                }
            }
        }
     
        ; Reduce CPU usage and improve responsiveness
        Sleep, 5  ; Minimal sleep to allow the loop to run smoothly
    }
     
    ; GUI updates
    GuiControl,, ZeroYLabel, %ZeroY%
    GuiControl,, CFovXLabel, %CFovX%
    GuiControl,, CFovYLabel, %CFovY%
    GuiControl,, SmoothingValue, %smoothing%
    GuiControl,, PredictionValue, %predictionMultiplier%
    GuiControl,, ToleranceValue, %ColVn%
    GuiControl,, RecoilIntensity, %RecoilIntensity%          ; Reset Recoil Intensity in GUI
    GuiControl,, NoRecoilSpeed, %NoRecoilSpeed%              ; Reset No Recoil Speed in GUI
    GuiControl,, FOVValue, %FOVValue%                        ; Reset FOV in GUI
     
    ; ButtonCallbacks
        HeadshotsButton:
            ZeroY := A_ScreenHeight / 2.18
            GuiControl,, ZeroYLabel, %ZeroY%
            MsgBox, Target Selected: Headshots`nY Position: %ZeroY%
            Return
     
        ; ChestButton callback
        ChestButton:
            ZeroY := A_ScreenHeight / 2.22
            GuiControl,, ZeroYLabel, %ZeroY%
            MsgBox, Target Selected: Chest`nY Position: %ZeroY%
            Return
        
        ; BellyButton callback
        BellyButton:
            ZeroY := A_ScreenHeight / 2.30
            GuiControl,, ZeroYLabel, %ZeroY%
            MsgBox, Target Selected: Belly`nY Position: %ZeroY%
            Return
     
        ; FeetButton callback
        FeetButton:
            ZeroY := A_ScreenHeight / 2.38
            GuiControl,, ZeroYLabel, %ZeroY%
            MsgBox, Target Selected: Feet`nY Position: %ZeroY%
            Return
     
    GuiMove:
        PostMessage, 0xA1, 2
        return
    	
    	Delete::
        ToggleAimLoop6()  ; Call the function to toggle
    return
    	
    AimLoop8:
        if toggle8 {
            targetFound8 := false
     
            if (GetKeyState("LButton", "P") || GetKeyState("RButton", "P")) {
                ; Look for the purple diamond within the defined area
                PixelSearch, AimPixelX, AimPixelY, ScanL8, ScanT8, ScanR8, ScanB8, EMCol8, ColVn8, Fast RGB
                if (!ErrorLevel) {
                    ; Diamond found, calculate adjusted aim point
                    targetX8 := AimPixelX + OffsetX8
                    targetY8 := AimPixelY + OffsetY8
                    targetFound8 := true
                }
     
                if (targetFound8) {
                    ; Calculate movement needed to reach adjusted target
                    TargetAimX := targetX8 - ZeroX8
                    TargetAimY := targetY8 - ZeroY8
     
                    ; Smoothing multiplier for gradual movement
                    MoveX := Round(TargetAimX * 0.1)
                    MoveY := Round(TargetAimY * 0.1)
     
                    ; Execute movement if it's substantial enough
                    if (Abs(MoveX) > 1 || Abs(MoveY) > 1) {
                        DllCall("mouse_event", "UInt", 1, "Int", MoveX, "Int", MoveY, "UInt", 0, "Int", 0)
                    }
                }
            }
        }
    return
     
    ToggleAimLoop8() {
        global toggle8
        toggle8 := !toggle8
        
        ; Update the checkbox state
        GuiControl,, EnableAimLoop8, % toggle8 ? 1 : 0  ; Set checkbox based on toggle state
     
        if (toggle8) {
            SetTimer, AimLoop8, 10  ; Start the loop with a timer
            SoundBeep, 500, 300
            MsgBox, Aim Loop Started
        } else {
            SetTimer, AimLoop8, Off  ; Stop the loop when toggled off
            SoundBeep, 750, 300
            MsgBox, Aim Loop Stopped
        }
     
        Gosub, UpdateStatus  ; Call UpdateStatus to refresh checkmark visibility
    }
     
    ; Page Up key to toggle Aim Loop
    PgUp::ToggleAimLoop8()
     
    ; Pause functionality with Alt key
    -::  ; Use '-' key to pause
        Paused8 := !Paused8
        Pause, Toggle
        if Paused8 {
            SoundBeep, 750, 500
        }
        return
    	
    AimLoop6:
        ; Declare global variables so they can be recognized
        global RapidFireEnabled, NoRecoilEnabled, DropShotEnabled, JitterEnabled, SniperBreathEnabled
        global AutoSprintEnabled, FastReloadEnabled, QuickScopeEnabled, AntiAimEnabled, HitboxCycleEnabled
        global AutoReloadEnabled, AutoCrouchEnabled, BunnyHopEnabled, JumpShotEnabled, DropShot2Enabled
        global CrouchShotEnabled, HoldBreathEnabled, AutoDropEnabled, AntiAFKEnabled, RecoilIntensity
        global NoRecoilSpeed, lastReloadTime, reloadCooldown, isReloading, ZeroX6, ZeroY6, TargetAimX, TargetAimY
        global JoshTriggerBotEnabled, MeleeSpamEnabled, AutoStrafeEnabled, AutoCrouchProneEnabled
     
        ; Auto Sprint Implementation - Runs independently of mouse button state
        if (AutoSprintEnabled && GetKeyState("W", "P")) {
            if (!GetKeyState("LShift", "P")) {  ; Ensure Shift is not already held
                Send {LShift down}
            }
        } else {
            if (GetKeyState("LShift", "P")) {  ; Release Shift if it's held
                Send {LShift up}
            }
        }
     
        ; Aim feature implementation - Only run if LButton or RButton is pressed
        if (GetKeyState("LButton", "P") or GetKeyState("RButton", "P")) {
            targetFound6 := false  ; Reset targetFound6 at the start of each loop iteration
     
            ; Look for the purple diamond within the defined area
            PixelSearch, AimPixelX, AimPixelY, ScanL6, ScanT6, ScanR6, ScanB6, EMCol6, ColVn6, Fast RGB
            if (!ErrorLevel) {
                targetX6 := AimPixelX + OffsetX6
                targetY6 := AimPixelY + OffsetY6
                targetFound6 := true
            }
     
            if (targetFound6) {
                TargetAimX := targetX6 - ZeroX6
                TargetAimY := targetY6 - ZeroY6
                MoveX := Round(TargetAimX * 0.3)
                MoveY := Round(TargetAimY * 0.3)
                if (Abs(MoveX) > 0 || Abs(MoveY) > 0) {
                    DllCall("mouse_event", "UInt", 1, "Int", MoveX, "Int", MoveY, "UInt", 0, "Int", 0)
                }
            }
     
            ; Call the function to handle all feature implementations
            ExecuteFeatures()
        }
     
        Gosub, UpdateStatus
        Sleep, 5  ; Minimal sleep to allow the loop to run smoothly
    return
     
    ExecuteFeatures() {
        global RapidFireEnabled, NoRecoilEnabled, DropShotEnabled, JitterEnabled, SniperBreathEnabled
        global AutoSprintEnabled, FastReloadEnabled, QuickScopeEnabled, AntiAimEnabled, HitboxCycleEnabled
        global AutoReloadEnabled, AutoCrouchEnabled, BunnyHopEnabled, JumpShotEnabled, DropShot2Enabled
        global CrouchShotEnabled, HoldBreathEnabled, AutoDropEnabled, AntiAFKEnabled, RecoilIntensity
        global NoRecoilSpeed, lastReloadTime, reloadCooldown, isReloading, ZeroX6, ZeroY6, TargetAimX, TargetAimY
        global JoshTriggerBotEnabled, MeleeSpamEnabled, AutoStrafeEnabled, AutoCrouchProneEnabled
     
        ; Josh Trigger Bot Implementation
        if (JoshTriggerBotEnabled && Sqrt((targetX6 - ZeroX6)**2 + (targetY6 - ZeroY6)**2) < 100) {
            Click  ; Simulate a mouse click when the target is within 100 pixels
            Sleep 50  ; Short delay between clicks
        }
        
        ; Rapid Fire Implementation
        if (RapidFireEnabled && GetKeyState("LButton", "P")) {
            Click down
            Sleep, 30  ; Short delay for firing rate
            Click up
        }
     
        ; No Recoil Implementation
        if (NoRecoilEnabled && (GetKeyState("LButton", "P") || GetKeyState("RButton", "P"))) {
            if (RecoilIntensity < 0) {
                RecoilIntensity := 0
            }
            MouseMove, 0, RecoilIntensity, 0, R
            Sleep, NoRecoilSpeed
        }
     
        ; Drop Shot Implementation
        if (DropShotEnabled && GetKeyState("LButton", "P")) {
            Send {C down}  ; Hold down the 'C' key (Crouch)
            While GetKeyState("LButton", "P") {  ; While the Left Mouse Button (LButton) is held down
                Sleep, 10  ; Wait for 10 ms before checking again
            }
            Send {C up}  ; Release the 'C' key (Crouch)
        }
     
        ; Jitter Implementation
        if (JitterEnabled && GetKeyState("LButton", "P")) {
            MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
        }
     
        ; Sniper Breath Implementation
        if (SniperBreathEnabled && GetKeyState("RButton", "P")) {
            Send {Shift down}
            Sleep, 1000  ; Hold breath for 1 second
            Send {Shift up}
        }
     
        ; Auto Sprint Implementation
        if (AutoSprintEnabled && GetKeyState("W", "P")) {
            Send {LShift down}
        } else {
            Send {LShift up}
        }
     
        ; Fast Reload Implementation
        if (FastReloadEnabled && GetKeyState("R", "P")) {
            Send {R up}
            Sleep, 50
            Send {R down}
            Sleep, 50
            Send {R up}
        }
     
        ; Quick Scope Implementation
        if (QuickScopeEnabled && GetKeyState("RButton", "P")) {
            Send {RButton down}
            Sleep, 50  ; Adjust time for how long to aim before shooting
            Send {LButton up}
        }
     
        ; Anti-aim functionality
        if (AntiAimEnabled) {
            MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
            Sleep, 50
        }
     
        ; Hitbox Cycle Implementation
        if (HitboxCycleEnabled && (Mod(A_Index, 5) == 0)) {
            target := (target = "Head") ? "Chest" : (target = "Chest") ? "Belly" : (target = "Belly") ? "Feet" : "Head"
            ZeroY := (target = "Head") ? A_ScreenHeight / 2.18 : (target = "Chest") ? A_ScreenHeight / 2.22 : (target = "Belly") ? A_ScreenHeight / 2.30 : A_ScreenHeight / 2.38
            GuiControl,, ZeroYLabel, %ZeroY%
            Sleep, 10000 ; Timer to switch hitbox
        }
     
        ; Auto reload functionality
        if (AutoReloadEnabled) {
            if (!GetKeyState("RButton", "P")) {
                if (GetKeyState("LButton", "P") && !isReloading && (A_TickCount - lastReloadTime > reloadCooldown)) {
                    Send {R}
                    lastReloadTime := A_TickCount
                    isReloading := True
                    Sleep, 500 ; Adjust the sleep duration as needed
                    isReloading := False
                }
            }
        }
     
        ; Auto crouch functionality
        if (AutoCrouchEnabled && GetKeyState("LButton", "P")) {
            Send {C}
            Sleep, 50  ; Short delay to prevent spam
        }
     
        ; Bunny Hop Implementation
        if (BunnyHopEnabled && GetKeyState("LButton", "P")) {
            Send {Space down}
            Sleep, 10  ; Adjust timing for hopping
            Send {Space up}
            Sleep, 10
        }
     
        ; Jump Shot
        if (JumpShotEnabled && GetKeyState("LButton", "P")) {
            Send, {Space}
            Sleep, 300  ; Adjust timing as needed
        }
     
        ; Drop Shot 2
        if (DropShot2Enabled && GetKeyState("LButton", "P")) {
            Send, {Ctrl down}
            Sleep, 500
            Send, {Ctrl up}
        }
     
        ; Crouch Shot
        if (CrouchShotEnabled && GetKeyState("LButton", "P")) {
            Send, {C down}
            Sleep, 75
            Send, {C up}
            Sleep, 75
        }
     
        ; Hold Breath
        if (HoldBreathEnabled && GetKeyState("RButton", "P")) {
            Sleep, 110  ; Delay before holding Shift
            Send, {Shift down}
            ; Release Shift when Right Mouse Button is released
            if (!GetKeyState("RButton", "P")) {
                Send, {Shift up}
            }
        }
     
        ; Auto drop functionality
        if (AutoDropEnabled && GetKeyState("LButton", "P")) {
            Send {C}
            Sleep, 50  ; Short delay to prevent spam
        }
     
        ; Anti-AFK Implementation
        if (AntiAFKEnabled) {
            Random, afkMovementX, -3, 3  ; Random movement in X direction
            Random, afkMovementY, -3, 3  ; Random movement in Y direction
            MouseMove, afkMovementX, afkMovementY, 0, R  ; Move mouse slightly to prevent AFK
     
            ; Perform additional anti-AFK actions
            Random, actionChoice, 1, 3  ; Randomly choose an action
            if (actionChoice == 1) {
                Send {C down}  ; Crouch
                Sleep, 100  ; Hold crouch
                Send {C up}  ; Stand back up
            } else if (actionChoice == 2) {
                Send {W down}  ; Move forward
                Sleep, 300  ; Move forward for a short duration
                Send {W up}  ; Stop moving
            } else if (actionChoice == 3) {
                Send {D down}  ; Strafe right
                Sleep, 300  ; Strafe right for a short duration
                Send {D up}  ; Stop strafing
            }
        }
     
        ; Auto Crouch/Prone spam
        if (AutoCrouchProneEnabled && GetKeyState("LButton", "P")) {
            Random, action, 0, 1  ; 0 for crouch, 1 for prone
            if (action = 0) {
                Send, {C down}  ; Crouch
                Sleep, 100
                Send, {C up}
            } else {
                Send, {Z down}  ; Go prone
                Sleep, 100
                Send, {Z up}
            }
        }
     
        ; Melee Spam
        if (MeleeSpamEnabled && GetKeyState("LButton", "P")) {
            Random, meleeSpamTime, 150, 250
            Send, {V}  ; Press Melee/Knife button
            Sleep, meleeSpamTime
        }
     
        ; Auto Strafe
        if (AutoStrafeEnabled && GetKeyState("LButton", "P")) {
            Random, direction, 0, 1  ; 0 for left, 1 for right
            if (direction = 0) {
                Send, {A down}  ; Move Left
                Sleep, 50
                Send, {A up}
            } else {
                Send, {D down}  ; Move Right
                Sleep, 50
                Send, {D up}
            }
        }
     
        ; Reduce CPU usage and improve responsiveness
        Sleep, 5  ; Minimal sleep to allow the loop to run smoothly
    }
     
     
    ToggleEnable2() {
        GuiControlGet, Enable2State,, Enable2Checkbox  ; Get the current state of the checkbox
        Enable2State := !Enable2State  ; Toggle the state
        GuiControl,, Enable2Checkbox, % Enable2State  ; Update the checkbox in the GUI
        toggle2 := Enable2State  ; Update toggle2 based on checkbox state
     
        ; Start the loop if toggled on
        if (toggle2) {
            SetTimer, AimLoop2, 5  ; Start the loop with a timer
            SoundBeep, 500, 300
            GuiControl, Show, Enable2Checkmark  ; Show the checkmark
        } else {
            SetTimer, AimLoop2, Off  ; Stop the loop when toggled off
            SoundBeep, 750, 300
            GuiControl, Hide, Enable2Checkmark  ; Hide the checkmark
        }
    }
    AimLoop2:
        ; Check if the script is enabled
        GuiControlGet, Enable2State,, Enable2Checkbox
        toggle2 := Enable2State
        if (toggle2) {
            targetFound := False
     
            if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
                ; Search for target pixel in a smaller region around the last known position
                PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea2, targetY - SearchArea2, targetX + SearchArea2, targetY + SearchArea2, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX
                    targetY := AimPixelY
                    targetFound := True
                } else {
                    PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                    if (!ErrorLevel) {
                        targetX := AimPixelX
                        targetY := AimPixelY
                        targetFound := True
                    }
                }
     
                if (targetFound) {
                    ; Get current time
                    currentTime := A_TickCount
     
                    ; Calculate the velocity of the target
                    if (lastTime != 0) {
                        deltaTime := (currentTime - lastTime) / 1000.0 ; Convert to seconds (It's in milliseconds)
                        velocityX := (targetX - prevX) / deltaTime
                        velocityY := (targetY - prevY) / deltaTime
                    }
     
                    ; Store the current position and time for the next iteration
                    prevX := targetX
                    prevY := targetY
                    lastTime := currentTime
     
                    ; Apply prediction if enabled
                    GuiControlGet, PredictionEnabled,, EnablePredictionCheckbox
                    if (PredictionEnabled && deltaTime != 0) {
                        PredictedX := targetX + Round(velocityX * predictionMultiplier * deltaTime)
                        PredictedY := targetY + Round(velocityY * predictionMultiplier * deltaTime)
                    } else {
                        PredictedX := targetX
                        PredictedY := targetY
                    }
     
                    ; Move the mouse smoothly with strength adjustment
                    AimX := PredictedX - ZeroX
                    AimY := PredictedY - ZeroY
                    DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
                }
            }
            ; Call the function to handle all feature implementations
            ExecuteFeatures2()
        }
     
        Gosub, UpdateStatus
        Sleep, 5  ; Minimal sleep to allow the loop to run smoothly
    return
     
    ExecuteFeatures2() {
        global RapidFireEnabled, NoRecoilEnabled, DropShotEnabled, JitterEnabled, SniperBreathEnabled
        global AutoSprintEnabled, FastReloadEnabled, QuickScopeEnabled, AntiAimEnabled, HitboxCycleEnabled
        global AutoReloadEnabled, AutoCrouchEnabled, BunnyHopEnabled, JumpShotEnabled, DropShot2Enabled
        global CrouchShotEnabled, HoldBreathEnabled, AutoDropEnabled, AntiAFKEnabled, RecoilIntensity
        global NoRecoilSpeed, lastReloadTime, reloadCooldown, isReloading, ZeroX6, ZeroY6, TargetAimX, TargetAimY
        global JoshTriggerBotEnabled, MeleeSpamEnabled, AutoStrafeEnabled, AutoCrouchProneEnabled
     
        ; Josh Trigger Bot Implementation
        if (JoshTriggerBotEnabled && Sqrt((targetX6 - ZeroX6)**2 + (targetY6 - ZeroY6)**2) < 100) {
            Click  ; Simulate a mouse click when the target is within 100 pixels
            Sleep 50  ; Short delay between clicks
        }
        
        ; Rapid Fire Implementation
        if (RapidFireEnabled && GetKeyState("LButton", "P")) {
            Click down
            Sleep, 30  ; Short delay for firing rate
            Click up
        }
     
        ; No Recoil Implementation
        if (NoRecoilEnabled && (GetKeyState("LButton", "P") || GetKeyState("RButton", "P"))) {
            if (RecoilIntensity < 0) {
                RecoilIntensity := 0
            }
            MouseMove, 0, RecoilIntensity, 0, R
            Sleep, NoRecoilSpeed
        }
     
        ; Drop Shot Implementation
        if (DropShotEnabled && GetKeyState("LButton", "P")) {
            Send {C down}  ; Hold down the 'C' key (Crouch)
            While GetKeyState("LButton", "P") {  ; While the Left Mouse Button (LButton) is held down
                Sleep, 10  ; Wait for 10 ms before checking again
            }
            Send {C up}  ; Release the 'C' key (Crouch)
        }
     
        ; Jitter Implementation
        if (JitterEnabled && GetKeyState("LButton", "P")) {
            MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
        }
     
        ; Sniper Breath Implementation
        if (SniperBreathEnabled && GetKeyState("RButton", "P")) {
            Send {Shift down}
            Sleep, 1000  ; Hold breath for 1 second
            Send {Shift up}
        }
     
        ; Auto Sprint Implementation
        if (AutoSprintEnabled && GetKeyState("W", "P")) {
            Send {LShift down}
        } else {
            Send {LShift up}
        }
     
        ; Fast Reload Implementation
        if (FastReloadEnabled && GetKeyState("R", "P")) {
            Send {R up}
            Sleep, 50
            Send {R down}
            Sleep, 50
            Send {R up}
        }
     
        ; Quick Scope Implementation
        if (QuickScopeEnabled && GetKeyState("RButton", "P")) {
            Send {RButton down}
            Sleep, 50  ; Adjust time for how long to aim before shooting
            Send {LButton up}
        }
     
        ; Anti-aim functionality
        if (AntiAimEnabled) {
            MouseMove, % (GetRandom(-5, 5)), % (GetRandom(-5, 5)), 0, R
            Sleep, 50
        }
     
        ; Hitbox Cycle Implementation
        if (HitboxCycleEnabled && (Mod(A_Index, 5) == 0)) {
            target := (target = "Head") ? "Chest" : (target = "Chest") ? "Belly" : (target = "Belly") ? "Feet" : "Head"
            ZeroY := (target = "Head") ? A_ScreenHeight / 2.18 : (target = "Chest") ? A_ScreenHeight / 2.22 : (target = "Belly") ? A_ScreenHeight / 2.30 : A_ScreenHeight / 2.38
            GuiControl,, ZeroYLabel, %ZeroY%
            Sleep, 10000 ; Timer to switch hitbox
        }
     
        ; Auto reload functionality
        if (AutoReloadEnabled) {
            if (!GetKeyState("RButton", "P")) {
                if (GetKeyState("LButton", "P") && !isReloading && (A_TickCount - lastReloadTime > reloadCooldown)) {
                    Send {R}
                    lastReloadTime := A_TickCount
                    isReloading := True
                    Sleep, 500 ; Adjust the sleep duration as needed
                    isReloading := False
                }
            }
        }
     
        ; Auto crouch functionality
        if (AutoCrouchEnabled && GetKeyState("LButton", "P")) {
            Send {C}
            Sleep, 50  ; Short delay to prevent spam
        }
     
        ; Bunny Hop Implementation
        if (BunnyHopEnabled && GetKeyState("LButton", "P")) {
            Send {Space down}
            Sleep, 10  ; Adjust timing for hopping
            Send {Space up}
            Sleep, 10
        }
     
        ; Jump Shot
        if (JumpShotEnabled && GetKeyState("LButton", "P")) {
            Send, {Space}
            Sleep, 300  ; Adjust timing as needed
        }
     
        ; Drop Shot 2
        if (DropShot2Enabled && GetKeyState("LButton", "P")) {
            Send, {Ctrl down}
            Sleep, 500
            Send, {Ctrl up}
        }
     
        ; Crouch Shot
        if (CrouchShotEnabled && GetKeyState("LButton", "P")) {
            Send, {C down}
            Sleep, 75
            Send, {C up}
            Sleep, 75
        }
     
        ; Hold Breath
        if (HoldBreathEnabled && GetKeyState("RButton", "P")) {
            Sleep, 110  ; Delay before holding Shift
            Send, {Shift down}
            ; Release Shift when Right Mouse Button is released
            if (!GetKeyState("RButton", "P")) {
                Send, {Shift up}
            }
        }
     
        ; Auto drop functionality
        if (AutoDropEnabled && GetKeyState("LButton", "P")) {
            Send {C}
            Sleep, 50  ; Short delay to prevent spam
        }
     
        ; Anti-AFK Implementation
        if (AntiAFKEnabled) {
            Random, afkMovementX, -3, 3  ; Random movement in X direction
            Random, afkMovementY, -3, 3  ; Random movement in Y direction
            MouseMove, afkMovementX, afkMovementY, 0, R  ; Move mouse slightly to prevent AFK
     
            ; Perform additional anti-AFK actions
            Random, actionChoice, 1, 3  ; Randomly choose an action
            if (actionChoice == 1) {
                Send {C down}  ; Crouch
                Sleep, 100  ; Hold crouch
                Send {C up}  ; Stand back up
            } else if (actionChoice == 2) {
                Send {W down}  ; Move forward
                Sleep, 300  ; Move forward for a short duration
                Send {W up}  ; Stop moving
            } else if (actionChoice == 3) {
                Send {D down}  ; Strafe right
                Sleep, 300  ; Strafe right for a short duration
                Send {D up}  ; Stop strafing
            }
        }
     
        ; Auto Crouch/Prone spam
        if (AutoCrouchProneEnabled && GetKeyState("LButton", "P")) {
            Random, action, 0, 1  ; 0 for crouch, 1 for prone
            if (action = 0) {
                Send, {C down}  ; Crouch
                Sleep, 100
                Send, {C up}
            } else {
                Send, {Z down}  ; Go prone
                Sleep, 100
                Send, {Z up}
            }
        }
     
        ; Melee Spam
        if (MeleeSpamEnabled && GetKeyState("LButton", "P")) {
            Random, meleeSpamTime, 150, 250
            Send, {V}  ; Press Melee/Knife button
            Sleep, meleeSpamTime
        }
     
        ; Auto Strafe
        if (AutoStrafeEnabled && GetKeyState("LButton", "P")) {
            Random, direction, 0, 1  ; 0 for left, 1 for right
            if (direction = 0) {
                Send, {A down}  ; Move Left
                Sleep, 50
                Send, {A up}
            } else {
                Send, {D down}  ; Move Right
                Sleep, 50
                Send, {D up}
            }
        }
     
        ; Reduce CPU usage and improve responsiveness
        Sleep, 5  ; Minimal sleep to allow the loop to run smoothly
    }
     
    ; Submit Color function for Zombie Target
    SubmitZombieColor6:
        GuiControlGet, ZombieColorHex,, ZombieColorHex  ; Get the color input from the GUI
        ; Check if the color has changed before updating
        if (ZombieColorHex != LastColor6) {
            LastColor6 := ZombieColorHex  ; Store the current color as the last color
            UpdateZombieColor6()  ; Call the UpdateColor function to handle the actual update
        }
    return
    ; Update Color function for Zombie Target
    UpdateZombieColor6() {
        global EMCol6  ; The main zombie target color variable
        GuiControlGet, ZombieColorHex,, ZombieColorHex  ; Get the color input again
        
        if (ZombieColorHex != "") {
            ; Validate the hex input (must be 6 valid hex digits)
            if (RegExMatch(ZombieColorHex, "^[0-9A-Fa-f]{6}$")) {
                EMCol6 := "0x" . ZombieColorHex  ; Convert to the required 0x format
                GuiControl,, ZombieColorHex, % ZombieColorHex  ; Optionally update the display in the edit box
                MsgBox, Zombie target color successfully set to: %ZombieColorHex%  ; Notify user of success
            } else {
                MsgBox, Invalid hex color code! Please enter a valid 6-digit hex code.  ; Show error if invalid
            }
        }
    }
     
    ; Pick Color function (open native Windows color picker for Zombie Target)
    PickZombieColor6:
        Color := 0x000000  ; Initialize a default color value (black)
        ColorPick := DllCall("user32.dll\ChooseColor", "UInt", &Color)  ; Open color picker dialog
        if (ColorPick) {
            EMCol6 := Color  ; Set the zombie target color to the picked color
            ; Update the GUI Edit control to show the new color
            GuiControl,, ZombieColorHex, % Format("{:X}", EMCol6 & 0xFFFFFF)  ; Display color in hex format
        }
    return
     
    ToggleAimLoop6() {
        GuiControlGet, EnableAimLoop6State,, EnableAimLoop6  ; Get the current state of the checkbox
        EnableAimLoop6State := !EnableAimLoop6State  ; Toggle the state
        GuiControl,, EnableAimLoop6, % EnableAimLoop6State  ; Update the checkbox in the GUI
        toggle6 := EnableAimLoop6State  ; Update toggle6 based on checkbox state
     
        ; Start the loop if toggled on
        if (toggle6) {
            SetTimer, AimLoop6, 5  ; Start the loop with a timer
            SoundBeep, 500, 300
            GuiControl, Show, ZombieCheckmark  ; Show the checkmark
        } else {
            SetTimer, AimLoop6, Off  ; Stop the loop when toggled off
            SoundBeep, 750, 300
            GuiControl, Hide, ZombieCheckmark  ; Hide the checkmark
        }
    }
     
    ToggleFOVOverlay:
        showOverlay := !showOverlay
        if (showOverlay)
        {
            UpdateOverlay()
        }
        else
        {
            Gui, OverlayGui:Destroy  ; Close the overlay if it's visible
        }
    return
     
    ; Function to toggle the GUI's resizability
    ToggleResizable:
    isResizable := !isResizable
    if (isResizable) {
        Gui, -ToolWindow  ; Remove ToolWindow to allow resizing
        Gui, +Resize  ; Allow resizing
        GuiControl,, ToggleResizable, Set Non-Resizable  ; Update button text
    } else {
        Gui, +ToolWindow  ; Add ToolWindow to enable dragging without resizing
        Gui, -Resize  ; Disallow resizing
        GuiControl,, ToggleResizable, Set Resizable  ; Update button text
    }
    return
    return
     
    OpenInstructions:
        MsgBox, 0, Instructions, 
        (
        Welcome to the B06 AIO Aim GUI!
     
        Here are the instructions on how to use the features:
     
        * **Enable Multi-Player Aim**: Check the box to activate multi-player aiming functionality. Use Insert key to toggle this feature on or off.
        * **Enable Zombies Aim**: Check the box to activate the zombies aiming feature. Use the Delete key to toggle this feature on or off.
        * **Enable Prediction**: Check the box to activate prediction for better aiming accuracy. Use the Home key to toggle this feature.
        * **Target Color**: Enter the hex value for the target color you want to aim at and click "Set Color" to apply it.
        * **Smoothing**: Use the "+" and "-" buttons to adjust the smoothing value for your aim.
        * **Prediction Multiplier**: Use the "+" and "-" buttons to increase or decrease the prediction multiplier for aiming.
        * **Color Tolerance**: Adjust the color tolerance using the "+" and "-" buttons to refine target detection.
        * **Rapid Fire Toggle**: Click the toggle button to enable or disable rapid fire functionality.
        * **No Recoil Toggle**: Click the toggle button to enable or disable no recoil functionality.
        * **Field of View (FOV)**: Adjust the FOV using the slider for improved targeting range.
        * **FOV Overlay**: Click the button to toggle the FOV overlay on or off, and select the overlay type from the dropdown.
        * **Anti-Aim**: Check the box to enable anti-aim feature for enhanced aiming tactics.
        * **Auto Reload, Auto Crouch, Auto Drop**: Check these boxes to enable automatic actions during gameplay.
        * **Trigger Bot**: Activate this feature to automatically shoot when a target is detected.
        * **Quick Scope**: Enable this option for faster aiming and shooting when using a scoped weapon.
        * **Jitter**: Toggle this feature for unpredictable aiming patterns to confuse enemies.
        * **Fast Reload**: Enable this feature to reload your weapon faster than normal.
        * **Drop Shot**: Check this box to automatically drop to the ground while shooting, making you harder to hit.
        * **Credits**: Click the "Show Credits" button to view the contributors.
        * **Current ZeroY**: This indicates your current target Y-coordinate.
        * **Target Location**: Use buttons to set your aim target location (Head, Chest, Belly, Feet).
        * **Recoil Intensity**: Adjust the no recoil intensity using the slider for precise control.
        * **No Recoil Speed**: Modify the speed of the no recoil effect to suit your preferences.
        * **Cycle Hitboxes**: Check the box to enable cycling through hitboxes for more dynamic aiming.
        * **Open Zombie Aim**: Click the button to access the Zombie Aim feature. (BETA)
        * **Open Zombie Aim V2**: Click the button to access the enhanced version of the Zombie Aim feature. (BETA)
     
        To close the GUI, click the "Close" button.
     
        Enjoy your game!
        Credits to theasiangamr (Multi Source Code + B06 Updated Offsets & Base), Treason of aka(UtterlyTV), Iccbwa (Zombie Aim v1), kanepards (AHK Zombie Aim v2), & ali123x (Inf GobbleGums)
        )
    return
     
    OpenHotkeys:
        MsgBox, 0, Hotkeys and Tips, 
        (
        Welcome to the Hotkeys and Tips Section!
     
        Here are the important hotkeys and settings recommendations:
    	Personal Choice Settings Per Treason!!!!
    	Enable multiplayer to use additional features without they wont run
    	I personally use no recoil and keep both sliders down anywhere under 5
    	default settings are what I use aswell but may adjust to your liking
    	++Many features will not be functional until further updates eg. Anti AFK, Auto Drop , Quick Scope Auto Reload Etc.
    	Work to come with stronger aim and fixing aiming at other objects than Enemys
     
        **Hotkeys & COLOR TIPS:**
        * **F6**: Toggle Multi-Player Aim (43FF00)
        * **Delete**: Toggle Zombies Aim (DF00FF)
        * **Home**: Toggle Prediction
        * **PgUp**: Enable Zombie Aim V2 Less Sticky (DF00FF)
        * **PgDn**: Enable Zombie Aim V1 (EA00FF)
        * **']'**: Toggle Trigger Bot
        * **F1**: Toggle Hide / Show GUI
        * **F12**: Pause/Unpause Functionality
     
        **Tips:**
        - **Multi-Player vs. Zombies Aim**: Avoid using both aiming features at the same time to prevent aiming conflicts.
        - **Target Color**: Make sure to set the correct hex color for optimal performance. Use the "Set Color" button to apply changes.
        - **Smoothing and Prediction**: Adjust these settings based on your playstyle for better accuracy.
        - **Use Rapid Fire and No Recoil**: These features can enhance your gameplay but ensure they are suitable for the game mode you are in.
     
        **Settings Recommendations:**
        - Adjust the **Field of View (FOV)** based on your preferred play style; a wider FOV can help in spotting targets.
        - Fine-tune the **Color Tolerance** for more accurate target detection, especially in fast-paced scenarios.
        - Enable **Auto Reload, Auto Crouch, and Drop Shot** for automatic actions that can enhance your survival chances in combat.
     
        **Note**: Regularly test and adjust settings to find what works best for you.
     
        To close the GUI, click the "Close" button.
     
        Happy gaming!
        Credits to all contributors for their invaluable work and support!
        )
    return
    UpdateOverlay()
    {
        global showOverlay, overlayType, overlaySize
        ; Get the current FOV value from the slider
        GuiControlGet, FOVValue
        overlaySize := FOVValue * 4  ; Adjust the overlay size based on FOV value
     
        ; Center overlay position
        xPos := (A_ScreenWidth - overlaySize) / 2
        yPos := (A_ScreenHeight - overlaySize) / 2
     
        if (showOverlay)
        {
            ; Create the overlay GUI without any color or caption
            Gui, OverlayGui:New, +AlwaysOnTop +ToolWindow -Caption +E0x20 +LastFound +HwndOverlayHwnd
     
            ; Set the size and position
            Gui, OverlayGui:Show, w%overlaySize% h%overlaySize% x%xPos% y%yPos%
     
            ; Load the overlay shape based on selection
            if (OverlayType = "Circle")
            {
                Gui, OverlayGui:Add, Picture, w%overlaySize% h%overlaySize% hwndOverlayPic, Circle2.png  ; Load the circle image
            }
            else
            {
                Gui, OverlayGui:Add, Picture, w%overlaySize% h%overlaySize% hwndOverlayPic, Square2.png  ; Load the square image
            }
     
            ; Set the overlay to be fully transparent
            WinSet, Transparent, 20, ahk_id %OverlayHwnd%  ; Make the entire window transparent
            ; Make the overlay click-through
            WinSet, ExStyle, +0x20, ahk_id %OverlayHwnd%  ; Set the window to be click-through
     
            ; Show the overlay
            Gui, OverlayGui:Show
     
            ; Set the image area to be opaque (make the overlay visible)
            WinSet, Transparent, 255, ahk_id %OverlayPic%  ; Use the handle for the picture
        }
        else
        {
            ; Hide the overlay if toggled off
            Gui, OverlayGui:Hide
        }
    }
     
    ; Toggle Crosshair Overlay
    ToggleCrosshair:
        CrosshairVisible := !CrosshairVisible  ; Toggle visibility of the crosshair overlay
        if (CrosshairVisible)
        {
            UpdateCrosshair()
        }
        else
        {
            Gui, CrosshairGui:Destroy  ; Close the crosshair overlay if it's visible
        }
    return
     
    ; Update Crosshair Overlay
    UpdateCrosshair()
    {
        global CrosshairVisible, CrosshairType
     
        ; Calculate the size and position of the crosshair overlay
        overlaySize := 50  ; Fixed size for crosshair
        xPos := (A_ScreenWidth - overlaySize) / 2
        yPos := (A_ScreenHeight - overlaySize) / 2
     
        if (CrosshairVisible)
        {
            ; Create the crosshair GUI without any color or caption
            Gui, CrosshairGui:New, +AlwaysOnTop +ToolWindow -Caption +E0x20 +LastFound +HwndCrosshairHwnd
     
            ; Set the size and position for the crosshair
            Gui, CrosshairGui:Show, w%overlaySize% h%overlaySize% x%xPos% y%yPos%
     
            ; Load the crosshair image based on the selected type
            if (CrosshairType = "Green Crosshair")
            {
                Gui, CrosshairGui:Add, Picture, w%overlaySize% h%overlaySize% hwndCrosshairPic, green_crosshair.png  ; Load the green crosshair image
            }
            else if (CrosshairType = "Circle")
            {
                Gui, CrosshairGui:Add, Picture, w%overlaySize% h%overlaySize% hwndCrosshairPic, circle_crosshair.png  ; Load the circle crosshair image
            }
            else if (CrosshairType = "Square")
            {
                Gui, CrosshairGui:Add, Picture, w%overlaySize% h%overlaySize% hwndCrosshairPic, square_crosshair.png  ; Load the square crosshair image
            }
     
            ; Make the crosshair overlay click-through
            WinSet, ExStyle, +0x20, ahk_id %CrosshairHwnd%  ; Set the window to be click-through
     
            ; Set the crosshair to be transparent
            WinSet, Transparent, 20, ahk_id %CrosshairHwnd%  ; Make the entire window transparent
     
            ; Show the crosshair overlay
            Gui, CrosshairGui:Show
        }
        else
        {
            ; Hide the crosshair overlay if toggled off
            Gui, CrosshairGui:Hide
        }
    }
     
    UpdateCrosshairType:
        GuiControlGet, CrosshairType, , CrosshairType  ; Get the selected value from the Crosshair dropdown
        if (CrosshairVisible)  ; If the crosshair is visible, update it immediately
        {
            UpdateCrosshair()
        }
    return
     
    IncreaseSmoothing:
        smoothing += 0.01
        if (smoothing > 2)  ; Set a maximum limit for smoothing
            smoothing := 2
        GuiControl,, SmoothingValue, %smoothing%
        Return
     
    DecreaseSmoothing:
        smoothing -= 0.01
        if (smoothing < 0.0)  ; Set a minimum limit for smoothing
            smoothing := 0.0
        GuiControl,, SmoothingValue, %smoothing%
        Return
     
    IncreasePrediction:
        predictionMultiplier += 0.1
        GuiControl,, PredictionValue, %predictionMultiplier%
        Return
    	
     
    DecreasePrediction:
        predictionMultiplier -= 0.1
        if (predictionMultiplier < 0.1)  ; Minimum limit for prediction multiplier
            predictionMultiplier := 0.1
        GuiControl,, PredictionValue, %predictionMultiplier%
        Return
     
    IncreaseTolerance:
        ColVn += 1
        GuiControl,, ToleranceValue, %ColVn%
        Return
     
    DecreaseTolerance:
        ColVn -= 1
        if (ColVn < 0)  ; Minimum limit for color tolerance
            ColVn := 0
        GuiControl,, ToleranceValue, %ColVn%
        Return
    	
    UpdateFOV:
        GuiControlGet, FOVValue  ; Get the new FOV value from the slider
        CFovX := FOVValue  ; Update the global CFovX variable
        GuiControl,, CurrentFOV, %FOVValue%  ; Update the displayed FOV value
        ScanL := ZeroX - CFovX  ; Update the scan area based on the new FOV
        ScanT := ZeroY - CFovX
        ScanR := ZeroX + CFovX
        ScanB := ZeroY + CFovX
     
        if (showOverlay)
        {
            UpdateOverlay()  ; Update the overlay if it's currently visible
        }
    return
     
    UpdateOverlayType:
        GuiControlGet, OverlayType, , OverlayType  ; Get the selected value from the FOV Overlay dropdown
        if (showOverlay)  ; If the overlay is visible, update it immediately
        {
            UpdateOverlay()
        }
    return
    ; Function to update No Recoil Intensity
    UpdateRecoilIntensity:
        GuiControlGet, RecoilIntensity
        ; Update the display of the current Recoil Intensity value
        GuiControl,, CurrentRecoilIntensity, %RecoilIntensity%
    Return
     
    ; Function to update No Recoil Speed
    UpdateNoRecoilSpeed:
        GuiControlGet, NoRecoilSpeed
        ; Update the display of the current No Recoil Speed value
        GuiControl,, CurrentNoRecoilSpeed, %NoRecoilSpeed%
    Return
     
    UpdateTriggerBotStatus() {
        if (triggerActive) {
            if (paused1) {
                TriggerBotStatus := "Active, Paused"
            } else {
                TriggerBotStatus := "Active"
            }
        } else {
            TriggerBotStatus := "Off"
        }
        GuiControl,, TriggerBotStatusText, Trigger Bot: %TriggerBotStatus%  ; Update status in the GUI
    }
     
    ToggleTriggerBot:
        triggerActive := !triggerActive  ; Toggle the trigger active state
     
        ; Provide feedback to confirm the toggle
        if (triggerActive) {
            GuiControl, , ToggleTriggerBot, Stop Trigger Bot
            StartTriggerBot2()  ; Call the function to start the loop
            MsgBox, Trigger Bot started.  ; Indicate the Trigger Bot has started
        } else {
            GuiControl, , ToggleTriggerBot, Start Trigger Bot
            MsgBox, Trigger Bot stopped.  ; Indicate the Trigger Bot has stopped
        }
     
        UpdateTriggerBotStatus()  ; Update status after toggling
    return
     
    ; Function to toggle pause
    PauseToggle1() {
        paused1 := !paused1  ; Toggle paused1 for Trigger Bot
        GuiControl, , PauseToggle1, % (paused1 ? "Resume" : "Pause")
        SoundBeep, % (paused1 ? 750 : 500), % (paused1 ? 500 : 300)  ; Beep on pause/resume
        UpdateTriggerBotStatus()  ; Update status after pausing or resuming
    }
     
    ; Start the Trigger Bot loop
    StartTriggerBot2() {
        SetTimer, TriggerBotLoop, 10
    }
     
    ; The Trigger Bot loop logic
    TriggerBotLoop:
        if (paused1 || !triggerActive) {  ; Check if paused or inactive
            Sleep, 100
            return
        }
     
        KeyWait, RButton, D  ; Wait for the right mouse button to be pressed
        CoordMode, Pixel, Screen
        PixelSearch, Px, Py, ScanL3, ScanT3, ScanR3, ScanB3, 0xEA00FF, 30, Fast
     
        if (ErrorLevel = 0) {  ; If the pixel is found
            Sleep, 10
            Send {LButton down}
            Sleep, 10
            Send {LButton up}
            Sleep, 1000 ; Delay after each trigger
        }
    return
     
    ; Close the GUI
    GuiClose6:
        ExitApp
    toggle := false
     
    if (targetFound && toggle) {
        click down
    } else {
        click up
    }
     
    Paused := False
    F6:: ; Enable Multi-Player Aim Checkbox
        ; Toggle the Enable checkbox state
        GuiControlGet, EnableState,, EnableCheckbox
        newEnableState := !EnableState  ; Toggle the state
        GuiControl,, EnableCheckbox, % newEnableState  ; Update the checkbox
     
        ; Update the toggle variable based on the new state
        toggle := newEnableState
        
        ; Play sound and show/hide the checkmark
        if (toggle) {
            SoundBeep, 300, 100  ; Sound for enabling
            GuiControl, Show, EnableCheckmark  ; Show the checkmark
        } else {
            SoundBeep, 500, 300  ; Sound for disabling
            GuiControl, Hide, EnableCheckmark  ; Hide the checkmark
        }
    return
     
    ; Reset Defaults Function
    ResetDefaults:
        ; Set default values
        smoothing := 0.09
        predictionMultiplier := 2.5
        ColVn := 50
        ; Default Settings for Recoil, Speed, and FOV
        RecoilIntensity := 50  ; Default recoil intensity
        NoRecoilSpeed := 20    ; Default speed for no recoil
        FOVValue := 78     ; Initialize FOV with the main FOV value
     
        ; Update GUI controls with default values
        GuiControl,, SmoothingValue, %smoothing%
        GuiControl,, PredictionValue, %predictionMultiplier%
        GuiControl,, ToleranceValue, %ColVn%
        GuiControl,, RecoilIntensity, %RecoilIntensity%          ; Reset Recoil Intensity in GUI
        GuiControl,, NoRecoilSpeed, %NoRecoilSpeed%              ; Reset No Recoil Speed in GUI
        GuiControl,, FOVValue, %FOVValue% ; Update the GUI slider
        GuiControl,, CurrentFOV, %FOVValue% ; Update displayed current FOV
     
        ; Disable all toggle features and update the GUI statuses
        RapidFireEnabled := False
        NoRecoilEnabled := False
        AntiAimEnabled := False
        HitboxCycleEnabled := False
        AutoReloadEnabled := False
        AutoCrouchEnabled := False
        AutoDropEnabled := False
        
        GuiControl,, RapidFireStatus, OFF
        GuiControl,, NoRecoilStatus, OFF
        GuiControl,, AntiAimStatus, OFF
        GuiControl,, HitboxCycleStatus, OFF
        GuiControl,, AutoReloadStatus, OFF
        GuiControl,, AutoCrouchStatus, OFF
        GuiControl,, AutoDropStatus, OFF
        
        MsgBox, "Defaults have been reset, and all features are disabled."
    Return
     
    AimLoop9:
        if toggle9 {
            targetFound9 := false
     
            if (GetKeyState("LButton", "P") || GetKeyState("RButton", "P")) {
                ; Search for target pixel
                PixelSearch, AimPixelX, AimPixelY, targetX9 - 20, targetY9 - 20, targetX9 + 20, targetY9 + 20, EMCol9, ColVn9, Fast RGB
                if (!ErrorLevel) {
                    targetX9 := AimPixelX
                    targetY9 := AimPixelY
                    targetFound9 := true
                } else {
                    PixelSearch, AimPixelX, AimPixelY, ScanL9, ScanT9, ScanR9, ScanB9, EMCol9, ColVn9, Fast RGB
                    if (!ErrorLevel) {
                        targetX9 := AimPixelX
                        targetY9 := AimPixelY
                        targetFound9 := true
                    }
                }
     
                if (targetFound9) {
                    AimX := targetX9 - ZeroX9
                    AimY := targetY9 - ZeroY9
                    DirX := (AimX > 0) ? 1 : -1
                    DirY := (AimY > 0) ? 1 : -1
                    AimOffsetX := AimX * DirX
                    AimOffsetY := AimY * DirY
                    MoveX := ImpreciseMove((AimOffsetX ** (1 / 1.1))) * DirX
                    MoveY := ImpreciseMove((AimOffsetY ** (1 / 1.1))) * DirY
                    DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
                    RandomDelay(1, 2)
                }
            }
        }
    return
     
    ToggleAimLoop9() {
        global toggle9
        toggle9 := !toggle9
        
        ; Update the checkbox state
        GuiControl,, EnableAimLoop9, % toggle9 ? 1 : 0  ; Set checkbox based on toggle state
     
        if (toggle9) {
            SetTimer, AimLoop9, 10  ; Start the loop with a timer
            SoundBeep, 500, 300
            MsgBox, Zombie Aim Loop Started
        } else {
            SetTimer, AimLoop9, Off  ; Stop the loop when toggled off
            SoundBeep, 750, 300
            MsgBox, Zombie Aim Loop Stopped
        }
     
        Gosub, UpdateStatus  ; Call UpdateStatus to refresh checkmark visibility
    }
     
    ; Page Down key to toggle Aim Loop
    PgDn::
        ToggleAimLoop9()
    return
     
    ; Pause functionality with Alt key
    end::  ; Use '-' key to pause
        Paused9 := !Paused9
        Pause, Toggle
        if Paused9 {
            SoundBeep, 750, 500
        }
    return
     
    AimLoop0:
        if toggle1s {
            CoordMode, Pixel, Screen
            ; Check if right mouse button is held down
            if GetKeyState("RButton", "P") {
                ; PixelSearch looks for the target color in the defined area
                PixelSearch, Px, Py, ScanLs1, ScanTs1, ScanRs1, ScanBs1, 0xEA00FF, 30, Fast
                if (ErrorLevel = 0) {
                    ; Target found, send shots immediately
                    sleep, 10
                    send {LButton down}
                    sleep, 10
                    send {LButton up}
                }
            }
        }
    return
     
    ToggleAimLoop0() {
        global toggle1s
        toggle1s := !toggle1s
     
        ; Update the checkbox state to reflect the toggle (enabled/disabled)
        GuiControl,, EnableAimLoop0, % toggle1s ? 1 : 0  ; Update checkbox with the current toggle state
     
        if (toggle1s) {
            SetTimer, AimLoop0, 10  ; Start the loop with a timer
            SoundBeep, 500, 300
            MsgBox, Aim Loop Started
        } else {
            SetTimer, AimLoop0, Off  ; Stop the loop when toggled off
            SoundBeep, 750, 300
            MsgBox, Aim Loop Stopped
        }
     
        Gosub, UpdateStatus  ; Refresh the checkbox and other GUI controls
    }
     
    ; ] key to toggle Aim Loop
    ]:: 
        ToggleAimLoop0()
    return
     
    ; F8 key to pause/unpause
    F8::
        Paused1s := !Paused1s
        if (Paused1s) {
            SoundBeep, 750, 500
            MsgBox, Aim Loop Paused
        } else {
            SoundBeep, 500, 500
            MsgBox, Aim Loop Unpaused
        }
    return
     
    ToggleRapidFire:
        RapidFireEnabled := !RapidFireEnabled
        GuiControl,, RapidFireStatus, % (RapidFireEnabled ? "ON" : "OFF")
        MsgBox, % "Rapid Fire is now " (RapidFireEnabled ? "enabled" : "disabled")
        Return
     
     
    ToggleNoRecoil:
        NoRecoilEnabled := !NoRecoilEnabled
        GuiControl,, NoRecoilStatus, % (NoRecoilEnabled ? "ON" : "OFF")
        MsgBox, % "No Recoil is now " (NoRecoilEnabled ? "enabled" : "disabled")
        Return
    	
    ToggleAntiAFK:
        AntiAFKEnabled := !AntiAFKEnabled
        GuiControl,, AntiAFKStatus, % (AntiAFKEnabled ? "ON" : "OFF")
        MsgBox, % "Anti-AFK is now " (AntiAFKEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleAntiAim:
        AntiAimEnabled := !AntiAimEnabled
        GuiControl,, AntiAimStatus, % (AntiAimEnabled ? "ON" : "OFF")
        MsgBox, % "Anti Aim is now " (AntiAimEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleHitboxCycle:
        HitboxCycleEnabled := !HitboxCycleEnabled
        GuiControl,, HitboxCycleStatus, % (HitboxCycleEnabled ? "ON" : "OFF")
        MsgBox, % "Hitbox Cycle is now " (HitboxCycleEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleAutoReload:
        AutoReloadEnabled := !AutoReloadEnabled
        GuiControl,, AutoReloadStatus, % (AutoReloadEnabled ? "ON" : "OFF")
        MsgBox, % "Auto Reload is now " (AutoReloadEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleAutoCrouch:
        AutoCrouchEnabled := !AutoCrouchEnabled
        GuiControl,, AutoCrouchStatus, % (AutoCrouchEnabled ? "ON" : "OFF")
        MsgBox, % "Auto Crouch is now " (AutoCrouchEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
    	
    ToggleBunnyHop:
        BunnyHopEnabled := !BunnyHopEnabled
        GuiControl,, BunnyHopStatus, % (BunnyHopEnabled ? "ON" : "OFF")
        MsgBox, % "Bunny Hop is now " (BunnyHopEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
    	
    ToggleDropShot:
        DropShotEnabled := !DropShotEnabled
        GuiControl,, DropShotStatus, % (DropShotEnabled ? "ON" : "OFF")
        MsgBox, % "Drop Shot is now " (DropShotEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
    ToggleMeleeSpam:
        ; Toggle the Melee Spam state
        MeleeSpamEnabled := !MeleeSpamEnabled
        ; Show the notification message box
        MsgBox, % "Melee Spam is now " (MeleeSpamEnabled ? "enabled" : "disabled")
        ; Call UpdateStatus to refresh checkmarks and checkbox states
        GoSub, UpdateStatus
    Return
     
    ToggleAutoCrouchProne:
        ; Toggle the Auto Crouch/Prone Spam state
        AutoCrouchProneEnabled := !AutoCrouchProneEnabled
        ; Show the notification message box
        MsgBox, % "Auto Crouch/Prone Spam is now " (AutoCrouchProneEnabled ? "enabled" : "disabled")
        ; Call UpdateStatus to refresh checkmarks and checkbox states
        GoSub, UpdateStatus
    Return
     
    ToggleAutoStrafe:
        ; Toggle the Auto Strafe state
        AutoStrafeEnabled := !AutoStrafeEnabled
        ; Show the notification message box
        MsgBox, % "Auto Strafe is now " (AutoStrafeEnabled ? "enabled" : "disabled")
        ; Call UpdateStatus to refresh checkmarks and checkbox states
        GoSub, UpdateStatus
    Return
     
    ToggleJoshTriggerBot:
        ; Toggle the Josh Trigger Bot state
        JoshTriggerBotEnabled := !JoshTriggerBotEnabled
        ; Show the notification message box
        MsgBox, % "Josh Trigger Bot is now " (JoshTriggerBotEnabled ? "enabled" : "disabled")
        ; Call UpdateStatus to refresh checkmarks and checkbox states
        GoSub, UpdateStatus
    Return
     
    ToggleJitter:
        JitterEnabled := !JitterEnabled
        GuiControl,, JitterStatus, % (JitterEnabled ? "ON" : "OFF")
        MsgBox, % "Jitter is now " (JitterEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleSniperBreath:
        SniperBreathEnabled := !SniperBreathEnabled
        GuiControl,, SniperBreathStatus, % (SniperBreathEnabled ? "ON" : "OFF")
        MsgBox, % "Sniper Breath is now " (SniperBreathEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleAutoSprint:
        AutoSprintEnabled := !AutoSprintEnabled
        GuiControl,, AutoSprintStatus, % (AutoSprintEnabled ? "ON" : "OFF")
        MsgBox, % "Auto Sprint is now " (AutoSprintEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleFastReload:
        FastReloadEnabled := !FastReloadEnabled
        GuiControl,, FastReloadStatus, % (FastReloadEnabled ? "ON" : "OFF")
        MsgBox, % "Fast Reload is now " (FastReloadEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleQuickScope:
        QuickScopeEnabled := !QuickScopeEnabled
        GuiControl,, QuickScopeStatus, % (QuickScopeEnabled ? "ON" : "OFF")
        MsgBox, % "Quick Scope is now " (QuickScopeEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ToggleAutoDrop:
        AutoDropEnabled := !AutoDropEnabled
        GuiControl,, AutoDropStatus, % (AutoDropEnabled ? "ON" : "OFF")
        MsgBox, % "Auto Drop is now " (AutoDropEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
    	
    	; Jump Shot Toggle
    ToggleJumpShot:
        JumpShotEnabled := !JumpShotEnabled
        GuiControl,, JumpShotStatus, % (JumpShotEnabled ? "ON" : "OFF")
        MsgBox, % "Jump Shot is now " (JumpShotEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus  ; Call UpdateStatus to refresh checkmarks
        Return
     
    ; Drop Shot 2 Toggle
    ToggleDropShot2:
        DropShot2Enabled := !DropShot2Enabled
        GuiControl,, DropShot2Status, % (DropShot2Enabled ? "ON" : "OFF")
        MsgBox, % "Drop Shot 2 is now " (DropShot2Enabled ? "enabled" : "disabled")
        GoSub, UpdateStatus
        Return
     
    ; Crouch Shot Toggle
    ToggleCrouchShot:
        CrouchShotEnabled := !CrouchShotEnabled
        GuiControl,, CrouchShotStatus, % (CrouchShotEnabled ? "ON" : "OFF")
        MsgBox, % "Crouch Shot is now " (CrouchShotEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus
        Return
     
    ; Hold Breath Toggle
    ToggleHoldBreath:
        HoldBreathEnabled := !HoldBreathEnabled
        GuiControl,, HoldBreathStatus, % (HoldBreathEnabled ? "ON" : "OFF")
        MsgBox, % "Hold Breath is now " (HoldBreathEnabled ? "enabled" : "disabled")
        GoSub, UpdateStatus
        Return
     
    	Home::
        ; Toggle the prediction checkbox state
        GuiControlGet, PredictionState,, EnablePredictionCheckbox
        PredictionState := !PredictionState  ; Toggle the state
        GuiControl,, EnablePredictionCheckbox, % PredictionState  ; Update the checkbox in the GUI
     
        ; Update the checkmark visibility
        if (PredictionState) {
            SoundBeep, 500, 300
            GuiControl, Show, PredictionCheckmark  ; Show the checkmark
        } else {
            SoundBeep, 750, 300
            GuiControl, Hide, PredictionCheckmark  ; Hide the checkmark
        }
    return
     
    ToggleMonitor:
        ; Get the number of monitors
        SysGet, monitorCount, MonitorCount
        
        if (monitorCount >= 2) {
            ; Get the dimensions of the second monitor (Monitor 2)
            SysGet, monitorLeft, Monitor, 2  ; x position of the second monitor (left edge)
            SysGet, monitorTop, Monitor, 2   ; y position of the second monitor (top edge)
            SysGet, monitorRight, Monitor, 2 ; x position of the right edge of the second monitor
            SysGet, monitorBottom, Monitor, 2 ; y position of the bottom edge of the second monitor
     
            ; Define GUI width and height (as per your script)
            Width := 425
            Height := 555
     
            ; Calculate the new position (bottom-left corner)
            newX := monitorLeft  ; x position of the second monitor (left edge)
            newY := monitorBottom - Height  ; y position at the bottom-left of the second monitor (Height used here)
     
            ; Move the GUI to the second monitor
            Gui, Show, % "w" Width " h" Height " NA" " x" newX " y" newY
        } else {
            MsgBox, Only one monitor detected!
        }
    return
     
    UpdateStatus:
    ; Handle the state of the Multi-Player Aim checkbox
    GuiControlGet, state,, EnableCheckbox
    if (state) {
        GuiControl, Show, EnableCheckmark
    } else {
        GuiControl, Hide, EnableCheckmark
    }
     
    ; Handle the Prediction checkbox
    GuiControlGet, predictionState,, EnablePredictionCheckbox
    if (predictionState) {
        GuiControl, Show, vPredictionCheckmark
    } else {
        GuiControl, Hide, vPredictionCheckmark
    }
     
    ; Aim Loop 6 (Zombie Aim Loop)
    GuiControlGet, aimLoop6State,, EnableAimLoop6
    if (aimLoop6State) {
        SetTimer, AimLoop6, 5
        GuiControl, Show, ZombieCheckmark  ; Show the checkmark for Aim Loop 6
    } else {
        SetTimer, AimLoop6, Off
        GuiControl, Hide, ZombieCheckmark  ; Hide the checkmark for Aim Loop 6
    }
     
    ; Custom Aim Loop (Enable2)
    GuiControlGet, enable2State,, Enable2Checkbox
    if (enable2State) {
        SetTimer, AimLoop2, 5
        GuiControl, Show, Enable2Checkmark  ; Show the checkmark for Enable2
    } else {
        SetTimer, AimLoop2, Off
        toggle2 := false
        GuiControl, Hide, Enable2Checkmark  ; Hide the checkmark for Enable2
    }
    	
    	    ; Update the checkbox GUI to reflect the new state
        GuiControl,, JoshTriggerBotCheckbox, % (JoshTriggerBotEnabled ? "1" : "0")
        GuiControl,, AutoStrafeCheckbox, % (AutoStrafeEnabled ? "1" : "0")
        GuiControl,, AutoCrouchProneCheckbox, % (AutoCrouchProneEnabled ? "1" : "0")
        GuiControl,, MeleeSpamCheckbox, % (MeleeSpamEnabled ? "1" : "0")
     
        ; Tooltips for each feature
        ; Tooltip, % "Josh Trigger Bot is " (JoshTriggerBotEnabled ? "Enabled" : "Disabled")
        ; SetTimer, RemoveTooltip, -1500  ; Hide the tooltip after 1.5 seconds
     
     
        ; Handle Zombies Aim checkboxes and their conflicts
        GuiControlGet, zombiesState1,, EnableAimLoop8  ; Zombie Aim V2
        GuiControlGet, zombiesState2,, EnableAimLoop9  ; Zombie Aim V1
        GuiControlGet, triggerBotState,, EnableAimLoop0  ; Trigger Bot
     
        ; Handle conflicts and update checkmarks for Zombie Aim and Trigger Bot
        if (state || predictionState) {
            GuiControl,, EnableAimLoop8, 0  ; Disable Zombie Aim V2
            GuiControl, Hide, vZombieCheckmark3  ; Hide checkmark for Zombie Aim V2
     
            GuiControl,, EnableAimLoop9, 0  ; Disable Zombie Aim V1
            GuiControl, Hide, vZombieCheckmark2  ; Hide checkmark for Zombie Aim V1
     
            GuiControl,, EnableAimLoop0, 0  ; Disable Trigger Bot
            GuiControl, Hide, vTriggerBotCheckmark  ; Hide checkmark for Trigger Bot
        }
     
        ; Update checkmarks based on current states for Zombies Aim
        GuiControl, % (zombiesState1 ? "" : "Hide"), vZombieCheckmark3
        GuiControl, % (zombiesState2 ? "" : "Hide"), vZombieCheckmark2
        GuiControl, % (triggerBotState ? "" : "Hide"), vTriggerBotCheckmark
     
    ; Handle additional features and update checkmarks for various toggles
        GuiControlGet, dropShotState,, EnableDropShot
        DropShotEnabled := dropShotState
        GuiControlGet, dropShot2State,, EnableDropShot2
        DropShot2Enabled := dropShot2State
        GuiControlGet, crouchShotState,, EnableCrouchShot
        CrouchShotEnabled := crouchShotState
        GuiControlGet, holdBreathState,, EnableHoldBreath
        HoldBreathEnabled := holdBreathState
        GuiControlGet, jitterState,, EnableJitter
        JitterEnabled := jitterState
        GuiControlGet, sniperBreathState,, EnableSniperBreath
        SniperBreathEnabled := sniperBreathState
        GuiControlGet, autoSprintState,, EnableAutoSprint
        AutoSprintEnabled := autoSprintState
        GuiControlGet, fastReloadState,, EnableFastReload
        FastReloadEnabled := fastReloadState
        GuiControlGet, quickScopeState,, EnableQuickScope
        QuickScopeEnabled := quickScopeState
        GuiControlGet, bunnyHopState,, EnableBunnyHop
        BunnyHopEnabled := bunnyHopState
        GuiControlGet, antiAimState,, EnableAntiAim
        AntiAimEnabled := antiAimState
        GuiControlGet, hitboxCycleState,, EnableHitboxCycle
        HitboxCycleEnabled := hitboxCycleState
        GuiControlGet, autoReloadState,, EnableAutoReload
        AutoReloadEnabled := autoReloadState
        GuiControlGet, autoCrouchState,, EnableAutoCrouch
        AutoCrouchEnabled := autoCrouchState
        GuiControlGet, autoDropState,, EnableAutoDrop
        AutoDropEnabled := autoDropState
        GuiControlGet, antiAFKState,, AntiAFKCheckbox
        AntiAFKEnabled := antiAFKState
        GuiControlGet, jumpShotState,, EnableJumpShot
        JumpShotEnabled := jumpShotState
     
     
     
        ; Update checkmarks for additional features
        GuiControl, % (dropShotState ? "" : "Hide"), vDropShotCheckmark
        GuiControl, % (dropShot2State ? "" : "Hide"), vDropShot2Checkmark
        GuiControl, % (crouchShotState ? "" : "Hide"), vCrouchShotCheckmark
        GuiControl, % (holdBreathState ? "" : "Hide"), vHoldBreathCheckmark
        GuiControl, % (jitterState ? "" : "Hide"), vJitterCheckmark
        GuiControl, % (sniperBreathState ? "" : "Hide"), vSniperBreathCheckmark
        GuiControl, % (autoSprintState ? "" : "Hide"), vAutoSprintCheckmark
        GuiControl, % (fastReloadState ? "" : "Hide"), vFastReloadCheckmark
        GuiControl, % (quickScopeState ? "" : "Hide"), vQuickScopeCheckmark
        GuiControl, % (bunnyHopState ? "" : "Hide"), vBunnyHopCheckmark
        GuiControl, % (antiAimState ? "" : "Hide"), vAntiAimCheckmark
        GuiControl, % (hitboxCycleState ? "" : "Hide"), vHitboxCycleCheckmark
        GuiControl, % (autoReloadState ? "" : "Hide"), vAutoReloadCheckmark
        GuiControl, % (autoCrouchState ? "" : "Hide"), vAutoCrouchCheckmark
        GuiControl, % (autoDropState ? "" : "Hide"), vAutoDropCheckmark
        GuiControl, % (antiAFKState ? "" : "Hide"), vAntiAFKCheckmark
    Return
     
    ; Submit Color function
    SubmitColor:
        GuiControlGet, ColorHex,, ColorHex
        ; Check if the color has changed before updating
        if (ColorHex != LastColorHex) {
            LastColorHex := ColorHex
            UpdateColor()
        }
    return
     
    ; Update Color function
    UpdateColor() {
        global EMCol
        GuiControlGet, ColorHex,, ColorHex
        if (ColorHex != "") {
            ; Validate the hex input (6 digits)
            if (RegExMatch(ColorHex, "^[0-9A-Fa-f]{6}$")) {
                ; Ensure it starts with 0x for hex representation
                EMCol := "0x" . ColorHex
                ; Optionally update the display in the edit box
                GuiControl,, ColorHex, % ColorHex
                MsgBox, Color successfully set to: %ColorHex%
            } else {
                MsgBox, Invalid hex color code! Please enter a valid 6-digit hex code.
            }
        }
    }
     
    PickColor:
        Color := 0x000000
        ColorPick := DllCall("user32.dll\ChooseColor", "UInt", &Color)
        if (ColorPick) {
            EMCol := Color
            ; Update the GUI Edit control to show the new color
            GuiControl,, ColorHex, % Format("{:X}", EMCol & 0xFFFFFF)  ; Mask to ensure only 6 hex digits are shown
        }
    return
    RemoveTooltip:
        Tooltip
        SetTimer, RemoveTooltip, Off
    Return
    SaveSettings() {
        global EMCol, ColVn, ZeroX, ZeroY, smoothing, predictionMultiplier
        global RapidFireEnabled, NoRecoilEnabled, DropShotEnabled, DropShot2Enabled
        global JitterEnabled, SniperBreathEnabled, AutoSprintEnabled
        global FastReloadEnabled, QuickScopeEnabled, AntiAimEnabled
        global HitboxCycleEnabled, AutoReloadEnabled, AutoCrouchEnabled, AutoDropEnabled
        global BunnyHopEnabled, CrouchShotEnabled, JumpShotEnabled
        global RecoilIntensity, NoRecoilSpeed, FOVValue
        global JoshTriggerBotEnabled, AutoStrafeEnabled, AutoCrouchProneEnabled, MeleeSpamEnabled
     
        ; Delete existing settings file
        FileDelete, Settings.ini
     
        ; Use FileAppend to save settings with no spaces before or after values
        FileAppend,
        (
        EMCol=%EMCol%
        ColVn=%ColVn%
        ZeroX=%ZeroX%
        ZeroY=%ZeroY%
        smoothing=%smoothing%
        predictionMultiplier=%predictionMultiplier%
        RapidFireEnabled=%RapidFireEnabled%
        NoRecoilEnabled=%NoRecoilEnabled%
        DropShotEnabled=%DropShotEnabled%
        DropShot2Enabled=%DropShot2Enabled%
        JitterEnabled=%JitterEnabled%
        SniperBreathEnabled=%SniperBreathEnabled%
        AutoSprintEnabled=%AutoSprintEnabled%
        FastReloadEnabled=%FastReloadEnabled%
        QuickScopeEnabled=%QuickScopeEnabled%
        AntiAimEnabled=%AntiAimEnabled%
        HitboxCycleEnabled=%HitboxCycleEnabled%
        AutoReloadEnabled=%AutoReloadEnabled%
        AutoCrouchEnabled=%AutoCrouchEnabled%
        AutoDropEnabled=%AutoDropEnabled%
        BunnyHopEnabled=%BunnyHopEnabled%
        CrouchShotEnabled=%CrouchShotEnabled%
        JumpShotEnabled=%JumpShotEnabled%
        RecoilIntensity=%RecoilIntensity%
        NoRecoilSpeed=%NoRecoilSpeed%
        FOVValue=%FOVValue%
        JoshTriggerBotEnabled=%JoshTriggerBotEnabled%
        AutoStrafeEnabled=%AutoStrafeEnabled%
        AutoCrouchProneEnabled=%AutoCrouchProneEnabled%
        MeleeSpamEnabled=%MeleeSpamEnabled%
        ), Settings.ini
     
        ; Clean up formatting by removing any leading spaces
        FileRead, settings, Settings.ini
        StringReplace, settings, settings, %A_Space%, , All
        FileDelete, Settings.ini
        FileAppend, %settings%, Settings.ini
     
        MsgBox, Settings saved successfully!
    }
     
     
    LoadSettings() {
        global EMCol, ColVn, ZeroX, ZeroY, smoothing, predictionMultiplier
        global RapidFireEnabled, NoRecoilEnabled, DropShotEnabled, DropShot2Enabled
        global JitterEnabled, SniperBreathEnabled, AutoSprintEnabled
        global FastReloadEnabled, QuickScopeEnabled, AntiAimEnabled
        global HitboxCycleEnabled, AutoReloadEnabled, AutoCrouchEnabled, AutoDropEnabled
        global BunnyHopEnabled, CrouchShotEnabled, JumpShotEnabled
        global RecoilIntensity, NoRecoilSpeed, FOVValue
        global JoshTriggerBotEnabled, AutoStrafeEnabled, AutoCrouchProneEnabled, MeleeSpamEnabled
     
        if !FileExist("Settings.ini") {
            MsgBox, Settings file not found!
            return
        }
     
        FileRead, settings, Settings.ini
        Loop, Parse, settings, `n, `r
        {
            StringSplit, line, A_LoopField, =
            if (line1 && line2) {
                ; Use dynamic variable assignment correctly
                %line1% := line2
            }
        }
     
        ; Update GUI with loaded values
        GuiControl,, SmoothingValue, %smoothing%
        GuiControl,, PredictionValue, %predictionMultiplier%
        GuiControl,, ToleranceValue, %ColVn%
        GuiControl,, EMColorValue, %EMCol%
        GuiControl,, ZeroXValue, %ZeroX%
        GuiControl,, ZeroYValue, %ZeroY%
        GuiControl,, RapidFireCheckbox, %RapidFireEnabled%
        GuiControl,, NoRecoilCheckbox, %NoRecoilEnabled%
        GuiControl,, DropShotCheckbox, %DropShotEnabled%
        GuiControl,, DropShot2Checkbox, %DropShot2Enabled%
        GuiControl,, JitterCheckbox, %JitterEnabled%
        GuiControl,, SniperBreathCheckbox, %SniperBreathEnabled%
        GuiControl,, AutoSprintCheckbox, %AutoSprintEnabled%
        GuiControl,, FastReloadCheckbox, %FastReloadEnabled%
        GuiControl,, QuickScopeCheckbox, %QuickScopeEnabled%
        GuiControl,, AntiAimCheckbox, %AntiAimEnabled%
        GuiControl,, HitboxCycleCheckbox, %HitboxCycleEnabled%
        GuiControl,, AutoReloadCheckbox, %AutoReloadEnabled%
        GuiControl,, AutoCrouchCheckbox, %AutoCrouchEnabled%
        GuiControl,, AutoDropCheckbox, %AutoDropEnabled%
        GuiControl,, BunnyHopCheckbox, %BunnyHopEnabled%
        GuiControl,, CrouchShotCheckbox, %CrouchShotEnabled%
        GuiControl,, JumpShotCheckbox, %JumpShotEnabled%
        GuiControl,, RecoilIntensityValue, %RecoilIntensity%
        GuiControl,, NoRecoilSpeedValue, %NoRecoilSpeed%
        GuiControl,, FOVValue, %FOVValue%
        GuiControl,, JoshTriggerBotCheckbox, %JoshTriggerBotEnabled%
        GuiControl,, AutoStrafeCheckbox, %AutoStrafeEnabled%
        GuiControl,, AutoCrouchProneCheckbox, %AutoCrouchProneEnabled%
        GuiControl,, MeleeSpamCheckbox, %MeleeSpamEnabled%
     
        MsgBox, Settings loaded successfully!
    }
     
    toggle4 := false
    toggle5 := false
    toggle6 := false
     
    F4::
    toggle4 := !toggle4
    if (toggle4) {
        SetTimer, Press4, 10
        SoundBeep, 1000, 200
    } else {
        SetTimer, Press4, Off
        SoundBeep, 500, 200
    }
    Return
     
    /*
    F5::
    toggle5 := !toggle5
    if (toggle5) {
        SetTimer, Press5, 10
        SoundBeep, 1000, 200
    } else {
        SetTimer, Press5, Off
        SoundBeep, 500, 200
    }
    Return
     
    /*
    F6::
    toggle6 := !toggle6
    if (toggle6) {
        SetTimer, Press6, 10
        SoundBeep, 1000, 200
    } else {
        SetTimer, Press6, Off
        SoundBeep, 500, 200
    }
    Return
    */
     
    Press4:
    Send, 4
    Return
     
    Press5:
    Send, 5
    Return
     
    Press6:
    Send, 6
    Return
     
    ShowCredits:
        MsgBox, 0, Credits, Special Thanks to Sai, Treason, and AVXNTV3 for their contributions.
    Return
     
    Close:
    ExitApp
     
    f9::Reload
     
    OpenZombieAimV2:
        ; Target dot settings for Less Snappy Aim
        EMCol4 := 0xDF00FF  ; Color of purple diamond
        ColVn4 := 25        ; Tolerance for color match
        ZeroX4 := 955       ; Central aim point
        ZeroY4 := 500       ; Center Y coordinate of aim area
        CFovX4 := 200       ; Field of view width
        CFovY4 := 200       ; Field of view height
        ScanL4 := ZeroX4 - CFovX4
        ScanT4 := ZeroY4 - CFovY4
        ScanR4 := ZeroX4 + CFovX4
        ScanB4 := ZeroY4 + CFovY4
     
        targetX4 := 0
        targetY4 := 0
        toggle4 := false
        Paused4 := false
     
        ; Offset for final aim position relative to the purple diamond
        OffsetX4 := 45      ; Offset right
        OffsetY4 := 50      ; Offset down
     
        ; Target dot settings for Snappy Aim
        EMCol5 := 0xDF00FF  ; Color of purple diamond
        ColVn5 := 25        ; Tolerance for color match
        ZeroX5 := 955       ; Central aim point
        ZeroY5 := 500       ; Center Y coordinate of aim area
        CFovX5 := 200       ; Field of view width
        CFovY5 := 200       ; Field of view height
        ScanL5 := ZeroX5 - CFovX5
        ScanT5 := ZeroY5 - CFovY5
        ScanR5 := ZeroX5 + CFovX5
        ScanB5 := ZeroY5 + CFovY5
     
        targetX5 := 0
        targetY5 := 0
        toggle5 := false
        Paused5 := false
     
        ; Offset for final aim position relative to the purple diamond
        OffsetX5 := 45      ; Offset right
        OffsetY5 := 50      ; Offset down
        ; Close the launcher GUI
        Gui, Destroy
     
        ; Create Aim GUI without title bar
        Gui, +AlwaysOnTop +Resize +ToolWindow -Caption +E0x20
        Gui, Color, 880808
        Gui, Margin, 10, 10
        Gui, Font, s10 cD0D0D0 Bold
        Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200", Zombies Aim V2
     
        ; Add Controls
        Gui, Add, Text, % "x10 y40 w120", Less Snappy Aim Toggle:
        Gui, Add, Button, % "x130 y40 w100 gToggleAim4", Toggle Less Snappy Aim
        Gui, Add, Button, % "x240 y40 w100 gPauseAim4", Pause/Resume
     
        ; Snappy Aim Controls
        Gui, Add, Text, % "x10 y80 w120", Snappy Aim Toggle:
        Gui, Add, Button, % "x130 y80 w100 gToggleAim5", Toggle Snappy Aim
        Gui, Add, Button, % "x240 y80 w100 gPauseAim5", Pause/Resume
    	
    	; Additional GUI Button
    Gui, Add, Button, % "x100 y130 w150 gShowAdditionalGUI", Show Additional GUI ; Button to open the color settings GUI
     
        ; Add Close Button
        Gui, Add, Button, % "x10 y120 w80 gGuiClose2", Close
     
        ; Show Aim GUI
        Gui, Show, , Zombie Aim V2
     
    ; Enable dragging
    Gui, +LastFound
    WinGet, guiID, ID, A
    OnMessage(WM_NCHITTEST := 0x0084, "WM_NCHITTEST1")
    return
     
    WM_NCHITTEST1() {
        ; Allow dragging of the GUI
        return 2  ; HTCAPTION
    }
     
    ; Loop for Less Snappy Zombies Aim
    AimLoop1: 
        global toggle4, targetX4, targetY4, ZeroX4, ZeroY4, EMCol4, ColVn4, ScanL4, ScanT4, ScanR4, ScanB4, OffsetX4, OffsetY4
        while (toggle4) {
            targetFound4 := False
            if (toggle4 && (GetKeyState("LButton", "P") || GetKeyState("RButton", "P"))) {
                PixelSearch, AimPixelX4, AimPixelY4, ScanL4, ScanT4, ScanR4, ScanB4, EMCol4, ColVn4, Fast RGB
                if (!ErrorLevel) {
                    targetX4 := AimPixelX4 + OffsetX4
                    targetY4 := AimPixelY4 + OffsetY4
                    targetFound4 := True
                }
     
                if (targetFound4) {
                    TargetAimX4 := targetX4 - ZeroX4
                    TargetAimY4 := targetY4 - ZeroY4
                    MoveX4 := Round(TargetAimX4 * 0.1)
                    MoveY4 := Round(TargetAimY4 * 0.1)
                    if (Abs(MoveX4) > 1 || Abs(MoveY4) > 1) {
                        DllCall("mouse_event", "UInt", 1, "Int", MoveX4, "Int", MoveY4, "UInt", 0, "Int", 0)
                    }
                }
            }
            Sleep, 10  ; Less Snappy Aim loop delay
        }
    return
     
    ; Loop for Snappy V2 No GUI
    AimingLoop:
        global toggle5, targetX5, targetY5, ZeroX5, ZeroY5, EMCol5, ColVn5, ScanL5, ScanT5, ScanR5, ScanB5, OffsetX5, OffsetY5
        while (toggle5) {
            targetFound5 := False
            if (toggle5 && (GetKeyState("LButton", "P") || GetKeyState("RButton", "P"))) {
                PixelSearch, AimPixelX5, AimPixelY5, ScanL5, ScanT5, ScanR5, ScanB5, EMCol5, ColVn5, Fast RGB
                if (!ErrorLevel) {
                    targetX5 := AimPixelX5 + OffsetX5
                    targetY5 := AimPixelY5 + OffsetY5
                    targetFound5 := True
                }
     
                if (targetFound5) {
                    TargetAimX5 := targetX5 - ZeroX5
                    TargetAimY5 := targetY5 - ZeroY5
                    MoveX5 := Round(TargetAimX5 * 0.3)
                    MoveY5 := Round(TargetAimY5 * 0.3)
                    if (Abs(MoveX5) > 0 || Abs(MoveY5) > 0) {
                        DllCall("mouse_event", "UInt", 1, "Int", MoveX5, "Int", MoveY5, "UInt", 0, "Int", 0)
                    }
                }
            }
            Sleep, 5  ; Snappy Aim loop delay
        }
    return
     
    ; Toggle Less Snappy Aim
    ToggleAim4:
        toggle4 := !toggle4
        if toggle4 {
            ; Start the aiming loop
            SetTimer, AimLoop1, 0
        } else {
            ; Stop the aiming loop
            SetTimer, AimLoop1, Off
        }
        SoundBeep, % toggle4 ? 500 : 750, 300
    Return
     
    ; Pause Less Snappy Aim
    PauseAim4:
        Paused4 := !Paused4
        Pause, Toggle
        SoundBeep, 750, 500
    Return
     
    ; Toggle Snappy Aim
    ToggleAim5:
        toggle5 := !toggle5
        if toggle5 {
            ; Start the aiming loop
            SetTimer, AimingLoop, 0
        } else {
            ; Stop the aiming loop
            SetTimer, AimingLoop, Off
        }
        SoundBeep, % toggle5 ? 500 : 750, 300
    Return
     
    ; Pause Snappy Aim
    PauseAim5:
        Paused5 := !Paused5
        Pause, Toggle
        SoundBeep, 750, 500
    Return
     
    ; Show the additional GUI
    gShowAdditionalGUI:
        ShowAdditionalGUI()
    Return
     
    ; Function to create and show the additional settings GUI
    ShowAdditionalGUI() {
        Gui, New, +Resize, Zombie Aim V2
        Gui, Add, Text, , Target Color (Hex)
        Gui, Add, Edit, vColorHex, % Format("0x{:X}", EMCol4) ; Default color for EMCol4
        Gui, Add, Button, gSubmitColor4, Set Less Snappy Aim Color
        Gui, Add, Edit, vColorHex5, % Format("0x{:X}", EMCol5) ; Default color for EMCol5
        Gui, Add, Button, gSubmitColor5, Set Snappy Aim Color
        Gui, Add, Button, gClose2, Close  ; Close button
        Gui, Show
    }
     
    ; Close the additional GUI
    Close2:
        Gui, Destroy
    return
     
    ; Submit Color function for Less Snappy Aim
    SubmitColor4:
        Gui, Submit, NoHide
        ; Update EMCol4 with the new color
        NewColor := ColorHex
        if (NewColor && RegExMatch(NewColor, "^0x[0-9A-Fa-f]{6}$")) {
            EMCol4 := NewColor
            ToolTip, Less Snappy Aim color changed to %NewColor%
            Sleep, 2000
            ToolTip
        }
    return
     
    ; Submit Color function for Snappy Aim
    SubmitColor5:
        Gui, Submit, NoHide
        ; Update EMCol5 with the new color
        NewColor := ColorHex5
        if (NewColor && RegExMatch(NewColor, "^0x[0-9A-Fa-f]{6}$")) {
            EMCol5 := NewColor
            ToolTip, Snappy Aim color changed to %NewColor%
            Sleep, 2000
            ToolTip
        }
    return
     
    GuiClose3:
        ExitApp
    return
     
     
    OpenZombieAim:
        ; Define Zombie Aim variables for target and scanning
        EMCol1 := 0xEA00FF    ; Enemy color in hexadecimal
        ColVn1 := 25          ; Color variance for detection
        ZeroX1 := A_ScreenWidth / 2.08  ; X center offset for aim targeting
        ZeroY1 := A_ScreenHeight / 2.19 ; Y center offset for aim targeting
        CFovX1 := 120  ; Field of view width
        CFovY1 := 120  ; Field of view height
        ScanL1 := ZeroX1 - CFovX1  ; Left boundary of scan area
        ScanT1 := ZeroY1 - CFovY1  ; Top boundary of scan area
        ScanR1 := ZeroX1 + CFovX1  ; Right boundary of scan area
        ScanB1 := ZeroY1 + CFovY1  ; Bottom boundary of scan area
        targetX1 := 0  ; X position of target
        targetY1 := 0  ; Y position of target
     
        ; Close the launcher GUI
        Gui, Destroy
     
        ; Create Aim GUI without title bar
        Gui, +AlwaysOnTop +Resize +ToolWindow -Caption +E0x20
        Gui, Color, 880808
        Gui, Margin, 10, 10
        Gui, Font, s10 cD0D0D0 Bold
        Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200", Zombies Aim
     
        ; Add Controls
        Gui, Add, Text, % "x10 y40 w120", Aim Toggle:
        Gui, Add, Button, % "x130 y40 w100 gToggleAim", Toggle Aim
        Gui, Add, Button, % "x240 y40 w100 gPauseToggle2", Pause/Resume
     
        ; Adjust Compensation Section
        Gui, Add, Text, % "x10 y80 w150", Adjust Compensation:
        Gui, Add, Button, % "x10 y100 w50 gAdjustUp", Up
        Gui, Add, Button, % "x70 y100 w50 gAdjustDown", Down
        Gui, Add, Button, % "x130 y100 w50 gAdjustLeft", Left
        Gui, Add, Button, % "x190 y100 w50 gAdjustRight", Right
     
        ; Additional GUI Button for changing color
        Gui, Add, Button, % "x10 y140 w150 gShowColorGUI", Change Enemy Color
     
        ; Add Close Button
        Gui, Add, Button, % "x10 y180 w80 gGuiClose1", Close
     
        ; Show Aim GUI
        Gui, Show, , Zombie Aim
     
        ; Enable dragging
        Gui, +LastFound
        WinGet, guiID, ID, A
        OnMessage(WM_NCHITTEST := 0x0084, "WM_NCHITTEST")
    return
     
    WM_NCHITTEST() {
        ; Allow dragging of the GUI
        return 2  ; HTCAPTION
    }
     
    ShowColorGUI() {
        ; Ensure EMCol1 is displayed in the correct format
        currentColor := Format("0x{:X}", EMCol1) ; This will keep the format intact
     
        Gui, New, +Resize, Change Enemy Color
        Gui, Add, Text, , Enter Enemy Color (Hex):
        Gui, Add, Edit, vNewColorHex w200 h30, % currentColor ; Set default color with larger size
        Gui, Add, Button, gSubmitColor3, Set Enemy Color
        Gui, Add, Button, gCloseColorGUI, Close
        Gui, Show
    }
     
     
     
    ; Close the color settings GUI
    CloseColorGUI:
        Gui, Destroy
    return
     
    SubmitColor3:
        Gui, Submit, NoHide
        ; Update EMCol1 with the new color
        NewColor := NewColorHex
        if (NewColor && RegExMatch(NewColor, "^0x[0-9A-Fa-f]{6}$")) {
            EMCol1 := NewColor
            MsgBox, New EMCol1 color set to: %EMCol1% ; Display the new value
            ToolTip, Enemy color changed to %EMCol1%
            Sleep, 2000
            ToolTip
        } else {
            MsgBox, Invalid color format! Please enter a valid hex color (e.g., 0xFFFFFF).
        }
    return
     
    AimLoop:
        targetFound1 := False
     
        if Paused2  ; Check if paused
            return  ; If paused, exit the loop
     
        if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
            PixelSearch, AimPixelX1, AimPixelY1, targetX1 - 20, targetY1 - 20, targetX1 + 20, targetY1 + 20, EMCol1, ColVn1, Fast RGB
            if (!ErrorLevel) {
                targetX1 := AimPixelX1
                targetY1 := AimPixelY1
                targetFound1 := True
            } else {
                PixelSearch, AimPixelX1, AimPixelY1, ScanL1, ScanT1, ScanR1, ScanB1, EMCol1, ColVn1, Fast RGB
                if (!ErrorLevel) {
                    targetX1 := AimPixelX1
                    targetY1 := AimPixelY1
                    targetFound1 := True
                }
            }
     
            if (targetFound1 && toggle1) {
                AimX1 := targetX1 - ZeroX1
                AimY1 := targetY1 - ZeroY1
                DirX1 := (AimX1 > 0) ? 1 : -1
                DirY1 := (AimY1 > 0) ? 1 : -1
                MoveX1 := ImpreciseMove((Abs(AimX1) ** (1 / 1.1))) * DirX1
                MoveY1 := ImpreciseMove((Abs(AimY1) ** (1 / 1.1))) * DirY1
                DllCall("mouse_event", uint, 1, int, MoveX1, int, MoveY1, uint, 0, int, 0)
                RandomDelay(1, 2)
            }
        }
     
        if (targetFound1 && toggle1) {
            click down
        } else {
            click up
        }
    return
     
    ToggleAim:
        toggle1 := !toggle1
        GuiControl, , ToggleAim, % toggle1 ? "Disable" : "Enable"
        SoundBeep, 500, 300
     
        if (toggle1) {
            SetTimer, AimLoop, 10  ; Start the aiming loop
        } else {
            SetTimer, AimLoop, Off  ; Stop the aiming loop
        }
    return
     
    PauseToggle2:
        Paused2 := !Paused2
        if (Paused2) {
            SoundBeep, 750, 500
        } else {
            SoundBeep, 500, 300
        }
    return
     
    AdjustUp:
        ZeroY1 += 5
    return
     
    AdjustDown:
        ZeroY1 -= 5
    return
     
    AdjustLeft:
        ZeroX1 /= 1.01
    return
     
    AdjustRight:
        ZeroX1 /= 0.99
    return
     
    GuiClose1:
        ExitApp
     
     
     
    ; Trigger Bot GUI
    OpenTriggerBot:
     
        ZeroX2 := A_ScreenWidth / 2.08
        ZeroY2 := A_ScreenHeight / 2.18	
        CFovXX2 := 40
        CFovYY2 := 120
        ScanL2 := ZeroX2 - CFovXX2
        ScanT2 := ZeroY2 - CFovYY2
        ScanR2 := ZeroX2 + CFovXX2
        ScanB2 := ZeroY2 + CFovYY2
     
        ; Close the launcher GUI if it's open
        Gui, Destroy
     
        ; Create Trigger Bot GUI
        Gui, +AlwaysOnTop +Resize +ToolWindow
        Gui, Color, 880808
        Gui, Margin, 10, 10
        Gui, Font, s10 cD0D0D0 Bold
        Gui, Add, Text, , Trigger Bot Controls:
        Gui, Add, Button, gStartTriggerBot, Start Trigger Bot
        Gui, Add, Button, gStopTriggerBot, Stop Trigger Bot
        Gui, Add, Button, gPauseToggle3, Pause/Resume
        Gui, Show, , Trigger Bot
     
        return
     
    StartTriggerBot:
        triggerActive := true
        GuiControl, , Start Trigger Bot, Disabled
        GuiControl, , Stop Trigger Bot, Enabled
        GuiControl, , Pause/Resume, Enabled
     
        Loop {
            if (paused3 || !triggerActive) {
                Sleep, 100
                continue
            }
            
            KeyWait, RButton, D
            CoordMode, Pixel, Screen
            PixelSearch, Px, Py, ScanL2, ScanT2, ScanR2, ScanB2, 0xEA00FF, 30, Fast
            
            if (ErrorLevel = 0) {
                Sleep, 10
                Send {LButton down}
                Sleep, 10
                Send {LButton up}
                Sleep, 2000 ; 2-second delay after each trigger
            }
        }
    return
     
    StopTriggerBot:
        triggerActive := false
        GuiControl, , Start Trigger Bot, Enabled
        GuiControl, , Stop Trigger Bot, Disabled
        GuiControl, , Pause/Resume, Disabled
    return
     
    PauseToggle3:
        paused3 := !paused3  ; Toggle the paused state
        if (paused3) {  ; Check the correct variable
            GuiControl, , Pause/Resume, Resume  ; Update the GUI control text
            SoundBeep, 750, 500  ; Beep for resume
        } else {
            GuiControl, , Pause/Resume, Pause  ; Update the GUI control text
            SoundBeep, 500, 300  ; Beep for pause
        }
    return
     
    GuiClose2:
        ExitApp
    	
    	F5::
        if (GuiVisible) {
            Gui, Hide
            GuiVisible := false
        } else {
            Gui, Show
            GuiVisible := true
        }
    return
     
    SaveSettings:
        SaveSettings()
        Return
     
    LoadSettings:
        LoadSettings()
        Return