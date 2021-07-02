Scriptname OStimSexTats_MCM extends nl_mcm_module

String Blue = "#6699ff"
String Pink = "#ff3389"

bool property OST_ENABLED auto
float Property OST_CHANCE Auto

bool property OST_BODY auto
bool property OST_HAND auto
bool property OST_FEET auto
bool property OST_FACE auto

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
    OST_BODY = True
    OST_HAND = True
    OST_FEET = True
    OST_FACE = True
endEvent

event OnVersionUpdate(int a_version)

endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(FONT_CUSTOM("Main Options:", pink))
    AddToggleOptionST("OST_ENABLED_STATE", "Enable Mod", OST_ENABLED)
    AddSliderOptionST("OST_CHANCE_STATE", "Probability", OST_CHANCE)
    AddHeaderOption(FONT_CUSTOM("Body Slot Options:", blue))
    AddToggleOptionST("tattoo_slot_toggle___body", "Body Tattoos", OST_BODY)
    AddToggleOptionST("tattoo_slot_toggle___hand", "Hand Tattoos", OST_HAND)
    AddToggleOptionST("tattoo_slot_toggle___feet", "Feet Tattoos", OST_FEET)
    AddToggleOptionST("tattoo_slot_toggle___face", "Face Tattoos", OST_FACE)
    AddHeaderOption(FONT_CUSTOM("Misc Options:", pink))
    AddTextOptionST("OST_SAVE_STATE", "Save Settings", "Click")
    AddTextOptionST("OST_LOAD_STATE", "Load Settings", "Click")
endEvent

state OST_ENABLED_STATE
    event OnDefaultST(string state_id)
        OST_ENABLED = true
        SetToggleOptionValueST(OST_ENABLED, false, "OST_ENABLED_STATE")
    endEvent

    event OnSelectST(string state_id)
        OST_ENABLED = !OST_ENABLED
        SetToggleOptionValueST(OST_ENABLED, false, "OST_ENABLED_STATE")
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

state tattoo_slot_toggle
    event OnDefaultST(string state_id)
        if (state_id == "body")
            OST_BODY = true
            SetToggleOptionValueST(OST_BODY, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "feet")
            OST_FEET = true
            SetToggleOptionValueST(OST_FEET, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "face")
            OST_FACE = true
            SetToggleOptionValueST(OST_FACE, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "hand")
            OST_HAND = true
            SetToggleOptionValueST(OST_HAND, false, "tattoo_slot_toggle___"+state_id)
        endif
    endEvent

    event OnSelectST(string state_id)
        if (state_id == "body")
            OST_BODY = !OST_BODY
            SetToggleOptionValueST(OST_BODY, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "feet")
            OST_FEET = !OST_FEET
            SetToggleOptionValueST(OST_FEET, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "face")
            OST_FACE = !OST_FACE
            SetToggleOptionValueST(OST_FACE, false, "tattoo_slot_toggle___"+state_id)
        elseif (state_id == "hand")
            OST_HAND = !OST_HAND
            SetToggleOptionValueST(OST_HAND, false, "tattoo_slot_toggle___"+state_id)
        endif
    endevent

    event OnHighlightST(string state_id)
         SetInfoText("Toggle tattoo's that apply to the "+state_id+" slot.")
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