Scriptname OStimSexTats_MCM extends nl_mcm_module

bool property OST_ENABLED auto
int OST_ENABLED_FLAG
float Property OST_CHANCE Auto

Int function getVersion()
    return 1
endFunction

event OnInit()
    RegisterModule("Core Options")
endEvent

event OnPageInit()
    SetModName("Ostim SexTats")
    SetLandingPage("Core Options")
    OST_ENABLED = True
    OST_CHANCE = 50.0
endEvent

event OnVersionUpdate(int a_version)

endevent

event OnPageDraw()
    if (OST_ENABLED)
        OST_ENABLED_FLAG = OPTION_FLAG_NONE
    else
        OST_ENABLED_FLAG = OPTION_FLAG_DISABLED
    endif

    SetCursorFillMode(TOP_TO_BOTTOM)
    AddToggleOptionST("OST_ENABLED_STATE", "Enable Mod", OST_ENABLED)
    AddSliderOptionST("OST_CHANCE_STATE", "Probability", OST_CHANCE)
endEvent

state OST_ENABLED_STATE
    event OnDefaultST(string state_id)
        OST_ENABLED = true
    endEvent

    event OnSelectST(string state_id)
        OST_ENABLED = !OST_ENABLED
        ForcePageReset()
    endevent

    event OnHighlightST(string state_id)
        if (OST_ENABLED)
            SetInfoText("Disable oSexTats")
        else
            SetInfoText("Enable oSexTats")
        endif
    endevent
endstate

state OST_CHANCE_STATE
    event OnDefaultST(String state_id)
        OST_CHANCE = 50
        SetSliderOptionValueST(50)
    endevent

    event OnHighlightST(String state_id)
        SetInfoText("Percentage chance of Tattoo being applied, never is 0 and 101 is always.")
    endEvent

    event OnSliderOpenST(string state_id)
        SetSliderDialog(OST_CHANCE, 0.0, 101.0, 0.5, 50)
    endevent

    event OnSliderAcceptST(string state_id, float f)
        OST_CHANCE = f
        SetSliderOptionValueST(f)
    endevent
endstate


; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oSexTats: " + OutputLog)
    Debug.Trace("oSexTats: " + OutputLog)
    if (error == true)
        Debug.Notification("oSexTats: " + OutputLog)
    endIF
EndFunction