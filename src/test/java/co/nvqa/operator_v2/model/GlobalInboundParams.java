package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class GlobalInboundParams
{
    private String hubName;
    private String deviceId;
    private String trackingId;
    private String overrideSize;
    private Double overrideWeight;
    private Double overrideDimHeight;
    private Double overrideDimWidth;
    private Double overrideDimLength;
    private String tags;

    public GlobalInboundParams()
    {
    }

    public String getHubName()
    {
        return hubName;
    }

    public void setHubName(String hubName)
    {
        this.hubName = hubName;
    }

    public String getDeviceId()
    {
        return deviceId;
    }

    public void setDeviceId(String deviceId)
    {
        this.deviceId = deviceId;
    }

    public String getTrackingId()
    {
        return trackingId;
    }

    public void setTrackingId(String trackingId)
    {
        this.trackingId = trackingId;
    }

    public String getOverrideSize()
    {
        return overrideSize;
    }

    public void setOverrideSize(String overrideSize)
    {
        this.overrideSize = overrideSize;
    }

    public Double getOverrideWeight()
    {
        return overrideWeight;
    }

    public void setOverrideWeight(Double overrideWeight)
    {
        this.overrideWeight = overrideWeight;
    }

    public Double getOverrideDimHeight()
    {
        return overrideDimHeight;
    }

    public void setOverrideDimHeight(Double overrideDimHeight)
    {
        this.overrideDimHeight = overrideDimHeight;
    }

    public Double getOverrideDimWidth()
    {
        return overrideDimWidth;
    }

    public void setOverrideDimWidth(Double overrideDimWidth)
    {
        this.overrideDimWidth = overrideDimWidth;
    }

    public Double getOverrideDimLength()
    {
        return overrideDimLength;
    }

    public void setOverrideDimLength(Double overrideDimLength)
    {
        this.overrideDimLength = overrideDimLength;
    }

    public String getTags()
    {
        return tags;
    }

    public void setTags(String tags)
    {
        this.tags = tags;
    }
}
