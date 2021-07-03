Scriptname OStimSexTats_MCM_SelectionPage extends nl_mcm_module

String Blue = "#6699ff"
String Pink = "#ff3389"

int property OSTJDB
    int function get()
        return JDB.solveObj(".OSTats.db")
      endfunction
      function set(int object)
        JDB.solveObjSetter(".OSTats.db", object, true)
      endfunction
endproperty

Int function getVersion()
    return 1
endFunction

event OnInit()
    RegisterModule("Tattoo Options", 2)
endevent

event OnPageInit()
    BuildDatabase()
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    if (JContainers.FileExistsAtPath(JContainers.UserDirectory()+ "OST_DB.json"))
        BuildTattooPage()
    elseif (BuildDatabase())
        BuildTattooPage()
    Else
        AddParagraph("Something went wrong, exit the MCM and try again. If this issue persists, double check that the Slavetats_cache.json file has been created by Slavetats.")
        return
    endif
endevent

bool function BuildDatabase()
    int raw
    Writelog("Building Database")
    if (JContainers.FileExistsAtPath(".\\slavetats_cache.json"))
        raw = JValue.ReadFromFile(".\\slavetats_cache.json")
        Writelog("Loading Cache")
    Else
        Writelog("Slavetats cache not found, build by clicking Add/Remove in the Slavetats MCM.", true)
        return false
    endif
    int data = Jmap.object()
    int output = Jmap.object()
    data = JValue.SolveObj(raw, ".default")
    ; build empty
    string slotkey = JMap.nextKey(data)
    while slotkey
        int packdata = jmap.getObj(data, slotkey)
        string packkey = JMap.NextKey(packdata)
        while packkey
            JValue.SolveIntSetter(output, "."+packkey+"."+"enabled", 1, true)
            JValue.SolveIntSetter(output, "."+packkey+"."+"body", 0, true)
            JValue.SolveIntSetter(output, "."+packkey+"."+"hands", 0, true)
            JValue.SolveIntSetter(output, "."+packkey+"."+"face", 0, true)
            JValue.SolveIntSetter(output, "."+packkey+"."+"feet", 0, true)
            packkey = JMap.nextkey(packdata, packkey)
        endwhile
        slotkey = JMap.nextkey(data, slotkey)
    endwhile
    ;build populated
    slotkey = JMap.NextKey(data)
    while slotkey
        int packdata = jmap.getObj(data, slotkey)
        string packkey = JMap.NextKey(packdata)
        while packkey
            JValue.SolveIntSetter(output, "."+packkey+"."+slotkey, 1, true)
            packkey = JMap.nextkey(packdata, packkey)
        endwhile
        slotkey = JMap.nextkey(data, slotkey)
    endwhile
    JValue.WriteToFile(output, JContainers.UserDirectory() + "OST_DB.json")
    OSTJDB = output
    return true
endfunction

function BuildTattooPage()
    AddTextOptionST("OST_REBUILD_STATE", "Rebuild Database", "Click")
    AddHeaderOption(FONT_CUSTOM("Currently installed Tattoo Packs:", Pink))
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("")
    string packname = JMap.NextKey(OSTJDB)
    while packname
        bool packenabled = (JValue.SolveInt(OSTJDB, "."+packname+"."+"enabled") as bool)
        AddToggleOptionST("tattoo_toggle_option___" +packname, packname, packenabled)
        packname = JMap.NextKey(OSTJDB, packname)
    endwhile
endfunction

state tattoo_toggle_option
    event OnSelectST(string state_id)
        bool packEnabled = (JValue.SolveInt(OSTJDB, "."+state_id+"."+"enabled") as bool)
        packenabled = !packenabled
        JValue.SolveIntSetter(OSTJDB, "."+state_id+"."+"enabled", packenabled as Int)
        SetToggleOptionValueST(packenabled, false, "tattoo_toggle_option___"+state_id)
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable or Disable this Pack.")
    endevent
endstate

state OST_REBUILD_STATE
    event OnSelectST(string state_id)
        ShowMessage("Database building, please wait a moment before pressing OK.")
        if (BuildDatabase())
            ShowMessage("Database Built!")
            ForcePageReset()
        else
            ShowMessage("Database failed to build, ensure that the Slavetats cache has been built.")
        endif
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Rebuild oSexTats database to be in sync with current slavetats database.")
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