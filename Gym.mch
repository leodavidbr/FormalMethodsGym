MACHINE
    Gym
    
CONSTANTS

   CLIENT,
   WORKOUT,
    EXERCISE, 
    CATEGORY,
    SOLICITATION,
    
    maxClients,
    maxWorkouts,
    maxExercises,
    
    maxExercisesInWorkout,
    maxWorkoutsInHistory,
    exactNumClientWorkouts,
    PUSH, PULL, LEGS,
    YES, NO   

PROPERTIES
    maxClients = 100
    & maxWorkouts = 15
    & maxExercises = 30

    & maxExercisesInWorkout = 7
    & maxWorkoutsInHistory = 40
    & exactNumClientWorkouts = 3
    
    & WORKOUT <: NAT
    & EXERCISE <: NAT
    & CATEGORY <: 0..2
    & SOLICITATION <: NAT
    
    
    & PUSH = 0 & PULL = 1 & LEGS =2
    & NO = 0 & YES = 1
   
    & CLIENT = {1,2,3,4,5}
    & WORKOUT = {1,2,3,4,5}
    & CATEGORY = {PUSH, PULL, LEGS}
    & SOLICITATION = {YES, NO}
    
VARIABLES
    
     clients, workouts, exercises
    
    , clientHasWorkout,
    clientWorkedOut,
    workoutHasExercise,
    exerciseHasCategory,
    clientHasSolicitation,
    workoutHasCategory

INVARIANT
    
     clients <: CLIENT 
    & workouts <: WORKOUT
    & exercises <: EXERCISE
    
    & clientHasWorkout : clients <-> workouts
    & clientWorkedOut : clients <-> WORKOUT
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
        
        addWorkout(workout, category, numOfExercisesInWorkout, exercisesInWorkout) =
        PRE workout : WORKOUT & category : CATEGORY & numOfExercisesInWorkout : NAT1
            & numOfExercisesInWorkout <= maxExercisesInWorkout
            & numOfExercisesInWorkout > 0
            
            & workouts : FIN(workouts)
            & workout /: workouts
            & card(workouts) < maxWorkouts
            & exercisesInWorkout : 0..(numOfExercisesInWorkout -1) --> EXERCISE
            & ran(exercisesInWorkout) <: exercises
            & card(ran(exercisesInWorkout)) =  numOfExercisesInWorkout
            & !ex . ( ex : EXERCISE & ex : ran(exercisesInWorkout) => exerciseHasCategory(ex) = category)
            
        THEN workouts := workouts \/ {workout}
            || workoutHasCategory(workout) := category
            || workoutHasExercise := workoutHasExercise \/ {workout}*ran(exercisesInWorkout)
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
        
        // verificar com MARCEL
        workoutLog <-- getWorkoutLog(client) =
        PRE 
             client : CLIENT
            & client : clients
            & clientWorkedOut[{client}] : FIN(clientWorkedOut[{client}])
        THEN 
            workoutLog := (0..(card(clientWorkedOut[{client}])) ) * (clientWorkedOut[{client}])

//        (0..maxWorkoutsInHistory) * (clientWorkedOut[{client}] \/ dom({0} * (0..(maxWorkoutsInHistory-card(clientWorkedOut[{client}])))))
        END;
        
        
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & clientHasSolicitation(client) = NO
        THEN clientHasSolicitation(client) := YES
        END;
        
//        // validar
//        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
//        PRE clientsWithSolicitation : 0..maxClients --> CLIENT
//        THEN clientsWithSolicitation := {cc | cc : CLIENT & cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = YES}
//        END;
        
        
        //            clientHasWorkout := ({client} <<| clientHasWorkout) \/ {client |-> workoutPush, client |-> workoutPull, client |-> workoutLeg} ||
        // TODO: Add complexity of the workout history size limit
        defineClientWorkouts(client, workoutPush, workoutPull, workoutLeg) =
        PRE client : CLIENT & client : clients 
            & clientHasSolicitation(client) = YES
            & workoutPush : WORKOUT & workoutPull : WORKOUT & workoutLeg : WORKOUT
            & workoutPush : workouts & workoutHasCategory[{workoutPush}] = {PUSH}
            & workoutPull : workouts & workoutHasCategory[{workoutPull}] = {PULL}
            & workoutLeg : workouts & workoutHasCategory[{workoutLeg}] = {LEGS}
            & workoutPush /= workoutPull & workoutPull /= workoutLeg & workoutPush /= workoutLeg 
            & clientWorkedOut \/ {client} * clientHasWorkout[{client}] : FIN(clientWorkedOut \/ {client} * clientHasWorkout[{client}])
            & card((clientWorkedOut \/ {client} * clientHasWorkout[{client}])) < maxWorkoutsInHistory
        THEN  clientHasWorkout, clientWorkedOut := clientHasWorkout <+ ({client} * {workoutPush, workoutPull, workoutLeg}), clientWorkedOut \/ ({client} * clientHasWorkout[{client}])
             || clientHasSolicitation(client) := NO
        END
        
END
