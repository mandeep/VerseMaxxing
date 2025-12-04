using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Concurrency }
using { /Verse.org/Simulation/Tags}
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }
using { CancelableTask }


follower_device := class(creative_device):
    
    @editable
    DamageProp: creative_prop = creative_prop{}

    @editable
    DamageVolume: damage_volume_device = damage_volume_device{}

    # using a class variable here as the cancelable task doesn't allow arguments
    var Follower: ?fort_character = false

    var FollowerTask: ?cancelable_task = false

    AttachPropToSeeker(Agent: agent):void=
        if (Character := Agent.GetFortCharacter[]):
            DamageVolume.Enable()
            set Follower = option{Character}
            Task := CancelableSpawn(FollowCharacter)
            set FollowerTask = option{Task}

    FollowCharacter()<suspends>:void=
        loop:
            if (CharacterToFollow := Follower?):
                PropTranslationLerp: vector3 = Lerp(DamageProp.GetTransform().Translation, CharacterToFollow.GetTransform().Translation, 1.0)
                DamageProp.MoveTo(PropTranslationLerp, CharacterToFollow.GetTransform().Rotation, 0.001)
            else:
                break

    
    TeleportProp(Teleporter: teleporter_device)<suspends>:void=
        if (DamageProp.TeleportTo[Teleporter.GetTransform()]) {}
