package com.nv.qa.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpVault
{
    private String name;
    private Long appVersion;
    private String dpName;
    private String address1;
    private String address2;
    private String city;
    private String country;
    private Double latitude;
    private Double longitude;

    public DpVault()
    {
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public Long getAppVersion()
    {
        return appVersion;
    }

    public void setAppVersion(Long appVersion)
    {
        this.appVersion = appVersion;
    }

    public String getDpName()
    {
        return dpName;
    }

    public void setDpName(String dpName)
    {
        this.dpName = dpName;
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

    public String getCity()
    {
        return city;
    }

    public void setCity(String city)
    {
        this.city = city;
    }

    public String getCountry()
    {
        return country;
    }

    public void setCountry(String country)
    {
        this.country = country;
    }

    public Double getLatitude()
    {
        return latitude;
    }

    public void setLatitude(Double latitude)
    {
        this.latitude = latitude;
    }

    public Double getLongitude()
    {
        return longitude;
    }

    public void setLongitude(Double longitude)
    {
        this.longitude = longitude;
    }
}
