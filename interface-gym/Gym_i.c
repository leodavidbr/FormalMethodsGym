/* WARNING if type checker is not performed, translation could contain errors ! */

#include "Gym.h"

/* Clause CONCRETE_CONSTANTS */
/* Basic constants */

#define Gym__r_maximumClient Gym__SZE_CLIENT-1
#define Gym__r_maximumWorkout Gym__SZE_WORKOUT-1
#define Gym__r_maximumExercise Gym__SZE_EXERCISE-1
#define Gym__r_maximumCategory Gym__SZE_CATEGORY-1
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

static bool Gym__r_clients[Gym__r_maximumClient+1];
static bool Gym__r_workouts[Gym__r_maximumWorkout+1];
static bool Gym__r_exercises[Gym__r_maximumExercise+1];
static bool Gym__r_clientHasWorkout[Gym__r_maximumClient+1][Gym__r_maximumWorkout+1];
static bool Gym__r_clientWorkedOut[Gym__r_maximumClient+1][Gym__r_maximumWorkout+1];
static bool Gym__r_workoutHasExercise[Gym__r_maximumWorkout+1][Gym__r_maximumExercise+1];
static int32_t Gym__r_exerciseHasCategory[Gym__r_maximumExercise+1];
static bool Gym__r_clientHasSolicitation[Gym__r_maximumClient+1];
static int32_t Gym__r_workoutHasCategory[Gym__r_maximumWorkout+1];
static bool Gym__r_isClientNew[Gym__r_maximumClient+1];
/* Clause INITIALISATION */
void Gym__INITIALISATION(void)
{
    
    unsigned int i = 0, j= 0;
    for(i = 0; i <= Gym__r_maximumClient;i++)
    {
        Gym__r_clients[i] = false;
    }
    for(i = 0; i <= Gym__r_maximumWorkout;i++)
    {
        Gym__r_workouts[i] = false;
    }
    for(i = 0; i <= Gym__r_maximumExercise;i++)
    {
        Gym__r_exercises[i] = false;
    }
    for(i = 0; i <= Gym__r_maximumExercise;i++)
    {
        Gym__r_exerciseHasCategory[i] = Gym__ANYCATEGORY;
    }
    for(i = 0; i <= Gym__r_maximumClient;i++)
    {
        Gym__r_clientHasSolicitation[i] = false;
    }
    for(i = 0; i <= Gym__r_maximumWorkout;i++)
    {
        Gym__r_workoutHasCategory[i] = Gym__ANYCATEGORY;
    }
    for(i = 0; i <= Gym__r_maximumClient;i++)
    {
        Gym__r_isClientNew[i] = true;
    }
    for(i = 0; i <= Gym__r_maximumClient;i++)
    {
        for(j = 0; j <= Gym__r_maximumWorkout;j++)
        {
            Gym__r_clientHasWorkout[i][j] = false;
        }
    }
    for(i = 0; i <= Gym__r_maximumClient;i++)
    {
        for(j = 0; j <= Gym__r_maximumWorkout;j++)
        {
            Gym__r_clientWorkedOut[i][j] = false;
        }
    }
    for(i = 0; i <= Gym__r_maximumWorkout;i++)
    {
        for(j = 0; j <= Gym__r_maximumExercise;j++)
        {
            Gym__r_workoutHasExercise[i][j] = false;
        }
    }
}

/* Clause OPERATIONS */

void Gym__addClient(int32_t client)
{
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            Gym__r_clientHasWorkout[client][ww] = false;
            ww = ww+1;
        }
    }
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            Gym__r_clientWorkedOut[client][ww] = false;
            ww = ww+1;
        }
    }
    Gym__r_clients[client] = true;
    Gym__r_clientHasSolicitation[client] = true;
    Gym__r_isClientNew[client] = true;
}

void Gym__removeClient(int32_t client)
{
    Gym__r_clients[client] = false;
}

