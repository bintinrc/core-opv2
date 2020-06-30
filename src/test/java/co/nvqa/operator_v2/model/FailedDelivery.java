package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Sergey Mishanin
 */
public class FailedDelivery extends DataEntity<FailedDelivery>
{
    private String trackingId;
    private String type;
    private String shipperName;
    private String lastAttemptTime;
    private String failureReasonComments;
    private Integer attemptCount;
    private Integer invalidFailureCount;
    private Integer validFailureCount;
    private String failureReasonCodeDescription;
    private Integer daysSinceLastAttempt;
    private Integer priorityLevel;
    private String lastScannedHubName;
    private String orderTags;

    public String getTrackingId()
    {
        return trackingId;
    }

    public void setTrackingId(String trackingId)
    {
        this.trackingId = trackingId;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getShipperName()
    {
        return shipperName;
    }

    public void setShipperName(String shipperName)
    {
        this.shipperName = shipperName;
    }

    public String getLastAttemptTime()
    {
        return lastAttemptTime;
    }

    public void setLastAttemptTime(String lastAttemptTime)
    {
        this.lastAttemptTime = lastAttemptTime;
    }

    public String getFailureReasonComments()
    {
        return failureReasonComments;
    }

    public void setFailureReasonComments(String failureReasonComments)
    {
        this.failureReasonComments = failureReasonComments;
    }

    public Integer getAttemptCount()
    {
        return attemptCount;
    }

    public void setAttemptCount(Integer attemptCount)
    {
        this.attemptCount = attemptCount;
    }

    public void setAttemptCount(String attemptCount)
    {
        setAttemptCount(Integer.valueOf(attemptCount));
    }

    public Integer getInvalidFailureCount()
    {
        return invalidFailureCount;
    }

    public void setInvalidFailureCount(Integer invalidFailureCount)
    {
        this.invalidFailureCount = invalidFailureCount;
    }

    public void setInvalidFailureCount(String invalidFailureCount)
    {
        setInvalidFailureCount(Integer.valueOf(invalidFailureCount));
    }

    public Integer getValidFailureCount()
    {
        return validFailureCount;
    }

    public void setValidFailureCount(Integer validFailureCount)
    {
        this.validFailureCount = validFailureCount;
    }

    public void setValidFailureCount(String validFailureCount)
    {
        setValidFailureCount(Integer.valueOf(validFailureCount));
    }

    public String getFailureReasonCodeDescription()
    {
        return failureReasonCodeDescription;
    }

    public void setFailureReasonCodeDescription(String failureReasonCodeDescription)
    {
        this.failureReasonCodeDescription = failureReasonCodeDescription;
    }

    public Integer getDaysSinceLastAttempt()
    {
        return daysSinceLastAttempt;
    }

    public void setDaysSinceLastAttempt(Integer daysSinceLastAttempt)
    {
        this.daysSinceLastAttempt = daysSinceLastAttempt;
    }

    public void setDaysSinceLastAttempt(String daysSinceLastAttempt)
    {
        if ("today".equalsIgnoreCase(daysSinceLastAttempt)){
            daysSinceLastAttempt = "0";
        }
        setDaysSinceLastAttempt(Integer.valueOf(daysSinceLastAttempt));
    }

    public Integer getPriorityLevel()
    {
        return priorityLevel;
    }

    public void setPriorityLevel(Integer priorityLevel)
    {
        this.priorityLevel = priorityLevel;
    }

    public void setPriorityLevel(String priorityLevel)
    {
        setPriorityLevel(Integer.valueOf(priorityLevel));
    }


    public String getLastScannedHubName()
    {
        return lastScannedHubName;
    }

    public void setLastScannedHubName(String lastScannedHubName)
    {
        this.lastScannedHubName = lastScannedHubName;
    }

    public String getOrderTags()
    {
        return orderTags;
    }

    public void setOrderTags(String orderTags)
    {
        this.orderTags = orderTags;
    }
}
