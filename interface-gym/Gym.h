#ifndef _Gym_h
#define _Gym_h

#include <stdint.h>
#include <stdbool.h>
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


/* Clause SETS */

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */
typedef int Gym__CLIENT;
typedef int Gym__WORKOUT;
typedef int Gym__EXERCISE;
typedef int Gym__CATEGORY;
#define Gym__maxClients 15
#define Gym__maxWorkouts 15
#define Gym__maxExercises 15
#define Gym__maxExercisesInWorkout 7
#define Gym__exactNumClientWorkouts 3
#define Gym__PUSH 0
#define Gym__PULL 1
#define Gym__LEGS 2
#define Gym__NULL 0
#define Gym__ANYEXERCISE 0
#define Gym__ANYWORKOUT 0
#define Gym__ANYCATEGORY 0
#define Gym__SZE_CLIENT 15
#define Gym__SZE_WORKOUT 15
#define Gym__SZE_EXERCISE 15
#define Gym__SZE_CATEGORY 3
/* Array and record constants */





















/* Clause CONCRETE_VARIABLES */

extern void Gym__INITIALISATION(void);

/* Clause OPERATIONS */

extern void Gym__addClient(int32_t client);
extern void Gym__removeClient(int32_t client);
extern void Gym__addWorkout(int32_t workout, int32_t categoryWr, bool *exercisesInWorkout);
extern void Gym__removeWorkout(int32_t workout);
extern void Gym__addExercise(int32_t exercise, int32_t categoryEx);
extern void Gym__removeExercise(int32_t exercise);
extern void Gym__askForWorkout(int32_t client);
extern void Gym__getWorkoutLog(int32_t client, bool *workoutLog);
extern void Gym__getClientsWithWorkoutSolicitation(bool *clientsWithSolicitation);
extern void Gym__defineClientWorkouts(int32_t client, int32_t wr1, int32_t wr2, int32_t wr3);
extern void Gym__getClients(bool *listClients);
extern void Gym__getExercises(bool *listExercises);
extern void Gym__getWorkouts(bool *listWorkouts);
extern void Gym__getCurrentWorkoutsClient(int32_t client, bool *listWorkouts);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* _Gym_h */
