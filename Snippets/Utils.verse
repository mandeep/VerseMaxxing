using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }



Utils<public> := module:
    All_Elements_Equal<public>(Array: []int)<transacts>:logic=
        if (Array.Length <= 1):
            return true

        for (i := 1..Array.Length-1):
            if (Array[i] <> Array[0]):
                return false

        true

    Any_Elements_Equal<public>(Array: []int)<transacts>:[]int=
        if (Array.Length <= 1):
            return Array
        
        var DuplicatesMap: [int]int = map{}
        var DuplicatesArray: []int = array{}

        for (Index->Element : Array):
            if (DuplicatesMap[Element]):
                set DuplicatesArray += array{Element}
            else if (set DuplicatesMap[Element] = 1) {}

        DuplicatesArray

    Find_Equal_Elements<public>(Array: []int)<transacts>:[]int=
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

    FindMax<public>(Array: []int)<transacts>:int=
        if (var MaxElement: int = Array[0]):
            for (Element : Array):
                if (Element > MaxElement):
                    set MaxElement = Element
            
            return MaxElement

        -1

    StringToMessage<public><localizes>(str: string):message=
        "{str}"