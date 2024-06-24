#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <algorithm>

extern "C" {
    #include "Gym.h"
}

class Exercise {
private:
    int id;
    std::string name;
    int category;
    std::string category_name;

public:
    Exercise() {}

    Exercise(int id, const std::string& name, int category, const std::string& category_name)
        : id(id), name(name), category(category), category_name(category_name) {}

    Exercise(const Exercise& exercise) {
        id = exercise.id;
        name = exercise.name;
        category = exercise.category;
        category_name = exercise.category_name;
    }

    int getId() const { return id; }
    std::string getName() const { return name; }
    int getCategory() const { return category; }
    std::string getCategoryName() const { return category_name; }
};

class Workout {

private:
    int id;
    std::string name;
    std::string category_name;
    int category;
    std::vector<Exercise> exercises;

public:
    Workout() {}

    Workout(int id, const std::string& name, const std::string& category_name, int category, const std::vector<Exercise>& exercises)
        : id(id), name(name), category_name(category_name), category(category), exercises(exercises) {}
    
 Workout(const Workout& workout) {
        id = workout.id;
        name = workout.name;
        category_name = workout.category_name;
        category = workout.category;
        exercises = workout.exercises;
    }
    int getId() const { return id; }
    std::string getCategoryName() const { return category_name; }
    int getCategory() const { return category; }
    std::string getName() const { return name; }
    const std::vector<Exercise>& getExercises() const { return exercises; }
};

std::map<std::string, int32_t> clientMap;
int32_t nextClientId = 1;

std::map<std::string, Exercise> exercisesMap;
int nextExerciseId = 1;

std::map<std::string, Workout> workoutsMap;
int nextWorkoutId = 1;

void addClient() {

    if (clientMap.size() >= Gym__maxClients) {
        std::cout << "Limite máximo de clientes atingido!" << std::endl;
        return;
    }

    std::string nome;
    std::cout << "Digite o nome do cliente: ";
    std::cin >> nome;

    if (clientMap.find(nome) != clientMap.end()) {
        std::cout << "Cliente já existe no sistema!" << std::endl;
        return;
    }

    clientMap[nome] = nextClientId;
    Gym__addClient(nextClientId);
    std::cout << "Cliente " << nome << " adicionado com ID " << nextClientId << std::endl;
    nextClientId++;
    
}

void showClients() {
    std::cout << "Lista de Clientes:" << std::endl;
    
    bool *clients = new bool[Gym__maxClients]{false};

    Gym__getClients(clients);

    for (const auto& pair : clientMap) {
        if (clients[pair.second]) {
            std::cout << "Nome: " << pair.first << ", ID: " << pair.second << std::endl;
        }
    }

    delete[] clients;
}

void removeClient() {
    std::string nome;
    std::cout << "Digite o nome do cliente a ser removido: ";
    std::cin >> nome;

    auto it = clientMap.find(nome);
    if (it != clientMap.end()) {
        int32_t clientId = it->second;
        clientMap.erase(it);
        Gym__removeClient(clientId);
        std::cout << "Cliente " << nome << " removido do sistema." << std::endl;
    } else {
        std::cout << "Cliente não encontrado no sistema!" << std::endl;
    }
}

void addExercise() {

    if (exercisesMap.size() >= Gym__maxExercises) {
        std::cout << "Limite máximo de exercícios atingido!" << std::endl;
        return;
    }

    std::string nome;
    int categoria;

    std::cout << "Digite o nome do exercício: ";
    std::cin >> nome;

    auto it = exercisesMap.find(nome);
    if (it != exercisesMap.end()) {
        std::cout << "Exercício já existe no sistema!" << std::endl;
        return;
    }

    do {
        std::cout << "Digite a categoria do exercício (0 = PUSH, 1 = PULL, 2 = LEGS): ";
        std::cin >> categoria;

        if (categoria != Gym__PUSH && categoria != Gym__PULL && categoria != Gym__LEGS) {
            std::cout << "Categoria inválida! Digite novamente." << std::endl;
        }
    } while (categoria != Gym__PUSH && categoria != Gym__PULL && categoria != Gym__LEGS);


    Gym__addExercise(nextExerciseId, categoria);

    std::string nome_categoria;

    if(categoria == Gym__PUSH){
        nome_categoria = "Push";
    } else if(categoria == Gym__PULL){
        nome_categoria = "Pull";
    } else {
        nome_categoria = "Legs";
    }

    Exercise exercise(nextExerciseId, nome, categoria, nome_categoria);
    exercisesMap[nome] = exercise;

    std::cout << "Exercício " << nome << " adicionado com ID " << nextExerciseId << std::endl;
    nextExerciseId++;
}

