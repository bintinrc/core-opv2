package co.nvqa.operator_v2.model;

/**
 *
 * @author Sergey Mishanin
 */
public class ThirdPartyOrderMapping
{
    private int shipperId = 1;
    private String shipperName;
    private String trackingId;
    private String thirdPlTrackingId;
    private String status;

    public ThirdPartyOrderMapping()
    {
    }

    public int getShipperId() {
        return shipperId;
    }

    public void setShipperId(int shipperId) {
        this.shipperId = shipperId;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public String getThirdPlTrackingId() {
        return thirdPlTrackingId;
    }

    public void setThirdPlTrackingId(String thirdPlTrackingId) {
        this.thirdPlTrackingId = thirdPlTrackingId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShipperName() {
        return shipperName;
    }

    public void setShipperName(String shipperName) {
        this.shipperName = shipperName;
    }

    @Override
    public String toString() {
        return "ThirdPartyOrderMapping{" +
                "shipperId='" + shipperId + '\'' +
                ", shipperName='" + shipperName + '\'' +
                ", trackingId='" + trackingId + '\'' +
                ", thirdPlTrackingId='" + thirdPlTrackingId + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    public String toCsvLine(){
        return trackingId + "," + shipperId + "," + thirdPlTrackingId;
    }
}
