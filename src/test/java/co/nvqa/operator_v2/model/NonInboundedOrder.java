package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Sergey Mishanin
 */
public class NonInboundedOrder extends DataEntity<NonInboundedOrder>
{
    private String shipper;
    private String trackingId;
    private String granularStatus;
    private String orderPickupDate;
    private String fromAddress;
    private String reservationCount;
    private String lastSuccessReservation;
    private String nextPendingReservation;
    private String orderCreateDate;
    private String reservationAddress;
    private String lastReservationDatetime;
    private String lastReservationStatus;
    private String lastReservationFailureDescription;
    private String lastReservationFailureCategory;

    public String getShipper()
    {
        return shipper;
    }

    public void setShipper(String shipper)
    {
        this.shipper = shipper;
    }

    public String getTrackingId()
    {
        return trackingId;
    }

    public void setTrackingId(String trackingId)
    {
        this.trackingId = trackingId;
    }

    public String getGranularStatus()
    {
        return granularStatus;
    }

    public void setGranularStatus(String granularStatus)
    {
        this.granularStatus = granularStatus;
    }

    public String getOrderPickupDate()
    {
        return orderPickupDate;
    }

    public void setOrderPickupDate(String orderPickupDate)
    {
        this.orderPickupDate = orderPickupDate;
    }

    public String getFromAddress()
    {
        return fromAddress;
    }

    public void setFromAddress(String fromAddress)
    {
        this.fromAddress = fromAddress;
    }

    public String getReservationCount()
    {
        return reservationCount;
    }

    public void setReservationCount(String reservationCount)
    {
        this.reservationCount = reservationCount;
    }

    public String getLastSuccessReservation()
    {
        return lastSuccessReservation;
    }

    public void setLastSuccessReservation(String lastSuccessReservation)
    {
        this.lastSuccessReservation = lastSuccessReservation;
    }

    public String getNextPendingReservation()
    {
        return nextPendingReservation;
    }

    public void setNextPendingReservation(String nextPendingReservation)
    {
        this.nextPendingReservation = nextPendingReservation;
    }

    public String getOrderCreateDate()
    {
        return orderCreateDate;
    }

    public void setOrderCreateDate(String orderCreateDate)
    {
        this.orderCreateDate = orderCreateDate;
    }

    public String getReservationAddress()
    {
        return reservationAddress;
    }

    public void setReservationAddress(String reservationAddress)
    {
        this.reservationAddress = reservationAddress;
    }

    public String getLastReservationDatetime()
    {
        return lastReservationDatetime;
    }

    public void setLastReservationDatetime(String lastReservationDatetime)
    {
        this.lastReservationDatetime = lastReservationDatetime;
    }

    public String getLastReservationStatus()
    {
        return lastReservationStatus;
    }

    public void setLastReservationStatus(String lastReservationStatus)
    {
        this.lastReservationStatus = lastReservationStatus;
    }

    public String getLastReservationFailureDescription()
    {
        return lastReservationFailureDescription;
    }

    public void setLastReservationFailureDescription(String lastReservationFailureDescription)
    {
        this.lastReservationFailureDescription = lastReservationFailureDescription;
    }

    public String getLastReservationFailureCategory()
    {
        return lastReservationFailureCategory;
    }

    public void setLastReservationFailureCategory(String lastReservationFailureCategory)
    {
        this.lastReservationFailureCategory = lastReservationFailureCategory;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setShipper(getValueIfIndexExists(values, 0));
        setTrackingId(getValueIfIndexExists(values, 1));
        setGranularStatus(getValueIfIndexExists(values, 2));
        setOrderPickupDate(getValueIfIndexExists(values, 3));
        setFromAddress(getValueIfIndexExists(values, 4));
        setReservationCount(getValueIfIndexExists(values, 5));
        setLastSuccessReservation(getValueIfIndexExists(values, 6));
        setNextPendingReservation(getValueIfIndexExists(values, 7));
        setOrderCreateDate(getValueIfIndexExists(values, 8));
        setReservationAddress(getValueIfIndexExists(values, 9));
        setLastReservationDatetime(getValueIfIndexExists(values, 10));
        setLastReservationStatus(getValueIfIndexExists(values, 11));
        setLastReservationFailureDescription(getValueIfIndexExists(values, 12));
        setLastReservationFailureCategory(getValueIfIndexExists(values, 13));
    }
}
