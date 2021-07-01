Scriptname OStimSexTats_MCM_SelectionPage extends nl_mcm_module

String Blue = "#6699ff"
String Pink = "#ff3389"

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
    if (JContainers.FileExistsAtPath(".\\slavetats_cache.json"))
        raw = JValue.ReadFromFile(".\\slavetats_cache.json")
    Else
        Writelog("Slavetats cache not found, build by clicking Add/Remove in the Slavetats MCM.", true)
        return false
    endif
    int output = Jmap.Object()
    int bodydata = Jmap.Object()
    bodydata = JValue.SolveObj(raw, ".default.body")
    if Bodydata
        string packname = Jmap.NextKey(bodydata)
        while packname
            JValue.SolveIntSetter(output, ".body."+packname, 1, true)
            packname = JMap.NextKey(Bodydata, packname)
        endwhile
    endif
    int facedata = Jmap.Object()
    facedata = JValue.SolveObj(raw, ".default.face")
    if facedata
        string packname = Jmap.NextKey(facedata)
        while packname
            JValue.SolveIntSetter(output, ".face."+packname, 1, true)
            packname = JMap.NextKey(facedata, packname)
        endwhile
    endif
    int handdata = Jmap.Object()
    handdata = JValue.SolveObj(raw, ".default.hands")
    if handdata
        string packname = Jmap.NextKey(handdata)
        while packname
            JValue.SolveIntSetter(output, ".hand."+packname, 1, true)
            packname = JMap.NextKey(handdata, packname)
        endwhile
    endif
    int feetdata = Jmap.Object()
    feetdata = JValue.SolveObj(raw, ".default.feet")
    if feetdata
        string packname = Jmap.NextKey(feetdata)
        while packname
            bool enabled = true
            JValue.SolveIntSetter(output, ".feet."+packname, enabled as Int, true)
            packname = JMap.NextKey(feetdata, packname)
        endwhile
    endif
    JValue.WriteToFile(output, JContainers.UserDirectory() + "OST_DB.json")
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
        elseif (BodyKey == "Hand")
            title = "Hand Tattoos:"
        elseif (BodyKey == "Feet")
            title = "Feet Tattoos:"
        Else
            title = bodykey + " Tattoos:"
        endif
        AddHeaderOption(FONT_CUSTOM(title, pink))
        string packkey = Jmap.NextKey(Bodydata)
        while packkey
            bool packenabled = (JValue.SolveInt(data, "."+bodykey+"."+packkey) as bool)
            writelog(packenabled)
            AddToggleOptionST("tattoo_toggle_option___" + bodykey + packkey, packkey, packenabled)
            packkey = JMap.NextKey(Bodydata, packkey)
        endwhile
        bodykey = JMap.NextKey(data, bodykey)
    endwhile
endfunction


int function BuildTattooObj(bool enabled = true)
    int tatobj = Jmap.object()
    jmap.setInt(tatobj, "Enabled", enabled as Int)
    return tatobj
endfunction

state tattoo_toggle_option
    event OnSelectST(string state_id)
        int data = JValue.ReadFromFile(JContainers.UserDirectory()+ "OST_DB.json")
        string body = StringUtil.Substring(state_id, 0, 4)
        string pack = StringUtil.Substring(state_id, 4, 0)
        writelog(body)
        writelog(pack)
        bool packenabled = (JValue.SolveInt(data, "."+body+"."+pack) as bool)
        packenabled = !packenabled
        SetToggleOptionValueST(packenabled, false, "tattoo_toggle_option___"+state_id)
        JValue.SolveIntSetter(data, "."+body+"."+pack, packenabled as Int)
        JValue.WriteToFile(data, JContainers.UserDirectory() + "OST_DB.json")
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