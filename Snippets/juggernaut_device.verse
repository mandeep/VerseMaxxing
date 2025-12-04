using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


juggernaut_device := class(creative_device):
    @editable
    SwordGranter: item_granter_device = item_granter_device{}

    SetJuggernaut(Player: agent)<suspends>:void=
        if (Character := Player.GetFortCharacter[]):
            Character.SetHealth(1.0)
        
        loop:
            Sleep(0.1)

            TeamCollection := GetPlayspace().GetTeamCollection()
            Teams: []team := TeamCollection.GetTeams()

            if (not Player.GetFortCharacter[]):
                break
            
            if (not Player.GetFortCharacter[].IsActive[]):
                break

            if (JuggernautTeam := Teams[8], not TeamCollection.IsOnTeam[Player, JuggernautTeam]):
                break
            
            if (Character := Player.GetFortCharacter[], Character.IsActive[]):
                if (Character.GetHealth() >= 100.0):
                    SwordGranter.GrantItem(Player)
                    break

                Sleep(1.0)

                Character.SetHealth(Character.GetHealth() + 0.5)
