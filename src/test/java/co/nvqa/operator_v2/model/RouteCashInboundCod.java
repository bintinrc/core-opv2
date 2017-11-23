package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCashInboundCod
{
    private long routeId;
    private Double amountCollected;
    private String receiptNumber;

    public RouteCashInboundCod()
    {
    }

    public long getRouteId()
    {
        return routeId;
    }

    public void setRouteId(long routeId)
    {
        this.routeId = routeId;
    }

    public Double getAmountCollected()
    {
        return amountCollected;
    }

    public void setAmountCollected(Double amountCollected)
    {
        this.amountCollected = amountCollected;
    }

    public String getReceiptNumber()
    {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber)
    {
        this.receiptNumber = receiptNumber;
    }
}
