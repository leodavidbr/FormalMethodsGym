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
    YES, NO,
    
    NULL,
    ANYEXERCISE,
    ANYWORKOUT,
    
    VALID_CLIENT

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
    
    
    & PUSH = 0 & PULL = 1 & LEGS = 2
    & NO = 0 & YES = 1
   
    & CLIENT = 0..5
    & WORKOUT = 0..5
    & CATEGORY = {PUSH, PULL, LEGS}
    & SOLICITATION = {YES, NO}

    & NULL = 0
    & NULL : CLIENT & NULL : WORKOUT & NULL : EXERCISE
    & ANYEXERCISE : EXERCISE
    & ANYWORKOUT : WORKOUT
    
//    & VALID_CLIENT = CLIENT - {NULL}
    
    & VALID_CLIENT <: CLIENT
    & CLIENT = VALID_CLIENT \/ {NULL}
    & card(VALID_CLIENT) +1 = card(CLIENT) 
//    & VALID_CLIENT
VARIABLES
    
     clients, workouts, exercises
    
    , clientHasWorkout,
    clientWorkedOut,
    workoutHasExercise,
    exerciseHasCategory,
    clientHasSolicitation,
    workoutHasCategory,
    isClientNew

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
    & isClientNew : clients --> SOLICITATION
    
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

//    // todo cliente que não tem solicitação de treino tem 3 treinos
//    & !clientx . (clientx : CLIENT & clientx : clients & (clientHasSolicitation(clientx) = NO) =>
//        card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts)
//    // todo cliente que tem solicitação de treino tem 3 ou 0 treinos
//    & !clientx . (clientx : CLIENT & clientx : clients & clientHasSolicitation(clientx) = YES => card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts or card(clientHasWorkout[{clientx}]) = 0)
    
    // todo cliente nao novo tem exatamente exactNumClientWorkouts workouts
    & !clientx . (clientx : CLIENT & clientx : clients & isClientNew[{clientx}] = {NO} => card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts)
    
    // todo cliente novo tem 0 workouts
    & !clientx . (clientx : CLIENT & clientx : clients & isClientNew(clientx) = YES => card(clientHasWorkout[{clientx}]) = 0)
    
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
    || isClientNew := {}
    
OPERATIONS 
        
        addClient(client) =
        PRE client : CLIENT
            & clients : FIN(clients)
            & client /: clients
            & card(clients) < maxClients
        THEN clients, clientHasSolicitation, isClientNew := 
            clients \/ {client},
            clientHasSolicitation <+ {client |-> YES},
            isClientNew \/ {client |-> YES}
            
        END;
        
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients, clientHasSolicitation, clientHasWorkout, clientWorkedOut := 
            clients - {client},
            {client} <<| clientHasSolicitation,
            {client} <<| clientHasWorkout,
            {client} <<| clientWorkedOut
        END;
        
        // TODO: exercisesInWorkout NULL
        addWorkout(workout, category, numOfExercisesInWorkout, exercisesInWorkout) =
        PRE workout : WORKOUT & category : CATEGORY & numOfExercisesInWorkout : NAT1
            & numOfExercisesInWorkout <= maxExercisesInWorkout
            & numOfExercisesInWorkout > 0
            & workouts : FIN(workouts)
            & workout /: workouts
            & card(workouts) < maxWorkouts
            // typing exercisesInWorkout init
            & exercisesInWorkout : 0..(maxExercisesInWorkout -1) --> EXERCISE
