// TODO: Refinar as funções, pois todas estão como parciais
// TODO: Analisar clientHasSolicitation, se deve ser feito com SOLICITATION ou de outra forma
// TODO: Adicionar as invariantes

// COMENTARIO:Nao precisa remover os conjuntos, so nao pode ter dados abstratos na interface das operacoes


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
    & workoutHasExercise : workouts <-> exercises // TODO: verificar com Marcel se pode (acredito que sim)
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
        addClient(client) =
        PRE client : CLIENT
            & client /: clients
        THEN clients := clients \/ {client}
            || clientHasSolicitation  := clientHasSolicitation \/ {client |-> YES}
        END;
        
        // TODO: verificar se esta correto.
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients := clients - {client}
            || clientHasSolicitation := {client} <<| clientHasSolicitation
            || clientHasWorkout := {client} <<| clientHasWorkout
            || clientWorkedOut := {client} <<| clientWorkedOut
        END;
        
        // PENSAR: addWorkout pode receber exercicios ainda nao cadastrados e adiciona-los a lista de exercicios?
        addWorkout(workout, exPush, exPull, exLeg) =
        PRE workout : WORKOUT
            & workout /: workouts
            & exPush : EXERCISE & exPull : EXERCISE & exLeg : EXERCISE
            & exPush : exercises & exerciseHasCategory[{exPush}] = {PUSH}
            & exPull : exercises & exerciseHasCategory[{exPull}] = {PULL}
            & exLeg : exercises & exerciseHasCategory[{exLeg}] = {LEGS}
        THEN workouts := workouts \/ {workout}
            || workoutHasExercise := workoutHasExercise 
                                        \/ {workout |-> exPush, workout |-> exPull, workout |-> exLeg}
        END;
        
        // verificar se esta correto (pois a prova nao foi automaticamente)
        removeWorkout(workout) =
        PRE workout : WORKOUT & workout : workouts
        THEN workouts := workouts - {workout}
            || clientHasWorkout := clientHasWorkout |>> {workout}
            || clientHasSolicitation := clientHasSolicitation \/ clientHasWorkout~[{workout}]*{YES}
            || workoutHasExercise := {workout} <<| workoutHasExercise
        END;
        
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
        // fazer a operação
        workoutLog <-- getWorkoutLog(client) =
        PRE client : CLIENT & workoutLog : CLIENT
        THEN clients := {}
        END;
        
        // PENSAR: pode chamar a operacao se o cliente ja tiver solicitacao?
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
        THEN clientHasSolicitation(client) := YES
        END;
        
        // fazer a operação
        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        PRE clientsWithSolicitation <: CLIENT
        THEN clients := {}
        END;
        
        // VERIFICAR: se no doc define que so pode ser definido o treino se houver solicitacao? Acho que eh bom ser assim
        defineClientWorkout(client, workout) =
        PRE client : CLIENT & workout : WORKOUT
            & client : clients & workout : workouts
            & clientHasSolicitation(client) = YES
        THEN clientHasWorkout(client) := workout
        END;
        
        // fazer a operação
        goToNextDay = clients := {}
        
END
