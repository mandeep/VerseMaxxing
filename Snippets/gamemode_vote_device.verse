using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Verse.org/Random }
using { /Verse.org/Colors/NamedColors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { Utils }


gamemode_candidate := class<concrete>:
    var MapTexture: texture = DefaultMapTexture 
    var MapName: string = ""
    # var Selection: widget = texture_block{DefaultImage := MapBorderImage, DefaultDesiredSize:=vector2{X:=415.0, Y:=515.0}}

    CreateMapUI(VoteButton: button_regular, VoteCounter: text_block, Selection: texture_block):overlay=
        MapStackBox := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot:
                    Widget := texture_block:
                        DefaultImage := MapTexture
                        DefaultDesiredSize := vector2{X := 400.0, Y := 400.0}
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 20.0, Bottom := 20.0}
                stack_box_slot:
                    Widget := VoteButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Left := 10.0, Right := 10.0}
            
        MapOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := Selection
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                overlay_slot:
                    Widget := color_block:
                        DefaultColor := Black
                        DefaultDesiredSize:=vector2{X := 460.0, Y := 560.0}
                        DefaultOpacity := 0.5
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                overlay_slot:
                    Widget := VoteCounter
                    HorizontalAlignment := horizontal_alignment.Right
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin{Top := 5.0, Right := 10.0}
                overlay_slot:
                    Widget := MapStackBox
    
        MapOverlay


gamemode_vote_info := class:
    var Vote: int = -1
    var Buttons: []text_button_base = array{}
    var Counters: []text_block = array{}
    var Highlights: []texture_block = array{}
    var Canvas: canvas = canvas{}


