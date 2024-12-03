using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary }
using { Utils }


# Select a random player from the players in the game
#
# Players are weighted based on how long they've been in the current session
# The longer they've been in session without being picked, the greater
# their chance of being selected
random_player_device := class(creative_device):
    # Hashmap to store the time when a player entered the game
    var EntryTimeMap: [agent]float = map{}

    # Hashmap to store the current weight (time in game) for each player
    var WeightMap: [agent]float = map{}

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)

        for (Player : GetPlayspace().GetPlayers()):
            OnPlayerAdded(Player)

    # Add players to the EntryTimeMap when they join the session
    OnPlayerAdded(Agent: agent):void=
        EntryTime := GetSecondsSinceEpoch()
        
        if (not EntryTimeMap[Agent], set EntryTimeMap[Agent] = EntryTime) {}
        if (not WeightMap[Agent],   set WeightMap[Agent] = EntryTime) {}

    # Remove players from the maps when they leave the session
    OnPlayerRemoved(Agent: agent):void=
        var UpdatedEntryTimeMap: [agent]float = map{}

        for (Key->Value : EntryTimeMap, Key <> Agent):
            if (set UpdatedEntryTimeMap[Key] = Value) {}
        
        set EntryTimeMap = UpdatedEntryTimeMap

        var UpdatedWeightMap: [agent]float = map{}

        for (Key->Value : WeightMap, Key <> Agent):
            if (set UpdatedWeightMap[Key] = Value) {}
        
        set WeightMap = UpdatedWeightMap

    # Retrieve the sum of all the weights of the players in the session
    GetTotalWeight():float=
        var TotalWeight: float = 0.0

        for (Player->Weight : WeightMap):
            set TotalWeight += Weight

        TotalWeight

    # Update the weights of the players
    #
    # To be called after each round
    UpdateWeights():void=
        CurrentTime := GetSecondsSinceEpoch()

        for (Player->Time : EntryTimeMap):
            if (EntryTime := EntryTimeMap[Player], set WeightMap[Player] = CurrentTime - EntryTime) {}

    # Reset the weight of the selected player
    #
    # Resetting the weight of the selected player insures that this player
    # has a lower probability of being picked in the next round 
    ResetWeight(Agent: agent):void=
        var CurrentTotalWeight: float = GetTotalWeight()

        if (PlayerCurrentWeight := WeightMap[Agent]):
            set CurrentTotalWeight -= PlayerCurrentWeight

        TargetPercentage: float = 0.05
        NewWeight: float = (CurrentTotalWeight * TargetPercentage) / (1.0 - TargetPercentage)

        if (set EntryTimeMap[Agent] = GetSecondsSinceEpoch(), set WeightMap[Agent] = NewWeight):

    # Calculate the probability of being picked for all players in the session
    CalculateProbabilities():[agent]int=
        var Probabilities: [agent]int = map{}

        TotalWeight: float = GetTotalWeight()

        for (Player->Weight : WeightMap):
            if (Probability := Round[(Weight / TotalWeight) * 100.0], set Probabilities[Player] = Probability) {}
        
        Probabilities

    # Selected a random player in the session
    SelectRandomPlayer():?agent=
        TotalWeight: float = GetTotalWeight()
        RandomValue: float = GetRandomFloat(0.0, TotalWeight)

        var CumulativeWeight: float = 0.0
    
        var SelectedPlayer: ?agent = false

        for (Player->Weight : WeightMap):
            set CumulativeWeight += Weight

            if (RandomValue <= CumulativeWeight):
                return option{Player}

        SelectedPlayer

    # Select a given amount of random players
    #
    # Useful for game modes where more than one player is given a special role
    SelectMultipleRandomPlayers(Number: int):[]?agent=
        var SelectedPlayers: []?agent = array{}

        if (GetPlayspace().GetPlayers().Length = 0):
            return SelectedPlayers

        if (GetPlayspace().GetPlayers().Length <= 2):
            return array{SelectRandomPlayer()}
        loop:
            if (SelectedPlayers.Length = Number):
                break
            RandomPlayer := SelectRandomPlayer()

            if (not SelectedPlayers.Find[RandomPlayer]):
                set SelectedPlayers += array{RandomPlayer}

        SelectedPlayers
