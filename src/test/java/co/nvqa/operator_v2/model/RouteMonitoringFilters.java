package co.nvqa.operator_v2.model;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteMonitoringFilters
{
    private Date routeDate;
    private String[] routeTags;
    private String[] hubs;
    private String[] zones;

    public RouteMonitoringFilters()
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

    public String[] getHubs()
    {
        return hubs;
    }

    public void setHubs(String[] hubs)
    {
        this.hubs = hubs;
    }

    public String[] getZones()
    {
        return zones;
    }

    public void setZones(String[] zones)
    {
        this.zones = zones;
    }
}