gamemode_vote_device := class(creative_device):
    var Maps: []gamemode_candidate := array:
        gamemode_candidate{MapTexture := ClassicModeImage, MapName := "Classic"}
        gamemode_candidate{MapTexture := InfectionModeImage, MapName := "Infection"}
        # gamemode_candidate{MapTexture := ReviveModeImage, MapName := "Revive"}
        gamemode_candidate{MapTexture := JailbreakModeImage, MapName := "Jailbreak"}
        gamemode_candidate{MapTexture := BetrayalModeImage, MapName := "Traitor"}
        gamemode_candidate{MapTexture := PreyModeImage, MapName := "Revenge"}
        gamemode_candidate{MapTexture := JuggernautModeImage, MapName := "Juggernaut"}
        gamemode_candidate{MapTexture := CrownModeImage, MapName := "Crown"}
        gamemode_candidate{MapTexture := FreezeModeImage, MapName := "Freeze"}

    var WinningMode<private>: int = 0

    var VoteInfoMap: [agent]?gamemode_vote_info = map{}

    GetWinningVote():int=
        WinningMode
    
    StartVote(Agent: ?agent):void=
        set Maps = Shuffle(Maps)

        Players := GetPlayspace().GetPlayers()

        for (Player : Players):
            OpenUI(Player)

    
    EndVote(Agent: ?agent):void=
        WinningIndex: int = TallyVotes()

        Players := GetPlayspace().GetPlayers()

        for (Player : Players):
            CloseUI(Player)
            
        if (Map := Maps[WinningIndex]):
            case (Map.MapName):
                "Infection" =>
                    set WinningMode = 1
                "Revive" =>
                    set WinningMode = 2
                "Jailbreak" =>
                    set WinningMode = 3
                "Traitor" =>
                    set WinningMode = 4
                "Revenge" =>
                    set WinningMode = 5
                "Juggernaut" =>
                    set WinningMode = 6
                "Crown" =>
                    set WinningMode = 7
                "Freeze" =>
                    set WinningMode = 8
                _ =>
                    set WinningMode = 0

    CountVotes():[]int=
        Players := GetPlayspace().GetPlayers()

        var VoteCounts: []int = array{}

        for (Index := 0..2, Map := Maps[Index]):
            set VoteCounts += array{0}

        for (Player : Players):
            if (VoteInfo := VoteInfoMap[Player]?):
                if (set VoteCounts[VoteInfo.Vote] += 1) {}

        VoteCounts

    CastVote(Message: widget_message):void=
        if (VoteInfo := VoteInfoMap[Message.Player]?):
            for (Index->Button : VoteInfo.Buttons):
                if (Button = Message.Source):
                    set VoteInfo.Vote = Index

        UpdateUI(Message)
        
    
    TallyVotes():int= 
        Votes: []int := CountVotes()

        if (FindMax(Any_Elements_Equal(Votes)) = FindMax(Votes)):
            MapsToPick: []int = Shuffle(Find_Equal_Elements(Votes))

            if (RandomMap := MapsToPick[0]):
                return RandomMap
            else:
                return 0

        var MaxVote: int = 0
        var MaxIndex: int = 0

        for (Index->Vote : Votes):
            if (Vote > MaxVote):
                set MaxVote = Vote
                set MaxIndex = Index

        MaxIndex

    OpenUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            NewCanvas := CreateCanvas(Agent)
            PlayerUI.AddWidget(NewCanvas, player_ui_slot{InputMode := ui_input_mode.All})

    CloseUI(Agent: agent):void=
        if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
            if (VoteInfo := VoteInfoMap[Player]?):
                PlayerUI.RemoveWidget(VoteInfo.Canvas)

    CloseUIButton(Message: widget_message):void=
        if (Player := Message.Player, PlayerUI := GetPlayerUI[Player]):
            if (VoteInfo := VoteInfoMap[Player]?):
                PlayerUI.RemoveWidget(VoteInfo.Canvas)

    UpdateUI(Message: widget_message):void=
        Players := GetPlayspace().GetPlayers()
        Votes := CountVotes()

        for (Player : Players):
            if (VoteInfo := VoteInfoMap[Player]?):
                for (Index->Counter : VoteInfo.Counters):
                    if (VoteCount := Votes[Index]):
                        Counter.SetText(StringToMessage("{VoteCount}"))

        if (Player := Message.Player, VoteInfo := VoteInfoMap[Player]?):
            for (Index->Button : VoteInfo.Buttons, Highlight := VoteInfo.Highlights[Index]):
                if (Button = Message.Source):
                    Highlight.SetVisibility(widget_visibility.Visible)
                else:
                    Highlight.SetVisibility(widget_visibility.Hidden)
    

    CreateCanvas(Agent: agent):canvas=
        VoteInfo := gamemode_vote_info{}

        VoteLayout := stack_box{Orientation := orientation.Horizontal}

        for (Index := 0..2, Map := Maps[Index]):
            VoteButton: button_regular = button_regular{}
            VoteButton.SetText(StringToMessage("{Map.MapName}"))
            VoteButton.OnClick().Subscribe(CastVote)

            VoteCounter := text_block:
                DefaultText := StringToMessage("0")
                DefaultTextColor := White
                DefaultTextOpacity := 0.95
                DefaultJustification := text_justification.Left
                DefaultShadowColor := Black
                DefaultShadowOpacity := 0.6
                DefaultShadowOffset := option{vector2{X := 2.0, Y := 2.0}}

            VoteHighlight := texture_block:
                DefaultImage := MapSelectionImage
                DefaultDesiredSize:=vector2{X:=465.0, Y:=565.0}

            VoteHighlight.SetVisibility(widget_visibility.Hidden)

            set VoteInfo.Buttons += array{VoteButton}
            set VoteInfo.Counters += array{VoteCounter}
            set VoteInfo.Highlights += array{VoteHighlight}

            VoteWidget := Map.CreateMapUI(VoteButton, VoteCounter, VoteHighlight)


            VoteSlot := stack_box_slot:
                Widget := VoteWidget
                Padding := margin{Left := 40.0, Right := 40.0}
                HorizontalAlignment := horizontal_alignment.Fill
                VerticalAlignment := vertical_alignment.Fill

            VoteLayout.AddWidget(VoteSlot)

        CloseButton := button_regular{DefaultText := StringToMessage("Close")}
        CloseButton.OnClick().Subscribe(CloseUIButton)

        VoteOverlay := stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot:
                    Widget := VoteLayout
                    Padding := margin{Top := 200.0}
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                stack_box_slot:
                    Widget := CloseButton
                    Padding := margin{Top:= 40.0}
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Bottom


        VoteCanvas := canvas:
            Slots := array:
                canvas_slot:
                    Widget := VoteOverlay
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.4}, Maximum := vector2{X := 0.5, Y := 0.4}}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true

        set VoteInfo.Canvas = VoteCanvas

        if (set VoteInfoMap[Agent] = option{VoteInfo}) {}
        
        VoteCanvas