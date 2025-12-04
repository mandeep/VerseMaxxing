using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Verse.org/Concurrency }
using { /Verse.org/Random }
using { /Verse.org/Colors/NamedColors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { Utils }
using { WrappableSubscribe }

seeker_team := class<concrete>(base_team){}
hider_team := class<concrete>(base_team){}
zombie_team := class<concrete>(base_team){}
prisoner_team := class<concrete>(base_team){}
traitor_team := class<concrete>(base_team){}
freeze_team := class<concrete>(base_team){}
frozen_team := class<concrete>(base_team){}
crown_team := class<concrete>(base_team){}
juggernaut_team := class<concrete>(base_team){}


game_manager_device := class(creative_device):
    @editable
    RoundTimer: timer_device = timer_device{}

    @editable
    ResetTimer: timer_device = timer_device{}

    @editable
    PreVoteTimer: timer_device = timer_device{}

    @editable
    PostVoteTimer: timer_device = timer_device{}

    @editable
    StartGameCounter: player_counter_device = player_counter_device{}

    @editable
    VoteTimer: timer_device = timer_device{}

    @editable
    GameModeTimer: timer_device = timer_device{}

    @editable
    ReleaseTimer: timer_device = timer_device{}

    @editable
    VoteDevice: vote_device = vote_device{}

    @editable
    GameModeVoteDevice: gamemode_vote_device = gamemode_vote_device{}

    @editable
    MapTeleportDevice: map_teleporter_device = map_teleporter_device{}

    @editable
    RandomPlayerSelector: random_player_device = random_player_device{}

    @editable
    ItemRemover: item_remover_device = item_remover_device{}

    @editable
    SwordGranter: item_granter_device = item_granter_device{}

    @editable
    SpectatorVolume: damage_volume_device = damage_volume_device{}

    @editable
    DBNODevice: down_but_not_out_device = down_but_not_out_device{}

    @editable
    HidersRemainingUI: hiders_remaining_device = hiders_remaining_device{}

    @editable
    SeekerDistanceUI: seeker_distance_device = seeker_distance_device{}

    @editable
    EliminationUI: elimination_ui_device = elimination_ui_device{}

    @editable
    JailbreakDevice: jailbreak_device = jailbreak_device{}

    @editable
    FreezeDevice: freeze_device = freeze_device{}

    @editable
    CrownDevice: crown_device = crown_device{}

    @editable
    JuggernautDevice: juggernaut_device = juggernaut_device{}

    @editable
    PreyDevice: prey_device = prey_device{}

    @editable
    TraitorDevice: traitor_device = traitor_device{}

    @editable
    LootDevice: loot_device = loot_device{}

    @editable
    RoleSelectorDevice: role_selector_device = role_selector_device{}

    @editable
    MessagesDevice: messages_device = messages_device{}

    @editable
    WaitMessage: hud_message_device = hud_message_device{}

    @editable
    EndGameAudio: []audio_player_device = array{}

    @editable
    var SeekerTeam: seeker_team = seeker_team{}

    @editable
    var HiderTeam: hider_team = hider_team{}

    @editable
    var ZombieTeam: zombie_team = zombie_team{}

    @editable
    var TraitorTeam: traitor_team = traitor_team{}

    @editable
    var PrisonerTeam: prisoner_team = prisoner_team{}

    @editable
    var FreezeTeam: freeze_team = freeze_team{}

    @editable
    var FrozenTeam: frozen_team = frozen_team{}

    @editable
    var CrownTeam: crown_team = crown_team{}

    @editable
    var JuggernautTeam: juggernaut_team = juggernaut_team{}

    @editable
    MapAnalyticsDevices: []analytics_device = array{}

    @editable
    ModeAnalyticsDevices: []analytics_device = array{}

    @editable
    WinAnalyticDevices: []analytics_device = array{}

    @editable
    WinAccoladeDevices: []accolades_device = array{}

    PlayerStatsManager: player_stats_manager = player_stats_manager{}

    RoundEndedEvent: event() = event(){}

    CrownLeavesEvent: event() = event(){}

    var SubscribedEvents: []cancelable = array{}

    # var StartGameEvent: ?cancelable = false

    var SelectedPlayers: []agent = array{}


    OnBegin<override>()<suspends>:void=
        SpectatorVolume.Disable()
        SetToDefaultTeam()

        StartGameCounter.CountSucceedsEvent.Subscribe(StartPreVoteTimer)
        StartGameCounter.CountFailsEvent.Subscribe(HandleNotEnoughPlayers)
        PreVoteTimer.SuccessEvent.Subscribe(VoteDevice.StartVote)
        VoteTimer.SuccessEvent.Subscribe(VoteDevice.EndVote)
        VoteTimer.SuccessEvent.Subscribe(StartGame)
        # VoteTimer.SuccessEvent.Subscribe(GameModeVoteDevice.StartVote)
        # GameModeTimer.SuccessEvent.Subscribe(StartGame)
        RoundTimer.SuccessEvent.Subscribe(EndGame)
        ResetTimer.SuccessEvent.Subscribe(TeleportToSpawn)
        # PostVoteTimer.SuccessEvent.Subscribe(SetUpGame)

        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        SeekerTeam.EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)
        HiderTeam.EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)
        FreezeTeam.EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)
        JuggernautTeam.EliminationManager.EliminatedEvent.Subscribe(OnPlayerEliminated)

        for (Player : GetPlayspace().GetPlayers()):
            OnPlayerAdded(Player)
        # GoldCoinDevice.MoveGoldToLobby()

    HandleNotEnoughPlayers():void=
        if (PreVoteTimer.GetActiveDuration() < PreVoteTimer.GetMaxDuration()):
            PreVoteTimer.Reset()
        
        else if (VoteTimer.GetActiveDuration() < VoteTimer.GetMaxDuration()):
            VoteDevice.EndVote(false)
            VoteTimer.Reset()

        # else if (GameModeTimer.GetActiveDuration() < GameModeTimer.GetMaxDuration()):
        #     GameModeVoteDevice.EndVote(false)
        #     GameModeTimer.Reset()
        
        # else if (RoundTimer.GetActiveDuration() < RoundTimer.GetMaxDuration()):
        #     RoundTimer.Reset()
        #     EndGame(false)
        #     TeleportToSpawn(false)
        else if (ReleaseTimer.GetActiveDuration() < ReleaseTimer.GetMaxDuration()):
            ReleaseTimer.Reset()
    

        else if (PostVoteTimer.GetActiveDuration() < PostVoteTimer.GetMaxDuration()):
            PostVoteTimer.Reset()
        
        WaitMessage.Show()
    #     spawn:
    #         UpdateWaitMessage()

    # UpdateWaitMessage()<suspends>:void=
    #     loop:
    #         if (StartGameCounter.IsPassingTest[]):
    #             break
            
    #         WaitMessage.SetText(StringToMessage("."))
    #         Sleep(1.0)
    #         WaitMessage.SetText(StringToMessage(".."))
    #         Sleep(1.0)
    #         WaitMessage.SetText(StringToMessage("..."))
    #         Sleep(1.0)
    #         WaitMessage.SetText(StringToMessage(""))
    #         Sleep(1.0)

    StartPreVoteTimer():void=
        if (StartGameCounter.IsPassingTest[]):
            PreVoteTimer.Start()

    StartGame(Agent: ?agent):void=
        spawn:
            SetUpGame()

    SelectRoles(GameModeVoteResults: int)<suspends>:void=
        if (GameModeVoteResults = 4 or GameModeVoteResults = 5):
            MaybePlayers: []?agent = RandomPlayerSelector.SelectMultipleRandomPlayers(2)
            for (MaybePlayer : MaybePlayers):
                if (SelectedPlayer := MaybePlayer?):
                    set SelectedPlayers += array{SelectedPlayer}
        else:
            if (GetPlayspace().GetPlayers().Length > 1):
                MaybePlayer: ?agent = RandomPlayerSelector.SelectRandomPlayer()
                if (SelectedPlayer := MaybePlayer?):
                    set SelectedPlayers = array{SelectedPlayer}

    SetUpGame()<suspends>:void=
        # GameModeVoteDevice.EndVote(false)
        # Sleep(0.1)

        MapVoteResults: int = VoteDevice.GetWinningVote()
        GameModeVoteResults: int = GameModeVoteDevice.GetWinningVote()

        SubmitMapAnalytics(MapVoteResults)
        
        SelectRoles(GameModeVoteResults)

        spawn:
            DisplayRoles(GameModeVoteResults)

        PostVoteTimer.SuccessEvent.Await()

        AssignTeams(GameModeVoteResults)
        SetGameMode(GameModeVoteResults, MapVoteResults)
        TeleportPlayers(MapVoteResults, GameModeVoteResults)

        AddUIs(GameModeVoteResults)

        ShowMessages(GameModeVoteResults)
        LootDevice.PlaceLootInMap(MapVoteResults)

        SpectatorVolume.Enable()
        CheckForGameEnd()

    DisplayRoles(GameModeVoteResults: int)<suspends>:void=
        Sleep(1.0)
        Probabilities: [agent]int = RandomPlayerSelector.CalculateProbabilities()
        RoleSelectorDevice.DisplayRoleHUD()
        Sleep(0.15)
        RoleSelectorDevice.DisplayPlayerRoles(SelectedPlayers, Probabilities, GameModeVoteResults)
    
    AssignTeams(GameModeVoteResults: int):void=
        if (GameModeVoteResults = 7):
            if (CrownPlayer := SelectedPlayers[0]):
                CrownTeam.InitializeAgent(CrownPlayer)

            AllPlayers: []player = GetPlayspace().GetPlayers()

            for (Player : AllPlayers):
                if (not CrownTeam.FindOnTeam[Player]):
                    SeekerTeam.InitializeAgent(Player)
        else if (GameModeVoteResults = 6):
            if (Juggernaut := SelectedPlayers[0]):
                JuggernautTeam.InitializeAgent(Juggernaut)

            AllPlayers: []player = GetPlayspace().GetPlayers()

            for (Player : AllPlayers):
                if (not JuggernautTeam.FindOnTeam[Player]):
                    SeekerTeam.InitializeAgent(Player)
        else:
            AllPlayers: []player = GetPlayspace().GetPlayers()
            
            if (AllPlayers.Length > 1): 
                if (Seeker := SelectedPlayers[0]):
                    SeekerTeam.InitializeAgent(Seeker)

                for (Player : AllPlayers):
                    if (not SeekerTeam.FindOnTeam[Player]):
                        HiderTeam.InitializeAgent(Player)
            else:
                for (Player : AllPlayers):
                    HiderTeam.InitializeAgent(Player)

    SetGameMode(GameModeVoteResults: int, MapVoteResults: int):void=
        JailbreakDevice.DisableSeekerMutatorZones()
        
        case (GameModeVoteResults):
            1 =>
                Print("Infection")
                # DBNODevice.Disable()
                SetZombieGameMode()
                if (AnalyticDevice := ModeAnalyticsDevices[1], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            2 =>
                Print("Revive")
                # DBNODevice.Enable()
                # DBNODevice.Disable()
                # DBNODevice.Enable()
                # SetReviveGameMode()
                if (AnalyticDevice := ModeAnalyticsDevices[2], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            3 =>
                Print("Jailbreak")
                # DBNODevice.Disable()
                SetJailbreakMode(MapVoteResults)
                if (AnalyticDevice := ModeAnalyticsDevices[3], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            4 =>
                Print("Traitor")
                # DBNODevice.Disable()
                SetTraitorMode()
                if (AnalyticDevice := ModeAnalyticsDevices[4], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            5 =>
                Print("Revenge")
                # DBNODevice.Disable()
                SetPreyMode()
                if (AnalyticDevice := ModeAnalyticsDevices[5], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            6 =>
                Print("Juggernaut")
                # DBNODevice.Disable()
                SetJuggernautGameMode()
                if (AnalyticDevice := ModeAnalyticsDevices[6], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            7 =>
                Print("Crown")
                # DBNODevice.Disable()
                SetCrownGameMode()
                if (AnalyticDevice := ModeAnalyticsDevices[7], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            8 =>
                Print("Freeze")
                # DBNODevice.Disable()
                SetFreezeGameMode()
                if (AnalyticDevice := ModeAnalyticsDevices[8], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)
            _ =>
                Print("Classic")
                # DBNODevice.Disable()
                if (AnalyticDevice := ModeAnalyticsDevices[0], Player := SelectedPlayers[0]):
                    AnalyticDevice.Submit(Player)

    TeleportPlayers(MapVoteResults: int, GameModeVoteResults: int):void=
        for (SeekerAgent : SeekerTeam.GetAgents[], Seeker := player[SeekerAgent]):
            if (SeekerTeleporter := MapTeleportDevice.SeekerTeleporters[MapVoteResults]):
                SeekerTeleporter.Teleport(Seeker)
        if (GameModeVoteResults = 8):
            for (FreezeAgent : FreezeTeam.GetAgents[], Freeze := player[FreezeAgent]):
                MapTeleportDevice.TeleportHider(Freeze, MapVoteResults)
        if (GameModeVoteResults = 7):
            for (CrownAgent : CrownTeam.GetAgents[], Crown := player[CrownAgent]):
                MapTeleportDevice.TeleportHider(Crown, MapVoteResults)
        if (GameModeVoteResults = 6):
            for (JuggernautAgent : JuggernautTeam.GetAgents[], Juggernaut := player[JuggernautAgent]):
                MapTeleportDevice.TeleportHider(Juggernaut, MapVoteResults)
        else:
            for (HiderAgent : HiderTeam.GetAgents[], Hider := player[HiderAgent]):
                MapTeleportDevice.TeleportHider(Hider, MapVoteResults)

    ShowMessages(GameModeVoteResults: int):void=
        AllPlayers := GetPlayspace().GetPlayers()

        case (GameModeVoteResults):
            8 =>
                for (Player : AllPlayers):
                    if (SeekerTeam.FindOnTeam[Player]):
                        MessagesDevice.ShowFreezeSeekerHelpMessage(Player)
                    else:
                        MessagesDevice.ShowFreezeHiderHelpMessage(Player)
            7 =>
                for (Player : AllPlayers):
                    MessagesDevice.ShowCrownHelpMessage(Player)
            6 =>
                if (Juggernaut := JuggernautTeam.GetAgents[][0]):
                    MessagesDevice.ShowJuggernautHelpMessage(Juggernaut)
            5 =>
                if (Avenger := SelectedPlayers[1]):
                    MessagesDevice.ShowAvengerHelpMessage(Avenger)
            4 =>
                if (Traitor := TraitorTeam.GetAgents[][0]):
                    MessagesDevice.ShowTraitorHelpMessage(Traitor)
            # 3 =>
            #     for (Player : AllPlayers):
            #         if (SeekerTeam.FindOnTeam[Player]):
            #             MessagesDevice.ShowJailbreakSeekerHelpMessage(Player)
            #         else:
            #             MessagesDevice.ShowJailbreakHiderHelpMessage(Player)
            # 1 =>
            #     for (Player : AllPlayers):
            #         if (SeekerTeam.FindOnTeam[Player]):
            #             MessagesDevice.ShowInfectionSeekerHelpMessage(Player)
            #         else:
            #             MessagesDevice.ShowInfectionHiderHelpMessage(Player)
            _ =>
                # Print("")

    CheckForGameEnd():void=
        spawn:
            WaitForGameEnd()

    WaitForGameEnd()<suspends>:void=
        Loser :=
            race:
                block:
                    SeekerTeam.TeamEmptyEvent.Await()
                    1
                block:
                    HiderTeam.TeamEmptyEvent.Await()
                    2
                block:
                    RoundEndedEvent.Await()
                    3
                block:
                    JailbreakDevice.AllPlayersCaptured.Await()
                    2
                block:
                    FreezeTeam.TeamEmptyEvent.Await()
                    2
                block:
                    FrozenTeam.TeamEmptyEvent.Await()
                    2
                block:
                    JuggernautTeam.TeamEmptyEvent.Await()
                    2
                block:
                    CrownLeavesEvent.Await()
                    2

        Sleep(1.0)
        if (StartGameCounter.IsPassingTest[]):
            EndGameAfterEliminations(Loser)
        else:
            EndGame(false)
            RoundTimer.Reset()
            TeleportToSpawn(false)

    AddUIs(GameMode: int):void=
        if (array{1, 2, 4, 5}.Find[GameMode]):
            for (SeekerAgent : SeekerTeam.GetAgents[]):
                HidersRemainingUI.AddUI(SeekerAgent)
                HidersRemainingUI.UpdateUI(SeekerAgent, HiderTeam.Count())

        else if (GameMode = 8):
            for (SeekerAgent : SeekerTeam.GetAgents[]):
                HidersRemainingUI.AddUI(SeekerAgent)
                HidersRemainingUI.UpdateUI(SeekerAgent, FreezeTeam.Count())

        # if (Seekers := SeekerTeam.GetAgents[]):
        #     SeekerDistanceUI.SetSeekers(Seekers)
        
        # for (HiderAgent : HiderTeam.GetAgents[]):
        #     SeekerDistanceUI.AddUI(HiderAgent)

    RemoveUIs():void=
        for (SeekerAgent : SeekerTeam.GetAgents[]):
            HidersRemainingUI.RemoveUI(SeekerAgent)

        for (Player : GetPlayspace().GetPlayers()):
            EliminationUI.RemoveUI(Player)

        # for (HiderAgent : HiderTeam.GetAgents[]):
        #     SeekerDistanceUI.RemoveUI(HiderAgent)

    EndGameAfterEliminations(LosingTeam: int):void=
        GameMode: int = GameModeVoteDevice.GetWinningVote()

        if (LosingTeam = 1, AudioPlayer := EndGameAudio[1]):
            AudioPlayer.Play()

            if (GameMode = 6):
                MessagesDevice.ShowJuggernautMessage()

                if (Juggernaut := JuggernautTeam.GetAgents[][0], AccoladeDevice := WinAccoladeDevices[2]):
                    AccoladeDevice.Award(Juggernaut)

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[2]):
                    AnalyticDevice.Submit(Player)
            else if (GameMode = 7):
                MessagesDevice.ShowDefaultCrownMessage()

                MaybeCrownPlayer := CrownDevice.GetCurrentCrown()
                if (Crown := MaybeCrownPlayer?, AccoladeDevice := WinAccoladeDevices[3]):
                    AccoladeDevice.Award(Crown)

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[3]):
                    AnalyticDevice.Submit(Player)
            else:
                MessagesDevice.ShowHiderMessage()

                for (Hider : HiderTeam.GetAgents[], AccoladeDevice := WinAccoladeDevices[1]):
                    AccoladeDevice.Award(Hider)

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[1]):
                    AnalyticDevice.Submit(Player)
        else if (LosingTeam = 2, AudioPlayer := EndGameAudio[0]):
            AudioPlayer.Play()
            MessagesDevice.ShowSeekerMessage()

            for (Seeker : SeekerTeam.GetAgents[], AccoladeDevice := WinAccoladeDevices[0]):
                AccoladeDevice.Award(Seeker)

            if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[0]):
                AnalyticDevice.Submit(Player)
        else if (LosingTeam = 3, AudioPlayer := EndGameAudio[1]):
            if (GameMode = 6):
                MessagesDevice.ShowJuggernautMessage()

                if (Juggernaut := JuggernautTeam.GetAgents[][0], AccoladeDevice := WinAccoladeDevices[2]):
                    AccoladeDevice.Award(Juggernaut)

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[2]):
                    AnalyticDevice.Submit(Player)
            else if (GameMode = 7):
                # should only be one player on this team at game end
                MaybeCrownPlayer := CrownDevice.GetCurrentCrown()
                if (Crown := MaybeCrownPlayer?, AccoladeDevice := WinAccoladeDevices[3]):
                    MessagesDevice.ShowCrownMessage(Crown)
                    AccoladeDevice.Award(Crown)
                else:
                    MessagesDevice.ShowDefaultCrownMessage()

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[3]):
                    AnalyticDevice.Submit(Player)

                CrownDevice.Terminate()
            else:
                MessagesDevice.ShowHiderMessage()

                for (Hider : HiderTeam.GetAgents[], AccoladeDevice := WinAccoladeDevices[1]):
                    AccoladeDevice.Award(Hider)

                if (Player := GetPlayspace().GetPlayers()[0], AnalyticDevice := WinAnalyticDevices[1]):
                    AnalyticDevice.Submit(Player)
                
                AudioPlayer.Play()
                # return early since this means that the game has already ended and EndGame has already been called by the Round Timer SuccessEvent
                return

            AudioPlayer.Play()

        RoundTimer.Reset()
        EndGame(false)

    EndGame(Agent: ?agent):void=
        RoundEndedEvent.Signal()

        EndGameMode()

        if (StartGameCounter.IsPassingTest[]):
            ResetTimer.Start()

            RandomPlayerSelector.UpdateWeights()
            for (SelectedPlayer : SelectedPlayers):
                RandomPlayerSelector.ResetWeight(SelectedPlayer)

            # if (SomeAgent := GetPlayspace().GetPlayers()[0]):
            #     SubmitMapAnalytics(VoteDevice.GetWinningVote(), SomeAgent)

        for (Player : GetPlayspace().GetPlayers()):
            if (Character := Player.GetFortCharacter[], Character.IsActive[], Character.IsDownButNotOut[]):
                DBNODevice.Revive(Player)
        
        RemoveUIs()
    
        # change all players back to team 1 and class 1
        RemovePlayersFromTeams()
        SetToDefaultTeam()

        # GoldCoinDevice.ResetGold()
        # GoldCoinDevice.MoveGoldToLobby()

        # DBNODevice.Disable()
        SpectatorVolume.Disable()

    RemovePlayersFromTeams():void=
        SeekerTeam.ClearAgents()
        HiderTeam.ClearAgents()
        ZombieTeam.ClearAgents()
        PrisonerTeam.ClearAgents()
        FreezeTeam.ClearAgents()
        FrozenTeam.ClearAgents()
        TraitorTeam.ClearAgents()
        CrownTeam.ClearAgents()

        set SelectedPlayers = array{}

    SetToDefaultTeam():void=
        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            HiderTeam.ClassSelector.ChangeTeam(Player)

            if (Character := Player.GetFortCharacter[]):
                Character.SetVulnerability(true)
        
            # remove all items from the item remover list. currently just the seeker's knife
            ItemRemover.Remove(Player)

    EndGameMode():void=
        for (Event : SubscribedEvents):
            Event.Cancel()

        set SubscribedEvents = array{}
        
        GameMode: int = GameModeVoteDevice.GetWinningVote()

        if (GameMode = 3):
            JailbreakDevice.Terminate()

    SetZombieGameMode():void=
        for (Hider : HiderTeam.GetAgents[]):
            if (Character := Hider.GetFortCharacter[], Character.IsActive[]):
                # need to set health to 100 otherwise a knife stroke will eliminate the player
                # another way to do this is to just make the hiders invincible
                Character.SetMaxHealth(100.0)
                ZombieEvent: cancelable = Character.DamagedEvent().Subscribe(SwitchToZombie)
                set SubscribedEvents += array{ZombieEvent}

        for (Seeker : SeekerTeam.GetAgents[]):
            if (Character := Seeker.GetFortCharacter[], Character.IsActive[]):
                Character.SetVulnerability(false)

    SetFreezeGameMode():void=
        for (Hider : HiderTeam.GetAgents[]):
            if (Character := Hider.GetFortCharacter[], Character.IsActive[]):
                FreezeTeam.InitializeAgent(Hider)
                FreezeEvent: cancelable = Character.DamagedEvent().Subscribe(FreezeDevice.FreezePlayer)
                set SubscribedEvents += array{FreezeEvent}

        for (Seeker : SeekerTeam.GetAgents[]):
            if (Character := Seeker.GetFortCharacter[], Character.IsActive[]):
                Character.SetVulnerability(false)

        FreezeDevice.Initialize(FreezeTeam, FrozenTeam)

    SetCrownGameMode():void=
        CrownDevice.Initialize(CrownTeam, SeekerTeam)

        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            if (Character := Player.GetFortCharacter[], Character.IsActive[]):
                CrownEvent: cancelable = Character.DamagedEvent().Subscribe(CrownDevice.CrownPlayer)
                set SubscribedEvents += array{CrownEvent}
        
        # not setting Seeker to invincible as the Crown team is invincible and cannot harm the seeker

    SetJuggernautGameMode():void=
        if (Juggernaut := JuggernautTeam.GetAgents[][0]):
            spawn:
                JuggernautDevice.SetJuggernaut(Juggernaut)

    SetJailbreakMode(MapVoteResults: int):void=
        # for (MutatorZone : MutatorZones):
        #     MutatorZone.Enable()

        for (Hider : HiderTeam.GetAgents[]):
            if (Character := Hider.GetFortCharacter[],  Character.IsActive[]):
                PrisonerTeam.ClassSelector.ChangeTeam(Hider)

                JailbreakEvent: cancelable = Character.DamagedEvent().Subscribe(SendPrisonerToJail)
                set SubscribedEvents += array{JailbreakEvent}
            
        JailbreakDevice.Initialize(MapVoteResults)

    SetPreyMode():void=
        for (Player : SelectedPlayers):
            if (not SeekerTeam.FindOnTeam[Player]):
                spawn:
                    AwaitSeekerRelease(Player)
            else:
                spawn:
                    PreyDevice.WeakenSeeker(Player)
    
    SetTraitorMode():void=
        for (Player : SelectedPlayers):
            if (not SeekerTeam.FindOnTeam[Player]):
                spawn:
                    AwaitTraitorChange(Player)

        for (Hider : HiderTeam.GetAgents[]):
            if (Character := Hider.GetFortCharacter[],  Character.IsActive[]):
                TraitorEvent: cancelable = Character.DamagedEvent().Subscribe(TraitorDevice.CheckForBystanders)
                set SubscribedEvents += array{TraitorEvent}

    # SetReviveGameMode():void=
    #     DBNODevice.Disable()
    #     DBNODevice.Enable()

    #     for (Hider : HiderTeam.GetAgents[]):
    #         if (Character := Hider.GetFortCharacter[],  Character.IsActive[]):
    #             TempTask: cancelable = Character.DamagedEvent().Subscribe(KnockOutPlayer)
    #             set GameModeTask = option{TempTask}

    SwitchToZombie(DamageResult: damage_result):void=
        if (Target := fort_character[DamageResult.Target], TargetAgent := Target.GetAgent[]):
            HiderTeam.EliminateAgent(TargetAgent)
            ZombieTeam.InitializeAgent(TargetAgent)

    SendPrisonerToJail(DamageResult: damage_result):void=
        spawn:
            JailbreakDevice.SendPrisonerToJail(DamageResult)

    # KnockOutPlayer(DamageResult: damage_result):void=
    #     if (Target := fort_character[DamageResult.Target], TargetAgent := Target.GetAgent[]):
    #         DBNODevice.Down(TargetAgent)

    AwaitSeekerRelease(Player: agent)<suspends>:void=
        ReleaseTimer.SuccessEvent.Await()
        GrantSwordToPlayer(Player)

    AwaitTraitorChange(Player: agent)<suspends>:void=
        ReleaseTimer.SuccessEvent.Await()
        HiderTeam.EliminateAgent(Player)
        TraitorTeam.InitializeAgent(Player)

    GrantSwordToPlayer(Player: agent):void=
        SwordGranter.GrantItem(Player)
        
    TeleportToSpawn(Agent: ?agent):void=
        MapTeleportDevice.TeleportPlayersToLobby(Agent)
        StartPreVoteTimer()

    SubmitMapAnalytics(MapVoteResults: int):void=
        if (Agent := GetPlayspace().GetPlayers()[0], AnalyticsDevice := MapAnalyticsDevices[MapVoteResults]):
            AnalyticsDevice.Submit(Agent)

    OnPlayerEliminated(Agent: agent):void=
        if (SeekerTeam.FindOnTeam[Agent]):
            SeekerTeam.EliminateAgent(Agent)

        if (FreezeTeam.FindOnTeam[Agent]):
            FreezeTeam.EliminateAgent(Agent)

        if (JuggernautTeam.FindOnTeam[Agent]):
            JuggernautTeam.EliminateAgent(Agent)

        if (HiderTeam.FindOnTeam[Agent]):
            HiderTeam.EliminateAgent(Agent)
            SeekerDistanceUI.RemoveUI(Agent)

            for (SeekerAgent : SeekerTeam.GetAgents[]):
                if (HiderTeamAgents := HiderTeam.GetAgents[]):
                    HidersRemainingUI.UpdateUI(SeekerAgent, HiderTeam.Count())

        EliminationUI.AddUI(Agent)

    OnPlayerRemoved(Player: player):void=
        if (SeekerTeam.FindOnTeam[Player]):
            SeekerTeam.EliminateAgent(Player)

        if (ZombieTeam.FindOnTeam[Player]):
            ZombieTeam.EliminateAgent(Player)

        if (PrisonerTeam.FindOnTeam[Player]):
            PrisonerTeam.EliminateAgent(Player)

        if (TraitorTeam.FindOnTeam[Player]):
            TraitorTeam.EliminateAgent(Player)

        if (FreezeTeam.FindOnTeam[Player]):
            FreezeTeam.EliminateAgent(Player)

        if (FrozenTeam.FindOnTeam[Player]):
            FreezeTeam.EliminateAgent(Player)

        if (CrownTeam.FindOnTeam[Player]):
            CrownTeam.EliminateAgent(Player)
            CrownLeavesEvent.Signal()

        if (JuggernautTeam.FindOnTeam[Player]):
            JuggernautTeam.EliminateAgent(Player)

        if (HiderTeam.FindOnTeam[Player]):
            HiderTeam.EliminateAgent(Player)
            # SeekerDistanceUI.RemoveUI(Player)

            for (SeekerAgent : SeekerTeam.GetAgents[]):
                HidersRemainingUI.UpdateUI(SeekerAgent, HiderTeam.Count())

        # if (StartGameCounter.GetCount() <= 1, StartGameTask := StartGameEvent?):
        #         # StartGameTask.Cancel()
        #         StartGameCounter.CompareToTarget()

    OnPlayerAdded(Player: player):void=
        HiderTeam.ClassSelector.ChangeTeam(Player)
        PlayerStatsManager.InitializePlayer(Player)
        LootDevice.AddGoldToPlayer(Player)

        # if (StartGameCounter.GetCount() = StartGameCounter.GetTargetCount()):
        #     StartGameTask := StartGameCounter.CountSucceedsEvent.Subscribe(StartPreVoteTimer)
        #     set StartGameEvent = option{StartGameTask}

    CheckTeamPlayer(TeamIndex: int):?agent=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams: []team := TeamCollection.GetTeams()
        AllPlayers := GetPlayspace().GetPlayers()

        for (Player : AllPlayers):
            if (Team := Teams[TeamIndex], TeamCollection.IsOnTeam[Player, Team]):
                return option{Player}

        false