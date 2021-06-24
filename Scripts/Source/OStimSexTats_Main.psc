Scriptname OStimSexTats_main extends Quest

OStimSexTats_MCM Property OSTMCM Auto
OsexIntegrationMain Property OStim Auto
Actor Property PlayerRef Auto

Import SlaveTats

Event OnInit()
    RegisterForModEvent("OStim_Start", "OnOstimStart")
    RegisterForKey(42)
EndEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    if (OSTMCM.OST_ENABLED)
        OSTMCM.WriteLog(1)
        Int tat = JMap.Object()
        tat = GetValidTat()
        JValue.Retain(tat)
        OSTMCM.WriteLog(2)
        while Ostim.AnimationRunning()
            utility.wait(1.0)
        endwhile
        OSTMCM.WriteLog(3)
        if (add_tattoo(PlayerRef, tat, -1))
            OSTMCM.WriteLog("Failed to apply tat.", true)
        endif
        OSTMCM.WriteLog(4)
        synchronize_tattoos(PlayerRef)
        JValue.Release(tat)
        OSTMCM.WriteLog(5)
    endif
EndEvent

Int Function GetValidTat()
    OSTMCM.WriteLog(11)
    
    int matches = JValue.addToPool(JArray.object(), "SlaveTatsDemo")
    int template = JValue.addToPool(JValue.objectFromPrototype("{\"name\": \"Slave (left breast) \", \"section\":\"Slave Marks\"}"), "SlaveTatsDemo")
    
    OSTMCM.WriteLog(12)
    
    if query_available_tattoos(template, matches)
        OSTMCM.WriteLog("Failed to find valid tats.", true)
        JValue.CleanPool("SlaveTatsDemo")
        return
    endif
    
    OSTMCM.WriteLog(13 +" "+ matches)
    
    int rand = Utility.RandomInt(0, JValue.Count(Matches))
    OSTMCM.WriteLog(14 +" "+rand)
    
    int ret = Jarray.Object()
    ret = JArray.GetObj(Matches, rand)
    OSTMCM.WriteLog(15 +" "+ret)
    
    JValue.CleanPool("SlaveTatsDemo")
    return ret
endFunction

Event OnKeyDown(Int Keycode)
    if Keycode == 42
        OSTMCM.Writelog(GetValidTat())
    endif
endevent