package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;
import java.util.Optional;

/**
 * @author Sergey Mishanin
 */
public class Dp extends DataEntity<Dp>
{
    private Long id;
    private Long dpmsId;
    private String name;
    private String shortName;
    private String type;
    private Boolean canShipperLodgeIn;
    private Boolean canCustomerCollect;
    private String service;
    private String driverCollectionMode;
    private Long maxParcelStayDuration;
    private String maxCap;
    private String capBuffer;
    private String contactNo;
    private String hub;
    private String address;
    private String address1;
    private String address2;
    private String unitNo;
    private String floorNo;
    private String city;
    private String country;
    private String postcode;
    private String directions;
    private String activity;
    private Double latitude;
    private Double longitude;

    public Dp()
    {
    }

    public Dp(Map<String, ?> dataMap)
    {
        fromMap(dataMap);
        Hub hub = HubFactory.getRandomHub();
        setLatitude(Optional.ofNullable(getLatitude()).orElse(hub.getLatitude()));
        setLongitude(Optional.ofNullable(getLongitude()).orElse(hub.getLongitude()));
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
        setId(Long.parseLong(id));
    }

    public Long getDpmsId()
    {
        return dpmsId;
    }

    public void setDpmsId(Long dpmsId)
    {
        this.dpmsId = dpmsId;
    }

    public void setDpmsId(String dpmsId)
    {
        setDpmsId(Long.parseLong(dpmsId));
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        if ("generated".equalsIgnoreCase(name))
        {
            name = "DP-" + TestUtils.generateDateUniqueString();
        }
        this.name = name;
    }

    public String getShortName()
    {
        return shortName;
    }

    public void setShortName(String shortName)
    {
        this.shortName = shortName;
    }

    public String getHub()
    {
        return hub;
    }

    public void setHub(String hub)
    {
        this.hub = StringUtils.strip(hub, "-");
    }

    public String getAddress1()
    {
        return address1;
    }

    public void setAddress1(String address1)
    {
        this.address1 = address1;
    }

    public String getAddress()
    {
        if (StringUtils.isNotBlank(address))
        {
            return address;
        } else
        {
            return StringUtils.trimToEmpty(getAddress1()) + " " + StringUtils.trimToEmpty(getAddress2()) +
                    " " + StringUtils.trimToEmpty(getCity()) +
                    " " + StringUtils.trimToEmpty(getPostcode()) +
                    " " + StringUtils.trimToEmpty(getCountry());
        }

    }

    public void setAddress(String address)
    {
        this.address = address;
    }

    public String getAddress2()
    {
        return address2;
    }

    public void setAddress2(String address2)
    {
        this.address2 = address2;
    }

    public String getUnitNo()
    {
        return unitNo;
    }

    public void setUnitNo(String unitNo)
    {
        this.unitNo = unitNo;
    }

    public String getFloorNo()
    {
        return floorNo;
    }

    public void setFloorNo(String floorNo)
    {
        this.floorNo = floorNo;
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

    public String getPostcode()
    {
        return postcode;
    }

    public void setPostcode(String postcode)
    {
        this.postcode = postcode;
    }

    public String getDirections()
    {
        return directions;
    }

    public void setDirections(String directions)
    {
        this.directions = directions;
    }

    public String getActivity()
    {
        return activity;
    }

    public void setActivity(String activity)
    {
        this.activity = activity;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public String getService()
    {
        return service;
    }

    public void setService(String service)
    {
        this.service = service;
    }

    public String getDriverCollectionMode()
    {
        return driverCollectionMode;
    }

    public void setDriverCollectionMode(String driverCollectionMode)
    {
        this.driverCollectionMode = driverCollectionMode;
    }

    public Long getMaxParcelStayDuration()
    {
        return maxParcelStayDuration;
    }

    public void setMaxParcelStayDuration(Long maxParcelStayDuration)
    {
        this.maxParcelStayDuration = maxParcelStayDuration;
    }

    public void setMaxParcelStayDuration(String maxParcelStayDuration)
    {
        setMaxParcelStayDuration(Long.parseLong(maxParcelStayDuration));
    }

    public String getContactNo()
    {
        return contactNo;
    }

    public void setContactNo(String contactNo)
    {
        if ("generated".equalsIgnoreCase(contactNo))
        {
            contactNo = TestUtils.generatePhoneNumber();
        }
        this.contactNo = contactNo;
    }

    public Boolean getCanShipperLodgeIn()
    {
        return canShipperLodgeIn;
    }

    public void setCanShipperLodgeIn(Boolean canShipperLodgeIn)
    {
        this.canShipperLodgeIn = canShipperLodgeIn;
    }

    public void setCanShipperLodgeIn(String canShipperLodgeIn)
    {
        setCanShipperLodgeIn(Boolean.parseBoolean(canShipperLodgeIn));
    }

    public Boolean getCanCustomerCollect()
    {
        return canCustomerCollect;
    }

    public void setCanCustomerCollect(Boolean canCustomerCollect)
    {
        this.canCustomerCollect = canCustomerCollect;
    }

    public void setCanCustomerCollect(String canCustomerCollect)
    {
        setCanCustomerCollect(Boolean.parseBoolean(canCustomerCollect));
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setId(getValueIfIndexExists(values, 0));
        setName(getValueIfIndexExists(values, 1));
        setShortName(getValueIfIndexExists(values, 2));
        setHub(getValueIfIndexExists(values, 3));
        setAddress(getValueIfIndexExists(values, 4));
        setDirections(getValueIfIndexExists(values, 5));
        setActivity(getValueIfIndexExists(values, 6));
    }

    public String getMaxCap()
    {
        return maxCap;
    }

    public void setMaxCap(String maxCap)
    {
        this.maxCap = maxCap;
    }

    public String getCapBuffer()
    {
        return capBuffer;
    }

    public void setCapBuffer(String capBuffer)
    {
        this.capBuffer = capBuffer;
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
