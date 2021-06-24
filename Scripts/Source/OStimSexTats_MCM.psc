Scriptname OStimSexTats_MCM extends nl_mcm_module

bool property OST_ENABLED auto

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
endEvent

event OnVersionUpdate(int a_version)

endevent

event OnPageDraw()
    AddToggleOptionST("OST_Enabled_STATE", "Enable Mod", OST_ENABLED)
endEvent

state OST_Enabled_STATE
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


; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("oSexTats: " + OutputLog)
    Debug.Trace("oSexTats: " + OutputLog)
    if (error == true)
        Debug.Notification("oSexTats: " + OutputLog)
    endIF
EndFunction