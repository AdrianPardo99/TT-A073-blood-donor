import datetime
from os import times

from random import randint
from time import time

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
        if max_weight > 0:
            if donors[i].profit == 1 or donors[i].profit == 2:
                arr.append(1)
                max_weight -= 1
            else:
                arr.append(0)
        else:
            arr.append(0)

    return arr


def get_random_string(tam):
    return randint(0, tam - 1)


def copy_sol(arr):
    arr_1 = []
    for i in arr:
        arr_1.append(i)
    return arr_1


def knapsack(max_weight, donors, max_iterations):
    timestamp = datetime.datetime.now().__str__().replace(" ", "T")
    f = open(f"data_{timestamp}.txt", "a")
    f.write("Crea solución\n")
    while True:
        solution = gen_random_solution(donors, max_weight)
        fitness = check_fitness(donors, solution)
        if check_weight(donors, max_weight, solution):
            break
    f.write(
        f"---------------\nPeso máximo: {max_weight}\n---------------\nIteraciones: {max_iterations}\n---------------\nDatos: {donors}\nComienza iteraciones\nSolución aleatoria:\n{solution}\n"
    )
    for i in range(max_iterations):
        mutate = get_random_string(len(donors))
        mutate_1 = get_random_string(len(donors))
        new_solution = copy_sol(solution)
        head = new_solution[mutate]
        new_solution[mutate] = new_solution[mutate_1]
        new_solution[mutate_1] = head
        new_fitness = check_fitness(donors, new_solution)
        if check_weight(donors, max_weight, new_solution) and new_fitness > fitness:
            fitness = new_fitness
            solution = copy_sol(new_solution)
            f.write(f"\nSe encontro mejor solución en iteracion: {i}\n{solution}\n")
    units = []
    for i in range(len(solution)):
        if solution[i] == 1:
            units.append(donors[i])
    f.write(f"Solución final:\n{solution}\n")
    f.close()
    return units
