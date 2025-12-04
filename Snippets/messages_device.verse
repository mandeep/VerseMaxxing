
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { Utils }

messages_device := class(creative_device):
    @editable
    SeekerWinMessage: hud_message_device = hud_message_device{}

    @editable
    HiderWinMessage: hud_message_device = hud_message_device{}

    @editable
    CrownWinMessage: hud_message_device = hud_message_device{}

    @editable
    JuggernautWinMessage: hud_message_device = hud_message_device{}

    @editable
    CrownHelpMessage: hud_message_device = hud_message_device{}

    @editable
    JuggernautHelpMessage: hud_message_device = hud_message_device{}

    @editable
    AvengerHelpMessage: hud_message_device = hud_message_device{}

    @editable
    TraitorHelpMessage: hud_message_device = hud_message_device{}

    @editable
    FreezeHiderHelpMessage: hud_message_device = hud_message_device{}

    @editable
    FreezeSeekerHelpMessage: hud_message_device = hud_message_device{}

    @editable
    JailbreakHiderHelpMessage: hud_message_device = hud_message_device{}

    @editable
    JailbreakSeekerHelpMessage: hud_message_device = hud_message_device{}

    @editable
    InfectionHiderHelpMessage: hud_message_device = hud_message_device{}

    @editable
    InfectionSeekerHelpMessage: hud_message_device = hud_message_device{}

    @editable
    PrisonerCaughtMessage: hud_message_device = hud_message_device{}

    @editable
    TraitorCaughtMessage: hud_message_device = hud_message_device{}

    DisplayTime: float = 5.0

    ShowSeekerMessage():void=
        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            SeekerWinMessage.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowHiderMessage():void=
        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            HiderWinMessage.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
        
    ShowCrownMessage(Agent: agent):void=
        AllPlayers := GetPlayspace().GetPlayers()
        
        Message: message = PlayerToMessage(Agent)

        for (Player : AllPlayers):
            CrownWinMessage.Show(Player, Message, ?DisplayTime := DisplayTime)

    ShowCrownHelpMessage(Agent: agent):void=
        CrownHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowJuggernautHelpMessage(Agent: agent):void=
        JuggernautHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowAvengerHelpMessage(Agent: agent):void=
        AvengerHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowTraitorHelpMessage(Agent: agent):void=
        TraitorHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowFreezeHiderHelpMessage(Agent: agent):void=
        FreezeHiderHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowFreezeSeekerHelpMessage(Agent: agent):void=
        FreezeSeekerHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowJailbreakHiderHelpMessage(Agent: agent):void=
        JailbreakHiderHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowJailbreakSeekerHelpMessage(Agent: agent):void=
        JailbreakSeekerHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowInfectionHiderHelpMessage(Agent: agent):void=
        InfectionHiderHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowInfectionSeekerHelpMessage(Agent: agent):void=
        InfectionSeekerHelpMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowTraitorCaughtMessage(Agent: agent):void=
        TraitorCaughtMessage.Show(Agent, StringToMessage(""), ?DisplayTime := DisplayTime)

    ShowPrisonerCaughtMessage(Agent: agent):void=
        PrisonerCaughtMessage.Show(Agent, PlayerToMessage(Agent), ?DisplayTime := DisplayTime)
        
    ShowDefaultCrownMessage():void=
        AllPlayers := GetPlayspace().GetPlayers()
        
        for (Player : AllPlayers):
            CrownWinMessage.Show(Player, StringToMessage("Crown"), ?DisplayTime := DisplayTime)

    ShowJuggernautMessage():void=
        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            JuggernautWinMessage.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                