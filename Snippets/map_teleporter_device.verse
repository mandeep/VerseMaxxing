using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


map_teleporter_device := class(creative_device):
    @editable
    SeekerTeleporters: []teleporter_device = array{}

    @editable
    PrisonerTeleporters: []teleporter_device = array{}

    @editable
    Map1HiderTeleporters: []teleporter_device = array{}
    @editable
    Map2HiderTeleporters: []teleporter_device = array{}
    @editable
    Map3HiderTeleporters: []teleporter_device = array{}
    @editable
    Map4HiderTeleporters: []teleporter_device = array{}

    @editable
    SpawnTeleporters: []teleporter_device = array{}

    TeleportSeeker(Player: player, MapVoteResults: int):void=
        if (SeekerTeleporter := SeekerTeleporters[MapVoteResults]):
                SeekerTeleporter.Teleport(Player)

    TeleportPrisoner(Player: player, MapVoteResults: int):void=
        if (PrisonerTeleporter := PrisonerTeleporters[MapVoteResults]):
            PrisonerTeleporter.Teleport(Player)

    TeleportHider(Hider: player, MapVoteResults: int):void=
        if (MapVoteResults = 0):
            if (HiderTeleporter := Map1HiderTeleporters[MapVoteResults]):
                HiderTeleporter.Teleport(Hider)
        else if (MapVoteResults = 1):
            if (HiderTeleporter := Map2HiderTeleporters[MapVoteResults]):
                HiderTeleporter.Teleport(Hider)
        else if (MapVoteResults = 2):
            if (HiderTeleporter := Map3HiderTeleporters[MapVoteResults]):
                HiderTeleporter.Teleport(Hider)
        else if (MapVoteResults = 3):
            if (HiderTeleporter := Map4HiderTeleporters[MapVoteResults]):
                HiderTeleporter.Teleport(Hider)

    TeleportPlayersToLobby(Agent: ?agent):void=
        AllPlayers: []player = GetPlayspace().GetPlayers()    
        
        for (Index->Player : AllPlayers):
            if (SpawnTeleporter := SpawnTeleporters[Index], Player.GetFortCharacter[].IsActive[]):
                SpawnTeleporter.Teleport(Player)
        
        # running this again instead of the prior for loop as we want players to be at the spawn pads
        # in case world partition issues arise
        for (Index->Player : AllPlayers):
            if (SpawnTeleporter := SpawnTeleporters[Index], not Player.GetFortCharacter[].IsActive[]):
                Player.Respawn(SpawnTeleporter.GetTransform().Translation, SpawnTeleporter.GetTransform().Rotation)
