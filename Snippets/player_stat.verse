using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

player_stat := class<final><persistable>:
    CurrentValue: int = 0
    HighestValue: int = 0


    SetHighestValue(NewValue: int)<transacts>:int=
        if:
            NewValue > HighestValue
        then:
            NewValue
        else:
            HighestValue


MakeUpdatedPlayerStat<constructor>(OldStats: player_stat, NewValue: int)<transacts>:=player_stat:
    CurrentValue := NewValue
    HighestValue := OldStats.SetHighestValue(NewValue)