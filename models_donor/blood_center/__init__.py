from django.utils.translation import pgettext_lazy


class BloodABOSystem:
    O_MINUS = "o-"
    O_PLUS = "o+"
    A_MINUS = "a-"
    A_PLUS = "a+"
    B_MINUS = "b-"
    B_PLUS = "b+"
    AB_MINUS = "ab-"
    AB_PLUS = "ab+"

    CHOICES = [
        (O_MINUS, pgettext_lazy("Blood ABO and RH System type", "O-")),
        (O_PLUS, pgettext_lazy("Blood ABO and RH System type", "O+")),
        (A_MINUS, pgettext_lazy("Blood ABO and RH System type", "A-")),
        (A_PLUS, pgettext_lazy("Blood ABO and RH System type", "A+")),
        (B_MINUS, pgettext_lazy("Blood ABO and RH System type", "B-")),
        (B_PLUS, pgettext_lazy("Blood ABO and RH System type", "B+")),
        (AB_MINUS, pgettext_lazy("Blood ABO and RH System type", "AB-")),
        (AB_PLUS, pgettext_lazy("Blood ABO and RH System type", "AB-")),
    ]


class BloodUnitType:
    PLATELETS = "platelets"
    PLASMA = "plasma"
    CRYOPRECIPITATE = "cryoprecipitate"
    BLOOD_CELLS = "blood cells"

    CHOICES = [
        (PLATELETS, pgettext_lazy("Blood unit type", "Platelets")),
        (PLASMA, pgettext_lazy("Blood unit type", "Plasma")),
        (CRYOPRECIPITATE, pgettext_lazy("Blood unit type", "Cryoprecipitate")),
        (BLOOD_CELLS, pgettext_lazy("Blood unit type", "Blood cells")),
    ]
