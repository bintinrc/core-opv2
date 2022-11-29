package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum PickupAppointmentStatusEnum {

    IN_PROGRESS("In Progress"),
    CANCELLED("Cancelled"),
    COMPLETED("Completed"),
    FAILED("Failed"),
    READY_FOR_ROUTING("Ready for Routing"),
    ROUTED("Routed");

    private final String name;

    PickupAppointmentStatusEnum(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }
}