//            & 
            & ran(exercisesInWorkout) <: exercises // todos os exs ja estao cadastrados
            & ran(exercisesInWorkout) : FIN(ran(exercisesInWorkout))
            & exercisesInWorkout : FIN(exercisesInWorkout)
            & card(ran(exercisesInWorkout)) = card(exercisesInWorkout) // nao pode ter ex repetido em exercisesInWorkout
            & card(ran(exercisesInWorkout)) =  numOfExercisesInWorkout // tamanho de exercisesInWorkout eh numOfExercisesInWorkout
            & !ex . ( ex : EXERCISE & ex : ran(exercisesInWorkout) => exerciseHasCategory(ex) = category) // todo ex em exercisesInWorkout tem a mesma categoria que o workout tera
            // typing exercisesInWorkout end
            
        THEN workouts, workoutHasCategory, workoutHasExercise  :=
            workouts \/ {workout},
            workoutHasCategory \/ {workout |-> category},
            workoutHasExercise \/ {workout}*ran(exercisesInWorkout)
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
        
        workoutLog <-- getWorkoutLog(client) =
        PRE 
             client : CLIENT
            & client : clients
            & clientWorkedOut[{client}] : FIN(clientWorkedOut[{client}])
        THEN 
            IF (clientWorkedOut[{client}] /= {}) 
            THEN
                ANY log 
                        WHERE log : 0..maxWorkoutsInHistory --> WORKOUT 
                            & ran(log |>> {NULL}) = clientWorkedOut[{client}] 
                            & log |>> {NULL} : FIN(log |>> {NULL})
                            & card(log |>> {NULL}) = card(clientWorkedOut[{client}])
                            & ( 
                                    // Redundante, pois o array nunca será vazio nem 100% cheio (considerando so os nao NULL). Mas como nao estamos realizando provas, isso garante que max e min nao serao chamados para conjuntos vazios (para o Atelier parar de reclamar).
                                    (dom(log |>> {NULL}) = {} or dom(log |> {NULL}) = {}) 
                                    or 
                                    // Todos os nao NULL (NULL sendo um filler) devem aparecer antes dos NULL
                                    (max(dom(log |>> {NULL})) < min(dom(log |> {NULL})) )
                              )
                        THEN workoutLog := log
                END
            ELSE
                workoutLog := (0..maxWorkoutsInHistory) * {NULL}
            END
        END;
        
        
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & clientHasSolicitation(client) = NO
        THEN clientHasSolicitation(client) := YES
        END;
        

        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        PRE { cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) &
             clientHasSolicitation(cc) = YES } : FIN({ cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = YES })

        THEN 
            IF (clientHasSolicitation~[{YES}] /= {})
            THEN
                ANY clientsW 
                  WHERE clientsW : 0..maxClients --> CLIENT
                       & ran(clientsW |>> {NULL}) = clientHasSolicitation~[{YES}] 
                            & clientsW |>> {NULL} : FIN(clientsW |>> {NULL})
                            & clientHasSolicitation~[{YES}] : FIN(clientHasSolicitation~[{YES}])
                            & card(clientsW |>> {NULL}) = card(clientHasSolicitation~[{YES}])
                            & ( 
                                // Redundante, pois o array nunca será vazio nem 100% cheio (considerando so os nao NULL). Mas como nao estamos realizando provas, isso garante que max e min nao serao chamados para conjuntos vazios (para o Atelier parar de reclamar).
                                (dom(clientsW |> {NULL}) ={} or dom(clientsW |>> {NULL}) = {})
                                or
                                // Todos os nao NULL (NULL sendo um filler) devem aparecer antes dos NULL
                                (max(dom(clientsW |>> {NULL})) < min(dom(clientsW |> {NULL})))
                              )
                  THEN clientsWithSolicitation := clientsW
                END
            ELSE
                clientsWithSolicitation := (0..maxClients) * {NULL}
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

        THEN  clientHasWorkout, clientWorkedOut, clientHasSolicitation, isClientNew := 
clientHasWorkout <+ ({client} * {workoutPush, workoutPull, workoutLeg}), 
clientWorkedOut \/ ({client} * clientHasWorkout[{client}]),
clientHasSolicitation <+ {client |-> NO},
isClientNew <+ {client |-> NO}
        END
        
END

// 01
// quando usar NULL (0) como valor filler de tipos, por exemplo CLIENT = 0..10
// defino VALID_CLIENT = CLIENT - {NULL} para os locais onde eh esperado que nao se coloque um filler? como em AddClient.
// ou melhor so dizer que clientParaAdicionar tem que ser diferente de NULL?
// nesse caso, nao posso fazer
//    & VALID_CLIENT = CLIENT - {NULL}
// tenho que fazer isso
//    & VALID_CLIENT <: CLIENT
//    & CLIENT = VALID_CLIENT \/ {NULL}
//    & card(VALID_CLIENT) +1 = card(CLIENT) 

// MARCEL: melhor dizer que nao eh nulo nas precondicoes

// 02
// Values lemmas. ta certo? Posso tirar essa obrigacao de prova nao provada de alguma forma?

// MARCEL: o provador eh um jumento. Ignorar

// 03
// As POs na implementacao vao dar certo quando eu definir a implementacao dessas operacoes? Ou devo definir melhor as variaveis de ligacao?

// MARCEL: sim

// 04
// Como faco implementacao de relacao


// MARCEL:
// cwi : CLIENT*WORKOUT --> 
// Cwi |> {true} = cw

// 05
// Nas interfaces da maquina, quando tiver um "conjunto". Melhor fazer como 
// listaNaInterface : ITEM --> BOOL
// ou
// listaNaInterface : 0..maxItens --> ITEM
// & varias restricoes em listaNaInterface

// MARCEL: ITEM --> BOOL

// 06
// Posso estudar pelo livro para a prova? Ou ha diferencas grandes que devo tomar cuidado?

// MARCEL: Pode estudar pelo livro



// ----------------- TODOs ----------------- 
// TODO: transformar os "conjuntos" nas interfaces de operacoes para o formato
// ITEM --> BOOL

// TODO: adicionar clientEntrada /= NULL nas precondicoes 