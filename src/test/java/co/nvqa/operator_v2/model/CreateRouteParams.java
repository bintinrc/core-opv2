package co.nvqa.operator_v2.model;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class CreateRouteParams
{
    private Date routeDate;
    private String[] routeTags;
    private String zoneName;
    private String hubName;
    private String ninjaDriverName;
    private String vehicleName;
    private String comments;

    public CreateRouteParams()
    {
    }

    public Date getRouteDate()
    {
        return routeDate;
    }

    public void setRouteDate(Date routeDate)
    {
        this.routeDate = routeDate;
    }

    public String[] getRouteTags()
    {
        return routeTags;
    }

    public void setRouteTags(String[] routeTags)
    {
        this.routeTags = routeTags;
    }

    public String getZoneName()
    {
        return zoneName;
    }

    public void setZoneName(String zoneName)
    {
        this.zoneName = zoneName;
    }

    public String getHubName()
    {
        return hubName;
    }

    public void setHubName(String hubName)
    {
        this.hubName = hubName;
    }

    public String getNinjaDriverName()
    {
        return ninjaDriverName;
    }

    public void setNinjaDriverName(String ninjaDriverName)
    {
        this.ninjaDriverName = ninjaDriverName;
    }

    public String getVehicleName()
    {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName)
    {
        this.vehicleName = vehicleName;
    }

    public String getComments()
    {
        return comments;
    }

    public void setComments(String comments)
    {
        this.comments = comments;
    }
}
