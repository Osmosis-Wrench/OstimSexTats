Scriptname OStimSexTats_main extends Quest

OStimSexTats_MCM Property OSTMCM Auto
OsexIntegrationMain Property OStim Auto
Actor Property PlayerRef Auto

Import SlaveTats

Event OnInit()
    RegisterForModEvent("OStim_Start", "OnOstimStart")
EndEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)

EndEvent

Function OST_ApplyTat()

endfunction

Function OST_ClearTat()

endfunction

Function OST_FadeTat()

endfunction