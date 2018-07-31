package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class DriverInfo extends DataEntity<DriverInfo>
{
    private String uuid;
    private Long id;
    private String firstName;
    private String lastName;
    private String licenseNumber;
    private String type;
    private Integer codLimit;
    private String vehicleLicenseNumber;
    private Integer vehicleCapacity;
    private String contactType;
    private String contact;
    private String zoneId;
    private Integer zoneMin;
    private Integer zoneMax;
    private Integer zoneCost;
    private String username;
    private String password;
    private String comments;

    public String getUuid()
    {
        return uuid;
    }

    public void setUuid(String uuid)
    {
        this.uuid = uuid;
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

    public String getFirstName()
    {
        return firstName;
    }

    public void setFirstName(String firstName)
    {
        if("GENERATED".equalsIgnoreCase(firstName))
        {
            firstName = "Driver";
        }
        this.firstName = firstName;
    }

    public String getLastName()
    {
        return lastName;
    }

    public void setLastName(String lastName)
    {
        if("GENERATED".equalsIgnoreCase(lastName))
        {
            lastName = TestUtils.generateDateUniqueString();
        }
        this.lastName = lastName;
    }

    public String getLicenseNumber()
    {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber)
    {
        if("GENERATED".equalsIgnoreCase(licenseNumber))
        {
            licenseNumber = "D" + DateUtil.getTimestamp();
        }
        this.licenseNumber = licenseNumber;
    }

    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

    public Integer getCodLimit()
    {
        return codLimit;
    }

    public void setCodLimit(Integer codLimit)
    {
        this.codLimit = codLimit;
    }

    public void setCodLimit(String codLimit)
    {
        setCodLimit(Integer.valueOf(codLimit));
    }

    public String getVehicleLicenseNumber()
    {
        return vehicleLicenseNumber;
    }

    public void setVehicleLicenseNumber(String vehicleLicenseNumber)
    {
        if("GENERATED".equalsIgnoreCase(vehicleLicenseNumber))
        {
            vehicleLicenseNumber = "D" + DateUtil.getTimestamp();
        }
        this.vehicleLicenseNumber = vehicleLicenseNumber;
    }

    public Integer getVehicleCapacity()
    {
        return vehicleCapacity;
    }

    public void setVehicleCapacity(Integer vehicleCapacity)
    {
        this.vehicleCapacity = vehicleCapacity;
    }

    public void setVehicleCapacity(String vehicleCapacity)
    {
        setVehicleCapacity(Integer.valueOf(vehicleCapacity));
    }

    public String getContactType()
    {
        return contactType;
    }

    public void setContactType(String contactType)
    {
        this.contactType = contactType;
    }

    public String getContact()
    {
        return contact;
    }

    public void setContact(String contact)
    {
        if("GENERATED".equalsIgnoreCase(contact))
        {
            contact = "D" + DateUtil.getTimestamp() + "@ninjavan.co";
        }
        this.contact = contact;
    }

    public String getZoneId()
    {
        return zoneId;
    }

    public void setZoneId(String zoneId)
    {
        this.zoneId = zoneId;
    }

    public Integer getZoneMin()
    {
        return zoneMin;
    }

    public void setZoneMin(Integer zoneMin)
    {
        this.zoneMin = zoneMin;
    }

    public void setZoneMin(String zoneMin)
    {
        setZoneMin(Integer.valueOf(zoneMin));
    }

    public Integer getZoneMax()
    {
        return zoneMax;
    }

    public void setZoneMax(Integer zoneMax)
    {
        this.zoneMax = zoneMax;
    }

    public void setZoneMax(String zoneMax)
    {
        setZoneMax(Integer.valueOf(zoneMax));
    }

    public Integer getZoneCost()
    {
        return zoneCost;
    }

    public void setZoneCost(Integer zoneCost)
    {
        this.zoneCost = zoneCost;
    }

    public void setZoneCost(String zoneCost)
    {
        setZoneCost(Integer.parseInt(zoneCost));
    }

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        if("GENERATED".equalsIgnoreCase(username))
        {
            username = "D" + DateUtil.getTimestamp();
        }
        this.username = username;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        if("GENERATED".equalsIgnoreCase(password))
        {
            password = "D00" + DateUtil.getTimestamp();
        }
        this.password = password;
    }

    public void setName(String name)
    {
        if(StringUtils.isNotBlank(name))
        {
            String[] parts = StringUtils.normalizeSpace(name.trim()).split("\\s");

            if(parts.length>0)
            {
                setFirstName(parts[0]);
            }

            if(parts.length>1)
            {
                setLastName(parts[1]);
            }
        }
    }

    public String getComments()
    {
        return comments;
    }

    public void setComments(String comments)
    {
        this.comments = comments;
    }

    public boolean hasVehicleInfo()
    {
        return vehicleLicenseNumber!=null || vehicleCapacity!=null;
    }

    public boolean hasContactsInfo()
    {
        return contact!=null || contactType!=null;
    }

    public boolean hasZoneInfo()
    {
        return zoneId!=null || zoneMin!=null || zoneMax!=null || zoneCost!=null;
    }

    public void fromDriver(Driver driver)
    {
        setUuid(driver.getUuid());
        setId(driver.getId());
        setFirstName(driver.getFirstName());
        setLastName(driver.getLastName());
        setLicenseNumber(driver.getLicenseNumber());
        setType(driver.getDriverType());
        setCodLimit(driver.getCodLimit());

        if(CollectionUtils.isNotEmpty(driver.getVehicles()))
        {
            setVehicleLicenseNumber(driver.getVehicles().get(0).getVehicleNo());
            setVehicleCapacity(driver.getVehicles().get(0).getCapacity());
        }

        if(CollectionUtils.isNotEmpty(driver.getContacts()))
        {
            setContactType(driver.getContacts().get(0).getType());
            setContact(driver.getContacts().get(0).getDetails());
        }

        if(CollectionUtils.isNotEmpty(driver.getZonePreferences()))
        {
            setZoneMin(driver.getZonePreferences().get(0).getMinWaypoints());
            setZoneMax(driver.getZonePreferences().get(0).getMaxWaypoints());
            setZoneCost(driver.getZonePreferences().get(0).getCost());
        }

        setUsername(driver.getUsername());
        setPassword(driver.getPassword());
        setComments(driver.getComments());
    }
}
