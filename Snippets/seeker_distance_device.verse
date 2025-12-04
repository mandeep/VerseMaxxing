
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Utils }


seeker_distance_device := class(creative_device):
    var PlayerUIMap: [agent]?player_text_ui = map{}

    var SeekerAgents: []agent = array{}

    CentimeterToFeetConversion: float = (1.0 / 2.54 / 12.0)

    SetSeekers(Agents: []agent):void=
        set SeekerAgents = Agents

    CreateUI():player_text_ui=
        UIText: text_block = text_block:
            DefaultText := StringToMessage("Seeker Distance: 0ft")
            DefaultTextColor := White
            DefaultTextOpacity := 1.0
            DefaultJustification := text_justification.Left
            DefaultShadowColor := Black
            DefaultShadowOpacity := 0.6
            DefaultShadowOffset := option{vector2{X := 2.0, Y := 2.0}}

        UICanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := stack_box:
                        Orientation := orientation.Horizontal
                        Slots := array:
                            stack_box_slot:
                                Widget := UIText
                                HorizontalAlignment := horizontal_alignment.Left
                                VerticalAlignment := vertical_alignment.Fill
                    Anchors := anchors{Minimum := vector2{X := 0.05, Y := 0.85}, Maximum := vector2{X := 0.05, Y := 0.85}}
                    Alignment := vector2{X := 0.0, Y := 1.0}
                    SizeToContent := true


        player_text_ui{Canvas := UICanvas, Text := UIText}

    AddUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            UIElements := CreateUI()
            Canvas := UIElements.Canvas
            Text := UIElements.Text

            PlayerUI.AddWidget(Canvas)

            if (set PlayerUIMap[Agent] = option{UIElements}) {}

            spawn { UpdateUI(Agent) }

    RemoveUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player], UIElements := PlayerUIMap[Agent]?):
            PlayerUI.RemoveWidget(UIElements.Canvas)

            if (set PlayerUIMap[Agent] = false) {}

    UpdateUI(Agent: agent)<suspends>:void=
        if (UIElements := PlayerUIMap[Agent]?):
            loop:
                Sleep(0.25)
                SetUIText(Agent)
                if (not PlayerUIMap[Agent]?):
                    break

    SetUIText(Agent: agent):void=
        if (UIElements := PlayerUIMap[Agent]?, Player := player[Agent]):
            SeekerPlayers: []player = for (SeekerAgent : SeekerAgents, SeekerPlayer: player = player[SeekerAgent]) do SeekerPlayer
            NearestSeekerInfo := FindNearestPlayer(Player, SeekerPlayers)

            if (NearestSeeker := NearestSeekerInfo(0)?):
                SeekerDistanceFloat := NearestSeekerInfo(1)

                if (SeekerDistance: int = Int[SeekerDistanceFloat * CentimeterToFeetConversion]):
                    UIElements.Text.SetText(StringToMessage("Seeker Distance: {SeekerDistance}ft"))