void Gym__addWorkout(int32_t workout, int32_t categoryWr, bool *exercisesInWorkout)
{
    Gym__r_workouts[workout] = true;
    Gym__r_workoutHasCategory[workout] = categoryWr;
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumClient))
        {
            Gym__r_clientHasWorkout[ww][workout] = false;
            ww = ww+1;
        }
    }
    {
        int32_t ex;
        
        ex = 0;
        while((ex) <= (Gym__r_maximumExercise))
        {
            Gym__r_workoutHasExercise[workout][ex] = exercisesInWorkout[ex];
            ex = ex+1;
        }
    }
}

void Gym__removeWorkout(int32_t workout)
{
    Gym__r_workouts[workout] = false;
}

void Gym__addExercise(int32_t exercise, int32_t categoryEx)
{
    Gym__r_exercises[exercise] = true;
    Gym__r_exerciseHasCategory[exercise] = categoryEx;
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            Gym__r_workoutHasExercise[ww][exercise] = false;
            ww = ww+1;
        }
    }
}

void Gym__removeExercise(int32_t exercise)
{
    Gym__r_exercises[exercise] = false;
}

void Gym__askForWorkout(int32_t client)
{
    Gym__r_clientHasSolicitation[client] = true;
}

void Gym__getWorkoutLog(int32_t client, bool *workoutLog)
{
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            workoutLog[ww] = Gym__r_clientWorkedOut[client][ww];
            ww = ww+1;
        }
    }
}

void Gym__getClientsWithWorkoutSolicitation(bool *clientsWithSolicitation)
{
    {
        int32_t cc;
        
        cc = 0;
        while((cc) <= (Gym__r_maximumClient))
        {
            {
                bool ccInClient;
                
                ccInClient = Gym__r_clients[cc];
                if((ccInClient == true))
                {
                    clientsWithSolicitation[cc] = Gym__r_clientHasSolicitation[cc];
                }
                else
                {
                    clientsWithSolicitation[cc] = false;
                }
            }
            cc = cc+1;
        }
    }
}

void Gym__defineClientWorkouts(int32_t client, int32_t wr1, int32_t wr2, int32_t wr3)
{
    Gym__r_clientHasSolicitation[client] = false;
    Gym__r_isClientNew[client] = false;
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            {
                bool clHasWr;
                
                clHasWr = Gym__r_clientHasWorkout[client][ww];
                if((clHasWr == true))
                {
                    Gym__r_clientWorkedOut[client][ww] = true;
                }
            }
            ww = ww+1;
        }
    }
    Gym__r_clientHasWorkout[client][wr1] = true;
    Gym__r_clientHasWorkout[client][wr2] = true;
    Gym__r_clientHasWorkout[client][wr3] = true;
}

void Gym__getClients(bool *listClients)
{
    {
        int32_t cc;
        
        cc = 0;
        while((cc) <= (Gym__r_maximumClient))
        {
            listClients[cc] = Gym__r_clients[cc];
            cc = cc+1;
        }
    }
}

void Gym__getExercises(bool *listExercises)
{
    {
        int32_t ex;
        
        ex = 0;
        while((ex) <= (Gym__r_maximumExercise))
        {
            listExercises[ex] = Gym__r_exercises[ex];
            ex = ex+1;
        }
    }
}

void Gym__getWorkouts(bool *listWorkouts)
{
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            listWorkouts[ww] = Gym__r_workouts[ww];
            ww = ww+1;
        }
    }
}

void Gym__getCurrentWorkoutsClient(int32_t client, bool *listWorkouts)
{
    {
        int32_t ww;
        
        ww = 0;
        while((ww) <= (Gym__r_maximumWorkout))
        {
            {
                bool wwInWorkouts;
                
                wwInWorkouts = Gym__r_workouts[ww];
                if((wwInWorkouts == true))
                {
                    listWorkouts[ww] = Gym__r_clientHasWorkout[client][ww];
                }
                else
                {
                    listWorkouts[ww] = false;
                }
                ww = ww+1;
            }
        }
    }
}

