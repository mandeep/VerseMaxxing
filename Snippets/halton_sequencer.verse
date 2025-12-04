using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


HaltonSequencer<public> := module:
    GenerateSequence<public>(N: int, Base: int):[]float=
        var Factor: int = 1
        var Result: int  = 0
        
        var HaltonSequence: []float = for (I := 0..N) do 0.0

        for (I := 0..N):
            Difference: int = Factor - Result

            if (Difference = 1):
                set Result = 1
                set Factor *= Base
            
            else:
                var Index: int = 0
                if (FloorQuotient := Floor(Factor / Base), set Index = FloorQuotient):
                    loop:
                        if (Difference > Index):
                            break

                        set Index = FloorQuotient

                    set Result = (Base + 1) * Index - Difference
                    
            Sample: float = (Result * 1.0) / (Factor * 1.0)
            
            if (set HaltonSequence[I] = Sample) {}
        
        HaltonSequence

    GeneratePoints<public>(N: int, Area: vector3, Position: vector3, ?AllAxes: logic = false):[]vector3=
        # generate random points for the xy plane using the first 2 primes as bases
        X_RandomPoints: []float = GenerateSequence(N, 2)
        Y_RandomPoints: []float = GenerateSequence(N, 3)

        var X_Points: []float = for (i := 0..N) do 0.0
        var Y_Points: []float = for (i := 0..N) do 0.0

        var GeneratedPoints: []vector3 = for (i := 0..N) do vector3{X := 0.0, Y := 0.0, Z := 0.0}

        for (i := 0..N):
            if (X_Position := Position.X + X_RandomPoints[i] * Area.X, set X_Points[i] = X_Position) {
                if (set GeneratedPoints[i].X = X_Position) {}
            }

            if (Y_Position := Position.Y + Y_RandomPoints[i] * Area.Y, set Y_Points[i] = Y_Position) {
                if (set GeneratedPoints[i].Y = Y_Position) {}
            }

            if (set GeneratedPoints[i].Z = Position.Z) {}

        if (AllAxes?):
            # generate random points for the coordinate plane using the next available prime
            Z_RandomPoints: []float = GenerateSequence(N, 5)
            var Z_Points: []float = for (i := 0..N) do 0.0

            for (i := 0..N):
                if (Z_Position :=  Position.Z + Z_RandomPoints[i] * Area.Z, set Z_Points[i] = Z_Position) {
                    if (set GeneratedPoints[i].Z = Z_Position) {}
                }

        GeneratedPoints