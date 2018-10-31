package co.nvqa.operator_v2.model;

/**
 * @author Sergey Mishanin
 */
public class WaypointShipperInfo extends DataEntity<WaypointShipperInfo>
{
    private String shipperName;
    private Long scanned;
    private Long total;

    public String getShipperName()
    {
        return shipperName;
    }

    public void setShipperName(String shipperName)
    {
        this.shipperName = shipperName;
    }

    public Long getScanned()
    {
        return scanned;
    }

    public void setScanned(long scanned)
    {
        this.scanned = scanned;
    }

    public void setScanned(String scanned)
    {
        setScanned(Long.parseLong(scanned));
    }

    public Long getTotal()
    {
        return total;
    }

    public void setTotal(long total)
    {
        this.total = total;
    }

    public void setTotal(String total)
    {
        setTotal(Long.parseLong(total));
    }
}
