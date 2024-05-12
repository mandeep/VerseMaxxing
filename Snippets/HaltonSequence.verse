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
#
HaltonSequenceDevice := class(creative_device):

    # Generate n numbers of random points in base b
    #
    # Example: GenerateSequence(10, 2) generates the following 10
    # pseudo-random points: [0.5, 0.25, 0.75, 0.125, 0.625, 0.375, 0.875, 0.0625, 0.5625, 0.3125]
    #
    GenerateSequence(n: int, base: int):[]float=
        var factor: int = 1
        var result: int  = 0
        
        var halton_sequence: []float = for (i := 0..n) do 0.0

        for (i := 0..n):
            difference: int = factor - result

            if (difference = 1):
                set result = 1
                set factor *= base
            
            else:
                var index: int = 0
                if (set index = Floor(factor / base)):
                    loop:
                        if (difference > index):
                            break

                        if (set index = Floor(index / base)) {}

                    set result = (base + 1) * index - difference
                    
            sample: float = (result * 1.0) / (factor * 1.0)
            
            if (set halton_sequence[i] = sample) {}
        
        halton_sequence

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
    GeneratePoints(n: int, area: vector3, position: vector3, ?all_axes: logic = false):[]vector3=
        # generate random points for the xy plane using the first 2 primes as bases
        x_random_points: []float = GenerateSequence(n, 2)
        y_random_points: []float = GenerateSequence(n, 3)

        var x_points: []float = for (i := 0..n) do 0.0
        var y_points: []float = for (i := 0..n) do 0.0

        var generated_points: []vector3 = for (i := 0..n) do vector3{X := 0.0, Y := 0.0, Z := 0.0}

        for (i := 0..n):
            if (x_position := set x_points[i] = position.X + x_random_points[i] * area.X) {
                if (set generated_points[i].X = x_position) {}
            }

            if (y_position := set y_points[i] = position.Y + y_random_points[i] * area.Y) {
                if (set generated_points[i].Y = y_position) {}
            }

            if (set generated_points[i].Z = position.Z) {}

        if (all_axes?):
            # generate random points for the coordinate plane using the next available prime
            z_random_points: []float = GenerateSequence(n, 5)
            var z_points: []float = for (i := 0..n) do 0.0

            for (i := 0..n):
                if (z_position := set z_points[i] = position.Z + z_random_points[i] * area.Z) {
                    if (set generated_points[i].Z = z_position) {}
                }

        generated_points