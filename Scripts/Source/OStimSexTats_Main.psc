Scriptname OStimSexTats_main extends Quest

OStimSexTats_MCM Property OSTMCM Auto
OsexIntegrationMain Property OStim Auto
Actor Property PlayerRef Auto

Import SlaveTats

int property OSTJDB
    int function get()
        return JDB.solveObj(".OSTats.db")
      endfunction
      function set(int object)
        JDB.solveObjSetter(".OSTats.db", object, true)
      endfunction
endproperty

Event OnInit()
    RegisterForModEvent("OStim_Start", "OnOstimStart")
EndEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    OSTMCM.Writelog(1)
    if (OSTMCM.OST_ENABLED)
        if (OSTMCM.OST_CHANCE == 0.0)
            return
        elseif (OSTMCM.OST_CHANCE == 101)
            OST_ApplyTat()
        elseif (Utility.RandomInt(0, 100) <= OSTMCM.OST_CHANCE)
            OST_ApplyTat()
        Else
            OSTMCM.WriteLog("Failed roll, no tat applied.")
        endif
    endif
EndEvent

Function OST_ApplyTat()
    OSTMCM.Writelog(2)
    int matches = 0
    int template = 0
    int tattoo = 0

    matches = JValue.addToPool(JArray.object(), "SlaveTatsDemo")
    template = JValue.addToPool(-1, "SlaveTatsDemo")
    
    if query_available_tattoos(template, matches)
        OSTMCM.WriteLog("Failed to find valid tats.", true)
        JValue.CleanPool("SlaveTatsDemo")
        return
    endif

    int rand = Utility.RandomInt(0, JValue.Count(matches))

    tattoo =  JArray.getObj(matches, rand)
    
    while Ostim.AnimationRunning()
    utility.wait(1.0)
    endwhile
    
    if (add_tattoo(PlayerRef, tattoo))
        OSTMCM.WriteLog("Failed to apply tat.", true)
    endif
    
    if (synchronize_tattoos(PlayerRef, true))
        OSTMCM.WriteLog("Failed to sync tats.", true)
    Else
        Debug.Notification("Your partner left some markings on your body.")
    endif
    JValue.CleanPool("SlaveTatsDemo")
endFunction