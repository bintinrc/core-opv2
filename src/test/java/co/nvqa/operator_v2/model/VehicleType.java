package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

/**
 * @author Sergey Mishanin
 */
public class VehicleType extends DataEntity<VehicleType>
{
    private Long id;
    private String name;
    private String systemId;

    public VehicleType()
    {
    }

    public VehicleType(VehicleType anotherVehicleType)
    {
        id = anotherVehicleType.getId();
        name = anotherVehicleType.getName();
        systemId = anotherVehicleType.getSystemId();
    }

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getSystemId()
    {
        return systemId;
    }

    public void setSystemId(String systemId)
    {
        this.systemId = systemId;
    }
}
