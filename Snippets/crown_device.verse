using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


crown_device := class(creative_device):
    var CrownTeam: crown_team = crown_team{}
    var SeekerTeam: seeker_team = seeker_team{}

    var CurrentCrownPlayer: ?agent = false

    Initialize(Crown: crown_team, Seekers: seeker_team):void=
        set CrownTeam = Crown
        set SeekerTeam = Seekers

    CrownPlayer(DamageResult: damage_result):void=
        if:
            Instigator := DamageResult.Instigator?
            InstigatorAgent := Instigator.GetInstigatorAgent[]
            Target := fort_character[DamageResult.Target]
            TargetAgent := Target.GetAgent[]
        then:
            spawn:
                SwitchPlayerTeams(InstigatorAgent, TargetAgent)

    SwitchPlayerTeams(InstigatorAgent: agent, TargetAgent: agent)<suspends>:void=
        CrownTeam.InitializeAgent(InstigatorAgent)
        set CurrentCrownPlayer = option{InstigatorAgent}
        SeekerTeam.InitializeAgent(TargetAgent)
        if (TargetCharacter := TargetAgent.GetFortCharacter[], TargetCharacter.IsActive[]):
            TargetCharacter.SetVulnerability(false)
        # need to sleep so that the game doesn't end with an empty Seeker team
        Sleep(1.0)
        SeekerTeam.RemoveAgentFromTeam(InstigatorAgent)


    GetCurrentCrown():?agent=
        CurrentCrownPlayer

    Terminate():void=
        set CurrentCrownPlayer = false
        set CrownTeam = crown_team{}
        set SeekerTeam = seeker_team{}