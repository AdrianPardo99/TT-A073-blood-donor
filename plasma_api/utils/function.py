from .models import Petition


def assing_value(blood_type, type: int = 1) -> int:
    # receptor
    blood_value = {
        "O-": 128,
        "O+": 192,
        "A-": 160,
        "A+": 240,
        "B-": 136,
        "B+": 204,
        "AB-": 170,
        "AB+": 255,
    }
    # donor
    if type == 1:
        blood_value = {
            "O-": 255,
            "O+": 85,
            "A-": 51,
            "A+": 17,
            "B-": 15,
            "B+": 5,
            "AB-": 3,
            "AB+": 1,
        }
    if blood_type in blood_value.keys():
        return blood_value.get(blood_type)
    return 0


# If distinc of 0 is compatible
def check_compatibility(receptor: str, donor: str) -> bool:
    return (assing_value(receptor, 0) & assing_value(donor, 1)) != 0


def check_same_blood(receptor: str, donor: str) -> bool:
    return receptor == donor


def iterate_every_unit(receptor, donors, max_weight):
    for donor in donors:
        donor.compatible = check_compatibility(receptor, donor.blood_type)
        donor.weight = 1 if donor.compatible else max_weight + 1
        donor.profit = (
            2
            if check_same_blood(receptor, donor)
            else -1
            if not donor.compatible
            else 1
        )
    return donors
