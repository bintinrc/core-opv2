package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RunCheckResult
{
    private Double grandTotal;
    private Double deliveryFee;
    private Double codFee;
    private Double insuranceFee;
    private Double handlingFee;
    private Double gst;
    private String comments;

    public RunCheckResult()
    {
    }

    public Double getGrandTotal()
    {
        return grandTotal;
    }

    public void setGrandTotal(Double grandTotal)
    {
        this.grandTotal = grandTotal;
    }

    public Double getDeliveryFee()
    {
        return deliveryFee;
    }

    public void setDeliveryFee(Double deliveryFee)
    {
        this.deliveryFee = deliveryFee;
    }

    public Double getCodFee()
    {
        return codFee;
    }

    public void setCodFee(Double codFee)
    {
        this.codFee = codFee;
    }

    public Double getInsuranceFee()
    {
        return insuranceFee;
    }

    public void setInsuranceFee(Double insuranceFee)
    {
        this.insuranceFee = insuranceFee;
    }

    public Double getHandlingFee()
    {
        return handlingFee;
    }

    public void setHandlingFee(Double handlingFee)
    {
        this.handlingFee = handlingFee;
    }

    public Double getGst()
    {
        return gst;
    }

    public void setGst(Double gst)
    {
        this.gst = gst;
    }

    public String getComments()
    {
        return comments;
    }

    public void setComments(String comments)
    {
        this.comments = comments;
    }
}