void showExercises() {
    std::cout << "Lista de Exercícios:" << std::endl;

    bool *exercises = new bool[Gym__maxExercises]{false};

    Gym__getExercises(exercises);

    for (const auto& pair : exercisesMap) {
        if (exercises[pair.second.getId()]) {
            std::cout << "ID: " << pair.second.getId() << ", Nome: " << pair.second.getName()
                  << ", Categoria: " << pair.second.getCategoryName() << std::endl;
        }
    }

    delete[] exercises;
}

void removeExercise() {
    std::string nome;

    std::cout << "Digite o nome do exercício a ser removido: ";
    std::cin >> nome;

    bool exercicioAssociado = false;
    for (auto& pair : workoutsMap) {
        const auto& exercises = pair.second.getExercises();
        for (const auto& exercise : exercises) {
            if (exercise.getName() == nome) {
                exercicioAssociado = true;
                break;
            }
        }
        if (exercicioAssociado) {
            break;
        }
    }

    if (exercicioAssociado) {
        std::cout << "Não é possível remover o exercício porque ele está associado a algum treino." << std::endl;
        return;
    }

    auto it = exercisesMap.find(nome);
    if (it != exercisesMap.end()) {
        int id = it->second.getId(); 
        Gym__removeExercise(id);
        exercisesMap.erase(it);
        std::cout << "Exercício " << nome << " removido do sistema." << std::endl;
    } else {
        std::cout << "Exercício não encontrado!" << std::endl;
    }
}

void addWorkout() {

    if (workoutsMap.size() >= Gym__maxWorkouts) {
        std::cout << "Limite máximo de treinos atingido!" << std::endl;
        return;
    }

    int category;
    std::string name;
    std::vector<std::string> selectedExercises;

    std::cout << "Digite o nome do treino: ";
    std::cin >> name;

    auto it = workoutsMap.find(name);
    if (it != workoutsMap.end()) {
        std::cout << "Treino já existe no sistema!" << std::endl;
        return;
    }

    std::cout << "Digite a categoria do treino (0 = PUSH, 1 = PULL, 2 = LEGS): ";
    std::cin >> category;

    std::vector<std::string> exercisesInCategory;
    for (const auto& pair : exercisesMap) {
        if (pair.second.getCategory() == category) {
            exercisesInCategory.push_back(pair.first);
        }
    }

    if (exercisesInCategory.empty()) {
        std::cout << "Não há exercícios cadastrados nesta categoria." << std::endl;
        return;
    }

    std::cout << "Exercícios disponíveis para a categoria selecionada:" << std::endl;
    for (const auto& exercise : exercisesInCategory) {
        std::cout << "- " << exercise << std::endl;
    }

    std::cout << "Digite os exercícios a serem incluídos no treino (digite FIM para encerrar):" << std::endl;
    std::string exerciseName;
    int exerciseCount = 0;
    while (exerciseCount < Gym__maxExercisesInWorkout) {
        std::cin >> exerciseName;
        if (exerciseName == "FIM") {
            break;
        }

        auto it = std::find(exercisesInCategory.begin(), exercisesInCategory.end(), exerciseName);
        if (it != exercisesInCategory.end()) {
            selectedExercises.push_back(exerciseName);
        } else {
            std::cout << "Exercício não pertence à categoria selecionada." << std::endl;
        }
    }

    if (exerciseCount >= Gym__maxExercisesInWorkout) {
        std::cout << "Limite máximo de 7 exercícios atingido." << std::endl;
        return;
    }

    bool *exercisesInWorkout = new bool[Gym__maxExercisesInWorkout]{false};
    std::vector<Exercise> exercisesToAdd;

    for (const auto& exerciseName : selectedExercises) {
        auto it = exercisesMap.find(exerciseName);
        if (it != exercisesMap.end()) {
            exercisesToAdd.push_back(it->second);
            exercisesInWorkout[it->second.getId()] = true;
        } else {
            std::cout << "Erro: Exercício não encontrado no mapa." << std::endl;
        }
    }

   std::string name_categoria;

    if(category == Gym__PUSH){
        name_categoria = "Push";
    } else if(category == Gym__PULL){
        name_categoria = "Pull";
    } else {
        name_categoria = "Legs";
    }

    Workout workout(nextWorkoutId, name, name_categoria ,category, exercisesToAdd);
    workoutsMap[name] = workout;

    Gym__addWorkout(nextWorkoutId, category, exercisesInWorkout);

    std::cout << "Treino " << name << " adicionado com ID " << nextWorkoutId << std::endl;
    nextWorkoutId++;

    delete[] exercisesInWorkout;
}

