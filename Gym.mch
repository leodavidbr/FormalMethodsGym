// TODO: Refinar as funções, pois todas estão como parciais
// TODO: Analisar clientHasSolicitation, se deve ser feito com SOLICITATION ou de outra forma
// TODO: Adicionar as invariantes

// COMENTARIO:Nao precisa remover os conjuntos, so nao pode ter dados abstratos na interface das operacoes


MACHINE
    Gym
    
CONSTANTS

    CLIENT,
    WORKOUT,
    EXERCISE, 
    CATEGORY,
    SOLICITATION,
    DAY,
    
    maxClients,
    maxWorkouts,
    maxExercises,
    
    maxExercisesInWorkout,
    maxWorkoutsInHistory,
    exactNumClientWorkouts,
    PUSH, PULL, LEGS,
    YES, NO,
    SUN,MON,TUE,WED,THR,FRI,SAT,
    
    //novos
    sets,
    repetitions,
    maxSets,
    maxRepetitions
    
    
PROPERTIES
    maxClients = 100
    & maxWorkouts = 15
    & maxExercises = 30

    //novos
    & maxSets = 4
    & maxRepetitions = 20
    & sets <: NAT1
    & repetitions <: NAT1

    & maxExercisesInWorkout = 7
    & maxWorkoutsInHistory = 40
    & exactNumClientWorkouts = 3
    
    & CLIENT <: NAT
    & WORKOUT <: NAT
    & EXERCISE <: NAT
    & CATEGORY <: 0..2
    & SOLICITATION <: NAT
    & DAY <: NAT
    
    & PUSH = 0 & PULL = 1 & LEGS =2
    & NO = 0 & YES = 1
    & SUN=0 & MON=1 & TUE=2 & WED=3 & THR=4 & FRI=5 & SAT=6

    & CATEGORY = {PUSH, PULL, LEGS}
    & SOLICITATION = {YES, NO}
    & DAY = {SUN,MON,TUE,WED,THR,FRI,SAT}
    
VARIABLES
    clients, workouts, exercises
    
    , clientHasWorkout,
    clientWorkedOut,
    workoutHasExercise,
    exerciseHasCategory,
    clientHasSolicitation,
    workoutHasCategory,
    //novo
    workoutHasSets,
    workoutHasRepetitions

INVARIANT
    clients <: CLIENT 
    & workouts <: WORKOUT
    & exercises <: EXERCISE
    
    & clientHasWorkout : clients <-> workouts
    & clientWorkedOut : clients +-> WORKOUT
    & workoutHasExercise : workouts <-> exercises
    & exerciseHasCategory : exercises --> CATEGORY
    & clientHasSolicitation : clients --> SOLICITATION
    & workoutHasCategory : workouts --> CATEGORY
    
    //novo
    & workoutHasSets : workouts <-> sets
    & workoutHasRepetitions : workouts <-> repetitions
    
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
    
    //novo
    & card(workoutHasSets) <= maxSets
    & card(workoutHasRepetitions) <= maxRepetitions
    
INITIALISATION
    clients := {}
    || workouts := {}
    || exercises := {}    
    
    || clientHasWorkout := {}
    || clientWorkedOut := {}
    || workoutHasExercise := {}
    || exerciseHasCategory := {}
    || clientHasSolicitation := {}
    || workoutHasCategory := {}
    
    //novo
    || workoutHasSets := {}
    || workoutHasRepetitions := {}
OPERATIONS 
          
        addClient(client) =
        PRE client : CLIENT
            & clients : FIN(clients)
            & client /: clients
            & card(clients) < maxClients
        THEN clients := clients \/ {client}
            || clientHasSolicitation  := clientHasSolicitation \/ {client |-> YES}
        END;
        
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients := clients - {client}
            || clientHasSolicitation := {client} <<| clientHasSolicitation
            || clientHasWorkout := {client} <<| clientHasWorkout
            || clientWorkedOut := {client} <<| clientWorkedOut
        END;
        
        // TODO: workout has category
        //TODO: add sets and reps here
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
            & exercises : FIN(exercises)
            & exercise /: exercises
            & card(exercises) < maxExercises
        THEN exercises := exercises \/ {exercise}
            || exerciseHasCategory := exerciseHasCategory \/ {exercise|-> category}
        END;
        
        removeExercise(exercise) =
        PRE exercise : EXERCISE
            & exercise : exercises
            & exercise /: ran(workoutHasExercise)
        THEN
            exercises := exercises - {exercise}
            || exerciseHasCategory := {exercise} <<| exerciseHasCategory
        END;
        
        
        //desenvolvendo
        workoutLog <-- getWorkoutLog(client) =
        PRE client : CLIENT
            & client : clients
            & client : dom(clientWorkedOut)         
//            & workoutLog <: workouts
        THEN
            workoutLog := clientWorkedOut(client)
        END;
        
        
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & clientHasSolicitation(client) = NO
        THEN clientHasSolicitation(client) := YES
        END;
        
        //alterada, adicionada pre condição
        // adicionar segunda clausula no invariante?
        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations =
        PRE clientsWithSolicitation <: clients 
            & clientHasSolicitation : dom(clientHasSolicitation) +-> ran(clientHasSolicitation) 
        THEN 
        clientsWithSolicitation := {cc | cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = YES}
        END; 
        
        // TODO: Add complexity of the workout history size limit
        defineClientWorkouts(client, workoutPush, workoutPull, workoutLeg) =
        PRE client : CLIENT & client : clients 
            & clientHasSolicitation(client) = YES
            & workoutPush : WORKOUT & workoutPull : WORKOUT & workoutLeg : WORKOUT
            & workoutPush : workouts & workoutHasCategory[{workoutPush}] = {PUSH}
            & workoutPull : workouts & workoutHasCategory[{workoutPull}] = {PULL}
            & workoutLeg : workouts & workoutHasCategory[{workoutLeg}] = {LEGS}
        THEN clientHasWorkout := ({client} <<| clientHasWorkout) \/ {client |-> workoutPush, client |-> workoutPull, client |-> workoutLeg}                                                                             
             || clientHasSolicitation(client) := NO
        END;
        
        // TODO: fazer a operacao
        exercisesOfTheDay <-- getExercisesOfDayOfClient(client, day) =
        PRE client : CLIENT & client : clients
            & day : DAY
            & exercisesOfTheDay : 0..maxExercisesInWorkout +-> EXERCISE
        THEN clients := {}
        END
  
END
