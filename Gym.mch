MACHINE
    Gym
    
CONSTANTS
    
    CLIENT,
    WORKOUT,
    EXERCISE, 
    CATEGORY,
    
    maxClients,
    maxWorkouts,
    maxExercises,
    
    maxExercisesInWorkout,
    //    maxWorkoutsInHistory,
    exactNumClientWorkouts,
    PUSH, PULL, LEGS,
    
    
    NULL,
    ANYEXERCISE,
    ANYWORKOUT,
    ANYCATEGORY,
    
    SZE_CLIENT,
    SZE_WORKOUT,
    SZE_EXERCISE,
    SZE_CATEGORY
    
PROPERTIES
    maxClients = 15
    & maxWorkouts = 15
    & maxExercises = 15
    
    & maxExercisesInWorkout = 7
    //    & maxWorkoutsInHistory = 40
    & exactNumClientWorkouts = 3
    
    & CLIENT <: NAT
    & WORKOUT <: NAT
    & EXERCISE <: NAT
    & CATEGORY <: 0..2
    
    // tem que ter pelo menos NULL (0) e mais um; e tem que ser menor que o tamanho max
    & SZE_CLIENT : NAT1 & SZE_CLIENT >= 2 & SZE_CLIENT < MAXINT
    & SZE_WORKOUT : NAT1 & SZE_WORKOUT >= 2 & SZE_WORKOUT < MAXINT
    & SZE_EXERCISE : NAT1 & SZE_EXERCISE >= 2 & SZE_EXERCISE < MAXINT
    & SZE_CATEGORY : NAT1 & SZE_CATEGORY = 3
    
    & SZE_CLIENT = 15
    & SZE_WORKOUT = 15
    & SZE_EXERCISE = 15
    
    & PUSH = 0 & PULL = 1 & LEGS = 2
    
    & CLIENT = 0..(SZE_CLIENT-1)
    & WORKOUT = 0..(SZE_WORKOUT-1)
    & EXERCISE = 0..(SZE_EXERCISE-1)
    //    & CATEGORY = {PUSH, PULL, LEGS}
    & CATEGORY = 0..(SZE_CATEGORY-1)
    
    & PUSH : CATEGORY & PULL : CATEGORY & LEGS : CATEGORY
    
    & CLIENT : FIN(CLIENT)
    & WORKOUT : FIN(WORKOUT)
    & EXERCISE : FIN(EXERCISE)
    & CATEGORY : FIN(CATEGORY)
    
    & SZE_CLIENT = card(CLIENT)
    & SZE_WORKOUT = card(WORKOUT)
    & SZE_EXERCISE = card(EXERCISE)
    & SZE_CATEGORY = card(CATEGORY)
    
    & NULL = 0
    & NULL : CLIENT & NULL : WORKOUT & NULL : EXERCISE
    & ANYEXERCISE : EXERCISE
    & ANYWORKOUT : WORKOUT
    & ANYCATEGORY : CATEGORY
    
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
    & clientHasSolicitation : clients --> BOOL
    & workoutHasCategory : workouts --> CATEGORY
    & isClientNew : clients --> BOOL
    
    // limits
    & clients : FIN(clients)
    & workouts : FIN(workouts)
    & exercises : FIN(exercises)
    & card(clients) <= maxClients
    & card(workouts) <= maxWorkouts
    & card(exercises) <= maxExercises
    // todo cliente tem que ter um historico menor ou igual ao limite
    //    & !clientx . (clientx : CLIENT => 
    //        clientWorkedOut[{clientx}] : FIN(clientWorkedOut[{clientx}]) & 
    //        card(clientWorkedOut[{clientx}]) <= maxWorkoutsInHistory)
    
    // maximo de exercicios em um treino eh 7 
    & !workoutx . (workoutx : WORKOUT & workoutx : workouts => card(workoutHasExercise[{workoutx}]) <= maxExercisesInWorkout)
    
    
    // ------ BUSSINESS RULES ------
    
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
    
    
    // PROVAS OK (acho)
    // array de entrada tem certas complexidades...
    addWorkout(workout, categoryWr, exercisesInWorkout) =
    PRE workout : WORKOUT & categoryWr : CATEGORY 
        & workout /: workouts
        & card(workouts) < maxWorkouts
        
        // ------ typing exercisesInWorkout init ------ 
        & exercisesInWorkout : NAT --> BOOL
        & dom(exercisesInWorkout |> {TRUE}) <: EXERCISE
        & dom(exercisesInWorkout |> {TRUE}) <: exercises // todos os exs ja estao cadastrados
        & exercisesInWorkout |> {TRUE} : FIN(exercisesInWorkout |> {TRUE})
        & card(exercisesInWorkout |> {TRUE}) <= maxExercisesInWorkout
        & !ex . ( ex : EXERCISE & ex : dom(exercisesInWorkout |> {TRUE}) => exerciseHasCategory(ex) = categoryWr) // todo ex em exercisesInWorkout tem a mesma categoria que o workout
        // ------ typing exercisesInWorkout end ------
        
    THEN workouts, workoutHasCategory, workoutHasExercise  :=
        workouts \/ {workout},
        workoutHasCategory \/ {workout |-> categoryWr},
        workoutHasExercise \/ {workout}*dom(exercisesInWorkout |> {TRUE})
    END;
    
    
    removeWorkout(workout) =
    PRE workout : WORKOUT & workout : workouts
        & workout /: ran(clientHasWorkout)
        & workout /= NULL
    THEN workouts, workoutHasCategory, workoutHasExercise  := 
        workouts - {workout}, 
        {workout} <<| workoutHasCategory,
        {workout} <<| workoutHasExercise
    END;
    
    
    addExercise(exercise, categoryEx) =
    PRE exercise : EXERCISE
        & categoryEx : CATEGORY
        & exercises : FIN(exercises)
        & exercise /: exercises
        & exercise /= NULL
        & card(exercises) < maxExercises
    THEN exercises := exercises \/ {exercise}
        || exerciseHasCategory := exerciseHasCategory \/ {exercise|-> categoryEx}
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
        ANY log 
        WHERE log : NAT --> BOOL
            & dom(log |> {TRUE}) <: WORKOUT
            & dom(log |> {TRUE}) = clientWorkedOut[{client}] 
        THEN workoutLog := log
        END
    END;
    
    clientsWithSolicitation <-- getClientsWithWorkoutSolicitation = 
    ANY list 
    WHERE list : NAT --> BOOL
        & dom(list |> {TRUE}) <: CLIENT
        & dom(list |> {TRUE}) = clientHasSolicitation~[{TRUE}] 
    THEN clientsWithSolicitation := list
    END;
    
    // PROVAS OK (Leo)
    defineClientWorkouts(client, wr1, wr2, wr3) =
    PRE client : CLIENT & client : clients & client /= NULL
        & clientHasSolicitation(client) = TRUE
        & wr1 : WORKOUT & wr2 : WORKOUT & wr3 : WORKOUT
        & wr1 /= NULL & wr2 /= NULL & wr3 /= NULL
        & wr1 : workouts & wr2 : workouts & wr3 : workouts
        & workoutHasCategory[{wr1,wr2,wr3}] = CATEGORY
        & clientWorkedOut \/ {client} * clientHasWorkout[{client}] : FIN(clientWorkedOut \/ {client} * clientHasWorkout[{client}])
        //            & card(clientWorkedOut \/ {client} * clientHasWorkout[{client}]) < maxWorkoutsInHistory
        
    THEN  clientHasWorkout, clientWorkedOut, clientHasSolicitation, isClientNew := 
        clientHasWorkout <+ ({client} * {wr1, wr2, wr3}), 
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
// cwi : CLIENT*WORKOUT --> BOOL
// dom(Cwi |> {true}) = cw

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