Scriptname OStimSexTats_main extends Quest

OStimSexTats_MCM Property OSTMCM Auto
OsexIntegrationMain Property OStim Auto
Actor Property PlayerRef Auto

Import SlaveTats

Event OnInit()
    RegisterForModEvent("OStim_Start", "OnOstimStart")
EndEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    if (OSTMCM.OST_ENABLED)
        int matches = 0
        int template = 0
        int tattoo = 0

        matches = JValue.addToPool(JArray.object(), "SlaveTatsDemo")
        template = JValue.addToPool(JValue.objectFromPrototype("{\"name\": \"Slave (left breast) \", \"section\":\"Slave Marks\"}"), "SlaveTatsDemo")
        
        if query_available_tattoos(template, matches)
            OSTMCM.WriteLog("Failed to find valid tats.", true)
            JValue.CleanPool("SlaveTatsDemo")
            return
        endif

        tattoo =  JArray.getObj(matches, 0)
        JMap.setInt(tattoo, "color", 11536724)
        
        while Ostim.AnimationRunning()
        utility.wait(1.0)
        endwhile
        
        if (add_tattoo(PlayerRef, matches, -1))
            OSTMCM.WriteLog("Failed to apply tat.", true)
        endif
        
        if (synchronize_tattoos(PlayerRef))
            OSTMCM.WriteLog("Failed to sync tats.", true)
        endif
        JValue.CleanPool("SlaveTatsDemo")
    endif
EndEvent