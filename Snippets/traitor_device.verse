using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Utils }


traitor_device := class(creative_device):
    @editable
    TraitorVFX: visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    MessagesDevice: messages_device = messages_device{}

    FOV: float = 90.0  
    DrawDistance: float = 1000.0

    AngleBetween(V1: vector2, V2: vector2):float=
        if (U := V1.MakeUnitVector[], V := V2.MakeUnitVector[]):
            DP: float = DotProduct(U, V)

            return DP
        
        -1.0

    CheckFOV(Traitor: agent, Bystander: agent):logic=
        if (TraitorCharacter := Traitor.GetFortCharacter[], BystanderCharacter := Bystander.GetFortCharacter[]):
            TraitorCharacterLocation: vector3 = TraitorCharacter.GetTransform().Translation
            BystanderLocation: vector3 = BystanderCharacter.GetTransform().Translation

            DirectionToTraitor: vector3 = TraitorCharacterLocation - BystanderLocation
            BystanderViewDirection: vector3 = BystanderCharacter.GetViewRotation().GetLocalForward()

            V1: vector2 = vector2{X := DirectionToTraitor.X, Y := DirectionToTraitor.Y}
            V2: vector2 = vector2{X := BystanderViewDirection.X, Y := BystanderViewDirection.Y}

            LineOfSight: float = AngleBetween(V1, V2)
            Threshold: float = Cos(DegreesToRadians(FOV) / 2.0)

            if (LineOfSight > Threshold):
                return true
            
        false

    CheckForBystanders(DamageResult: damage_result):void=
        TeamCollection := GetPlayspace().GetTeamCollection()
        Teams: []team := TeamCollection.GetTeams()
    
        if:
            Instigator := DamageResult.Instigator?
            InstigatorAgent := Instigator.GetInstigatorAgent[]
            Target := fort_character[DamageResult.Target]
            TargetAgent := Target.GetAgent[]
            HiderTeam := Teams[0]
        then:
            AllPlayers := GetPlayspace().GetPlayers()

            for (Player : AllPlayers):           
                if (TeamCollection.IsOnTeam[Player, HiderTeam]):
                    InLineOfSight := CheckFOV(InstigatorAgent, Player)
                    if (InLineOfSight?, InstigatorPlayer := player[InstigatorAgent]):
                        PlayerDistance := CalculatePlayerDistance(InstigatorPlayer, Player)
                        if (PlayerDistance < DrawDistance):
                            TraitorVFX.Pickup(InstigatorAgent)
                            MessagesDevice.ShowTraitorCaughtMessage(InstigatorAgent)