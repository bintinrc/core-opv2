package co.nvqa.operator_v2.model;

/**
 * @author Sergey Mishanin
 */
public class RouteCleaningReportParcelInfo extends DataEntity<RouteCleaningReportParcelInfo>
{
    private String date;
    private String trackingId;
    private String granularStatus;
    private String lastScanHubId;
    private String exception;
    private String routeId;
    private String lastSeen;
    private String shipperName;
    private String driverName;
    private String lastScanType;

    public RouteCleaningReportParcelInfo()
    {
    }

    public String getDate()
    {
        return date;
    }

    public void setDate(String date)
    {
        this.date = date;
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

    public String getLastScanHubId()
    {
        return lastScanHubId;
    }

    public void setLastScanHubId(String lastScanHubId)
    {
        this.lastScanHubId = lastScanHubId;
    }

    public String getException()
    {
        return exception;
    }

    public void setException(String exception)
    {
        this.exception = exception;
    }

    public String getRouteId()
    {
        return routeId;
    }

    public void setRouteId(String routeId)
    {
        this.routeId = routeId;
    }

    public String getLastSeen()
    {
        return lastSeen;
    }

    public void setLastSeen(String lastSeen)
    {
        this.lastSeen = lastSeen;
    }

    public String getShipperName()
    {
        return shipperName;
    }

    public void setShipperName(String shipperName)
    {
        this.shipperName = shipperName;
    }

    public String getDriverName()
    {
        return driverName;
    }

    public void setDriverName(String driverName)
    {
        this.driverName = driverName;
    }

    public String getLastScanType()
    {
        return lastScanType;
    }

    public void setLastScanType(String lastScanType)
    {
        this.lastScanType = lastScanType;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setDate(getValueIfIndexExists(values, 0));
        setTrackingId(getValueIfIndexExists(values, 1));
        setGranularStatus(getValueIfIndexExists(values, 2));
        setLastScanHubId(getValueIfIndexExists(values, 3));
        setDriverName(getValueIfIndexExists(values, 4));
        setRouteId(getValueIfIndexExists(values, 4));
        setLastSeen(getValueIfIndexExists(values, 4));
        setShipperName(getValueIfIndexExists(values, 4));
        setDriverName(getValueIfIndexExists(values, 4));
        setLastScanType(getValueIfIndexExists(values, 4));
    }
}
