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


def gen_random_solution(donors):
    arr = []
    for i in range(len(donors)):
        arr.append(randint(0, 1))
    return arr


def get_random_string(tam):
    return randint(0, tam - 1)


def copy_sol(arr):
    arr_1 = []
    for i in arr:
        arr_1.append(i)
    return arr_1


def knapsack(max_weight, donors, max_iterations):
    while True:
        solution = gen_random_solution(donors)
        fitness = check_fitness(donors, solution)
        if check_weight(donors, max_weight, solution):
            break
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
