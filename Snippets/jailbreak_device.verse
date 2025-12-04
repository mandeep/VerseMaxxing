using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


jailbreak_device := class(creative_device):
    @editable
    SeekerMutatorZones: []mutator_zone_device = array{}

    @editable
    PrisonerMutatorZones: []mutator_zone_device = array{}

    @editable
    PrisonerCounters: []player_counter_device = array{}

    @editable
    Locks: []lock_device = array{}

    @editable
    LockButtons: []button_device = array{}

    @editable
    Class1Selector: class_and_team_selector_device = class_and_team_selector_device{}

    @editable
    Class2Selector: class_and_team_selector_device = class_and_team_selector_device{}

    @editable
    MapTeleportDevice: map_teleporter_device = map_teleporter_device{}

    @editable
    JailVFX: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    JailAudio: audio_player_device = audio_player_device{}

    @editable
    MessagesDevice: messages_device = messages_device{}

    var EnterTask: ?cancelable = false
    var ExitTask: ?cancelable = false
    var CountTask: ?cancelable = false

    var AllPlayersCaptured: event() = event(){}

    var CurrentMap: int = 0

    EscapeTime: float = 10.0

    ChangePrisonerClassOnCapture(Agent: agent):void=
        Class2Selector.ChangeClass(Agent)

    ChangePrisonerClassOnRelease(Agent: agent):void=
        Class1Selector.ChangeClass(Agent)

    Initialize(MapVoteResults: int):void=
        set CurrentMap = MapVoteResults
        if (PrisonerMutatorZone := PrisonerMutatorZones[CurrentMap], SeekerMutatorZone := SeekerMutatorZones[CurrentMap]):
            SeekerMutatorZone.Enable()
            PrisonerMutatorZone.Enable()
            
            TempEnterTask := PrisonerMutatorZone.AgentEntersEvent.Subscribe(ChangePrisonerClassOnCapture)
            set EnterTask = option{TempEnterTask}

            TempExitTask := PrisonerMutatorZone.AgentExitsEvent.Subscribe(ChangePrisonerClassOnRelease)
            set ExitTask = option{TempExitTask}

        if (PrisonerCounter := PrisonerCounters[CurrentMap]):
            TempCountTask := PrisonerCounter.CountedEvent.Subscribe(AllPrisonersCaptured)
            set CountTask = option{TempCountTask}

        if (LockButton := LockButtons[CurrentMap]):
            LockButton.InteractedWithEvent.Subscribe(JailReleaseTimer)

    SendPrisonerToJail(DamageResult: damage_result)<suspends>:void=
        if (Target := fort_character[DamageResult.Target], TargetAgent := Target.GetAgent[]):
            Target.PutInStasis(stasis_args { AllowEmotes := true, AllowFalling := false, AllowTurning := true })
            
            JailVFX.Pickup(TargetAgent)
            
            Sleep(1.0)

            if (PrisonerTeleporter := MapTeleportDevice.PrisonerTeleporters[CurrentMap]):
                PrisonerTeleporter.Teleport(TargetAgent)
                Target.ReleaseFromStasis()
        
            for (Player : GetPlayspace().GetPlayers()):
                MessagesDevice.ShowPrisonerCaughtMessage(TargetAgent)

    JailReleaseTimer(Agent: agent):void=
        spawn {HandleJailDoor(Agent)}

    HandleJailDoor(Agent: agent)<suspends>:void=
        Sleep(EscapeTime) # wait before closing an open door so that players have time to escape
        if (Lock := Locks[CurrentMap]):
            Lock.Close(Agent)

    Terminate():void=
        if (PrisonerMutatorZone := PrisonerMutatorZones[CurrentMap], SeekerMutatorZone := SeekerMutatorZones[CurrentMap]):
            PrisonerMutatorZone.Disable()
            SeekerMutatorZone.Disable()

        if (CurrentEnterTask := EnterTask?):
            CurrentEnterTask.Cancel()
            set EnterTask = false
        
        if (CurrentExitTask := ExitTask?):
            CurrentExitTask.Cancel()
            set ExitTask = false

        if (CurrentCountTask := CountTask?):
            CurrentCountTask.Cancel()
            set CountTask = false

    EnableSeekerMutatorZones():void=
        for (MutatorZone : SeekerMutatorZones):
            MutatorZone.Enable()

    EnablePrisonerMutatorZones():void=
        for (MutatorZone : PrisonerMutatorZones):
            MutatorZone.Enable()

    DisableSeekerMutatorZones():void=
        for (MutatorZone : SeekerMutatorZones):
            MutatorZone.Disable()

    DisablePrisonerMutatorZones():void=
        for (MutatorZone : PrisonerMutatorZones):
            MutatorZone.Disable()

    AllPrisonersCaptured(Agent: agent):void=
        if:
            PrisonerTeam := GetPlayspace().GetTeamCollection().GetTeams()[3]
            CountOfPrisoners := GetPlayspace().GetTeamCollection().GetAgents[PrisonerTeam].Length
            PrisonerCounters[CurrentMap].GetCount() = CountOfPrisoners
        then:
            AllPlayersCaptured.Signal()