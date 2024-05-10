using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }


HaltonSequenceDevice := class(creative_device):

    
    GenerateSequence(count: int, base: int):[]float=
        var factor: int = 1
        var result: int  = 0
        
        var halton_sequence: []float = for (i := 0..count) do 0.0

        for (i := 0..count):
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