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
    
    & CLIENT <: NAT
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
    
    // limits
    & clients : FIN(clients)
    & workouts : FIN(workouts)
    & exercises : FIN(exercises)
    & card(clients) <= maxClients
    & card(workouts) <= maxWorkouts
    & card(exercises) <= maxExercises
    // todo cliente tem que ter um historico menor ou igual ao limite
    & !clientx . (clientx : CLIENT => 
        clientWorkedOut[{clientx}] : FIN(clientWorkedOut[{clientx}]) & 
        card(clientWorkedOut[{clientx}]) <= maxWorkoutsInHistory)
    // maximo de exercicios em um treino eh 7 
    & !workoutx . (workoutx : WORKOUT & workoutx : workouts => card(workoutHasExercise[{workoutx}]) <= maxExercisesInWorkout)
    // Bussines rules

    // todo cliente que não tem solicitação de treino tem 3 treinos
    & !clientx . (clientx : CLIENT & clientx : clients & (clientHasSolicitation(clientx) = NO) =>
        card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts)
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
        THEN clients, clientHasSolicitation := 
            clients \/ {client},
            clientHasSolicitation <+ {client |-> YES}
        END;
        
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients, clientHasSolicitation, clientHasWorkout, clientWorkedOut := 
            clients - {client},
            {client} <<| clientHasSolicitation,
            {client} <<| clientHasWorkout,
            {client} <<| clientWorkedOut
        END;
        
        addWorkout(workout, category, numOfExercisesInWorkout, exercisesInWorkout) =
        PRE workout : WORKOUT & category : CATEGORY & numOfExercisesInWorkout : NAT1
            & numOfExercisesInWorkout <= maxExercisesInWorkout
            & numOfExercisesInWorkout > 0
            & workouts : FIN(workouts)
            & workout /: workouts
            & card(workouts) < maxWorkouts
            & exercisesInWorkout : 0..(numOfExercisesInWorkout -1) --> EXERCISE
            & ran(exercisesInWorkout) <: exercises // todos os exs ja estao cadastrados
            & ran(exercisesInWorkout) : FIN(ran(exercisesInWorkout))
            & exercisesInWorkout : FIN(exercisesInWorkout)
            & card(ran(exercisesInWorkout)) = card(exercisesInWorkout) // nao pode ter ex repetido em exercisesInWorkout
            & card(ran(exercisesInWorkout)) =  numOfExercisesInWorkout // tamanho de exercisesInWorkout eh numOfExercisesInWorkout
            & !ex . ( ex : EXERCISE & ex : ran(exercisesInWorkout) => exerciseHasCategory(ex) = category) // todo ex em exercisesInWorkout tem a mesma categoria que o workout tera
            
        THEN workouts, workoutHasCategory, workoutHasExercise  :=
            workouts \/ {workout},
            workoutHasCategory <+ {workout |-> category},
            workoutHasExercise <+ {workout}*ran(exercisesInWorkout)
        END;
        
        
        removeWorkout(workout) =
        PRE workout : WORKOUT & workout : workouts
            & workout /: ran(clientHasWorkout)
        THEN workouts, workoutHasCategory, workoutHasExercise  := 
            workouts - {workout}, 
            {workout} <<| workoutHasCategory,
            {workout} <<| workoutHasExercise
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
            ANY log 
                    WHERE log : 0..maxWorkoutsInHistory --> WORKOUT 
                        & ran(log |>> {0}) = clientWorkedOut[{client}] 
                        & log |>> {0} : FIN(log |>> {0})
                        & card(log |>> {0}) = card(clientWorkedOut[{client}])
                        // Todos os nao zero (zero sendo um filler) devem aparecer antes dos zeros
                        & ( (dom(log |> {0}) ={}) or max(dom(log |>> {0})) < min(dom(log |> {0})) )
                    THEN workoutLog := log
                    END
        END;
        
        
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & clientHasSolicitation(client) = NO
        THEN clientHasSolicitation(client) := YES
        END;
        

        // FIX: remove duplicity
        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        PRE { cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) &
             clientHasSolicitation(cc) = YES } : FIN({ cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = YES })

        THEN 
            ANY clientsW 
              WHERE clientsW : 0..maxClients --> CLIENT
                   & ran(clientsW |>> {0}) = clientHasSolicitation~[{YES}] 
                        & clientsW |>> {0} : FIN(clientsW |>> {0})
                        & clientHasSolicitation~[{YES}] : FIN(clientHasSolicitation~[{YES}])
                        & card(clientsW |>> {0}) = card(clientHasSolicitation~[{YES}])
                        // Todos os nao zero (zero sendo um filler) devem aparecer antes dos zeros
                        & ( (dom(clientsW |> {0}) ={}) or max(dom(clientsW |>> {0})) < min(dom(clientsW |> {0})) )
              THEN clientsWithSolicitation := clientsW
              END
        END;
        
        // FIX: remove duplicity
        defineClientWorkouts(client, workoutPush, workoutPull, workoutLeg) =
        PRE client : CLIENT & client : clients 
            & clientHasSolicitation(client) = YES
            & workoutPush : WORKOUT & workoutPull : WORKOUT & workoutLeg : WORKOUT
            & workoutPush : workouts & workoutHasCategory[{workoutPush}] = {PUSH}
            & workoutPull : workouts & workoutHasCategory[{workoutPull}] = {PULL}
            & workoutLeg : workouts & workoutHasCategory[{workoutLeg}] = {LEGS}
            & workoutPush /= workoutPull & workoutPull /= workoutLeg & workoutPush /= workoutLeg  // redundante
            & clientWorkedOut \/ {client} * clientHasWorkout[{client}] : FIN(clientWorkedOut \/ {client} * clientHasWorkout[{client}])
            & card((clientWorkedOut \/ {client} * clientHasWorkout[{client}])) < maxWorkoutsInHistory

        THEN  clientHasWorkout, clientWorkedOut, clientHasSolicitation := 
clientHasWorkout <+ ({client} * {workoutPush, workoutPull, workoutLeg}), 
clientWorkedOut \/ ({client} * clientHasWorkout[{client}]),
clientHasSolicitation <+ {client |-> NO}
        END
        
END
