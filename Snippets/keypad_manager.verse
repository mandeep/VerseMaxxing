using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }

player_keypad_ui := class:
    AssociatedPlayer: player
    AssociatedPassword: []string

    var CurrentPasswordArray : []string = array{}

    var AssociatedCanvas : canvas = canvas{}

    ZeroButtonText<localizes>: message = "0"
    OneButtonText<localizes>: message = "1"
    TwoButtonText<localizes>: message = "2"
    ThreeButtonText<localizes>: message = "3"
    FourButtonText<localizes>: message = "4"
    FiveButtonText<localizes>: message = "5"
    SixButtonText<localizes>: message = "6"
    SevenButtonText<localizes>: message = "7"
    EightButtonText<localizes>: message = "8"
    NineButtonText<localizes>: message = "9"

    ClearButtonText<localizes>: message = "CLEAR"
    DeleteButtonText<localizes>: message = "BACKSPACE"
    CloseButtonText<localizes>: message = "CLOSE"
    ConfirmButtonText<localizes>: message = "CONFIRM"

    EmptyPasswordText<localizes>: message = "Insert Secret Item Code"

    MessageFromString<localizes>(Value:string):message = "{Value}"

    ConfirmButton: button_loud = button_loud{}
    CloseButton: button_regular = button_regular{}

    ZeroButton: button_regular = button_regular{}
    OneButton: button_regular = button_regular{}
    TwoButton: button_regular = button_regular{}
    ThreeButton: button_regular = button_regular{}
    FourButton: button_regular = button_regular{}
    FiveButton: button_regular = button_regular{}
    SixButton: button_regular = button_regular{}
    SevenButton: button_regular = button_regular{}
    EightButton: button_regular = button_regular{}
    NineButton: button_regular = button_regular{}
    
    DeleteButton: button_regular = button_regular{}
    ClearButton: button_regular = button_regular{}

    DisplayedPasswordTextBlock: text_block = text_block:
        DefaultTextColor := color{R := 0.0, G := 0.0, B := 0.0}

    GetCanvas():canvas=
        AssociatedCanvas

    ConfirmPassword():int=
        CurrentPassword := Join(CurrentPasswordArray, "")
        
        if (Index := AssociatedPassword.Find[CurrentPassword]):
            return Index
        
        -1

    ZeroButtonClick(Message: widget_message): void = TryAddCurrentPassword(0)
    OneButtonClick(Message: widget_message): void = TryAddCurrentPassword(1)
    TwoButtonClick(Message: widget_message): void = TryAddCurrentPassword(2)
    ThreeButtonClick(Message: widget_message): void = TryAddCurrentPassword(3)
    FourButtonClick(Message: widget_message): void = TryAddCurrentPassword(4)
    FiveButtonClick(Message: widget_message): void = TryAddCurrentPassword(5)
    SixButtonClick(Message: widget_message): void = TryAddCurrentPassword(6)
    SevenButtonClick(Message: widget_message): void = TryAddCurrentPassword(7)
    EightButtonClick(Message: widget_message): void = TryAddCurrentPassword(8)
    NineButtonClick(Message: widget_message): void = TryAddCurrentPassword(9)

    ClearButtonClick(Message: widget_message):void=
        set CurrentPasswordArray = array{}
        UpdateDisplayedPasswordText()

    DeleteButtonClick(Message: widget_message):void=
        if (TempCurrentPasswordArray := CurrentPasswordArray.RemoveElement[CurrentPasswordArray.Length-1]):
            set CurrentPasswordArray = TempCurrentPasswordArray
            UpdateDisplayedPasswordText()

    TryAddCurrentPassword(Value: int):void=
        if (CurrentPasswordArray.Length < 32):
            set CurrentPasswordArray += array{"{Value}"}
            UpdateDisplayedPasswordText()

    UpdateDisplayedPasswordText():void=
        if (CurrentPasswordArray.Length = 0):
            DisplayedPasswordTextBlock.SetText(EmptyPasswordText)
            ConfirmButton.SetEnabled(false)
            DeleteButton.SetEnabled(false)
            ClearButton.SetEnabled(false)

        else:
            DisplayedPasswordTextBlock.SetText(MessageFromString("{Join(CurrentPasswordArray, "")}"))
            ConfirmButton.SetEnabled(true)
            DeleteButton.SetEnabled(true)
            ClearButton.SetEnabled(true)

        if (CurrentPasswordArray.Length >= 32):
            SetNumberButtonsButtonsEnabled(false)
        else:
            SetNumberButtonsButtonsEnabled(true)

    SetNumberButtonsButtonsEnabled(Status: logic):void=
        ZeroButton.SetEnabled(Status)
        OneButton.SetEnabled(Status)
        TwoButton.SetEnabled(Status)
        ThreeButton.SetEnabled(Status)
        FourButton.SetEnabled(Status)
        FiveButton.SetEnabled(Status)
        SixButton.SetEnabled(Status)
        SevenButton.SetEnabled(Status)
        EightButton.SetEnabled(Status)
        NineButton.SetEnabled(Status)

    InitCanvas():void=
        ZeroButton.SetText(ZeroButtonText)
        OneButton.SetText(OneButtonText)
        TwoButton.SetText(TwoButtonText)
        ThreeButton.SetText(ThreeButtonText)
        FourButton.SetText(FourButtonText)
        FiveButton.SetText(FiveButtonText)
        SixButton.SetText(SixButtonText)
        SevenButton.SetText(SevenButtonText)
        EightButton.SetText(EightButtonText)
        NineButton.SetText(NineButtonText)

        DeleteButton.SetText(DeleteButtonText)
        ClearButton.SetText(ClearButtonText)

        ZeroButton.OnClick().Subscribe(ZeroButtonClick)
        OneButton.OnClick().Subscribe(OneButtonClick)
        TwoButton.OnClick().Subscribe(TwoButtonClick)
        ThreeButton.OnClick().Subscribe(ThreeButtonClick)
        FourButton.OnClick().Subscribe(FourButtonClick)
        FiveButton.OnClick().Subscribe(FiveButtonClick)
        SixButton.OnClick().Subscribe(SixButtonClick)
        SevenButton.OnClick().Subscribe(SevenButtonClick)
        EightButton.OnClick().Subscribe(EightButtonClick)
        NineButton.OnClick().Subscribe(NineButtonClick)

        DeleteButton.OnClick().Subscribe(DeleteButtonClick)
        ClearButton.OnClick().Subscribe(ClearButtonClick)

        ConfirmButton.SetText(ConfirmButtonText)
        CloseButton.SetText(CloseButtonText)

        UpdateDisplayedPasswordText()

        set AssociatedCanvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.0, Y := 0.0}
                        Maximum := vector2{X := 1.0, Y := 1.0}
                    Offsets := margin:
                        Left := 0.0
                        Top := 0.0
                        Right := 0.0
                        Bottom := 0.0
                    SizeToContent := false
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    ZOrder := 0
                    Widget := color_block:
                        DefaultColor := color{R := 0.0, G := 0.0, B := 0.0}
                        DefaultOpacity := 0.65
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.5, Y := 0.5}
                        Maximum := vector2{X := 0.5, Y := 0.5}
                    Offsets := margin:
                        Left := 0.0
                        Top := 0.0
                        Right := 1100.0
                        Bottom := 1000.0
                    SizeToContent := false
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    ZOrder := 0
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Distribution := option{0.1}
                                Widget := canvas{}
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Distribution := option{0.125}
                                Widget := canvas:
                                    Slots := array:
                                        canvas_slot:
                                            Anchors := anchors:
                                                Minimum := vector2{X := 0.0, Y := 0.0}
                                                Maximum := vector2{X := 1.0, Y := 1.0}
                                            Offsets := margin:
                                                Left := 10.0
                                                Top := 10.0
                                                Right := 10.0
                                                Bottom := 10.0
                                            SizeToContent := false
                                            Alignment := vector2{X := 0.0, Y := 0.0}
                                            ZOrder := 1
                                            Widget := color_block:
                                                DefaultColor := color{R := 0.1, G := 0.1, B := 0.1}
                                                DefaultOpacity := 0.25
                                        canvas_slot:
                                            Anchors := anchors:
                                                Minimum := vector2{X := 0.0, Y := 0.0}
                                                Maximum := vector2{X := 1.0, Y := 1.0}
                                            Offsets := margin:
                                                Left := 20.0
                                                Top := 20.0
                                                Right := 20.0
                                                Bottom := 20.0
                                            SizeToContent := false
                                            Alignment := vector2{X := 0.0, Y := 0.0}
                                            ZOrder := 2
                                            Widget := color_block:
                                                DefaultColor := color{R := 1.0, G := 1.0, B := 1.0}
                                                DefaultOpacity := 0.6
                                        canvas_slot:
                                            Anchors := anchors:
                                                Minimum := vector2{X := 0.5, Y := 0.5}
                                                Maximum := vector2{X := 0.5, Y := 0.5}
                                            Offsets := margin:
                                                Left := 0.0
                                                Top := 0.0
                                                Right := 0.0
                                                Bottom := 0.0
                                            SizeToContent := true
                                            Alignment := vector2{X := 0.5, Y := 0.5}
                                            ZOrder := 3
                                            Widget := DisplayedPasswordTextBlock
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Fill
                                VerticalAlignment := vertical_alignment.Fill
                                Distribution := option{0.9}
                                Widget := stack_box:
                                    Orientation := orientation.Horizontal
                                    Slots := array:
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Distribution := option{0.5}
                                            Widget := stack_box:
                                                Orientation := orientation.Vertical
                                                Slots := array:
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{0.3}
                                                        Widget := canvas{}
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := stack_box:
                                                            Orientation := orientation.Horizontal
                                                            Slots := array:
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := OneButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := TwoButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := ThreeButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := stack_box:
                                                            Orientation := orientation.Horizontal
                                                            Slots := array:
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := FourButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := FiveButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := SixButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := stack_box:
                                                            Orientation := orientation.Horizontal
                                                            Slots := array:
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := SevenButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := EightButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := NineButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := stack_box:
                                                            Orientation := orientation.Horizontal
                                                            Slots := array:
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas{}
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas:
                                                                        Slots := array:
                                                                            canvas_slot:
                                                                                Anchors := anchors:
                                                                                    Minimum := vector2{X := 0.5, Y := 0.5}
                                                                                    Maximum := vector2{X := 0.5, Y := 0.5}
                                                                                Offsets := margin:
                                                                                    Left := 0.0
                                                                                    Top := 0.0
                                                                                    Right := 150.0
                                                                                    Bottom := 150.0
                                                                                SizeToContent := false
                                                                                Alignment := vector2{X := 0.5, Y := 0.5}
                                                                                ZOrder := 1
                                                                                Widget := ZeroButton
                                                                stack_box_slot:
                                                                    HorizontalAlignment := horizontal_alignment.Fill
                                                                    VerticalAlignment := vertical_alignment.Fill
                                                                    Distribution := option{1.0}
                                                                    Widget := canvas{}
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{0.5}
                                                        Widget := canvas{}
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Distribution := option{0.1}
                                            Widget := canvas{}
                                        stack_box_slot:
                                            HorizontalAlignment := horizontal_alignment.Fill
                                            VerticalAlignment := vertical_alignment.Fill
                                            Distribution := option{0.5}
                                            Widget := stack_box:
                                                Orientation := orientation.Vertical
                                                Slots := array:
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{0.3}
                                                        Widget := canvas{}
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := canvas:
                                                            Slots := array:
                                                                canvas_slot:
                                                                    Anchors := anchors:
                                                                        Minimum := vector2{X := 0.5, Y := 0.5}
                                                                        Maximum := vector2{X := 0.5, Y := 0.5}
                                                                    Offsets := margin:
                                                                        Left := 0.0
                                                                        Top := 0.0
                                                                        Right := 475.0
                                                                        Bottom := 150.0
                                                                    SizeToContent := false
                                                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                                                    ZOrder := 1
                                                                    Widget := DeleteButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := canvas:
                                                            Slots := array:
                                                                canvas_slot:
                                                                    Anchors := anchors:
                                                                        Minimum := vector2{X := 0.5, Y := 0.5}
                                                                        Maximum := vector2{X := 0.5, Y := 0.5}
                                                                    Offsets := margin:
                                                                        Left := 0.0
                                                                        Top := 0.0
                                                                        Right := 475.0
                                                                        Bottom := 150.0
                                                                    SizeToContent := false
                                                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                                                    ZOrder := 1
                                                                    Widget := ClearButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := canvas:
                                                            Slots := array:
                                                                canvas_slot:
                                                                    Anchors := anchors:
                                                                        Minimum := vector2{X := 0.5, Y := 0.5}
                                                                        Maximum := vector2{X := 0.5, Y := 0.5}
                                                                    Offsets := margin:
                                                                        Left := 0.0
                                                                        Top := 0.0
                                                                        Right := 475.0
                                                                        Bottom := 150.0
                                                                    SizeToContent := false
                                                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                                                    ZOrder := 1
                                                                    Widget := ConfirmButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{1.0}
                                                        Widget := canvas:
                                                            Slots := array:
                                                                canvas_slot:
                                                                    Anchors := anchors:
                                                                        Minimum := vector2{X := 0.5, Y := 0.5}
                                                                        Maximum := vector2{X := 0.5, Y := 0.5}
                                                                    Offsets := margin:
                                                                        Left := 0.0
                                                                        Top := 0.0
                                                                        Right := 475.0
                                                                        Bottom := 150.0
                                                                    SizeToContent := false
                                                                    Alignment := vector2{X := 0.5, Y := 0.5}
                                                                    ZOrder := 1
                                                                    Widget := CloseButton
                                                    stack_box_slot:
                                                        HorizontalAlignment := horizontal_alignment.Fill
                                                        VerticalAlignment := vertical_alignment.Fill
                                                        Distribution := option{0.5}
                                                        Widget := canvas{}


