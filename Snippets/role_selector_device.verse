
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { Utils }


role_selector_device := class(creative_device):
    @editable
    ProbabilityDisplay: hud_message_device = hud_message_device{}

    @editable
    RoleTrigger: trigger_device = trigger_device{}

    @editable
    SeekerDisplay: hud_message_device = hud_message_device{}

    @editable
    HiderDisplay: hud_message_device = hud_message_device{}

    @editable
    TraitorDisplay: hud_message_device = hud_message_device{}

    @editable
    PreyDisplay: hud_message_device = hud_message_device{}

    @editable
    CrownDisplay: hud_message_device = hud_message_device{}

    @editable
    JuggernautDisplay: hud_message_device = hud_message_device{}

    @editable
    SelectorTimer: timer_device = timer_device{}

    DisplayTime: float = 0.25


    DisplayRoleHUD():void=
        RoleTrigger.Trigger()
        SelectorTimer.Start()

    DisplayPlayerRoles(Seekers: []agent, Probabilities: [agent]int, GameMode: int)<suspends>:void=
        for (Index->Player : GetPlayspace().GetPlayers()):
            if (Probability := Probabilities[Player]):
                spawn:
                    DisplayRoleUI(Player, Seekers, Probability, GameMode)
        # Sleep(1.0)

    DisplayRoleUI(Player: player, Seekers: []agent, Probability: int, GameMode: int)<suspends>:void=
        # DisplayTime of 0.0 means the HUD will display forever. Calling Show() again
        # with a short duration DisplayTime will clear the HUD. This is a workaround as the Hide()
        # method does not work https://forums.unrealengine.com/t/hud-message-device-doesnt-hide-hud-when-called-through-verse-after-calling-show-on-specific-agents/1302149/8
        ShowProbabilities(Player, Probability)
        CycleThroughRoles(Player, GameMode)
        ShowSelectedRole(Player, Seekers, GameMode, false, false)

        # HideProbabilities(Player)

    CycleThroughRoles(Player: player, GameMode: int)<suspends>:void=
        var NumberOfRoles: int = 2

        if (GameMode = 4 or GameMode = 5):
            set NumberOfRoles = 3

        Steps: float = 8.0 / (NumberOfRoles * 2.0 * 0.25)

        for (Step := 0..Int[Steps]):
            SeekerDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
            Sleep(DisplayTime)

            if (HiderGameModes := array{0, 1, 2, 3, 4, 5, 8}, HiderGameModes.Find[GameMode]):
                HiderDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                Sleep(DisplayTime)

            if (GameMode = 6):
                JuggernautDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                Sleep(DisplayTime)
            
            if (GameMode = 7):
                CrownDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                Sleep(DisplayTime)

            if (NumberOfRoles = 3):
                if (GameMode = 4):
                    TraitorDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                    Sleep(DisplayTime)
                else:
                    PreyDisplay.Show(Player, StringToMessage(""), ?DisplayTime := DisplayTime)
                    Sleep(DisplayTime)

    ShowSelectedRole(Player: player, Seekers: []agent, GameMode: int, Traitor: ?agent, Prey: ?agent)<suspends>:void=
        if (Seekers.Find[Player]):
            if (GameMode = 6):
                JuggernautDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
            else if (GameMode = 7):
                CrownDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
            else if (GameMode = 5 and Player = Seekers[1]):
                PreyDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
            else if (GameMode = 4 and Player = Seekers[1]):
                TraitorDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
            else:
                SeekerDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
            # Sleep(3.0)
        else:
            if (HiderGameModes := array{0, 1, 2, 3, 4, 5, 8}, HiderGameModes.Find[GameMode]):
                HiderDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
                Sleep(DisplayTime)

            if (GameMode = 6 or GameMode = 7):
                SeekerDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 5.0)
                Sleep(DisplayTime)

            # Sleep(3.0)
    
    ShowProbabilities(Player: player, Probability: int):void=
        ProbabilityDisplay.Show(Player, StringToMessage("{Probability}"), ?DisplayTime := 0.0)
    
    HideProbabilities(Player: player):void=
        ProbabilityDisplay.Show(Player, StringToMessage(""), ?DisplayTime := 0.01)