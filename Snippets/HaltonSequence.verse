using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }


<# 
This device can be used to randomly generate points for the
placement of objects within the scene.
#>
HaltonSequenceDevice := class(creative_device):

    
    <#
    Generate n numbers of random points

    Example: GenerateSequence(10, 2) generates the following 10
    pseudo-random points: [0.5, 0.25, 0.75, 0.125, 0.625, 0.375, 0.875, 0.0625, 0.5625, 0.3125]
    #>
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