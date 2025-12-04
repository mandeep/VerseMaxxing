
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


freeze_device := class(creative_device):  
    @editable
    FrozenVFX: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    SeekerVFX: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    TempFrozenSelector: class_and_team_selector_device = class_and_team_selector_device{}

    var FreezeHidersTeam: freeze_team = freeze_team{}
    var FrozenSeekersTeam: frozen_team = frozen_team{}

    var FrozenPlayers: []agent = array{}

    Initialize(FreezeTeam: freeze_team, FrozenTeam: frozen_team):void=
        set FreezeHidersTeam = FreezeTeam
        set FrozenSeekersTeam = FrozenTeam

    FreezePlayer(DamageResult: damage_result):void=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams: []team := TeamCollection.GetTeams()

        if:
            Instigator := DamageResult.Instigator?
            InstigatorAgent := Instigator.GetInstigatorAgent[]
            Target := fort_character[DamageResult.Target]
            TargetAgent := Target.GetAgent[]
        then:
            if:
                SeekerTeam := Teams[1]
                TeamCollection.IsOnTeam[InstigatorAgent, SeekerTeam]

                # FrozenHidersTeam := Teams[6]
                not FrozenSeekersTeam.FindOnTeam[TargetAgent]
                not FrozenPlayers.Find[TargetAgent]
                # FreezeTeam.Count() > 1
                # FreezeTeam.Count() - FrozenPlayers.Length > 1
            then:
                # Target.SetVulnerability(false)
                Target.PutInStasis(stasis_args { AllowEmotes := true, AllowFalling := false, AllowTurning := true })
                Target.SetVulnerability(false)
                TempFrozenSelector.ChangeClass(TargetAgent)
                # FrozenVFX.Pickup(TargetAgent)
                # FrozenHidersSelector.ChangeTeam(TargetAgent)
                set FrozenPlayers += array{TargetAgent}
                spawn:
                    ConvertFrozenPlayer(TargetAgent)
            else if:
                # HiderTeam := Teams[5]
                # FrozenHidersTeam := Teams[6]
                # TeamCollection.IsOnTeam[InstigatorAgent, HiderTeam]
                # TeamCollection.IsOnTeam[TargetAgent, FrozenHidersTeam]
                FreezeHidersTeam.FindOnTeam[InstigatorAgent]
                FrozenPlayers.Find[TargetAgent]
            then:
                # Target.SetVulnerability(true)
                FreezeHidersTeam.ClassSelector.ChangeClass(TargetAgent)
                Target.ReleaseFromStasis()
                Target.SetVulnerability(true)
                Target.SetHealth(21.0)
                set FrozenPlayers = FrozenPlayers.RemoveAllElements(TargetAgent)
            else if:
                FrozenSeekersTeam.FindOnTeam[InstigatorAgent]
                FreezeHidersTeam.FindOnTeam[TargetAgent]
                not FrozenPlayers.Find[TargetAgent]
            then:
                Target.Damage(100.0)
                set FrozenPlayers = FrozenPlayers.RemoveAllElements(TargetAgent)

            
            # if (FreezeTeam.Count() - FrozenPlayers.Length = 1):
            #     for (Player : FreezeTeam.GetAgents[]):
            #         if (Character := Player.GetFortCharacter[]):
            #             Character.SetHealth(1.0)

            # cannot do damage in a damage event or it will cause infinite recursion
            # if (FreezeTeam.Count() = FrozenPlayers.Length):
            #     for (Player : FreezeTeam.GetAgents[]):
            #         if (Character := Player.GetFortCharacter[]):
            #             Character.Damage(100.0)


    ConvertFrozenPlayer(Player: agent)<suspends>:void=
        Sleep(15.0)

        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams: []team := TeamCollection.GetTeams()
        
        if (FrozenPlayers.Find[Player]):
            # FrozenSeekersSelector.ChangeTeam(Player)
            FreezeHidersTeam.EliminateAgent(Player)
            FrozenSeekersTeam.InitializeAgent(Player)
            FrozenPlayers.RemoveAllElements(Player)

            if (Character := Player.GetFortCharacter[]):
                Character.ReleaseFromStasis()
                # Sleep(0.5) # give time for frozen vfx to despawn
                # SeekerVFX.Pickup(Player)