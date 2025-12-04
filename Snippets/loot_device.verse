
using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { HaltonSequencer }
# using { SeedableRandom }
using { WrappableSubscribe }

GoldCoinTag := class(tag){}
HiddenRoomCoinTag := class(tag){}
GoldPlaneTag := class(tag){}
LobbyFloorGoldTag := class(tag){}
BunkerTicketPlaneTag := class(tag){}
CastleTicketPlaneTag := class(tag){}
ChateauTicketPlaneTag := class(tag){}
CornMazeTicketPlaneTag := class(tag){}
BunkerLootPlaneTag := class(tag){}
CastleLootPlaneTag := class(tag){}
ChateauLootPlaneTag := class(tag){}
CornMazeLootPlaneTag := class(tag){}

# for now just have to connect to the coin collectedevent as there is a bug
# with teleporting many devices
loot_device := class(creative_device):
    @editable
    GoldItemGranter: item_granter_device = item_granter_device{}

    # @editable
    # LobbyObbyGoldAccoladeDevice: accolades_device = accolades_device{}

    # @editable
    # LobbyObbyGold: []collectible_object_device = array{}

    # @editable
    # LobbyPlane: creative_prop = creative_prop{}

    @editable
    GoldAccoladeDevice: accolades_device = accolades_device{}

    # @editable
    # HiddenRoomAccoladeDevice: accolades_device = accolades_device{}

    @editable
    GoldItemGranter100: item_granter_device = item_granter_device{}

    @editable
    GoldItemGranter10: item_granter_device = item_granter_device{}

    @editable
    GoldItemGranter1k: item_granter_device = item_granter_device{}

    @editable
    GoldItemGranter10k: item_granter_device = item_granter_device{}

    @editable
    CoinSound: audio_player_device = audio_player_device{}

    @editable
    BunkerTickets: []collectible_object_device = array{}

    @editable
    CastleTickets: []collectible_object_device = array{}

    @editable
    ChateauTickets: []collectible_object_device = array{}

    @editable
    CornMazeTickets: []collectible_object_device = array{}

    @editable
    BunkerLoot: []collectible_object_device = array{}

    @editable
    BunkerRareLoot: []collectible_object_device = array{}

    PlayerStatsManager: player_stats_manager = player_stats_manager{}
    # var PlanesInWorld: []creative_prop = array{}

    # SFC32Instance: SFC32 = SFC32{}

    var Denominations: [int]item_granter_device = map{}

    OnBegin<override>()<suspends>:void=
        for (Ticket : BunkerTickets):
            Ticket.CollectedEvent.Subscribe(GrantTicketGold)

        for (Ticket : CastleTickets):
            Ticket.CollectedEvent.Subscribe(GrantTicketGold)

        for (Ticket : ChateauTickets):
            Ticket.CollectedEvent.Subscribe(GrantTicketGold)

        for (Ticket : CornMazeTickets):
            Ticket.CollectedEvent.Subscribe(GrantTicketGold)

        for (LootItem : BunkerLoot):
            LootItem.CollectedEvent.Subscribe(GrantLootGold)

        for (RareLootItem : BunkerRareLoot):
            RareLootItem.CollectedEvent.Subscribe(GrantRareLoot)

        # for (ObbyGold : LobbyObbyGold):
        #     ObbyGold.CollectedEvent.SubscribeAgent(GrantObbyGold, ObbyGold)

        # TaggedGoldCoins := FindCreativeObjectsWithTag(GoldCoinTag{})
        # TaggedLobbyGoldCoins := FindCreativeObjectsWithTag(LobbyFloorGoldTag{})
        # TaggedHiddenRoomGoldCoins := FindCreativeObjectsWithTag(HiddenRoomCoinTag{})
        # # TaggedPlanes := GetCreativeObjectsWithTag(GoldPlaneTag{})

        # # for (TaggedPlane : TaggedPlanes, Plane := creative_prop[TaggedPlane]):
        # #     set PlanesInWorld += array{Plane}

        # for (TaggedCoin : TaggedGoldCoins, Coin := collectible_object_device[TaggedCoin]):
        #     set CoinsInWorld += array{Coin}

        # for (TaggedLobbyCoin : TaggedLobbyGoldCoins, Coin := collectible_object_device[TaggedLobbyCoin]):
        #     set CoinsForLobby += array{Coin}

        # for (TaggedHiddenCoin : TaggedHiddenRoomGoldCoins, Coin := collectible_object_device[TaggedHiddenCoin]):
        #     set CoinsHidden += array{Coin}

        # for (Coin : CoinsInWorld):
        #     Coin.CollectedEvent.SubscribeAgent(GrantGold, Coin)

        # for (Coin : CoinsForLobby):
        #     Coin.CollectedEvent.SubscribeAgent(GrantGold, Coin)

        # for (Coin : CoinsHidden):
        #     Coin.CollectedEvent.SubscribeAgent(GrantHiddenGold, Coin)

        set Denominations = map{10000 => GoldItemGranter10k, 1000 => GoldItemGranter1k, 100 => GoldItemGranter100, 10 => GoldItemGranter10, 1=> GoldItemGranter}

    # MoveGoldToLobby():void=
    #     MoveGold(array{LobbyPlane}, CoinsForLobby)

    PlaceLootInMap(Map: int):void=
        PlaceTickets(Map)
        PlaceLoot(Map)

    PlaceTickets(Map: int):void=
        var TaggedTicketPlanes: generator(creative_object_interface) = FindCreativeObjectsWithTag(BunkerTicketPlaneTag{})
        var Tickets: []collectible_object_device = array{}

        case (Map):
            3 =>
                set TaggedTicketPlanes = FindCreativeObjectsWithTag(CornMazeTicketPlaneTag{})
                set Tickets = CornMazeTickets
            1 => 
                set TaggedTicketPlanes = FindCreativeObjectsWithTag(CastleTicketPlaneTag{})
                set Tickets = CastleTickets
            2 =>
                set TaggedTicketPlanes = FindCreativeObjectsWithTag(ChateauTicketPlaneTag{})
                set Tickets = ChateauTickets
            _ =>
                set TaggedTicketPlanes = FindCreativeObjectsWithTag(BunkerTicketPlaneTag{})
                set Tickets = BunkerTickets


        var TicketPlanes: []creative_prop = array{}

        for (TaggedTicketPlane : TaggedTicketPlanes, TicketPlane := creative_prop[TaggedTicketPlane]):
            set TicketPlanes += array{TicketPlane}

        # if (Seed := "{GetSecondsSinceEpoch()}", SFC32Instance.Init[Seed]):
        #     if (ShuffledArray := SFC32Instance.KnuthShuffle[TicketPlanes], set TicketPlanes = ShuffledArray) {}
        # else:
        #     set TicketPlanes = Shuffle(TicketPlanes)

        set TicketPlanes = Shuffle(TicketPlanes)
        # set Tickets = Shuffle(Tickets)

        for (Index->Ticket : Tickets):
            if (TicketPlane := TicketPlanes[Index], Ticket.TeleportTo[TicketPlane.GetTransform().Translation, Ticket.GetTransform().Rotation]) {}

    
    PlaceLoot(Map: int):void=
        var TaggedLootPlanes: generator(creative_object_interface) = FindCreativeObjectsWithTag(BunkerTicketPlaneTag{})
        var Loot: []collectible_object_device = array{}

        case (Map):
            3 =>
                set TaggedLootPlanes = FindCreativeObjectsWithTag(CornMazeLootPlaneTag{})
            1 => 
                set TaggedLootPlanes = FindCreativeObjectsWithTag(CastleLootPlaneTag{})
            2 =>
                set TaggedLootPlanes = FindCreativeObjectsWithTag(ChateauLootPlaneTag{})
            _ =>
                set TaggedLootPlanes = FindCreativeObjectsWithTag(BunkerLootPlaneTag{})
                set Loot = BunkerLoot
                set Loot += BunkerRareLoot

        var LootPlanes: []creative_prop = array{}

        for (TaggedLootPlane : TaggedLootPlanes, LootPlane := creative_prop[TaggedLootPlane]):
            set LootPlanes += array{LootPlane}

        set LootPlanes = Shuffle(LootPlanes)
        # set Loot = Shuffle(Loot)

        for (Index->LootItem : Loot):
            if (LootPlane := LootPlanes[Index], LootItem.TeleportTo[LootPlane.GetTransform().Translation, LootItem.GetTransform().Rotation]):
                Print("Placing Loot at {LootItem.GetTransform().Translation}")

    # MoveGoldToSelectedMap(MapVoteResults: int):void=
    #     case (MapVoteResults):
    #         0 =>
    #             Print("Moving Bunker Gold")
    #         1 =>
    #             Print("Moving Castle Gold")
    #         _ =>
    #             Print("Moving Chateau Gold")
    #             TaggedChateauGoldPlanes := GetCreativeObjectsWithTag(ChateauGoldPlaneTag{})
    #             ChateauGoldPlanes: []creative_prop = for (TaggedPlane : TaggedChateauGoldPlanes, GoldPlane := creative_prop[TaggedPlane]) do GoldPlane
    #             MoveGold(ChateauGoldPlanes, CoinsInWorld)
                
    # MoveGold(Planes: []creative_prop, CoinsToMove: []collectible_object_device):void=
    #     Seed := "{GetSecondsSinceEpoch()}"
        
    #     var CoinIndex: int = 0

    #     for (Plane : Planes):
    #         SizeX: float = Plane.GetTransform().Scale.X
    #         SizeY: float = Plane.GetTransform().Scale.Y

    #         AreaSize := vector3{X := SizeX * 100, Y := SizeY * 100, Z := 1.0}

    #         # translation of an object is given at the center of the object, we need to subtract half of the edge from each axis to obtain the edge of the object
    #         AreaPosition := vector3{X := Plane.GetTransform().Translation.X - (SizeX * 100) / 2.0, Y := Plane.GetTransform().Translation.Y - (SizeY * 100) / 2.0, Z := Plane.GetTransform().Translation.Z}

    #         if (SFC32Instance.Init[Seed], N := Round[SizeX * SizeY / (SFC32Instance.GetRandomInt[20, 30] * 1.0)]):
    #             Points := GeneratePoints(N-1, AreaSize, AreaPosition)
    #             for (Point : Points):
    #                 # multiplying the size by 2 is completely arbitrary. it's used just to get more variety in the offset
    #                 if (OffsetX := SFC32Instance.GetRandomFloat[-SizeX * 2, SizeX * 2], OffsetY := SFC32Instance.GetRandomFloat[-SizeY * 2, SizeY * 2]):
    #                     OffsetPoint: vector3 = vector3{X := Point.X + OffsetX, Y := Point.Y + OffsetY, Z := Point.Z + 40.0}
    #                     if (Coin := CoinsToMove[CoinIndex]):
    #                         spawn:
    #                             TeleportCoin(Coin, OffsetPoint, Coin.GetTransform().Rotation)
    #                         set CoinIndex += 1

    #     Print("Coins deployed: {CoinIndex}")

    # ResetGold():void=
    #     DefaultLocation: vector3 = vector3{X := -3712.0, Y := -44533.0, Z := 245.0}

    #     for (Coin : CoinsInWorld):
    #         spawn:
    #             TeleportCoin(Coin, DefaultLocation, Coin.GetTransform().Rotation)

    #     for (Coin : CoinsForLobby):
    #         spawn:
    #             TeleportCoin(Coin, DefaultLocation, Coin.GetTransform().Rotation)

    # TeleportCoin(Coin: collectible_object_device, Location: vector3, Rotation: rotation)<suspends>:void=
    #     Coin.MoveTo(Location, Rotation, 0.0001)

    GrantTicketGold(Agent: agent):void=
        GoldItemGranter10.GrantItem(Agent)
        GoldAccoladeDevice.Award(Agent)
        CoinSound.Play(Agent)
        AddGoldToStats(Agent, ?Amount := 10)

    GrantLootGold(Agent: agent):void=
        for (I := 0..4):
            GoldItemGranter.GrantItem(Agent)
        GoldAccoladeDevice.Award(Agent)
        CoinSound.Play(Agent)
        AddGoldToStats(Agent, ?Amount := 5)

    GrantRareLoot(Agent: agent):void=
        for (I := 0..1):
            GoldItemGranter10.GrantItem(Agent)
        GoldAccoladeDevice.Award(Agent)
        CoinSound.Play(Agent)
        AddGoldToStats(Agent, ?Amount := 20)

    # GrantGold(Agent: agent, Coin: collectible_object_device):void=
    #     GoldItemGranter.GrantItem(Agent)
    #     GoldAccoladeDevice.Award(Agent)
    #     CoinSound.Play(Agent)
    #     AddGoldToStats(Agent, ?Amount := 1)
    #     spawn:
    #         RespawnGold(Coin)

    # GrantHiddenGold(Agent: agent, Coin: collectible_object_device):void=
    #     HiddenRoomItemGranter.GrantItem(Agent)
    #     HiddenRoomAccoladeDevice.Award(Agent)
    #     AddGoldToStats(Agent, ?Amount := 100)
    #     CoinSound.Play(Agent)
        
    # GrantObbyGold(Agent: agent, Coin: collectible_object_device):void=
    #     GoldItemGranter.GrantItem(Agent)
    #     LobbyObbyGoldAccoladeDevice.Award(Agent)
    #     AddGoldToStats(Agent, ?Amount := 1)
    #     CoinSound.Play(Agent)
    #     spawn:
    #         RespawnGold(Coin)

    # RespawnGold(Coin: collectible_object_device)<suspends>:void=
    #     Sleep(30.0)
    #     Coin.RespawnForAll()
    
    AddGoldToStats(Agent: agent, ?Amount: int):void=
        if:
            CurrentPlayerStats := PlayerStatsManager.GetPlayerStats[Agent]
            CurrentGold := CurrentPlayerStats.GoldCount.CurrentValue
        then:
            PlayerStatsManager.RecordPlayerStat(Agent, "Gold", ?Amount := CurrentGold + Amount)

    AddGoldToPlayer(Agent: agent):void=
        if:
            CurrentPlayerStats := PlayerStatsManager.GetPlayerStats[Agent]
            CurrentGold := CurrentPlayerStats.GoldCount.CurrentValue
        then:
            spawn:
                GrantPlayerInventoryGold(Agent, CurrentGold)
        
    GrantPlayerInventoryGold(Agent: agent, GoldToGrant: int)<suspends>:void=
        var TotalGold: int = GoldToGrant

        for (Denomination->Granter : Denominations):
            loop:
                Sleep(0.1)
                if (TotalGold < Denomination):
                    break
                
                Granter.GrantItem(Agent)
                set TotalGold -= Denomination