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
    
    NULL,
    ANYEXERCISE,
    ANYWORKOUT,

    SZE_CLIENT,
    SZE_WORKOUT,
    SZE_EXERCISE

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
    & SOLICITATION = BOOL
    
    // tem que ter pelo menos NULL (0) e mais um; e tem que ser menor que o tamanho max
    & SZE_CLIENT : NAT & SZE_CLIENT >= 2 & SZE_CLIENT < MAXINT
    & SZE_WORKOUT : NAT & SZE_WORKOUT >= 2 & SZE_WORKOUT < MAXINT
    & SZE_EXERCISE : NAT & SZE_EXERCISE >= 2 & SZE_EXERCISE < MAXINT
    
    & PUSH = 0 & PULL = 1 & LEGS = 2
    
    & CLIENT = 0..(SZE_CLIENT-1)
    & WORKOUT = 0..(SZE_WORKOUT-1)
    & EXERCISE = 0..(SZE_EXERCISE-1)
    & CATEGORY = {PUSH, PULL, LEGS}
    
    & NULL = 0
    & NULL : CLIENT & NULL : WORKOUT & NULL : EXERCISE
    & ANYEXERCISE : EXERCISE
    & ANYWORKOUT : WORKOUT
    
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
    & !clientx . (clientx : CLIENT & clientx : clients & isClientNew[{clientx}] = {FALSE} => card(clientHasWorkout[{clientx}]) = exactNumClientWorkouts)
    
    // todo cliente novo tem 0 workouts
    & !clientx . (clientx : CLIENT & clientx : clients & isClientNew(clientx) = TRUE => card(clientHasWorkout[{clientx}]) = 0)
    
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
        
        // Provas OK (Leo)
        addClient(client) =
        PRE client : CLIENT
            & clients : FIN(clients)
            & client /: clients
            & card(clients) < maxClients
        THEN clients, clientHasSolicitation, isClientNew := 
            clients \/ {client},
            clientHasSolicitation <+ {client |-> TRUE},
            isClientNew \/ {client |-> TRUE}
            
        END;
        
        // Provas OK (Leo)
        removeClient(client) =
        PRE client : CLIENT & client : clients
        THEN clients, clientHasSolicitation, clientHasWorkout, clientWorkedOut, isClientNew := 
            clients - {client},
            {client} <<| clientHasSolicitation,
            {client} <<| clientHasWorkout,
            {client} <<| clientWorkedOut,
            {client} <<| isClientNew
        END;
        
        // TODO: exercisesInWorkout NULL
        // TODO?: analisar se retirada de numOfExercisesInWorkout esta ok
