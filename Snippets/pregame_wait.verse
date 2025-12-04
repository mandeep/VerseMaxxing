
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


pregame_wait := class(creative_device):
    @editable
    PlayerCounter: player_counter_device = player_counter_device{}
    
    @editable
    WaitMessage: hud_message_device = hud_message_device{}

    OnBegin<override>()<suspends>:void=
        PlayerCounter.CountFailsEvent.Subscribe(ShowMessage)
        PlayerCounter.CountSucceedsEvent.Subscribe(HideMessage)

    ShowMessage():void=
        WaitMessage.Show()

    HideMessage():void=
        WaitMessage.Hide()