void showWorkouts() {
    std::cout << "Treinos cadastrados:" << std::endl;

     bool *workouts = new bool[Gym__maxWorkouts]{false};

    Gym__getWorkouts(workouts);

    for (const auto& pair : workoutsMap) {
        if (workouts[pair.second.getId()]) {
           const Workout& workout = pair.second;

            std::cout << "Nome: " << workout.getName() << std::endl;
            std::cout << "Categoria: " << workout.getCategoryName() << std::endl;

            std::cout << "Exercícios:" << std::endl;
            const auto& exercises = workout.getExercises();
            for (const auto& exercise : exercises) {
                std::cout << "- " << exercise.getName() << " (ID: " << exercise.getId() << ")" << std::endl;
            }

            std::cout << std::endl; 
        }
    }

    delete[] workouts;
}

void removeWorkout() {
    std::string nome;

    std::cout << "Digite o nome do treino a ser removido: ";
    std::cin >> nome;


    auto it = workoutsMap.find(nome);
    if (it == workoutsMap.end()) {
        std::cout << "Treino não encontrado no sistema." << std::endl;
        return;
    }

    int workoutId = it->second.getId();

    bool anyClientWithWorkout = false;
    for (const auto& clientPair : clientMap) {
        bool *clientWorkoutLog = new bool[Gym__maxWorkouts]{false};
        Gym__getWorkoutLog(clientPair.second, clientWorkoutLog);

        if (clientWorkoutLog[workoutId]) {
            anyClientWithWorkout = true;
            std::cout << "O treino não pode ser removido porque o cliente '" << clientPair.first
                      << "' tem solicitação de treino associada a ele." << std::endl;
            delete[] clientWorkoutLog;
            return;
        }

        delete[] clientWorkoutLog;
    }

    Gym__removeWorkout(workoutId);
    workoutsMap.erase(it);
    std::cout << "Treino " << nome << " removido com sucesso." << std::endl;
}

void askForWorkout() {
    std::string nome;

    std::cout << "Digite o nome do cliente que precisa de um novo treino: ";
    std::cin >> nome;

    auto it = clientMap.find(nome);
    if (it == clientMap.end()) {
        std::cout << "Cliente não encontrado." << std::endl;
        return;
    }

    int clientId = it->second;
    std::cout << "Treino solicitado para o cliente " << nome << " (ID: " << clientId << ")." << std::endl;
    Gym__askForWorkout(clientId);
}

