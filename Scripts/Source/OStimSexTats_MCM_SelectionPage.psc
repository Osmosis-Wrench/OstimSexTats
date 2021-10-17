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
    SetCursorFillMode(LEFT_TO_RIGHT)
    if (JContainers.FileExistsAtPath("OSTDB.json"))
        BuildTattooPage()
    Else
        AddParagraph("Something went wrong, exit back to the game and try again. If this issue persists, double check that the Slavetats_cache.json file has been created by Slavetats.")
        return
    endif
endevent

bool function BuildDatabase()
    int zDatabase = JValue.readFromDirectory("Data\\Textures\\Actors\\Character\\slavetats",".json") 
    ; get all slavetats json files.
    zDatabase = JValue.evalLuaObj(zDatabase, "return SexTats.handleFiles(jobject)") 
    ; recreate slavetats_cache.json but faster than slavetats does it, so it's less hassle for us to deal with.
    zDatabase = JValue.evalLuaObj(zDatabase, "return SexTats.handleSlaveTats(jobject)") 
    ; convert our version of slavetats_cache.json into a easier to parse format for later.
    JValue.WriteToFile(zDatabase, "OSTDB.json")
endfunction

int tattooPages
int currentTattooPage = 1

function BuildTattooPage()
    ;int pageInfo = JValue.readFromFile("test_OSTPAGE.json")
    int pageInfo = JValue.readFromFile("OSTDB.json")
    pageinfo = JValue.evalluaobj(pageInfo, "return SexTats.BuildTattooPage(jobject)")
    
    int size = JValue.count(pageInfo)
    
    if size > 100
        tattooPages = math.Ceiling(size / 100)
    else
        tattooPages = 1
    endif

    AddHeaderOption(FONT_CUSTOM("Currently Installed Tattoo Packs:", pink))
    AddHeaderOption(FONT_CUSTOM("Page " + currentTattooPage + " / "+ tattooPages, Blue))
    int nextFlag = OPTION_FLAG_NONE
    int previousFlag = OPTION_FLAG_NONE
    if (currentTattooPage == 1)
        previousFlag = OPTION_FLAG_DISABLED
    endif
    if (currentTattooPage == tattooPages)
        nextFlag = OPTION_FLAG_DISABLED
    endif
    AddTextOptionST("tattoo_page_change___"+(currentTattooPage - 1), "", "PREVIOUS PAGE", previousFlag)
    AddTextOptionST("tattoo_page_change___"+(currentTattooPage + 1), "", "Next Page", nextFlag)
    AddHeaderOption("")
    AddHeaderOption("")

    int i = (100 * currentTattooPage) - 100
    while i < (100 * currentTattooPage)
        string packname = JArray.GetStr(pageInfo, i)
        AddToggleOptionST("tattoo_pack_toggle___"+packname, packname, true)
        i += 1
    endwhile

endfunction

state tattoo_pack_toggle
    event OnSelectST(string state_id)
        writelog("toggled "+state_id)
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable or Disable this Pack.")
    endevent
endstate

state tattoo_page_change
    event OnSelectST(string state_id)
        currentTattooPage = state_id as int
        ForcePageReset()
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