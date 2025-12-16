SeedableRandom<public> := module:
    LeftShift(Value : int, Shift : int)<transacts><decides>:int=
        var Output : int = 0

        for (Index := 0..(31 - Shift)):
            Shifted := RightShift[Value, Index]

            Bit := Mod[Shifted, 2]

            if (Bit = 1):
                set Output += Floor[Pow(2.0, (Index + Shift) * 1.0)]

        return Output

    RightShift(Value : int, Shift : int)<transacts><decides>:int=
        return Floor[(Value * 1.0) / (Pow(2.0, Shift * 1.0))]

    XOR(A : int, B : int)<transacts><decides>:int=
        var Output : int = 0

        var ShiftedA : int = A
        var ShiftedB : int = B

        for (Index := 0..63, ShiftedA <> 0 or ShiftedB <> 0):
            BitA := Mod[ShiftedA, 2]
            BitB := Mod[ShiftedB, 2]

            if ((BitA = 1 and BitB = 0) or (BitA = 0 and BitB = 1)):
                set Output = Output + LeftShift[1, Index]

            set ShiftedA = RightShift[ShiftedA, 1]
            set ShiftedB = RightShift[ShiftedB, 1]

        return Output

    OR(A : int, B : int)<transacts><decides>:int=
        var Output : int = 0

        var ShiftedA : int = A
        var ShiftedB : int = B

        for (Index := 0..63, ShiftedA <> 0 or ShiftedB <> 0):
            BitA := Mod[ShiftedA, 2]
            BitB := Mod[ShiftedB, 2]

            if (BitA = 1 or BitB = 1):
                set Output = Output + LeftShift[1, Index]

            set ShiftedA = RightShift[ShiftedA, 1]
            set ShiftedB = RightShift[ShiftedB, 1]

        return Output

    UInt32(Value : int)<transacts><decides>:int=
        var Output : int = 0

        if (Value > 4294967295):
            for (Index := 0..31):
                Shifted := RightShift[Value, Index]

                Bit := Mod[Shifted, 2]

                if (Bit = 1):
                    set Output += LeftShift[1, Index]
        else if (Value < 0):
            for (Index := 0..31):
                Shifted := RightShift[-Value, Index]
        
                Bit := Mod[Shifted, 2]
        
                if (Bit = 0):
                    set Output += LeftShift[1, Index]
        
            set Output += 1
        else:
            set Output = Value

        return Output

    UInt16(Value : int)<transacts><decides>:int=
        var Output : int = 0

        if (Value > 65535):
            for (Index := 0..15):
                Shifted := RightShift[Value, Index]

                Bit := Mod[Shifted, 2]

                if (Bit = 1):
                    set Output += LeftShift[1, Index]
        else if (Value < 0):
            for (Index := 0..15):
                Shifted := RightShift[-Value, Index]
        
                Bit := Mod[Shifted, 2]
        
                if (Bit = 0):
                    set Output += LeftShift[1, Index]
        
            set Output += 1
        else:
            set Output = Value

        return Output

    Int32(Value : int)<transacts><decides>:int=
        var Output : int = 0

        if (Value > 2147483647):
            TopBit := Mod[RightShift[Value, 31], 2]

            set Output = -LeftShift[TopBit, 31]

            for (Index := 0..30):
                Shifted := RightShift[Value, Index]

                Bit := Mod[Shifted, 2]

                if (Bit = 1):
                    set Output += LeftShift[1, Index]
        else:
            set Output = Value

        return Output

    IMul(A : int, B : int)<transacts><decides>:int=
        CastA := UInt32[A]
        CastB := UInt32[B]

        HighA := UInt16[RightShift[CastA, 16]]
        LowA := UInt16[CastA]

        HighB := UInt16[RightShift[CastB, 16]]
        LowB := UInt16[CastB]

        return Int32[LowA * LowB + UInt32[LeftShift[HighA * LowB + LowA * HighB, 16]]]

    CharCodes : [char]int = map{
        '\t' => 9,
        '\n' => 10,
        '\r' => 13,
        ' ' => 32,
        '!' => 33,
        '"' => 34,
        '#' => 35,
        '$' => 36,
        '%' => 37,
        '&' => 38,
        '\'' => 39,
        '(' => 40,
        ')' => 41,
        '*' => 42,
        '+' => 43,
        ',' => 44,
        '-' => 45,
        '.' => 46,
        '/' => 47,
        '0' => 48,
        '1' => 49,
        '2' => 50,
        '3' => 51,
        '4' => 52,
        '5' => 53,
        '6' => 54,
        '7' => 55,
        '8' => 56,
        '9' => 57,
        ':' => 58,
        ';' => 59,
        '<' => 60,
        '=' => 61,
        '>' => 62,
        '?' => 63,
        '@' => 64,
        'A' => 65,
        'B' => 66,
        'C' => 67,
        'D' => 68,
        'E' => 69,
        'F' => 70,
        'G' => 71,
        'H' => 72,
        'I' => 73,
        'J' => 74,
        'K' => 75,
        'L' => 76,
        'M' => 77,
        'N' => 78,
        'O' => 79,
        'P' => 80,
        'Q' => 81,
        'R' => 82,
        'S' => 83,
        'T' => 84,
        'U' => 85,
        'V' => 86,
        'W' => 87,
        'X' => 88,
        'Y' => 89,
        'Z' => 90,
        '[' => 91,
        '\' => 92,
        ']' => 93,
        '^' => 94,
        '_' => 95,
        '`' => 96,
        'a' => 97,
        'b' => 98,
        'c' => 99,
        'd' => 100,
        'e' => 101,
        'f' => 102,
        'g' => 103,
        'h' => 104,
        'i' => 105,
        'j' => 106,
        'k' => 107,
        'l' => 108,
        'm' => 109,
        'n' => 110,
        'o' => 111,
        'p' => 112,
        'q' => 113,
        'r' => 114,
        's' => 115,
        't' => 116,
        'u' => 117,
        'v' => 118,
        'w' => 119,
        'x' => 120,
        'y' => 121,
        'z' => 122,
        '{' => 123,
        '|' => 124,
        '}' => 125,
        '~' => 126
    }

    Murmur3Hash<public> := class:
        var H : int = 2166136261

        Init<public>(Seed : string)<transacts><decides>:void=
            set H = UInt32[2166136261]

            for (I := 0..Seed.Length - 1):
                C := CharCodes[Seed[I]]

                var K : int = IMul[C, 3432918353]
                set K = OR[LeftShift[K, 15], RightShift[UInt32[K], 17]]
                set H = XOR[H, IMul[K, 461845907]]
                set H = OR[LeftShift[H, 13], RightShift[UInt32[H], 19]]
                set H = Int32[IMul[H, 5] + 3864292196]

            set H = XOR[H, Seed.Length]

        Gen<public>()<transacts><decides>:int=
            set H = XOR[H, RightShift[UInt32[H], 16]]
            set H = IMul[H, 2246822507]
            
            set H = XOR[H, RightShift[UInt32[H], 13]]
            set H = IMul[H, 3266489909]
            
            set H = XOR[H, RightShift[UInt32[H], 16]]

            return UInt32[H]

    SFC32<public> := class:
        var A : int = 0x9E3779B9 # phi
        var B : int = 0x243F6A88 # pi
        var C : int = 0xB7E15162 # e
        var D : int = 0

        Init<public>(Seed : string)<transacts><decides>:int=
            Murmur3HashInstance := Murmur3Hash{}
            Murmur3HashInstance.Init[Seed]

            set A = Murmur3HashInstance.Gen[]
            set B = Murmur3HashInstance.Gen[]
            set C = Murmur3HashInstance.Gen[]
            set D = Murmur3HashInstance.Gen[]

        Gen<public>()<transacts><decides>:int=
            set A = UInt32[A]
            set B = UInt32[B]
            set C = UInt32[C]
            set D = UInt32[D]

            var T : int = UInt32[UInt32[A + B] + D]
            set A = XOR[B, RightShift[B, 9]]
            set B = UInt32[C + LeftShift[C, 3]]
            set C = OR[LeftShift[C, 21], RightShift[C, 11]]
            set C = UInt32[C + T]
            set D = UInt32[D + 1]

            return UInt32[T]

        GetRandomFloat<public>(Minimum : float, Maximum : float)<transacts><decides>:float=
            Random := (1.0 * Gen[]) / 4294967296.0

            return Random * (Maximum - Minimum) + Minimum

        GetRandomInt<public>(Minimum : int, Maximum : int)<transacts><decides>:int=
            return Floor[GetRandomFloat[1.0 * Minimum, 1.0 * Maximum]]

        KnuthShuffle<public>(Array: []t where t:type)<transacts><decides>:[]t=
            var ShuffledArray: []t = array{}

            for (Element : Array):
                set ShuffledArray += array{Element}

            var I: int = ShuffledArray.Length - 1

            loop:
                if (I < 1):
                    break

                if (J := GetRandomInt[0, I]):
                    if:
                        Temp := ShuffledArray[I]
                        set ShuffledArray[I] = ShuffledArray[J]
                        set ShuffledArray[J] = Temp
                
                set I -= 1

            ShuffledArray