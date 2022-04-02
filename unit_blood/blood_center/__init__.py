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
    ST = "ST"
    CE = "CE"
    CP = "CP"
    PF = "PF"
    PDFL = "PDFL"
    CRIO = "CRIO"

    CHOICES = [
        (ST, pgettext_lazy("Blood unit type", "ST (Sangre total)")),
        (CE, pgettext_lazy("Blood unit type", "CE (Concentrado de eritorcitos)")),
        (CP, pgettext_lazy("Blood unit type", "CP (Concentrado de plaquetas)")),
        (PF, pgettext_lazy("Blood unit type", "PF (Plasma fresco)")),
        (
            PDFL,
            pgettext_lazy(
                "Blood unit type", "PDFL (Plasma desprovisto de factores lábiles)"
            ),
        ),
        (CRIO, pgettext_lazy("Blood unit type", "CRIO (Crioprecipitado)")),
    ]


class DeadlineType:
    MAX = 5
    HIGH_PRIORITY = 4
    HIGH = 3
    MEDIUM = 2
    LOW = 1

    CHOICES = [
        (LOW, pgettext_lazy("Deadline type", "Low")),
        (MEDIUM, pgettext_lazy("Deadline type", "Medium")),
        (HIGH, pgettext_lazy("Deadline type", "High")),
        (HIGH_PRIORITY, pgettext_lazy("Deadline type", "High priority")),
        (MAX, pgettext_lazy("Deadline type", "Max")),
    ]


class TransferStatus:
    CREATED = "created"
    CONFIRMED = "confirmed"
    PREPARED = "prepared"
    SENDING = "sending"
    IN_TRANSIT = "in_transit"
    ARRIVED = "arrived"
    VERIFYING = "verifying"
    FINISHED = "finished"

    CHOICES = [
        (CREATED, pgettext_lazy("Transfer status", "Created")),
        (CONFIRMED, pgettext_lazy("Transfer status", "Confirmed")),
        (PREPARED, pgettext_lazy("Transfer status", "Prepared")),
        (SENDING, pgettext_lazy("Transfer status", "Sending")),
        (IN_TRANSIT, pgettext_lazy("Transfer status", "In transit")),
        (ARRIVED, pgettext_lazy("Transfer status", "Arrived")),
        (VERIFYING, pgettext_lazy("Transfer status", "Verifying")),
        (FINISHED, pgettext_lazy("Transfer status", "Finished")),
    ]