keypad_device := class(creative_device):
    @editable
    OpenUIButton: button_device = button_device{}

    @editable
    IncorrectAudio: audio_player_device = audio_player_device{}

    @editable
    ItemGranters: []item_granter_device = array{}

    @editable
    DevicePasswords: []string = array{}

    var StoredPlayerUIs : [player]?player_keypad_ui = map{}

    OnBegin<override>()<suspends>:void=
        OpenUIButton.InteractedWithEvent.Subscribe(OpenUIForPlayer)

    OpenUIForPlayer(Agent: agent):void=
        if (Player := player[Agent], PlayerGameUI := GetPlayerUI[Player]):
            var CurrentPlayerUI: player_keypad_ui = player_keypad_ui:
                AssociatedPlayer := Player
                AssociatedPassword := DevicePasswords
    
            CurrentPlayerUI.InitCanvas()

            CurrentPlayerUI.ConfirmButton.OnClick().Subscribe(ConfirmPassword)
            CurrentPlayerUI.CloseButton.OnClick().Subscribe(CloseButtonClick)

            if (SavedPlayerUI := StoredPlayerUIs[Player]?):
                set CurrentPlayerUI = SavedPlayerUI

            else if (set StoredPlayerUIs[Player] = option{CurrentPlayerUI}) {}
            
            PlayerGameUI.AddWidget(CurrentPlayerUI.GetCanvas(), player_ui_slot{InputMode := ui_input_mode.All})


    CloseButtonClick(Message: widget_message):void=
        CloseUIForPlayer(Message.Player)

    ForceCloseUIForPlayer(Agent: ?agent):void=
        if (Player := player[Agent?]). CloseUIForPlayer(Player)

    CloseUIForPlayer(Player: player):void=
        if (SavedPlayerUI := StoredPlayerUIs[Player]?, PlayerGameUI := GetPlayerUI[Player]):
            PlayerGameUI.RemoveWidget(SavedPlayerUI.GetCanvas())
            if (set StoredPlayerUIs[Player] = false) {}

    ConfirmPassword(Message : widget_message):void= 
        if (SavedPlayerUI := StoredPlayerUIs[Message.Player]?):
            PasswordResult := SavedPlayerUI.ConfirmPassword()
            
            if (DevicePasswords[PasswordResult], ItemGranter := ItemGranters[PasswordResult]):
                ItemGranter.GrantItem(Message.Player)
                CloseUIForPlayer(Message.Player)
            else:
                IncorrectAudio.Play(Message.Player)