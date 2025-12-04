using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/FortPlayerUtilities }
using { Utils }


elimination_ui_device := class(creative_device):
    var PlayerUIMap: [agent]?player_button_ui = map{}

    CreateUI():player_button_ui=
        LobbyButton: button_regular = button_regular:
            DefaultText := StringToMessage("Lobby")

        SpectateButton: button_regular = button_regular:
            DefaultText := StringToMessage("Spectate")

        SpectateButton.OnClick().Subscribe(RemoveUIFromButton)
        LobbyButton.OnClick().Subscribe(RespawnPlayer)
    

        UICanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                Widget := LobbyButton
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center
                                Padding := margin{Left := 100.0, Right := 100.0}
                            stack_box_slot:
                                Widget := SpectateButton
                                HorizontalAlignment := horizontal_alignment.Center
                                VerticalAlignment := vertical_alignment.Center
                                Padding := margin{Left := 100.0, Right := 100.0}
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.75}, Maximum := vector2{X := 0.5, Y := 0.75}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true


        player_button_ui{Canvas := UICanvas, Button1 := LobbyButton, Button2 := SpectateButton}

    AddUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            EliminationUI := CreateUI()
            Canvas := EliminationUI.Canvas
            Button1 := EliminationUI.Button1
            Button2 := EliminationUI.Button2

            PlayerUI.AddWidget(Canvas)

            if (set PlayerUIMap[Agent] = option{EliminationUI}) {}

    RemoveUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player], EliminationUI := PlayerUIMap[Agent]?):
            PlayerUI.RemoveWidget(EliminationUI.Canvas)

            if (set PlayerUIMap[Agent] = false) {}

    RemoveUIFromButton(Message: widget_message):void=
        if (Player := Message.Player, PlayerUI := GetPlayerUI[Player], EliminationUI := PlayerUIMap[Player]?):
            PlayerUI.RemoveWidget(EliminationUI.Canvas)

            if (set PlayerUIMap[Player] = false) {}

    RespawnPlayer(Message: widget_message):void=
        if (Player := Message.Player, Character := Player.GetFortCharacter[], not Character.IsActive[]):
            # hard coding the respawn location due to world partition issues that can arise when
            # the spawn teleporters are not in scope
            RespawnLocation := vector3{ X:= -389.637829, Y := -21693.624916, Z := 1231.000007}
            Player.Respawn(RespawnLocation, rotation{})
            RemoveUI(Player)
