package co.nvqa.operator_v2.model;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class RouteMonitoringParams extends DataEntity<RouteMonitoringParams>
{
    private Long routeId;
    private Integer totalWaypoint;
    private Integer completionPercentage;
    private Integer pendingCount;
    private Integer successCount;
    private Integer failedCount;
    private Integer cmiCount;
    private Integer earlyCount;
    private Integer lateCount;

    public RouteMonitoringParams(){}

    public RouteMonitoringParams(Map<String, String> data){
        fromMap(data);
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
        setRouteId(Long.parseLong(routeId));
    }

    public Integer getTotalWaypoint()
    {
        return totalWaypoint;
    }

    public void setTotalWaypoint(Integer totalWaypoint)
    {
        this.totalWaypoint = totalWaypoint;
    }

    public void setTotalWaypoint(String totalWaypoint)
    {
        setTotalWaypoint(Integer.parseInt(totalWaypoint));
    }

    public Integer getCompletionPercentage()
    {
        return completionPercentage;
    }

    public void setCompletionPercentage(Integer completionPercentage)
    {
        this.completionPercentage = completionPercentage;
    }

    public void setCompletionPercentage(String completionPercentage)
    {
        setCompletionPercentage(Integer.parseInt(completionPercentage));
    }

    public Integer getPendingCount()
    {
        return pendingCount;
    }

    public void setPendingCount(Integer pendingCount)
    {
        this.pendingCount = pendingCount;
    }

    public void setPendingCount(String pendingCount)
    {
        setPendingCount(Integer.parseInt(pendingCount));
    }

    public Integer getSuccessCount()
    {
        return successCount;
    }

    public void setSuccessCount(Integer successCount)
    {
        this.successCount = successCount;
    }

    public void setSuccessCount(String successCount)
    {
        setSuccessCount(Integer.parseInt(successCount));
    }

    public Integer getFailedCount()
    {
        return failedCount;
    }

    public void setFailedCount(Integer failedCount)
    {
        this.failedCount = failedCount;
    }

    public void setFailedCount(String failedCount)
    {
        setFailedCount(Integer.parseInt(failedCount));
    }

    public Integer getCmiCount()
    {
        return cmiCount;
    }

    public void setCmiCount(Integer cmiCount)
    {
        this.cmiCount = cmiCount;
    }

    public void setCmiCount(String cmiCount)
    {
        setCmiCount(Integer.parseInt(cmiCount));
    }

    public Integer getEarlyCount()
    {
        return earlyCount;
    }

    public void setEarlyCount(Integer earlyCount)
    {
        this.earlyCount = earlyCount;
    }

    public void setEarlyCount(String earlyCount)
    {
        setEarlyCount(Integer.parseInt(earlyCount));
    }

    public Integer getLateCount()
    {
        return lateCount;
    }

    public void setLateCount(Integer lateCount)
    {
        this.lateCount = lateCount;
    }

    public void setLateCount(String lateCount)
    {
        setLateCount(Integer.parseInt(lateCount));
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        throw new UnsupportedOperationException();
    }
}
