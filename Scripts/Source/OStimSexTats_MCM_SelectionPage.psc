Scriptname OStimSexTats_MCM_SelectionPage extends nl_mcm_module

event OnInit()
    RegisterModule("Tattoo Options", 2)
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    BuildTattooPage()
endevent

function BuildTattooPage()
    int raw
    if (JContainers.FileExistsAtPath(".\\slavetats_cache.json"))
        raw = JValue.ReadFromFile(".\\slavetats_cache.json")
    Else
        AddParagraph("Something went wrong, exit the MCM and try again. If this issue persists, double check that the Slavetats_cache.json file has been created by Slavetats.")
        return
    endif
    jValue.writeToFile(raw, JContainers.UserDirectory()+"raw.json")
    int data = JMap.GetObj(raw, "default.")
    jValue.writeToFile(data, JContainers.UserDirectory()+"data.json")
    string tattookey = JMap.NextKey(data)
    while tattookey
        AddToggleOptionST("tattoo_toggle_option___"+tattookey, tattookey, true)
        tattookey = JMap.NextKey(data, tattookey)
    endwhile
endfunction

state tattoo_toggle_option
    event OnSelectST(string state_id)
        
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable or Disable " + state_id)
    endevent
endstate