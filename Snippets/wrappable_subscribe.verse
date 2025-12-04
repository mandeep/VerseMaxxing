using { /Verse.org/Simulation }


WrappableSubscribe<public> := module:
    (Listenable : listenable(agent)).SubscribeAgent<public>(OutputFunc : tuple(agent, t)->void, ExtraData : t where t:type):cancelable=
        Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
        Listenable.Subscribe(Wrapper.InputFunc)

    wrapper_agent(t : type) := class():
        ExtraData : t;
        OutputFunc : tuple(agent, t) -> void
        InputFunc(Agent : agent):void = OutputFunc(Agent, ExtraData)

    (Listenable : listenable(tuple())).SubscribeEmpty<public>(OutputFunc : t -> void, ExtraData : t where t:type):cancelable=
        Wrapper := wrapper_empty(t) {ExtraData := ExtraData, OutputFunc := OutputFunc}
        Listenable.Subscribe(Wrapper.InputFunc)

    wrapper_empty(t : type) := class():
        ExtraData : t;
        OutputFunc : t -> void
        InputFunc():void = OutputFunc(ExtraData)