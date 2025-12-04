
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Colors/NamedColors }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Utils }


hiders_remaining_device := class(creative_device):
    var PlayerUIMap: [agent]?player_text_ui = map{}

    CreateUI():player_text_ui=
        UIText: text_block = text_block:
            DefaultText := StringToMessage("Hiders Remaining: 0")
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

    RemoveUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player], UIElements := PlayerUIMap[Agent]?):
            PlayerUI.RemoveWidget(UIElements.Canvas)

            if (set PlayerUIMap[Agent] = false) {}


    UpdateUI(Agent: agent, Count: int):void=
        if (UIElements := PlayerUIMap[Agent]?):
            UIElements.Text.SetText(StringToMessage("Hiders Remaining: {Count}"))
