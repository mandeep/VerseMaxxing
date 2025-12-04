
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


player_stats_manager := class:
    InitializePlayer(Player: player):void=
        if (not PlayerStatsMap[Player], set PlayerStatsMap[Player] = player_stats_table{}) {}

    InitializeAllPlayers(Players: []player):void=
        for (Player : Players):
            InitializePlayer(Player)

    GetPlayerStats(Agent: agent)<decides><transacts>:player_stats_table=
        var PlayerStats: player_stats_table = player_stats_table{}
        
        if:
            Player := player[Agent]
            PlayerStatsTable := PlayerStatsMap[Player]
            set PlayerStats = MakePlayerStatsTable(PlayerStatsTable)
        
        PlayerStats

    RecordPlayerStat(Agent: agent, Stat: string, ?Amount: int = 0):void=
        if:
            Player := player[Agent]
            PlayerStatsTable := PlayerStatsMap[Player]
    
            if (Stat = "Gold"):
                GoldStat := PlayerStatsTable.GoldCount
        
                set PlayerStatsMap[Player] = player_stats_table:
                    MakePlayerStatsTable<constructor>(PlayerStatsTable)
                    # GoldCount := MakeUpdatedPlayerStat(GoldStat, Amount)