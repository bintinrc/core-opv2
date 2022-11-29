package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum PickupAppointmentPriorityEnum {

    PRIORITY("Priority"),
    NON_PRIORITY("Non-Priority"),
    ALL("All");

    private final String name;
    PickupAppointmentPriorityEnum(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
