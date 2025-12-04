using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /Verse.org/Simulation }


base_team := class<abstract>:
    @editable # Used to set a player to the team.
    ClassSelector: class_and_team_selector_device = class_and_team_selector_device{}

    @editable # Used to subscribe to team member (prop team) or enemy (hunter team) eliminated events.
    EliminationManager: elimination_manager_device = elimination_manager_device{}
    
     # This is an array of agents on the team.
    var TeamAgents<private>: []agent = array{}
    
    # This event is signaled when the TeamAgents array becomes empty (signaling the end of the round).
   TeamEmptyEvent: event() = event(){}

   TeamMemberEliminatedEvent: event() = event(){}

    # Returns the current TeamAgents array.
    # This is required because the TeamAgents array is private, so other classes cannot access it directly. 
    GetAgents()<decides><transacts>:[]agent=
        TeamAgents

    ClearAgents():void=
        set TeamAgents = array{}
    
    # Return the size of the TeamAgents array
    # This requires a function because the TeamAgents array is private, so other classes cannot access it directly.
    Count()<transacts>:int=
        TeamAgents.Length
    
    # Returns an index in the TeamAgents array of an agent, fails otherwise.
    FindOnTeam(Agent: agent)<decides><transacts>:int=
        Index := TeamAgents.Find[Agent]

    # Set the agent to the team and notify the player.
    InitializeAgent(Agent: agent):void=
        AddAgentToTeam(Agent)
        ClassSelector.ChangeTeam(Agent)
   
    # Add an agent to TeamAgents.
    AddAgentToTeam(AgentToAdd: agent):void=
        if (not FindOnTeam[AgentToAdd]):
            set TeamAgents += array{AgentToAdd}
    
    # When an agent leaves the match, remove them from the TeamAgents array and check for the end of the round.
    # this was a function with the suspends effect but it was removed so that concurrency isn't needed
    EliminateAgent(Agent: agent):void=
        # Sleep(0.0) # Delaying 1 game tick to ensure the player is respawned before proceeding.
        RemoveAgentFromTeam(Agent)
        TeamMemberEliminatedEvent.Signal()
    
    # Remove an agent from TeamAgents.
    # If the agent removed was the last, signal TeamEmptyEvent.
    RemoveAgentFromTeam(AgentToRemove: agent):void=
        set TeamAgents = TeamAgents.RemoveAllElements(AgentToRemove)
        if (Count() < 1):
            TeamEmptyEvent.Signal()