void clientsWithSolicitation() {
    const int maxClients = Gym__maxClients;
    bool *clientsWithSolicitation = new bool[maxClients];

    Gym__getClientsWithWorkoutSolicitation(clientsWithSolicitation);

    bool anyClientWithSolicitation = false;

    std::cout << "Clientes com solicitação de treino:" << std::endl;
    for (int i = 1; i <= maxClients; ++i) {
        if (clientsWithSolicitation[i]) {
            anyClientWithSolicitation = true;
            auto it = std::find_if(clientMap.begin(), clientMap.end(),
                                   [i](const std::pair<std::string, int>& pair) {
                                       return pair.second == i;
                                   });
            if (it != clientMap.end()) {
                std::cout << "Cliente " << it->first << " (ID: " << i << ") tem solicitação de treino." << std::endl;
            } else {
                std::cout << "Cliente com ID " << i << " tem solicitação de treino." << std::endl;
            }
        }
    }

    if (!anyClientWithSolicitation) {
        std::cout << "Nenhum cliente tem solicitação de treino." << std::endl;
    }

    delete[] clientsWithSolicitation;
}

void defineWorkoutClient() {
    std::string clientName;
    std::string wr1Name, wr2Name, wr3Name;

    std::cout << "Digite o nome do cliente: ";
    std::cin >> clientName;

    auto clientIt = clientMap.find(clientName);
    if (clientIt == clientMap.end()) {
        std::cout << "Cliente não encontrado!" << std::endl;
        return;
    }

    int32_t clientId = clientIt->second;
    const int maxClients = Gym__maxClients;
    bool *clientsWithSolicitation = new bool[maxClients];

    Gym__getClientsWithWorkoutSolicitation(clientsWithSolicitation);

    
        if (!clientsWithSolicitation[clientId]) {
            std::cout << "Cliente não tem solicitação!" << std::endl;
            return;
        } else {
             std::cout << "Digite o nome do primeiro treino: ";
             std::cin >> wr1Name;
             std::cout << "Digite o nome do segundo treino: ";
             std::cin >> wr2Name;
             std::cout << "Digite o nome do terceiro treino: ";
             std::cin >> wr3Name;

    auto wr1It = workoutsMap.find(wr1Name);
    auto wr2It = workoutsMap.find(wr2Name);
    auto wr3It = workoutsMap.find(wr3Name);

    if (wr1It == workoutsMap.end() || wr2It == workoutsMap.end() || wr3It == workoutsMap.end()) {
        std::cout << "Um ou mais treinos não foram encontrados!" << std::endl;
        return;
    }

    int32_t wr1Id = wr1It->second.getId();
    int32_t wr2Id = wr2It->second.getId();
    int32_t wr3Id = wr3It->second.getId();

    int category1 = wr1It->second.getCategory();
    int category2 = wr2It->second.getCategory();
    int category3 = wr3It->second.getCategory();

    if ((category1 == Gym__PUSH || category1 == Gym__PULL || category1 == Gym__LEGS) &&
        (category2 == Gym__PUSH || category2 == Gym__PULL || category2 == Gym__LEGS) &&
        (category3 == Gym__PUSH || category3 == Gym__PULL || category3 == Gym__LEGS) &&
        category1 != category2 && category1 != category3 && category2 != category3) {

        Gym__defineClientWorkouts(clientId, wr1Id, wr2Id, wr3Id);
        std::cout << "Treinos definidos para o cliente " << clientName << std::endl;
    } else {
        std::cout << "Os treinos devem ser de categorias diferentes: PUSH, PULL, e LEGS." << std::endl;
    }
        }
   
}

void showWorkoutLogClient() {
    std::string nome;

    std::cout << "Digite o nome do cliente: ";
    std::cin >> nome;

    auto clientIt = clientMap.find(nome);
    if (clientIt == clientMap.end()) {
        std::cout << "Cliente não encontrado!" << std::endl;
        return;
    }

    int clientId = clientIt->second;

    bool *clientWorkoutLog = new bool[Gym__maxWorkouts]{false};
    Gym__getWorkoutLog(clientId, clientWorkoutLog);

    std::cout << "Log de treinos para o cliente " << nome << ":" << std::endl;

    bool anyWorkout = false;
    for (int i = 0; i < Gym__maxWorkouts; ++i) {
        if (clientWorkoutLog[i]) {
            anyWorkout = true;
            for (const auto& workoutPair : workoutsMap) {
                if (workoutPair.second.getId() == i) {
                    std::cout << "Treino: " << workoutPair.second.getName() << " (ID: " << i << ")" << std::endl;
                    break;
                }
            }
        }
    }

    if (!anyWorkout) {
        std::cout << "Nenhum treino encontrado para este cliente." << std::endl;
    }

    delete[] clientWorkoutLog;
}

