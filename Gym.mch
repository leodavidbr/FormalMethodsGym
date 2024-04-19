// TODO: Refinar as funções, pois todas estão como parciais
// TODO: Analisar clientHasSolicitation, se deve ser feito com SOLICITATION ou de outra forma
// TODO: Adicionar as invariantes

// COMENTARIO:Nao precisa remover os conjuntos, so nao pode ter dados abstratos na interface das operacoes


MACHINE
    Gym
    
CONSTANTS
    maxClients,
    maxWorkouts,
    maxExercises,
    
    maxExercisesInWorkout,
    maxWorkoutsInHistory,
    exactNumClientWorkouts
    
PROPERTIES
    maxClients = 100
    & maxWorkouts = 15
    & maxExercises = 30

    & maxExercisesInWorkout = 7
    & maxWorkoutsInHistory = 40
    & exactNumClientWorkouts = 3
SETS
    CLIENT; WORKOUT; EXERCISE; 
    CATEGORY = {PUSH, PULL, LEGS};
    SOLICITATION = {YES, NO};
    DAY = {SUN,MON,TUE,WED,THR,FRI,SAT}
    
    
VARIABLES
    timeInDays
    
    , clients, workouts, exercises
    
    , clientHasWorkout,
    clientWorkedOut,
    workoutHasExercise,
    exerciseHasCategory,
    clientHasSolicitation,
    workoutHasCategory

INVARIANT
    timeInDays : INTEGER
    
    & clients <: CLIENT 
    & workouts <: WORKOUT
    & exercises <: EXERCISE
    
    & clientHasWorkout : clients <-> workouts
    & clientWorkedOut : clients +-> WORKOUT
    & workoutHasExercise : workouts <-> exercises
    & exerciseHasCategory : exercises --> CATEGORY
    & clientHasSolicitation : clients --> SOLICITATION
    & workoutHasCategory : workouts --> CATEGORY
    
    // Bussines rules
    // limits
    & card(clients) <= maxClients
    & card(workouts) <= maxWorkouts
    & card(exercises) <= maxExercises
    & !clientx . (clientx : CLIENT & clientx : clients => card(clientWorkedOut[{clientx}]) < maxWorkoutsInHistory)
    // todo cliente que não tem solicitação de treino tem 3 treinos
    & !clientx . (clientx : CLIENT & clientx : clients & clientHasSolicitation(clientx) = NO => card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts)
    // todo cliente que tem solicitação de treino tem 3 ou 0 treinos
    & !clientx . (clientx : CLIENT & clientx : clients & clientHasSolicitation(clientx) = YES => card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts or card(clientHasWorkout[{clientx}]) = 0)
    // todo cliente que tem treino (sempre exatamente 3) tem um exercício de cada categoria
    & !clientx . (clientx : CLIENT & clientx : clients & card(clientHasWorkout[{clientx}]) = 3 =>  workoutHasCategory[ clientHasWorkout[{clientx}]] = CATEGORY )
    
    // 
        
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
    || workoutHasCategory := {}
    
OPERATIONS 
        
        //ok
        addClient(client) =
        PRE client : CLIENT
            & clients : FIN(clients)
            & client /: clients
            & card(clients) < maxClients
        THEN clients := clients \/ {client}
            || clientHasSolicitation  := clientHasSolicitation \/ {client |-> YES}
        END;
        
        // TODO: verificar se esta correto.
        //Por mim está ok
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients := clients - {client}
            || clientHasSolicitation := {client} <<| clientHasSolicitation
            || clientHasWorkout := {client} <<| clientHasWorkout
            || clientWorkedOut := {client} <<| clientWorkedOut
        END;
        
        // TODO: workout has category
        addWorkout(workout, category, exercisesInWorkout) =
        PRE workout : WORKOUT & category : CATEGORY
            & workouts : FIN(workouts)
            & workout /: workouts
            & card(workouts) < maxWorkouts
            & exercisesInWorkout : 0..maxExercisesInWorkout --> exercises
//            & exPush : EXERCISE & exPull : EXERCISE & exLeg : EXERCISE
//            & exPush : exercises & exerciseHasCategory[{exPush}] = {PUSH}
        THEN workouts := workouts \/ {workout}
            || workoutHasCategory(workout) := category
            || workoutHasExercise := workoutHasExercise \/ {workout}*ran(exercisesInWorkout)
//            || workoutHasExercise := workoutHasExercise 
//                                        \/ {workout |-> exPush, workout |-> exPull, workout |-> exLeg}
        END;
        
        // verificar se esta correto (pois a prova nao foi automaticamente)
        //para mim está coerente
        //nao ficou claro se o treino deve ser removido do histórico do cliente
        removeWorkout(workout) =
        PRE workout : WORKOUT & workout : workouts
        THEN workouts := workouts - {workout}
            || clientHasWorkout := clientHasWorkout |>> {workout}
            || clientHasSolicitation := clientHasSolicitation \/ clientHasWorkout~[{workout}]*{YES}
            || workoutHasExercise := {workout} <<| workoutHasExercise
        END;
        
        //ok
        addExercise(exercise, category) =
        PRE exercise : EXERCISE
            & category : CATEGORY
            & exercises : FIN(exercises)
            & exercise /: exercises
            & card(exercises) < maxExercises
        THEN exercises := exercises \/ {exercise}
            || exerciseHasCategory := exerciseHasCategory \/ {exercise|-> category}
        END;
        
        //so pode remover um exercicio que nao possui nenhum treino atrelado
        //verificar operação pois não foi feita a prova automatica
        removeExercise(exercise) =
        PRE exercise : EXERCISE
            & exercise : exercises
            & exercise /: ran(workoutHasExercise)
        THEN
            exercises := exercises - {exercise}
            || exerciseHasCategory := {exercise} <<| exerciseHasCategory
        END;
        
        // TODO: tipar workoutLog?
        //esta errado, clientHasWorkoout deve ser manipulado
        workoutLog <-- getWorkoutLog(client) =
        PRE client : CLIENT
            & client : clients
            & client : dom(clientHasWorkout)
//            & workoutLog <: WORKOUT
        THEN
            workoutLog := clientHasWorkout(client)
        END;
        
        
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & clientHasSolicitation(client) = NO
        THEN clientHasSolicitation(client) := YES
        END;
        
        // validar
        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        clientsWithSolicitation := {cc | cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = YES};
        
        // TODO: Add complexity of the workout history size limit
        defineClientWorkouts(client, workoutPush, workoutPull, workoutLeg) =
        PRE client : CLIENT & client : clients 
            & clientHasSolicitation(client) = YES
            & workoutPush : WORKOUT & workoutPull : WORKOUT & workoutLeg : WORKOUT
            & workoutPush : workouts & workoutHasCategory[{workoutPush}] = {PUSH}
            & workoutPull : workouts & workoutHasCategory[{workoutPull}] = {PULL}
            & workoutLeg : workouts & workoutHasCategory[{workoutLeg}] = {LEGS}
        THEN clientHasWorkout := ({client} <<| clientHasWorkout) \/ {client |-> workoutPush, client |-> workoutPull, client |-> workoutLeg} ||
             clientHasSolicitation(client) := NO
        END;
        
        // TODO: fazer a operacao
        exercisesOfTheDay <-- getExercisesOfDayOfClient(client, day) =
        PRE client : CLIENT & client : clients
            & day : DAY
            & exercisesOfTheDay : 0..maxExercisesInWorkout +-> EXERCISE
        THEN clients := {}
        END
        
        
        
//        // fazer a operação
//        goToNextDay = clients := {}
        
END