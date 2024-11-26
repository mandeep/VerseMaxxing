using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Teams }
using { /Verse.org/Simulation }
using { /Verse.org/Concurrency }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary }



Utils<public> := module:
    # Check if all elements in an array are equal
    AllElementsEqual<public>(Array: []int)<transacts>:logic=
        if (Array.Length <= 1):
            return true

        for (i := 1..Array.Length-1):
            if (Array[i] <> Array[0]):
                return false

        true

    # Find any elements in an array that are not unique
    #
    # Returns a new array of elements that were found to be duplicates
    # Example: [0, 1, 1, 2, 2, 2] will return [1, 2]
    FindDuplicates<public>(Array: []int)<transacts>:[]int=
        if (Array.Length <= 1):
            return Array
        
        var DuplicatesMap: [int]int = map{}
        var DuplicatesArray: []int = array{}

        for (Index->Element : Array):
            if (DuplicatesMap[Element]):
                set DuplicatesArray += array{Element}
            else if (set DuplicatesMap[Element] = 1) {}

        DuplicatesArray

    # Find elements in an array that are equal in number
    #
    # Returns a new array of all indices of elements that were found to be equal
    # Example: [1, 1, 2] returns [0, 1]
    FindDuplicateIndices<public>(Array: []int)<transacts>:[]int=
        if (Array.Length <= 1):
            return array{0}

        var Duplicates: [int][]int = map{}
        
        for (Index->Element : Array):
            if (Duplicates[Element]):
                if (set Duplicates[Element] += array{Index}) {}
            else:
                if (set Duplicates[Element] = array{Index}) {}
        
        var Indices: []int = array{0}

        if (var MaxElement: int = Array[0]):
            for (Key->Value : Duplicates):
                if (Key > MaxElement):
                    set MaxElement = Key

            if (ElementIndices := Duplicates[MaxElement]):
                set Indices = ElementIndices

        Indices

    # Find the maximum element in an array
    FindMax<public>(Array: []int)<transacts>:int=
        if (var MaxElement: int = Array[0]):
            for (Element : Array):
                if (Element > MaxElement):
                    set MaxElement = Element
            
            return MaxElement

        -1

    # Convert a string to a message
    StringToMessage<public><localizes>(str: string):message=
        "{str}"

    # Convert an agent to a message
    PlayerToMessage<public><localizes>(Agent: agent):message=
        "{Agent}"

    # Given an agent and team collection, return the team number the player is on
    GetPlayerTeam<public>(Agent: agent, TeamCollection: fort_team_collection):int=
        if (AgentsTeam := TeamCollection.GetTeam[Agent]):
            TeamArray := TeamCollection.GetTeams()
            for (TeamNumber->Team : TeamArray):
                if (AgentsTeam = Team):
                    return TeamNumber + 1
    
        -1

    # Convert an array of players to an int array
    # This is useful when needing to sort an array of players
    ConvertPlayerArrayToIntArray<public>(Array: []player):[]int=
        var IntArray: []int = array{}

        for (Index->Player : Array):
            set IntArray += array{Index}
        
        IntArray

    # A comparator for sorting in ascending order
    LessThan<public>(Left: int, Right: int)<computes><decides>:void=
        Left < Right

    # A comparator for sorting in descending order
    GreaterThan<public>(Left: int, Right: int)<computes><decides>:void=
        Left > Right

    # Calculate the distance between two players
    CalculatePlayerDistance<public>(Player1: player, Player2: player):float=
        var PlayerDistance: float = 0.0

        if (FortChararacter1 := Player1.GetFortCharacter[], FortChararacter2 := Player2.GetFortCharacter[]):
            set PlayerDistance = Distance(FortChararacter1.GetTransform().Translation, FortChararacter2.GetTransform().Translation)

        PlayerDistance

    # Given a player and an array of other players, find the nearest player to the given player
    #
    # Returns the nearest player to the given player and the distance between them
    FindNearestPlayer<public>(Player: player, PlayersToCheck: []player):tuple(?player, float)=
        var NearestPlayer: ?player = false
        var NearestDistance: float = 1000000000000000000.0

        for (PlayerToCheck : PlayersToCheck):
            CalculatedDistance := CalculatePlayerDistance(Player, PlayerToCheck)
            
            if (CalculatedDistance < NearestDistance):
                set NearestDistance = CalculatedDistance
                set NearestPlayer = option{PlayerToCheck}


        (NearestPlayer, NearestDistance)

    # Sort a map of players based on the value and return a new array of the sorted players
    InsertionSort<public>(MapToSort: [player]float):[]player=
        var Keys: []player = array{}

        for (Key->Value : MapToSort):
            set Keys += array{Key}

        N: int = Keys.Length

        for (I := 1..N-1):
            if (CurrentKey := Keys[I]):
                var J: int = I - 1

                loop:
                    if (J < 0 or MapToSort[Keys[J]] <= MapToSort[CurrentKey]):
                        break
                    
                    if (KeyToSwap  := Keys[J], set Keys[J + 1] = KeyToSwap) {}

                    set J -= 1
                
                if (set Keys[J+1] = CurrentKey) {}

        Keys

    # Sort a map of players based on the value in the map and return a new map of the players in sorted order
    SortedMap<public>(MapToSort: [player]float):[player]float=
        SortedKeys: []player = InsertionSort(MapToSort)
        
        var SortedMapOutput: [player]float = map{}

        for (Key : SortedKeys):
            if (KeyToSwap := MapToSort[Key], set SortedMapOutput[Key] = KeyToSwap) {}
        

        SortedMapOutput
