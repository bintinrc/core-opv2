package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.StandardTestConstants;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class ShipmentInfo extends DataEntity<ShipmentInfo>
{

    private static final DateTimeFormatter FE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
    private static final DateTimeFormatter BE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");

    private String shipmentType;
    private Long id;
    private String createdAt;
    private String transitAt;
    private String status;
    private String origHubName;
    private String currHubName;
    private String destHubName;
    private String arrivalDatetime;
    private String completedAt;
    private int ordersCount;
    private String comments;
    private String mawb;

    public ShipmentInfo()
    {
    }

    public ShipmentInfo (Shipments shipments)
    {
        setShipmentType(shipments.getShipment().getShipmentType());
        setId(shipments.getShipment().getId());
        setCreatedAt(normalisedDate(shipments.getShipment().getCreatedAt()));
        setTransitAt(normalisedDate(shipments.getShipment().getTransitAt()));
        setStatus(shipments.getShipment().getStatus());
        setOrigHubName(shipments.getShipment().getOrigHubName());
        setCurrHubName(shipments.getShipment().getCurrHubName());
        setDestHubName(shipments.getShipment().getDestHubName());
        setArrivalDatetime(normalisedDate(shipments.getShipment().getArrivalDatetime()));
        setCompletedAt(normalisedDate(shipments.getShipment().getCompletedAt()));
        setOrdersCount(Math.toIntExact(shipments.getShipment().getOrdersCount()));
        setComments(shipments.getShipment().getComments());
        setMawb(shipments.getShipment().getMawb());
    }

    private String normalisedDate(String originDate)
    {
        if (originDate == null)
        {
            return null;
        }

        final ZonedDateTime zdt = ZonedDateTime.parse(originDate, BE_FORMATTER);
        ZonedDateTime normalisedZdt = zdt
                .withZoneSameInstant(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));

        int nano = normalisedZdt.getNano();
        if (nano >= 500_000L) {
            normalisedZdt = normalisedZdt.plusSeconds(1L);
        }
        return normalisedZdt.format(FE_FORMATTER);
    }

    public String getShipmentType()
    {
        return shipmentType;
    }

    public void setShipmentType(String shipmentType)
    {
        this.shipmentType = shipmentType;
    }

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
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

    public int getOrdersCount()
    {
        return ordersCount;
    }

    public void setOrdersCount(int ordersCount)
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
