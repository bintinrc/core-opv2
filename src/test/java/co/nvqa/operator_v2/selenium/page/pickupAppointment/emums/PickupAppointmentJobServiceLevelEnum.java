package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum PickupAppointmentJobServiceLevelEnum {

    PREMIUM("Premium"),
    STANDARD("Standard");

    private final String name;

    public String getName() {
        return name;
    }

    PickupAppointmentJobServiceLevelEnum(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }
}
