package co.nvqa.operator_v2.model;

/**
 * @author Sergey Mishanin
 */
public class RouteCleaningReportCodInfo extends DataEntity<RouteCleaningReportCodInfo>
{
    private String routeDate;
    private Double codInbound;
    private Double codExpected;
    private Long routeId;
    private String driverName;

    public RouteCleaningReportCodInfo()
    {
    }

    public Double getCodInbound()
    {
        return codInbound;
    }

    public void setCodInbound(Double codInbound)
    {
        this.codInbound = codInbound;
    }

    public void setCodInbound(String codInbound)
    {
        setCodInbound(Double.valueOf(codInbound));
    }

    public Double getCodExpected()
    {
        return codExpected;
    }

    public void setCodExpected(Double codExpected)
    {
        this.codExpected = codExpected;
    }

    public void setCodExpected(String codExpected)
    {
        setCodExpected(Double.valueOf(codExpected));
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

    public String getRouteDate()
    {
        return routeDate;
    }

    public void setRouteDate(String routeDate)
    {
        this.routeDate = routeDate;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setRouteDate(getValueIfIndexExists(values, 0));
        setCodInbound(getValueIfIndexExists(values, 1));
        setCodExpected(getValueIfIndexExists(values, 2));
        setRouteId(getValueIfIndexExists(values, 3));
        setDriverName(getValueIfIndexExists(values, 4));
    }
}
