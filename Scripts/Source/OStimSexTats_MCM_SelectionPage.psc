Scriptname OStimSexTats_MCM_SelectionPage extends nl_mcm_module

String Blue = "#6699ff"
String Pink = "#ff3389"

event OnInit()
    RegisterModule("Tattoo Options", 2)
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    writelog("Building database.")
    writelog("database built: " + BuildDatabase())
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
    if (JContainers.FileExistsAtPath(".\\slavetats_cache.json"))
        raw = JValue.ReadFromFile(".\\slavetats_cache.json")
    Else
        return False
    endif
    string datapointer = JMap.NextKey(raw)
    int data = JMap.GetObj(raw, datapointer)
    string bodykey = JMap.NextKey(data)
    int ostdb = Jmap.object()
    int bodydata
    while bodykey
        bodydata = JMap.GetObj(data, bodykey)
        string title
        if (BodyKey == "Body")
            title = "Body Tattoos"
        elseif (BodyKey == "Face")
            title = "Face Tattoos"
        elseif (BodyKey == "Hands")
            title = "Hand Tattoos"
        elseif (BodyKey == "Feet")
            title = "Feet Tattoos"
        Else
            title = bodykey
        endif
        string packkey = JMap.NextKey(bodydata)
        while packkey
            bool enabled = true
            string name = packkey
            writelog(name + " " + title + " " + enabled)
            Jmap.SetObj(ostdb, title + "."+ name, BuildTattoPackObject(name, enabled))
            packkey = Jmap.NextKey(bodydata, packkey)
        endwhile
        bodykey = Jmap.NextKey(data, bodykey)
    endwhile
    JValue.WriteToFile(ostdb, JContainers.UserDirectory()+ "OST_DB.json")
    return true
endfunction

function BuildTattooPage()
    int data
    if (JContainers.FileExistsAtPath(JContainers.UserDirectory()+ "OST_DB.json"))
        data = JValue.ReadFromFile(JContainers.UserDirectory()+ "OST_DB.json")
    Else
        AddParagraph("OST_DB.json not found, please report this error.")
        return
    endif
    string bodykey = JMap.NextKey(data)
    int bodydata
    while bodykey
        bodydata = JMap.GetObj(data, bodykey)
        string title
        if (BodyKey == "Body")
            title = "Body Tattoos:"
        elseif (BodyKey == "Face")
            title = "Face Tattoos:"
        elseif (BodyKey == "Hands")
            title = "Hand Tattoos:"
        elseif (BodyKey == "Feet")
            title = "Feet Tattoos:"
        Else
            title = bodykey + " Tattoos:"
        endif
        AddHeaderOption(FONT_CUSTOM(title, pink))
        string packKey = Jmap.NextKey(bodydata)
        while packKey
            AddToggleOptionST("tattoo_toggle_option___"+bodykey+packKey, packkey, true)
            packkey = Jmap.NextKey(bodydata, packkey)
        endwhile
        bodykey = JMap.NextKey(data, bodykey)
    endwhile
endfunction


int function BuildTattoPackObject(string name, bool enabled)
    int tatobj = Jmap.object()
    int ret = jmap.object()
    jmap.setInt(tatobj, "Enabled", enabled as Int)
    jmap.setobj(ret, name, tatobj)
    return ret
endfunction

state tattoo_toggle_option
    event OnSelectST(string state_id)
        
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Enable or Disable this Pack.")
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