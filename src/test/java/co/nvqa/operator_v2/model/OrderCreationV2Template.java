package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class OrderCreationV2Template
{
    private Long shipperId;
    private String orderNo;
    private String shipperOrderNo;
    private String orderType;
    private String toFirstName;
    private String toLastName;
    private String toContact;
    private String toEmail;
    private String toAddress1;
    private String toAddress2;
    private String toPostcode;
    private String toDistrict;
    private String toCity;
    private String toStateOrProvince;
    private String toCountry;
    private Integer parcelSize;
    private Integer weight;
    private Integer length;
    private Integer width;
    private Integer height;
    private String deliveryDate;
    private Integer deliveryTimewindowId;
    private Integer maxDeliveryDays;
    private String pickupDate;
    private Integer pickupTimewindowId;
    private boolean pickupWeekend;
    private boolean deliveryWeekend;
    private String pickupInstruction;
    private String deliveryInstruction;
    private Double codValue;
    private Double insuredValue;
    private String fromFirstName;
    private String fromLastName;
    private String fromContact;
    private String fromEmail;
    private String fromAddress1;
    private String fromAddress2;
    private String fromPostcode;
    private String fromDistrict;
    private String fromCity;
    private String fromStateOrProvince;
    private String fromCountry;
    private String multiParcelRefNo;

    public OrderCreationV2Template()
    {
    }

    public Long getShipperId()
    {
        return shipperId;
    }

    public void setShipperId(Long shipperId)
    {
        this.shipperId = shipperId;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
    }

    public String getShipperOrderNo()
    {
        return shipperOrderNo;
    }

    public void setShipperOrderNo(String shipperOrderNo)
    {
        this.shipperOrderNo = shipperOrderNo;
    }

    public String getOrderType()
    {
        return orderType;
    }

    public void setOrderType(String orderType)
    {
        this.orderType = orderType;
    }

    public String getToFirstName()
    {
        return toFirstName;
    }

    public void setToFirstName(String toFirstName)
    {
        this.toFirstName = toFirstName;
    }

    public String getToLastName()
    {
        return toLastName;
    }

    public void setToLastName(String toLastName)
    {
        this.toLastName = toLastName;
    }

    public String getToContact()
    {
        return toContact;
    }

    public void setToContact(String toContact)
    {
        this.toContact = toContact;
    }

    public String getToEmail()
    {
        return toEmail;
    }

    public void setToEmail(String toEmail)
    {
        this.toEmail = toEmail;
    }

    public String getToAddress1()
    {
        return toAddress1;
    }

    public void setToAddress1(String toAddress1)
    {
        this.toAddress1 = toAddress1;
    }

    public String getToAddress2()
    {
        return toAddress2;
    }

    public void setToAddress2(String toAddress2)
    {
        this.toAddress2 = toAddress2;
    }

    public String getToPostcode()
    {
        return toPostcode;
    }

    public void setToPostcode(String toPostcode)
    {
        this.toPostcode = toPostcode;
    }

    public String getToDistrict()
    {
        return toDistrict;
    }

    public void setToDistrict(String toDistrict)
    {
        this.toDistrict = toDistrict;
    }

    public String getToCity()
    {
        return toCity;
    }

    public void setToCity(String toCity)
    {
        this.toCity = toCity;
    }

    public String getToStateOrProvince()
    {
        return toStateOrProvince;
    }

    public void setToStateOrProvince(String toStateOrProvince)
    {
        this.toStateOrProvince = toStateOrProvince;
    }

    public String getToCountry()
    {
        return toCountry;
    }

    public void setToCountry(String toCountry)
    {
        this.toCountry = toCountry;
    }

    public Integer getParcelSize()
    {
        return parcelSize;
    }

    public void setParcelSize(Integer parcelSize)
    {
        this.parcelSize = parcelSize;
    }

    public Integer getWeight()
    {
        return weight;
    }

    public void setWeight(Integer weight)
    {
        this.weight = weight;
    }

    public Integer getLength()
    {
        return length;
    }

    public void setLength(Integer length)
    {
        this.length = length;
    }

    public Integer getWidth()
    {
        return width;
    }

    public void setWidth(Integer width)
    {
        this.width = width;
    }

    public Integer getHeight()
    {
        return height;
    }

    public void setHeight(Integer height)
    {
        this.height = height;
    }

    public String getDeliveryDate()
    {
        return deliveryDate;
    }

    public void setDeliveryDate(String deliveryDate)
    {
        this.deliveryDate = deliveryDate;
    }

    public Integer getDeliveryTimewindowId()
    {
        return deliveryTimewindowId;
    }

    public void setDeliveryTimewindowId(Integer deliveryTimewindowId)
    {
        this.deliveryTimewindowId = deliveryTimewindowId;
    }

    public Integer getMaxDeliveryDays()
    {
        return maxDeliveryDays;
    }

    public void setMaxDeliveryDays(Integer maxDeliveryDays)
    {
        this.maxDeliveryDays = maxDeliveryDays;
    }

    public String getPickupDate()
    {
        return pickupDate;
    }

    public void setPickupDate(String pickupDate)
    {
        this.pickupDate = pickupDate;
    }

    public Integer getPickupTimewindowId()
    {
        return pickupTimewindowId;
    }

    public void setPickupTimewindowId(Integer pickupTimewindowId)
    {
        this.pickupTimewindowId = pickupTimewindowId;
    }

    public boolean isPickupWeekend()
    {
        return pickupWeekend;
    }

    public void setPickupWeekend(boolean pickupWeekend)
    {
        this.pickupWeekend = pickupWeekend;
    }

    public boolean isDeliveryWeekend()
    {
        return deliveryWeekend;
    }

    public void setDeliveryWeekend(boolean deliveryWeekend)
    {
        this.deliveryWeekend = deliveryWeekend;
    }

    public String getPickupInstruction()
    {
        return pickupInstruction;
    }

    public void setPickupInstruction(String pickupInstruction)
    {
        this.pickupInstruction = pickupInstruction;
    }

    public String getDeliveryInstruction()
    {
        return deliveryInstruction;
    }

    public void setDeliveryInstruction(String deliveryInstruction)
    {
        this.deliveryInstruction = deliveryInstruction;
    }

    public Double getCodValue()
    {
        return codValue;
    }

    public void setCodValue(Double codValue)
    {
        this.codValue = codValue;
    }

    public Double getInsuredValue()
    {
        return insuredValue;
    }

    public void setInsuredValue(Double insuredValue)
    {
        this.insuredValue = insuredValue;
    }

    public String getFromFirstName()
    {
        return fromFirstName;
    }

    public void setFromFirstName(String fromFirstName)
    {
        this.fromFirstName = fromFirstName;
    }

    public String getFromLastName()
    {
        return fromLastName;
    }

    public void setFromLastName(String fromLastName)
    {
        this.fromLastName = fromLastName;
    }

    public String getFromContact()
    {
        return fromContact;
    }

    public void setFromContact(String fromContact)
    {
        this.fromContact = fromContact;
    }

    public String getFromEmail()
    {
        return fromEmail;
    }

    public void setFromEmail(String fromEmail)
    {
        this.fromEmail = fromEmail;
    }

    public String getFromAddress1()
    {
        return fromAddress1;
    }

    public void setFromAddress1(String fromAddress1)
    {
        this.fromAddress1 = fromAddress1;
    }

    public String getFromAddress2()
    {
        return fromAddress2;
    }

    public void setFromAddress2(String fromAddress2)
    {
        this.fromAddress2 = fromAddress2;
    }

    public String getFromPostcode()
    {
        return fromPostcode;
    }

    public void setFromPostcode(String fromPostcode)
    {
        this.fromPostcode = fromPostcode;
    }

    public String getFromDistrict()
    {
        return fromDistrict;
    }

    public void setFromDistrict(String fromDistrict)
    {
        this.fromDistrict = fromDistrict;
    }

    public String getFromCity()
    {
        return fromCity;
    }

    public void setFromCity(String fromCity)
    {
        this.fromCity = fromCity;
    }

    public String getFromStateOrProvince()
    {
        return fromStateOrProvince;
    }

    public void setFromStateOrProvince(String fromStateOrProvince)
    {
        this.fromStateOrProvince = fromStateOrProvince;
    }

    public String getFromCountry()
    {
        return fromCountry;
    }

    public void setFromCountry(String fromCountry)
    {
        this.fromCountry = fromCountry;
    }

    public String getMultiParcelRefNo()
    {
        return multiParcelRefNo;
    }

    public void setMultiParcelRefNo(String multiParcelRefNo)
    {
        this.multiParcelRefNo = multiParcelRefNo;
    }
}
