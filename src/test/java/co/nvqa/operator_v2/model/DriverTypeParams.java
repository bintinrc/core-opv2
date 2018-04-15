package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverTypeParams
{
    private Long driverTypeId;
    private String driverTypeName;

    public DriverTypeParams()
    {
    }

    public Long getDriverTypeId()
    {
        return driverTypeId;
    }

    public void setDriverTypeId(Long driverTypeId)
    {
        this.driverTypeId = driverTypeId;
    }

    public String getDriverTypeName()
    {
        return driverTypeName;
    }

    public void setDriverTypeName(String driverTypeName)
    {
        this.driverTypeName = driverTypeName;
    }
}
