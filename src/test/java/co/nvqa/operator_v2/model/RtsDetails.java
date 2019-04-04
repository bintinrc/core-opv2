package co.nvqa.operator_v2.model;

import co.nvqa.commons.support.DateUtil;

import java.text.ParseException;
import java.util.Date;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
public class RtsDetails extends DataEntity<RtsDetails>
{
    private String reason;
    private String internalNotes;
    private Date deliveryDate;
    private String timeSlot;
    private RtsAddress address;

    public RtsDetails()
    {
    }

    public String getReason()
    {
        return reason;
    }

    public void setReason(String reason)
    {
        this.reason = reason;
    }

    public String getInternalNotes()
    {
        return internalNotes;
    }

    public void setInternalNotes(String internalNotes)
    {
        this.internalNotes = internalNotes;
    }

    public Date getDeliveryDate()
    {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate)
    {
        this.deliveryDate = deliveryDate;
    }

    public void setDeliveryDate(String deliveryDate) throws ParseException
    {
        setDeliveryDate(DateUtil.SDF_YYYY_MM_DD.parse(deliveryDate));
    }

    public RtsAddress getAddress()
    {
        return address;
    }

    public void setAddress(RtsAddress address)
    {
        this.address = address;
    }

    public String getTimeSlot()
    {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot)
    {
        this.timeSlot = timeSlot;
    }

    public static class RtsAddress extends DataEntity<RtsAddress>
    {
        private String country;
        private String city;
        private String address1;
        private String address2;
        private String postcode;

        public String getCountry()
        {
            return country;
        }

        public void setCountry(String country)
        {
            this.country = country;
        }

        public String getCity()
        {
            return city;
        }

        public void setCity(String city)
        {
            this.city = city;
        }

        public String getAddress1()
        {
            return address1;
        }

        public void setAddress1(String address1)
        {
            this.address1 = address1;
        }

        public String getAddress2()
        {
            return address2;
        }

        public void setAddress2(String address2)
        {
            this.address2 = address2;
        }

        public String getPostcode()
        {
            return postcode;
        }

        public void setPostcode(String postcode)
        {
            this.postcode = postcode;
        }
    }
}
