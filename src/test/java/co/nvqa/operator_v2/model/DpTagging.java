package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class DpTagging extends DataEntity<DpTagging>
{
    private String trackingId;
    private Long dpId;

    public DpTagging()
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

    public Long getDpId()
    {
        return dpId;
    }

    public void setDpId(Long dpId)
    {
        this.dpId = dpId;
    }
}
