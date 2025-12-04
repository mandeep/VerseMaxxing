using { /Verse.org/Concurrency }
using { /UnrealEngine.com/Temporary/Diagnostics }


# from Mayapple on the FN Create discord
CancelableTask<public> := module:
    no_rollback_cancelable<public> := interface:
        Cancel<public>():void

    cancelable_task_base<internal> := class<abstract>:
        Task<internal>:task(void)
        CancelEvent<internal>:event()

    cancelable_task<public> := class(cancelable_task_base, no_rollback_cancelable):
        Cancel<override>():void=
            CancelEvent.Signal()

        Get<public>()<transacts>:task(void) = Task

    CancelableFunction<internal>(Function:type{_()<suspends>:any}, CancelEvent:event())<suspends>:void=
        race:
            Function()
            CancelEvent.Await()

    CancelableSpawn<public>(Function:type{_()<suspends>:any}):cancelable_task=
        CancelEvent := event(){}
        Task:task(void) = spawn{CancelableFunction(Function, CancelEvent)}

        cancelable_task{Task := Task, CancelEvent := CancelEvent}