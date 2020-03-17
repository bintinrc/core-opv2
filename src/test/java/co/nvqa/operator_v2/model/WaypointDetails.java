package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.util.TestUtils;

/**
 *
 * @author Sergey Mishanin
 */
public class WaypointDetails extends DataEntity<WaypointDetails>
{
    private Long id;
    private String address1;
    private String address2;
    private String city;
    private String country;
    private String postalCode;
    private Double latitude;
    private Double longitude;

    public WaypointDetails()
    {
    }

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public void setId(String id)
    {
        setId(Long.valueOf(id));
    }

    public String getAddress1()
    {
        return address1;
    }

    public void setAddress1(String address1)
    {
        if("GENERATED".equalsIgnoreCase(address1)){
            this.address1 = TestUtils.generateRandomAddress().getAddress1();
        }
        else
        {
            this.address1 = address1;
        }
    }

    public String getAddress2()
    {
        return address2;
    }

    public void setAddress2(String address2)
    {
        if("GENERATED".equalsIgnoreCase(address2)){
            this.address2 = TestUtils.generateRandomAddress().getAddress2();
        }
        else
        {
            this.address2 = address2;
        }
    }

    public String getCity()
    {
        return city;
    }

    public void setCity(String city)
    {
        if("GENERATED".equalsIgnoreCase(city))
        {
            this.city = TestUtils.generateRandomAddress().getCity();
        }
        else
        {
            this.city = city;
        }
    }

    public String getCountry()
    {
        return country;
    }

    public void setCountry(String country)
    {
        if("GENERATED".equalsIgnoreCase(country))
        {
            this.country = TestUtils.generateRandomAddress().getCountry();
        }
        else
        {
            this.country = country;
        }
    }

    public String getPostalCode()
    {
        return postalCode;
    }

    public void setPostalCode(String postalCode)
    {
        if("GENERATED".equalsIgnoreCase(postalCode))
        {
            this.postalCode = TestUtils.generateRandomAddress().getPostcode();
        }
        else
        {
            this.postalCode = postalCode;
        }
    }

    public Double getLatitude()
    {
        return latitude;
    }

    public void setLatitude(Double latitude)
    {
        this.latitude = latitude;
    }

    public void setLatitude(String latitude)
    {
        if("GENERATED".equalsIgnoreCase(latitude))
        {
            setLatitude(TestUtils.generateLatitude());
        }
        else
        {
            setLatitude(Double.valueOf(latitude));
        }
    }

    public Double getLongitude()
    {
        return longitude;
    }

    public void setLongitude(Double longitude)
    {
        this.longitude = longitude;
    }

    public void setLongitude(String longitude)
    {
        if("GENERATED".equalsIgnoreCase(longitude))
        {
            setLongitude(TestUtils.generateLongitude());
        }
        else
        {
            setLongitude(Double.valueOf(longitude));
        }
    }
}
