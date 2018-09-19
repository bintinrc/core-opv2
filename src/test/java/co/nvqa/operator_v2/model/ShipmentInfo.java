package co.nvqa.operator_v2.model;

/**
 * @author Sergey Mishanin
 */
public class ShipmentInfo extends DataEntity<ShipmentInfo>
{
    private String shipmentType;
    private String id;
    private String createdAt;
    private String transitAt;
    private String status;
    private String origHubName;
    private String currHubName;
    private String destHubName;
    private String arrivalDatetime;
    private String completedAt;
    private String ordersCount;
    private String comments;
    private String mawb;

    public ShipmentInfo()
    {
    }

    public String getShipmentType()
    {
        return shipmentType;
    }

    public void setShipmentType(String shipmentType)
    {
        this.shipmentType = shipmentType;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getCreatedAt()
    {
        return createdAt;
    }

    public void setCreatedAt(String createdAt)
    {
        this.createdAt = createdAt;
    }

    public String getTransitAt()
    {
        return transitAt;
    }

    public void setTransitAt(String transitAt)
    {
        this.transitAt = transitAt;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getOrigHubName()
    {
        return origHubName;
    }

    public void setOrigHubName(String origHubName)
    {
        this.origHubName = origHubName;
    }

    public String getCurrHubName()
    {
        return currHubName;
    }

    public void setCurrHubName(String currHubName)
    {
        this.currHubName = currHubName;
    }

    public String getDestHubName()
    {
        return destHubName;
    }

    public void setDestHubName(String destHubName)
    {
        this.destHubName = destHubName;
    }

    public String getArrivalDatetime()
    {
        return arrivalDatetime;
    }

    public void setArrivalDatetime(String arrivalDatetime)
    {
        this.arrivalDatetime = arrivalDatetime;
    }

    public String getCompletedAt()
    {
        return completedAt;
    }

    public void setCompletedAt(String completedAt)
    {
        this.completedAt = completedAt;
    }

    public String getOrdersCount()
    {
        return ordersCount;
    }

    public void setOrdersCount(String ordersCount)
    {
        this.ordersCount = ordersCount;
    }

    public String getComments()
    {
        return comments;
    }

    public void setComments(String comments)
    {
        this.comments = comments;
    }

    public String getMawb()
    {
        return mawb;
    }

    public void setMawb(String mawb)
    {
        this.mawb = mawb;
    }
}
