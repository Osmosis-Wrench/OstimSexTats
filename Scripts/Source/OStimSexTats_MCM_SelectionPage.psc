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
    int zDatabase = JValue.ReadFromFile("slavetats_cache.json")
    int test = JValue.evalLuaObj(zDatabase, "return SexTats.handleSlaveTats(jobject)")
    JValue.WriteToFile(test, "OSTJDB_123.json")
endfunction

function UpdateOSTValid()

endfunction

function BuildTattooPage()

endfunction

state tattoo_toggle_option
    event OnSelectST(string state_id)

    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable or Disable this Pack.")
    endevent
endstate

state OST_REBUILD_STATE
    event OnSelectST(string state_id)
        BuildDatabase()
    endevent
endstate

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("SexTats: " + OutputLog)
    Debug.Trace("SexTats: " + OutputLog)
    if (error == true)
        Debug.Notification("SexTats: " + OutputLog)
    endIF
EndFunction