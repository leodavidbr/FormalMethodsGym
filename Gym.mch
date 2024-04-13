// TODO: Refinar as funções, pois todas estão como parciais
// TODO: Analisar clientHasSolicitation, se deve ser feito com SOLICITATION ou de outra forma
// COMENTARIO:Nao precisa remover os conjuntos, so nao pode ter dados abstratos na interface das operacoes
// TESTE

MACHINE
    Gym

SETS
    CLIENT; WORKOUT; EXERCISE; 
    CATEGORY = {PUSH, PULL, LEGS}; 
    SOLICITATION = {YES, NO}
    
VARIABLES
    timeInDays
    
    , clients, workouts, exercises
    
    , clientHasWorkout,
    clientWorkedOut,
    workoutHasExercise,
    exerciseHasCategory,
    clientHasSolicitation

INVARIANT
    timeInDays : INTEGER
    
    & clients <: CLIENT 
    & workouts <: WORKOUT
    & exercises <: EXERCISE
    
    & clientHasWorkout : clients +-> WORKOUT
    & clientWorkedOut : clients +-> WORKOUT
    & workoutHasExercise : WORKOUT <-> EXERCISE // TODO: verificar com Marcel se pode (acredito que sim)
    & exerciseHasCategory : exercises --> CATEGORY
    & clientHasSolicitation : clients --> SOLICITATION
    
INITIALISATION
    timeInDays := 0
    
    || clients := {}
    || workouts := {}
    || exercises := {}    
    
    || clientHasWorkout := {}
    || clientWorkedOut := {}
    || workoutHasExercise := {}
    || exerciseHasCategory := {}
    || clientHasSolicitation := {}
    
OPERATIONS 
       // fazer a operação
        addClient(client) =
        PRE client : CLIENT
            & client /: clients
        THEN clients := clients \/ {client}
            || clientHasSolicitation  := clientHasSolicitation \/ {client |-> YES}
        END;
        
        // fazer a operação
        removeClient(client) =
        PRE client : CLIENT
        THEN clients := {}
        END;
        
        // fazer a operação
        addWorkout(workout, exPush, exPull, exLeg) =
        PRE workout : WORKOUT
            & exPush : EXERCISE & exPull : EXERCISE & exLeg : EXERCISE
            & exPush : exercises & exerciseHasCategory[{exPush}] = {PUSH}
            & exPull : exercises & exerciseHasCategory[{exPull}] = {PULL}
            & exLeg : exercises & exerciseHasCategory[{exLeg}] = {LEGS}
        THEN workouts := {}
        END;
        
        // fazer a operação
        removeWorkout(workout) =
        PRE workout : WORKOUT
        THEN workouts := {}
        END;
        
        // fazer a operação
        addExercise(exercise, category) =
        PRE exercise : EXERCISE
            & category : CATEGORY
            & exercise /: exercises
        THEN exercises := exercises \/ {exercise}
            || exerciseHasCategory := exerciseHasCategory \/ {exercise|-> category}
        END;
        
        // fazer a operação
        removeExercise(exercise) =
        PRE exercise : EXERCISE
        THEN exercises := {}
        END;
        
        // TODO tipar workoutLog
        workoutLog <-- getWorkoutLog(client) =
        PRE client : CLIENT & workoutLog : CLIENT
        THEN clients := {}
        END;
        
        // fazer a operação
        askForWorkout(client) = 
        PRE client : CLIENT
        THEN clients := {}
        END;
        
        // fazer a operação
        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        PRE clientsWithSolicitation <: CLIENT
        THEN clients := {}
        END;
        
        // fazer a operação
        defineClientWorkout(client) =
        PRE client : CLIENT
        THEN clients := {}
        END;
        
        // fazer a operação
        goToNextDay = clients := {}
        
END
