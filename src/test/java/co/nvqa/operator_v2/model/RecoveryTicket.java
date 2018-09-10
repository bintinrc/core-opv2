package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RecoveryTicket
{
    private String trackingId;
    private String entrySource;
    private String investigatingDepartment;
    private String investigatingHub;
    private String ticketType;
    private String ticketSubType;
    private String parcelLocation;
    private String liability;
    private String damageDescription;
    private String orderOutcomeDamaged;
    private String orderOutcomeMissing;
    private String ticketNotes;
    private String custZendeskId;
    private String shipperZendeskId;
    private String parcelDescription;

    public RecoveryTicket()
    {
    }

    public String getTrackingId()
    {
        return trackingId;
    }

    public void setTrackingId(String trackingId)
    {
        this.trackingId = trackingId;
    }

    public String getEntrySource()
    {
        return entrySource;
    }

    public void setEntrySource(String entrySource)
    {
        this.entrySource = entrySource;
    }

    public String getInvestigatingDepartment()
    {
        return investigatingDepartment;
    }

    public void setInvestigatingDepartment(String investigatingDepartment)
    {
        this.investigatingDepartment = investigatingDepartment;
    }

    public String getInvestigatingHub()
    {
        return investigatingHub;
    }

    public void setInvestigatingHub(String investigatingHub)
    {
        this.investigatingHub = investigatingHub;
    }

    public String getTicketType()
    {
        return ticketType;
    }

    public void setTicketType(String ticketType)
    {
        this.ticketType = ticketType;
    }

    public String getTicketSubType()
    {
        return ticketSubType;
    }

    public void setTicketSubType(String ticketSubType)
    {
        this.ticketSubType = ticketSubType;
    }

    public String getParcelLocation()
    {
        return parcelLocation;
    }

    public void setParcelLocation(String parcelLocation)
    {
        this.parcelLocation = parcelLocation;
    }

    public String getLiability()
    {
        return liability;
    }

    public void setLiability(String liability)
    {
        this.liability = liability;
    }

    public String getDamageDescription()
    {
        return damageDescription;
    }

    public void setDamageDescription(String damageDescription)
    {
        this.damageDescription = damageDescription;
    }

    public String getOrderOutcomeDamaged()
    {
        return orderOutcomeDamaged;
    }

    public void setOrderOutcomeDamaged(String orderOutcomeDamaged)
    {
        this.orderOutcomeDamaged = orderOutcomeDamaged;
    }

    public String getOrderOutcomeMissing()
    {
        return orderOutcomeMissing;
    }

    public void setOrderOutcomeMissing(String orderOutcomeMissing)
    {
        this.orderOutcomeMissing = orderOutcomeMissing;
    }

    public String getTicketNotes()
    {
        return ticketNotes;
    }

    public void setTicketNotes(String ticketNotes)
    {
        this.ticketNotes = ticketNotes;
    }

    public String getCustZendeskId()
    {
        return custZendeskId;
    }

    public void setCustZendeskId(String custZendeskId)
    {
        this.custZendeskId = custZendeskId;
    }

    public String getShipperZendeskId()
    {
        return shipperZendeskId;
    }

    public void setShipperZendeskId(String shipperZendeskId)
    {
        this.shipperZendeskId = shipperZendeskId;
    }

    public String getParcelDescription()
    {
        return parcelDescription;
    }

    public void setParcelDescription(String parcelDescription)
    {
        this.parcelDescription = parcelDescription;
    }
}