void showCurrentWorkoutClient() {
    std::string nome;

    std::cout << "Digite o nome do cliente: ";
    std::cin >> nome;

    auto clientIt = clientMap.find(nome);
    if (clientIt == clientMap.end()) {
        std::cout << "Cliente não encontrado!" << std::endl;
        return;
    }

    int clientId = clientIt->second;

    bool *clientCurrentWorkout = new bool[Gym__exactNumClientWorkouts]{false};
    Gym__getCurrentWorkoutsClient(clientId, clientCurrentWorkout);

    std::cout << "Treino atual do cliente " << nome << ":" << std::endl;

    bool anyWorkout = false;
    for (int i = 1; i <= Gym__exactNumClientWorkouts; ++i) {
        if (clientCurrentWorkout[i]) {
            anyWorkout = true;
            for (const auto& workoutPair : workoutsMap) {
                if (workoutPair.second.getId() == i) {
                    std::cout << "Treino: " << workoutPair.second.getName() << " (ID: " << i << ")" << std::endl;
                    std::cout << "Exercícios do treino:" << std::endl;
                    const auto& exercises = workoutPair.second.getExercises();
                    for (const auto& exercise : exercises) {
                        std::cout << "- " << exercise.getName() << std::endl;
                    }
                    std::cout << std::endl;
                    break;
                }
            }
        }
    }

    if (!anyWorkout) {
        std::cout << "Nenhum treino encontrado para este cliente." << std::endl;
    }

    delete[] clientCurrentWorkout;
}

void mostrarMenu() {
    std::cout << "Menu de Opções:" << std::endl;
    std::cout << "1. Adicionar cliente" << std::endl;
    std::cout << "2. Mostrar clientes" << std::endl;
    std::cout << "3. Remover cliente" << std::endl;
    std::cout << "4. Adicionar exercício" << std::endl;
    std::cout << "5. Mostrar exercícios" << std::endl;
    std::cout << "6. Excluir exercício" << std::endl;
    std::cout << "7. Adicionar treino" << std::endl;
    std::cout << "8. Mostrar treino" << std::endl;
    std::cout << "9. Excluir treino" << std::endl;
    std::cout << "10. Solicitar Treino" << std::endl;
    std::cout << "11. Ver clientes com solicitação de treino" << std::endl;
    std::cout << "12. Definir treino para cliente" << std::endl;
    std::cout << "13. Mostrar histórico de treinos do cliente" << std::endl;
    std::cout << "14. Mostrar treino atual do cliente" << std::endl;
    std::cout << "0. Sair" << std::endl;
}

int main() {
    int opcao;

    do {
        mostrarMenu();
        std::cout << "Escolha uma opção, caso deseje sair digite 0: ";
        std::cin >> opcao;

        switch (opcao) {
            case 1: addClient(); break;
            case 2: showClients(); break;
            case 3: removeClient(); break;
            case 4: addExercise(); break;
            case 5: showExercises(); break;
            case 6: removeExercise(); break;
            case 7: addWorkout(); break;
            case 8: showWorkouts(); break;
            case 9: removeWorkout(); break;
            case 10: askForWorkout(); break;
            case 11: clientsWithSolicitation(); break;
            case 12: defineWorkoutClient(); break;
            case 13: showWorkoutLogClient(); break;
            case 14: showCurrentWorkoutClient(); break;
            case 0: std::cout << "Saindo da academia ...\n"; break;
            default: std::cout << "Opção inválida. Tente novamente.\n"; break;
        }

    } while (opcao != 0);

    return 0;
}