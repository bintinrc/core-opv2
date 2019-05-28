package co.nvqa.operator_v2.model;

/**
 * @author Kateryna Skakunova
 */
public class ReservationRejectionEntity extends DataEntity<ReservationRejectionEntity>
{
    private String timeRejected;
    private String pickupInfo;
    private String priorityLevel;
    private String timeslot;
    private String reasonForRejection;
    private String driverInfo;
    private String route;
    private String hub;

    public ReservationRejectionEntity()
    {
    }

    public String getTimeRejected()
    {
        return timeRejected;
    }

    public void setTimeRejected(String timeRejected)
    {
        this.timeRejected = timeRejected;
    }

    public String getPickupInfo()
    {
        return pickupInfo;
    }

    public void setPickupInfo(String pickupInfo)
    {
        this.pickupInfo = pickupInfo;
    }

    public String getPriorityLevel()
    {
        return priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel)
    {
        this.priorityLevel = priorityLevel;
    }

    public String getTimeslot()
    {
        return timeslot;
    }

    public void setTimeslot(String timeslot)
    {
        this.timeslot = timeslot;
    }

    public String getReasonForRejection()
    {
        return reasonForRejection;
    }

    public void setReasonForRejection(String reasonForRejection)
    {
        this.reasonForRejection = reasonForRejection;
    }

    public String getDriverInfo()
    {
        return driverInfo;
    }

    public void setDriverInfo(String driverInfo)
    {
        this.driverInfo = driverInfo;
    }

    public String getRoute()
    {
        return route;
    }

    public void setRoute(String route)
    {
        this.route = route;
    }

    public String getHub()
    {
        return hub;
    }

    public void setHub(String hub)
    {
        this.hub = hub;
    }
}
