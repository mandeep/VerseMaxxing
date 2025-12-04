using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


player_stats_table := class<final><persistable>:
    Version: int = 1
    GoldCount: player_stat = player_stat{}


MakePlayerStatsTable<constructor>(OldTable: player_stats_table)<transacts>:=player_stats_table:
    Version := OldTable.Version
    GoldCount := OldTable.GoldCount


var PlayerStatsMap: weak_map(player, player_stats_table) = map{}