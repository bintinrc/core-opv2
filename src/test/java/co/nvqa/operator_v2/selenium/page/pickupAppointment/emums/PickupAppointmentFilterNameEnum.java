package co.nvqa.operator_v2.selenium.page.pickupAppointment.emums;

public enum PickupAppointmentFilterNameEnum {

    SERVICE_LEVEL("serviceLevel"),
    SERVICE_TYPE("serviceType"),
    STATUS("status"),
    ZONES("zones"),
    MASTER_SHIPPER("masterShipper"),
    SHIPPER("shipper");

    private final String name;
    PickupAppointmentFilterNameEnum(String name) {
        this.name =name;
    }
}
