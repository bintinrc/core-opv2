package co.nvqa.operator_v2.model;

/**
 *
 * @author Sergey Mishanin
 */
public class RouteCleaningReportCodInfo extends DataEntity<RouteCleaningReportCodInfo>
{
    private String codInbound;
    private String codExpected;
    private Long routeId;
    private String driverName;

    public RouteCleaningReportCodInfo()
    {
    }

    public String getCodInbound()
    {
        return codInbound;
    }

    public void setCodInbound(String codInbound)
    {
        this.codInbound = codInbound;
    }

    public String getCodExpected()
    {
        return codExpected;
    }

    public void setCodExpected(String codExpected)
    {
        this.codExpected = codExpected;
    }

    public Long getRouteId()
    {
        return routeId;
    }

    public void setRouteId(Long routeId)
    {
        this.routeId = routeId;
    }

    public void setRouteId(String routeId)
    {
        setRouteId(Long.valueOf(routeId));
    }

    public String getDriverName()
    {
        return driverName;
    }

    public void setDriverName(String driverName)
    {
        this.driverName = driverName;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setCodInbound(getValueIfIndexExists(values, 0));
        setCodExpected(getValueIfIndexExists(values, 1));
        setRouteId(getValueIfIndexExists(values, 2));
        setDriverName(getValueIfIndexExists(values, 3));
    }
}
