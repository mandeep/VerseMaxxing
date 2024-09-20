using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


# This device can be used to randomly generate points for the
# placement of objects within the scene.
#
# References:
# Halton, John H. "Algorithm 247: Radical-inverse quasi-random point sequence." Communications of the ACM 7.12 (1964): 701-702.
# Owen, Art B. "A randomized Halton algorithm in R." arXiv preprint arXiv:1706.02808 (2017).
# Halton sequence: https://en.wikipedia.org/wiki/Halton_sequence
HaltonSequencer<public> := module:

    # Generate n numbers of random points
    #
    # Example: GenerateSequence(10, 2) generates the following 10
    # pseudo-random points: [0.5, 0.25, 0.75, 0.125, 0.625, 0.375, 0.875, 0.0625, 0.5625, 0.3125]
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
                if (set Index = Floor(Factor / Base)):
                    loop:
                        if (Difference > Index):
                            break

                        if (set Index = Floor(Index / Base)) {}

                    set Result = (Base + 1) * Index - Difference
                    
            Sample: float = (Result * 1.0) / (Factor * 1.0)
            
            if (set HaltonSequence[I] = Sample) {}
        
        HaltonSequence

    # Use the Halton Sequence generator to generate random points within a certain area at position
    #
    # n is the number of samples to generate
    # area is the size of the area to generate points within. This can be 2D or 3D
    # position is the position in world space to put the points
    # all_axes determines whether the points are generated for 2D or 3D. Default is 2D
    #
    # Example:
    # points: []vector3 = GeneratePoints(3, vector3{X := 3.0, Y := 3.0, Z := 3.0}, vector3{X := 100.0, Y := 50.0, Z := 300.0})
    # Here, points is an array of vector3, however the points were generated in 2D. Thus, the Z position will be 300.0
    # The output of the points array will be [vector3(101.5, 51.0, 300.0), vector3(100.75, 52.0, 300.0), vector3(102.25, 50.33, 300.00)]
    #
    GeneratePoints<public>(N: int, Area: vector3, Position: vector3, ?AllAxes: logic = false):[]vector3=
        # generate random points for the xy plane using the first 2 primes as bases
        X_RandomPoints: []float = GenerateSequence(N, 2)
        Y_RandomPoints: []float = GenerateSequence(N, 3)

        var X_Points: []float = for (i := 0..N) do 0.0
        var Y_Points: []float = for (i := 0..N) do 0.0

        var GeneratedPoints: []vector3 = for (i := 0..N) do vector3{X := 0.0, Y := 0.0, Z := 0.0}

        for (i := 0..N):
            if (X_Position := set X_Points[i] = Position.X + X_RandomPoints[i] * Area.X) {
                if (set GeneratedPoints[i].X = X_Position) {}
            }

            if (Y_Position := set Y_Points[i] = Position.Y + Y_RandomPoints[i] * Area.Y) {
                if (set GeneratedPoints[i].Y = Y_Position) {}
            }

            if (set GeneratedPoints[i].Z = Position.Z) {}

        if (AllAxes?):
            # generate random points for the coordinate plane using the next available prime
            Z_RandomPoints: []float = GenerateSequence(N, 5)
            var Z_Points: []float = for (i := 0..N) do 0.0

            for (i := 0..N):
                if (Z_Position := set Z_Points[i] = Position.Z + Z_RandomPoints[i] * Area.Z) {
                    if (set GeneratedPoints[i].Z = Z_Position) {}
                }

        GeneratedPoints