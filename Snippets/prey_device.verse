using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


prey_device := class(creative_device):
    # setting the health of the seeker to 100 HP means that he will be 20 HP at the 1 minute mark if we deplete at 0.33 HP / sec
    # need to account for 20 second lockup period so depletion rate will be .3076923. 
    DepletionRate: float = 0.3076923

    WeakenSeeker(Player: agent)<suspends>:void=
        if (Character := Player.GetFortCharacter[]):
            Character.SetMaxHealth(100.0)
            Character.SetHealth(100.0)
        
        loop:
            Sleep(0.1)

            TeamCollection := GetPlayspace().GetTeamCollection()
            Teams: []team := TeamCollection.GetTeams()

            if (not Player.GetFortCharacter[]):
                break
            
            if (not Player.GetFortCharacter[].IsActive[]):
                break

            if (SeekerTeam := Teams[1], not TeamCollection.IsOnTeam[Player, SeekerTeam]):
                break
            
            if (Character := Player.GetFortCharacter[], Character.IsActive[]):
                if (Character.GetHealth() <= 20.0):
                    break

                Sleep(1.0)

                Character.SetHealth(Character.GetHealth() - DepletionRate)
