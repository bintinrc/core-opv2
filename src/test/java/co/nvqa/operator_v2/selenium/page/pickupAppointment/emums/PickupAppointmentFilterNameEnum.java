package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum PickupAppointmentFilterNameEnum {

    SERVICE_LEVEL("serviceLevel"),
    SERVICE_TYPE("serviceType"),
    STATUS("jobStatus"),
    ZONES("zones"),
    MASTER_SHIPPER("masterShippers"),
    SHIPPER("shippers");

    private final String name;
    PickupAppointmentFilterNameEnum(String name) {
        this.name =name;
    }

    public String getName() {
        return name;
    }
}
