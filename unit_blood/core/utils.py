from random import randint


def create_array_random(N):
    while True:
        arr = []
        sum = 0
        for i in range(N):
            arr.append(randint(0, 1))
            sum += arr[-1]
        if sum > 0:
            break
    return arr


def create_array_from_random(array, qty):
    arr = []
    min = 1
    for i in array:
        qty = 0 if qty <= 0 else qty
        min = 0 if qty == 0 else min
        arr.append(randint(min, qty))
        if i == 0:
            arr[-1] = 0
        qty = qty - arr[-1]
    sum = 0
    for i in arr:
        sum += i
    if sum == qty:
        return arr
    for i in range(len(arr)):
        if arr[i] != 0:
            arr[i] += qty
            qty = 0
    return arr
