from random import randint

from .models import Petition


def check_weight(donors, max_weight, solution):
    weight = 0
    for i in range(len(donors)):
        if solution[i] == 1:
            weight += donors[i].weight
    return weight <= max_weight


def check_fitness(donors, solution):
    sum = 0
    for i in range(len(donors)):
        if solution[i] == 1:
            sum += donors[i].profit
    return sum


def gen_random_solution(donors, max_weight):
    arr = []
    for i in range(len(donors)):
        if max_weight == 1 and (donors[i].profit == 1 or donors[i].profit == 2):
            arr.append(1)
            max_weight -= 1
        else:
            arr.append(0)
        if max_weight != 1:
            if max_weight > 0:
                arr.append(randint(0, 1))
            else:
                arr.append(0)
            if arr[-1] == 1:
                max_weight -= 1

    return arr


def get_random_string(tam):
    return randint(0, tam - 1)


def copy_sol(arr):
    arr_1 = []
    for i in arr:
        arr_1.append(i)
    return arr_1


def knapsack(max_weight, donors, max_iterations):
    print("Inicia busqueda")
    while True:
        solution = gen_random_solution(donors, max_weight)
        fitness = check_fitness(donors, solution)
        if check_weight(donors, max_weight, solution):
            break
    print("Encontro solución")
    for i in range(max_iterations):
        mutate = get_random_string(len(donors))
        new_solution = copy_sol(solution)
        new_solution[mutate] = abs(new_solution[mutate] - 1)
        new_fitness = check_fitness(donors, new_solution)
        if check_weight(donors, max_weight, new_solution) and new_fitness >= fitness:
            fitness = new_fitness
            solution = copy_sol(new_solution)
    units = []
    for i in range(len(solution)):
        if solution[i] == 1:
            units.append(donors[i])
    return units
