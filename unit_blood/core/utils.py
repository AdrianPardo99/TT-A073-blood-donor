from random import randint
from simple_history.utils import get_history_manager_for_model


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


def update_user_and_change_reason_history(instance, user, reason):
    """
    based on 'from simple_history.utils import update_change_reason'.
    With improvements: In addition to allowing to change the reason in a history,
    it also allows setting a user
    """
    attrs = {}
    model = type(instance)
    manager = instance if instance.id is not None else model
    history = get_history_manager_for_model(manager)
    history_fields = [field.attname for field in history.model._meta.fields]
    for field in instance._meta.fields:
        if field.attname not in history_fields:
            continue
        value = getattr(instance, field.attname)
        if field.primary_key is True:
            if value is not None:
                attrs[field.attname] = value
        else:
            attrs[field.attname] = value

    record = history.filter(**attrs).order_by("-history_date").first()
    record.history_user_id = user
    record.history_change_reason = reason
    record.save()