//        addWorkout(workout, category, numOfExercisesInWorkout, exercisesInWorkout) =
//        addWorkout(workout, category, exercisesInWorkout) =
//        PRE workout : WORKOUT & category : CATEGORY 
////            & numOfExercisesInWorkout : NAT1
////            & numOfExercisesInWorkout <= maxExercisesInWorkout
////            & numOfExercisesInWorkout > 0
//            & workouts : FIN(workouts)
//            & workout /: workouts
//            & card(workouts) < maxWorkouts
//            // ------ typing exercisesInWorkout init ------ 
//            & exercisesInWorkout : EXERCISE --> BOOL
////            & exercisesInWorkout : 0..(maxExercisesInWorkout -1) --> EXERCISE
////            & 
//            & dom(exercisesInWorkout |> {TRUE}) <: exercises // todos os exs ja estao cadastrados
//            & exercisesInWorkout |> {TRUE} : FIN(exercisesInWorkout |> {TRUE})
//            & card(exercisesInWorkout |> {TRUE}) <= maxExercisesInWorkout
////            & ran(exercisesInWorkout) : FIN(ran(exercisesInWorkout))
////            & exercisesInWorkout : FIN(exercisesInWorkout)
////            & card(exercisesInWorkout |> {TRUE}) =  numOfExercisesInWorkout // tamanho de exercisesInWorkout eh numOfExercisesInWorkout
//            & !ex . ( ex : EXERCISE & ex : dom(exercisesInWorkout |> {TRUE}) => exerciseHasCategory(ex) = category) // todo ex em exercisesInWorkout tem a mesma categoria que o workout tera
//            // ------ typing exercisesInWorkout end ------
//            
//        THEN workouts, workoutHasCategory, workoutHasExercise  :=
//            workouts \/ {workout},
//            workoutHasCategory \/ {workout |-> category},
//            workoutHasExercise \/ {workout}*dom(exercisesInWorkout |> {TRUE})
//        END;
        
        
        removeWorkout(workout) =
        PRE workout : WORKOUT & workout : workouts
            & workout /: ran(clientHasWorkout)
            & workout /= NULL
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
            & exercise /= NULL
            & card(exercises) < maxExercises
        THEN exercises := exercises \/ {exercise}
            || exerciseHasCategory := exerciseHasCategory \/ {exercise|-> category}
        END;
        

        removeExercise(exercise) =
        PRE exercise : EXERCISE
            & exercise : exercises
            & exercise /: ran(workoutHasExercise)
            & exercise /= NULL
        THEN
            exercises := exercises - {exercise}
            || exerciseHasCategory := {exercise} <<| exerciseHasCategory
        END;
        
                
        askForWorkout(client) = 
        PRE client : CLIENT & client : clients
            & client /= NULL
        THEN clientHasSolicitation(client) := TRUE
        END;
        
        workoutLog <-- getWorkoutLog(client) =
        PRE 
             client : CLIENT
            & client : clients
            & client /= NULL
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
        

        clientsWithSolicitation <-- getClientsWithWorkoutSolicitations = 
        PRE { cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) &
             clientHasSolicitation(cc) = TRUE } : FIN({ cc | cc : CLIENT &
             cc : dom(clientHasSolicitation) & clientHasSolicitation(cc) = TRUE })

        THEN 
            IF (clientHasSolicitation~[{TRUE}] /= {})
            THEN
                ANY clientsW 
                  WHERE clientsW : 0..maxClients --> CLIENT
                       & ran(clientsW |>> {NULL}) = clientHasSolicitation~[{TRUE}] 
                            & clientsW |>> {NULL} : FIN(clientsW |>> {NULL})
                            & clientHasSolicitation~[{TRUE}] : FIN(clientHasSolicitation~[{TRUE}])
                            & card(clientsW |>> {NULL}) = card(clientHasSolicitation~[{TRUE}])
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
        
        // PROVAS OK (Leo)
        // TODO: Seria bom tirar a parte de maxWorkoutsInHistory da precondição e colocar como if no THEN
        defineClientWorkouts(client, workoutPush, workoutPull, workoutLeg) =
        PRE client : CLIENT & client : clients 
            & clientHasSolicitation(client) = TRUE
            & workoutPush : WORKOUT & workoutPull : WORKOUT & workoutLeg : WORKOUT
            & workoutPush /= NULL & workoutPull /= NULL & workoutLeg /= NULL
            & workoutPush : workouts & workoutHasCategory[{workoutPush}] = {PUSH}
            & workoutPull : workouts & workoutHasCategory[{workoutPull}] = {PULL}
            & workoutLeg : workouts & workoutHasCategory[{workoutLeg}] = {LEGS}
            & workoutPush /= workoutPull & workoutPull /= workoutLeg & workoutPush /= workoutLeg  // redundante
            & clientWorkedOut \/ {client} * clientHasWorkout[{client}] : FIN(clientWorkedOut \/ {client} * clientHasWorkout[{client}])
            & card(clientWorkedOut \/ {client} * clientHasWorkout[{client}]) < maxWorkoutsInHistory

        THEN  clientHasWorkout, clientWorkedOut, clientHasSolicitation, isClientNew := 
clientHasWorkout <+ ({client} * {workoutPush, workoutPull, workoutLeg}), 
clientWorkedOut \/ ({client} * clientHasWorkout[{client}]),
clientHasSolicitation <+ {client |-> FALSE},
isClientNew <+ {client |-> FALSE}
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