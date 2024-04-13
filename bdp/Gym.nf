Normalised(
THEORY MagicNumberX IS
  MagicNumber(Machine(Gym))==(3.5)
END
&
THEORY UpperLevelX IS
  First_Level(Machine(Gym))==(Machine(Gym));
  Level(Machine(Gym))==(0)
END
&
THEORY LoadedStructureX IS
  Machine(Gym)
END
&
THEORY ListSeesX IS
  List_Sees(Machine(Gym))==(?)
END
&
THEORY ListUsesX IS
  List_Uses(Machine(Gym))==(?)
END
&
THEORY ListIncludesX IS
  Inherited_List_Includes(Machine(Gym))==(?);
  List_Includes(Machine(Gym))==(?)
END
&
THEORY ListPromotesX IS
  List_Promotes(Machine(Gym))==(?)
END
&
THEORY ListExtendsX IS
  List_Extends(Machine(Gym))==(?)
END
&
THEORY ListVariablesX IS
  External_Context_List_Variables(Machine(Gym))==(?);
  Context_List_Variables(Machine(Gym))==(?);
  Abstract_List_Variables(Machine(Gym))==(?);
  Local_List_Variables(Machine(Gym))==(clientHasSolicitation,exerciseHasCategory,workoutHasExercise,clientWorkedOut,clientHasWorkout,exercises,workouts,clients,timeInDays);
  List_Variables(Machine(Gym))==(clientHasSolicitation,exerciseHasCategory,workoutHasExercise,clientWorkedOut,clientHasWorkout,exercises,workouts,clients,timeInDays);
  External_List_Variables(Machine(Gym))==(clientHasSolicitation,exerciseHasCategory,workoutHasExercise,clientWorkedOut,clientHasWorkout,exercises,workouts,clients,timeInDays)
END
&
THEORY ListVisibleVariablesX IS
  Inherited_List_VisibleVariables(Machine(Gym))==(?);
  Abstract_List_VisibleVariables(Machine(Gym))==(?);
  External_List_VisibleVariables(Machine(Gym))==(?);
  Expanded_List_VisibleVariables(Machine(Gym))==(?);
  List_VisibleVariables(Machine(Gym))==(?);
  Internal_List_VisibleVariables(Machine(Gym))==(?)
END
&
THEORY ListInvariantX IS
  Gluing_Seen_List_Invariant(Machine(Gym))==(btrue);
  Gluing_List_Invariant(Machine(Gym))==(btrue);
  Expanded_List_Invariant(Machine(Gym))==(btrue);
  Abstract_List_Invariant(Machine(Gym))==(btrue);
  Context_List_Invariant(Machine(Gym))==(btrue);
  List_Invariant(Machine(Gym))==(timeInDays: INTEGER & clients <: CLIENT & workouts <: WORKOUT & exercises <: EXERCISE & clientHasWorkout: clients +-> WORKOUT & clientWorkedOut: clients +-> WORKOUT & workoutHasExercise: WORKOUT <-> EXERCISE & exerciseHasCategory: exercises --> CATEGORY & clientHasSolicitation: clients --> SOLICITATION)
END
&
THEORY ListAssertionsX IS
  Expanded_List_Assertions(Machine(Gym))==(btrue);
  Abstract_List_Assertions(Machine(Gym))==(btrue);
  Context_List_Assertions(Machine(Gym))==(btrue);
  List_Assertions(Machine(Gym))==(btrue)
END
&
THEORY ListCoverageX IS
  List_Coverage(Machine(Gym))==(btrue)
END
&
THEORY ListExclusivityX IS
  List_Exclusivity(Machine(Gym))==(btrue)
END
&
THEORY ListInitialisationX IS
  Expanded_List_Initialisation(Machine(Gym))==(timeInDays,clients,workouts,exercises,clientHasWorkout,clientWorkedOut,workoutHasExercise,exerciseHasCategory,clientHasSolicitation:=0,{},{},{},{},{},{},{},{});
  Context_List_Initialisation(Machine(Gym))==(skip);
  List_Initialisation(Machine(Gym))==(timeInDays:=0 || clients:={} || workouts:={} || exercises:={} || clientHasWorkout:={} || clientWorkedOut:={} || workoutHasExercise:={} || exerciseHasCategory:={} || clientHasSolicitation:={})
END
&
THEORY ListParametersX IS
  List_Parameters(Machine(Gym))==(?)
END
&
THEORY ListInstanciatedParametersX END
&
THEORY ListConstraintsX IS
  List_Context_Constraints(Machine(Gym))==(btrue);
  List_Constraints(Machine(Gym))==(btrue)
END
&
THEORY ListOperationsX IS
  Internal_List_Operations(Machine(Gym))==(addClient,removeClient,addWorkout,removeWorkout,addExercise,removeExercise,getWorkoutLog,askForWorkout,getClientsWithWorkoutSolicitations,defineClientWorkout,goToNextDay);
  List_Operations(Machine(Gym))==(addClient,removeClient,addWorkout,removeWorkout,addExercise,removeExercise,getWorkoutLog,askForWorkout,getClientsWithWorkoutSolicitations,defineClientWorkout,goToNextDay)
END
&
THEORY ListInputX IS
  List_Input(Machine(Gym),addClient)==(client);
  List_Input(Machine(Gym),removeClient)==(client);
  List_Input(Machine(Gym),addWorkout)==(workout,exPush,exPull,exLeg);
  List_Input(Machine(Gym),removeWorkout)==(workout);
  List_Input(Machine(Gym),addExercise)==(exercise,category);
  List_Input(Machine(Gym),removeExercise)==(exercise);
  List_Input(Machine(Gym),getWorkoutLog)==(client);
  List_Input(Machine(Gym),askForWorkout)==(client);
  List_Input(Machine(Gym),getClientsWithWorkoutSolicitations)==(?);
  List_Input(Machine(Gym),defineClientWorkout)==(client);
  List_Input(Machine(Gym),goToNextDay)==(?)
END
&
THEORY ListOutputX IS
  List_Output(Machine(Gym),addClient)==(?);
  List_Output(Machine(Gym),removeClient)==(?);
  List_Output(Machine(Gym),addWorkout)==(?);
  List_Output(Machine(Gym),removeWorkout)==(?);
  List_Output(Machine(Gym),addExercise)==(?);
  List_Output(Machine(Gym),removeExercise)==(?);
  List_Output(Machine(Gym),getWorkoutLog)==(workoutLog);
  List_Output(Machine(Gym),askForWorkout)==(?);
  List_Output(Machine(Gym),getClientsWithWorkoutSolicitations)==(clientsWithSolicitation);
  List_Output(Machine(Gym),defineClientWorkout)==(?);
  List_Output(Machine(Gym),goToNextDay)==(?)
END
&
THEORY ListHeaderX IS
  List_Header(Machine(Gym),addClient)==(addClient(client));
  List_Header(Machine(Gym),removeClient)==(removeClient(client));
  List_Header(Machine(Gym),addWorkout)==(addWorkout(workout,exPush,exPull,exLeg));
  List_Header(Machine(Gym),removeWorkout)==(removeWorkout(workout));
  List_Header(Machine(Gym),addExercise)==(addExercise(exercise,category));
  List_Header(Machine(Gym),removeExercise)==(removeExercise(exercise));
  List_Header(Machine(Gym),getWorkoutLog)==(workoutLog <-- getWorkoutLog(client));
  List_Header(Machine(Gym),askForWorkout)==(askForWorkout(client));
  List_Header(Machine(Gym),getClientsWithWorkoutSolicitations)==(clientsWithSolicitation <-- getClientsWithWorkoutSolicitations);
  List_Header(Machine(Gym),defineClientWorkout)==(defineClientWorkout(client));
  List_Header(Machine(Gym),goToNextDay)==(goToNextDay)
END
&
THEORY ListOperationGuardX END
&
THEORY ListPreconditionX IS
  List_Precondition(Machine(Gym),addClient)==(client: CLIENT & client/:clients);
  List_Precondition(Machine(Gym),removeClient)==(client: CLIENT);
  List_Precondition(Machine(Gym),addWorkout)==(workout: WORKOUT & exPush: EXERCISE & exPull: EXERCISE & exLeg: EXERCISE & exPush: exercises & exerciseHasCategory[{exPush}] = {PUSH} & exPull: exercises & exerciseHasCategory[{exPull}] = {PULL} & exLeg: exercises & exerciseHasCategory[{exLeg}] = {LEGS});
  List_Precondition(Machine(Gym),removeWorkout)==(workout: WORKOUT);
  List_Precondition(Machine(Gym),addExercise)==(exercise: EXERCISE & category: CATEGORY & exercise/:exercises);
  List_Precondition(Machine(Gym),removeExercise)==(exercise: EXERCISE);
  List_Precondition(Machine(Gym),getWorkoutLog)==(client: CLIENT & workoutLog: CLIENT);
  List_Precondition(Machine(Gym),askForWorkout)==(client: CLIENT);
  List_Precondition(Machine(Gym),getClientsWithWorkoutSolicitations)==(clientsWithSolicitation <: CLIENT);
  List_Precondition(Machine(Gym),defineClientWorkout)==(client: CLIENT);
  List_Precondition(Machine(Gym),goToNextDay)==(btrue)
END
&
THEORY ListSubstitutionX IS
  Expanded_List_Substitution(Machine(Gym),goToNextDay)==(btrue | clients:={});
  Expanded_List_Substitution(Machine(Gym),defineClientWorkout)==(client: CLIENT | clients:={});
  Expanded_List_Substitution(Machine(Gym),getClientsWithWorkoutSolicitations)==(clientsWithSolicitation <: CLIENT | clients:={});
  Expanded_List_Substitution(Machine(Gym),askForWorkout)==(client: CLIENT | clients:={});
  Expanded_List_Substitution(Machine(Gym),getWorkoutLog)==(client: CLIENT & workoutLog: CLIENT | clients:={});
  Expanded_List_Substitution(Machine(Gym),removeExercise)==(exercise: EXERCISE | exercises:={});
  Expanded_List_Substitution(Machine(Gym),addExercise)==(exercise: EXERCISE & category: CATEGORY & exercise/:exercises | exercises,exerciseHasCategory:=exercises\/{exercise},exerciseHasCategory\/{exercise|->category});
  Expanded_List_Substitution(Machine(Gym),removeWorkout)==(workout: WORKOUT | workouts:={});
  Expanded_List_Substitution(Machine(Gym),addWorkout)==(workout: WORKOUT & exPush: EXERCISE & exPull: EXERCISE & exLeg: EXERCISE & exPush: exercises & exerciseHasCategory[{exPush}] = {PUSH} & exPull: exercises & exerciseHasCategory[{exPull}] = {PULL} & exLeg: exercises & exerciseHasCategory[{exLeg}] = {LEGS} | workouts:={});
  Expanded_List_Substitution(Machine(Gym),removeClient)==(client: CLIENT | clients:={});
  Expanded_List_Substitution(Machine(Gym),addClient)==(client: CLIENT & client/:clients | clients,clientHasSolicitation:=clients\/{client},clientHasSolicitation\/{client|->YES});
  List_Substitution(Machine(Gym),addClient)==(clients:=clients\/{client} || clientHasSolicitation:=clientHasSolicitation\/{client|->YES});
  List_Substitution(Machine(Gym),removeClient)==(clients:={});
  List_Substitution(Machine(Gym),addWorkout)==(workouts:={});
  List_Substitution(Machine(Gym),removeWorkout)==(workouts:={});
  List_Substitution(Machine(Gym),addExercise)==(exercises:=exercises\/{exercise} || exerciseHasCategory:=exerciseHasCategory\/{exercise|->category});
  List_Substitution(Machine(Gym),removeExercise)==(exercises:={});
  List_Substitution(Machine(Gym),getWorkoutLog)==(clients:={});
  List_Substitution(Machine(Gym),askForWorkout)==(clients:={});
  List_Substitution(Machine(Gym),getClientsWithWorkoutSolicitations)==(clients:={});
  List_Substitution(Machine(Gym),defineClientWorkout)==(clients:={});
  List_Substitution(Machine(Gym),goToNextDay)==(clients:={})
END
&
THEORY ListConstantsX IS
  List_Valuable_Constants(Machine(Gym))==(?);
  Inherited_List_Constants(Machine(Gym))==(?);
  List_Constants(Machine(Gym))==(?)
END
&
THEORY ListSetsX IS
  Set_Definition(Machine(Gym),CLIENT)==(?);
  Context_List_Enumerated(Machine(Gym))==(?);
  Context_List_Defered(Machine(Gym))==(?);
  Context_List_Sets(Machine(Gym))==(?);
  List_Valuable_Sets(Machine(Gym))==(CLIENT,WORKOUT,EXERCISE);
  Inherited_List_Enumerated(Machine(Gym))==(?);
  Inherited_List_Defered(Machine(Gym))==(?);
  Inherited_List_Sets(Machine(Gym))==(?);
  List_Enumerated(Machine(Gym))==(CATEGORY,SOLICITATION);
  List_Defered(Machine(Gym))==(CLIENT,WORKOUT,EXERCISE);
  List_Sets(Machine(Gym))==(CLIENT,WORKOUT,EXERCISE,CATEGORY,SOLICITATION);
  Set_Definition(Machine(Gym),WORKOUT)==(?);
  Set_Definition(Machine(Gym),EXERCISE)==(?);
  Set_Definition(Machine(Gym),CATEGORY)==({PUSH,PULL,LEGS});
  Set_Definition(Machine(Gym),SOLICITATION)==({YES,NO})
END
&
THEORY ListHiddenConstantsX IS
  Abstract_List_HiddenConstants(Machine(Gym))==(?);
  Expanded_List_HiddenConstants(Machine(Gym))==(?);
  List_HiddenConstants(Machine(Gym))==(?);
  External_List_HiddenConstants(Machine(Gym))==(?)
END
&
THEORY ListPropertiesX IS
  Abstract_List_Properties(Machine(Gym))==(btrue);
  Context_List_Properties(Machine(Gym))==(btrue);
  Inherited_List_Properties(Machine(Gym))==(btrue);
  List_Properties(Machine(Gym))==(CLIENT: FIN(INTEGER) & not(CLIENT = {}) & WORKOUT: FIN(INTEGER) & not(WORKOUT = {}) & EXERCISE: FIN(INTEGER) & not(EXERCISE = {}) & CATEGORY: FIN(INTEGER) & not(CATEGORY = {}) & SOLICITATION: FIN(INTEGER) & not(SOLICITATION = {}))
END
&
THEORY ListSeenInfoX END
&
THEORY ListANYVarX IS
  List_ANY_Var(Machine(Gym),addClient)==(?);
  List_ANY_Var(Machine(Gym),removeClient)==(?);
  List_ANY_Var(Machine(Gym),addWorkout)==(?);
  List_ANY_Var(Machine(Gym),removeWorkout)==(?);
  List_ANY_Var(Machine(Gym),addExercise)==(?);
  List_ANY_Var(Machine(Gym),removeExercise)==(?);
  List_ANY_Var(Machine(Gym),getWorkoutLog)==(?);
  List_ANY_Var(Machine(Gym),askForWorkout)==(?);
  List_ANY_Var(Machine(Gym),getClientsWithWorkoutSolicitations)==(?);
  List_ANY_Var(Machine(Gym),defineClientWorkout)==(?);
  List_ANY_Var(Machine(Gym),goToNextDay)==(?)
END
&
THEORY ListOfIdsX IS
  List_Of_Ids(Machine(Gym)) == (CLIENT,WORKOUT,EXERCISE,CATEGORY,SOLICITATION,PUSH,PULL,LEGS,YES,NO | ? | clientHasSolicitation,exerciseHasCategory,workoutHasExercise,clientWorkedOut,clientHasWorkout,exercises,workouts,clients,timeInDays | ? | addClient,removeClient,addWorkout,removeWorkout,addExercise,removeExercise,getWorkoutLog,askForWorkout,getClientsWithWorkoutSolicitations,defineClientWorkout,goToNextDay | ? | ? | ? | Gym);
  List_Of_HiddenCst_Ids(Machine(Gym)) == (? | ?);
  List_Of_VisibleCst_Ids(Machine(Gym)) == (?);
  List_Of_VisibleVar_Ids(Machine(Gym)) == (? | ?);
  List_Of_Ids_SeenBNU(Machine(Gym)) == (?: ?)
END
&
THEORY SetsEnvX IS
  Sets(Machine(Gym)) == (Type(CLIENT) == Cst(SetOf(atype(CLIENT,"[CLIENT","]CLIENT")));Type(WORKOUT) == Cst(SetOf(atype(WORKOUT,"[WORKOUT","]WORKOUT")));Type(EXERCISE) == Cst(SetOf(atype(EXERCISE,"[EXERCISE","]EXERCISE")));Type(CATEGORY) == Cst(SetOf(etype(CATEGORY,0,2)));Type(SOLICITATION) == Cst(SetOf(etype(SOLICITATION,0,1))))
END
&
THEORY ConstantsEnvX IS
  Constants(Machine(Gym)) == (Type(PUSH) == Cst(etype(CATEGORY,0,2));Type(PULL) == Cst(etype(CATEGORY,0,2));Type(LEGS) == Cst(etype(CATEGORY,0,2));Type(YES) == Cst(etype(SOLICITATION,0,1));Type(NO) == Cst(etype(SOLICITATION,0,1)))
END
&
THEORY VariablesEnvX IS
  Variables(Machine(Gym)) == (Type(clientHasSolicitation) == Mvl(SetOf(atype(CLIENT,?,?)*etype(SOLICITATION,0,1)));Type(exerciseHasCategory) == Mvl(SetOf(atype(EXERCISE,?,?)*etype(CATEGORY,0,2)));Type(workoutHasExercise) == Mvl(SetOf(atype(WORKOUT,?,?)*atype(EXERCISE,?,?)));Type(clientWorkedOut) == Mvl(SetOf(atype(CLIENT,?,?)*atype(WORKOUT,?,?)));Type(clientHasWorkout) == Mvl(SetOf(atype(CLIENT,?,?)*atype(WORKOUT,?,?)));Type(exercises) == Mvl(SetOf(atype(EXERCISE,?,?)));Type(workouts) == Mvl(SetOf(atype(WORKOUT,?,?)));Type(clients) == Mvl(SetOf(atype(CLIENT,?,?)));Type(timeInDays) == Mvl(btype(INTEGER,?,?)))
END
&
THEORY OperationsEnvX IS
  Operations(Machine(Gym)) == (Type(goToNextDay) == Cst(No_type,No_type);Type(defineClientWorkout) == Cst(No_type,atype(CLIENT,?,?));Type(getClientsWithWorkoutSolicitations) == Cst(SetOf(atype(CLIENT,?,?)),No_type);Type(askForWorkout) == Cst(No_type,atype(CLIENT,?,?));Type(getWorkoutLog) == Cst(atype(CLIENT,?,?),atype(CLIENT,?,?));Type(removeExercise) == Cst(No_type,atype(EXERCISE,?,?));Type(addExercise) == Cst(No_type,atype(EXERCISE,?,?)*etype(CATEGORY,?,?));Type(removeWorkout) == Cst(No_type,atype(WORKOUT,?,?));Type(addWorkout) == Cst(No_type,atype(WORKOUT,?,?)*atype(EXERCISE,?,?)*atype(EXERCISE,?,?)*atype(EXERCISE,?,?));Type(removeClient) == Cst(No_type,atype(CLIENT,?,?));Type(addClient) == Cst(No_type,atype(CLIENT,?,?)))
END
&
THEORY TCIntRdX IS
  predB0 == OK;
  extended_sees == KO;
  B0check_tab == KO;
  local_op == OK;
  abstract_constants_visible_in_values == KO;
  project_type == SOFTWARE_TYPE;
  event_b_deadlockfreeness == KO;
  variant_clause_mandatory == KO;
  event_b_coverage == KO;
  event_b_exclusivity == KO;
  genFeasibilityPO == KO
END
)
