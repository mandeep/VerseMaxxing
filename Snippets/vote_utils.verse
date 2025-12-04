# using { /Fortnite.com/UI }
# using { /Verse.org/Assets }
# using { /Verse.org/Colors/NamedColors }
# using { /UnrealEngine.com/Temporary/SpatialMath }
# using { /UnrealEngine.com/Temporary/UI }


# VoteUtils<public> := module:
#     map_candidate<public> := class<concrete>:
#         var MapTexture<public>: texture = DefaultMapTexture 
#         var MapName<public>: string = ""
#         var Selection<public>: widget = texture_block{DefaultImage := MapBorderImage, DefaultDesiredSize:=vector2{X:=465.0, Y:=565.0}}
#         var ID<public>: int = 0
    
#         CreateMapUI<public>(VoteButton: button_regular, VoteCounter: text_block):overlay=
#             MapStackBox := stack_box:
#                 Orientation := orientation.Vertical
#                 Slots := array:
#                     stack_box_slot:
#                         Widget := texture_block:
#                             DefaultImage := MapTexture
#                             DefaultDesiredSize := vector2{X := 400.0, Y := 400.0}
#                         HorizontalAlignment := horizontal_alignment.Center
#                         VerticalAlignment := vertical_alignment.Center
#                         Padding := margin{Top := 20.0, Bottom := 20.0}
#                     stack_box_slot:
#                         Widget := VoteButton
#                         HorizontalAlignment := horizontal_alignment.Center
#                         VerticalAlignment := vertical_alignment.Center
#                         Padding := margin{Left := 10.0, Right := 10.0}
                
#             MapOverlay := overlay:
#                 Slots := array:
#                     overlay_slot:
#                         Widget := Selection
#                         HorizontalAlignment := horizontal_alignment.Center
#                         VerticalAlignment := vertical_alignment.Center
#                     overlay_slot:
#                         Widget := color_block:
#                             DefaultColor := LightGray
#                             DefaultDesiredSize:=vector2{X := 460.0, Y := 560.0}
#                             DefaultOpacity := 0.25
#                         HorizontalAlignment := horizontal_alignment.Center
#                         VerticalAlignment := vertical_alignment.Center
#                     overlay_slot:
#                         Widget := VoteCounter
#                         HorizontalAlignment := horizontal_alignment.Right
#                         VerticalAlignment := vertical_alignment.Top
#                         Padding := margin{Top := 5.0, Right := 10.0}
#                     overlay_slot:
#                         Widget := MapStackBox
        
#             MapOverlay

#     vote_info<public> := class:
#         var Vote<public>: int = -1
#         var Buttons<public>: []text_button_base = array{}
#         var Counters<public>: []text_block = array{}
#         var Canvas<public>: canvas = canvas{}