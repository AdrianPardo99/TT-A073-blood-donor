class DeadlineType:
    MAXIMUM = 5
    PRIORITY = 4
    HIGH = 3
    MEDIUM = 2
    LOW = 1

    CHOICES = (
        LOW,
        MEDIUM,
        HIGH,
        PRIORITY,
        MAXIMUM,
    )


class DistanceDeadlineType:
    # Unit used Km
    MAXIMUM = 2.0
    PRIORITY = 5.0
    HIGH = 20.0
    MEDIUM = 100.0
    LOW = None

    CHOICES = (
        LOW,
        MEDIUM,
        HIGH,
        PRIORITY,
        MAXIMUM,
    )


class TimeDeadlineType:
    # Unit used minutes
    MAXIMUM = 20.0
    PRIORITY = 60.0
    HIGH = 720.0
    MEDIUM = 1440.0
    LOW = None

    CHOICES = (
        LOW,
        MEDIUM,
        HIGH,
        PRIORITY,
        MAXIMUM,
    )
