package co.nvqa.operator_v2.model;

import co.nvqa.commons.support.DateUtil;

import java.time.ZonedDateTime;

/**
 * @author Kateryna Skakunova
 */
public class ImplantedManifestOrder extends DataEntity<ImplantedManifestOrder>{

    private String trackingId;
    private ZonedDateTime scannedAt;
    private String destination;
    private String addressee;
    private String rackSector;
    private String deliveryBy;

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public ZonedDateTime getScannedAt() {
        return scannedAt;
    }

    public void setScannedAt(String scannedAt) {
        this.scannedAt = DateUtil.getDate(scannedAt, DateUtil.DATE_TIME_FORMATTER.withZone(DateUtil.SINGAPORE_ZONE_ID));
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getAddressee() {
        return addressee;
    }

    public void setAddressee(String addressee) {
        this.addressee = addressee;
    }

    public String getRackSector() {
        return rackSector;
    }

    public void setRackSector(String rackSector) {
        this.rackSector = rackSector;
    }

    public String getDeliveryBy() {
        return deliveryBy;
    }

    public void setDeliveryBy(String deliveryBy) {
        this.deliveryBy = deliveryBy;
    }
}
