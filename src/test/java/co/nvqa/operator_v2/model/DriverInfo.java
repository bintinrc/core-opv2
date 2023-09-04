package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.RandomUtil;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Map;
import java.util.Random;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess"})
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DriverInfo extends DataEntity<DriverInfo> {

  private String uuid;
  private Long id;
  private String displayName;
  private String firstName;
  private String lastName;
  private String licenseNumber;
  private String type;
  private String dpmsId;
  private Integer codLimit;
  private String employmentStartDate;
  private String employmentEndDate;
  private String vehicleType;
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
  private String hub;
  private String resigned;
  private Integer maxOnDemandWaypoints;

  public DriverInfo(Map<String, ?> data) {
    super(data);
  }

  public void setDisplayName(String displayName) {
    this.displayName = displayName.equalsIgnoreCase("GENERATED") ?
        String.format("Driver %s", TestUtils.generateDateUniqueString()) : displayName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName.equalsIgnoreCase("GENERATED") ? "Driver" : firstName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName.equalsIgnoreCase("GENERATED") ? "Automation" : lastName;
  }

  public void setLicenseNumber(String licenseNumber) {
    this.licenseNumber = licenseNumber.equalsIgnoreCase("GENERATED") ?
        String.format("D%s", RandomUtil.randomNumbersString(8)) : licenseNumber;
  }

  public void setDpmsId(String dpmsId) {
    this.dpmsId = dpmsId.equalsIgnoreCase("GENERATED") ?
        String.valueOf(new Random().nextInt(100)) : dpmsId;
  }

  public void setVehicleLicenseNumber(String vehicleLicenseNumber) {
    this.vehicleLicenseNumber = vehicleLicenseNumber.equalsIgnoreCase("GENERATED") ?
        String.format("D%s", RandomUtil.randomNumbersString(8)) : vehicleLicenseNumber;
  }

  public void setVehicleCapacity(Integer vehicleCapacity) {
    this.vehicleCapacity = vehicleCapacity;
  }

  public void setVehicleCapacity(String vehicleCapacity) {
    setVehicleCapacity(Integer.valueOf(vehicleCapacity));
  }

  public void setContact(String contact) {
    final String country = StandardTestConstants.NV_SYSTEM_ID.toUpperCase();
    if (contact.equalsIgnoreCase("GENERATED")) {
      switch (country) {
        case "SG":
          this.contact = String.format("%s812%s", "+65", RandomStringUtils.randomNumeric(5));
          break;
        case "ID":
          this.contact = String.format("%s812%s", "+62", RandomStringUtils.randomNumeric(6));
          break;
        case "MY":
          this.contact = String.format("%s012%s", "+60", RandomStringUtils.randomNumeric(7));
          break;
        case "PH":
          this.contact = String.format("%s0905%s", "+63", RandomStringUtils.randomNumeric(7));
          break;
        case "TH":
          this.contact = String.format("%s081%s", "+66", RandomStringUtils.randomNumeric(7));
          break;
        case "VN":
          this.contact = String.format("%s091%s", "+84", RandomStringUtils.randomNumeric(7));
          break;
        default:
          break;
      }
    } else {
      this.contact = contact;
    }
  }

  public void setZoneMin(Integer zoneMin) {
    this.zoneMin = zoneMin;
  }

  public void setZoneMin(String zoneMin) {
    setZoneMin(Integer.valueOf(zoneMin));
  }

  public void setZoneMax(Integer zoneMax) {
    this.zoneMax = zoneMax;
  }

  public void setZoneMax(String zoneMax) {
    setZoneMax(Integer.valueOf(zoneMax));
  }

  public void setZoneCost(Integer zoneCost) {
    this.zoneCost = zoneCost;
  }

  public void setZoneCost(String zoneCost) {
    setZoneCost(Integer.parseInt(zoneCost));
  }


  public void setUsername(String username) {
    this.username = username.equalsIgnoreCase("GENERATED") ?
        String.format("D%s", RandomUtil.randomNumbersString(8)) : username;
  }

  public void setPassword(String password) {
    this.password = password.equalsIgnoreCase("GENERATED") ?
        "Ninjitsu89" : password;
  }

  public void setName(String name) {
    if (StringUtils.isNotBlank(name)) {
      String[] parts = StringUtils.normalizeSpace(name.trim()).split("\\s");

      if (parts.length > 0) {
        setFirstName(parts[0]);
      }

      if (parts.length > 1) {
        setLastName(parts[1]);
      }
    }
  }

  public boolean hasVehicleInfo() {
    return vehicleLicenseNumber != null || vehicleCapacity != null;
  }

  public boolean hasContactsInfo() {
    return contact != null || contactType != null;
  }

  public boolean hasZoneInfo() {
    return zoneId != null || zoneMin != null || zoneMax != null || zoneCost != null;
  }

  public void fromDriver(Driver driver) {
    setUuid(driver.getUuid());
    setId(driver.getId());
    setDisplayName(driver.getDisplayName());
    setFirstName(driver.getFirstName());
    setLastName(driver.getLastName());
    setLicenseNumber(driver.getLicenseNumber());
    setType(driver.getDriverType());
    setCodLimit(driver.getCodLimit());
    setEmploymentStartDate(driver.getEmploymentStartDate());
    setMaxOnDemandWaypoints(driver.getMaxOnDemandJobs());

    if (CollectionUtils.isNotEmpty(driver.getVehicles())) {
      setVehicleLicenseNumber(driver.getLicenseNumber());
      setVehicleCapacity(driver.getVehicles().get(0).getCapacity());
    }

    if (CollectionUtils.isNotEmpty(driver.getContacts())) {
      setContactType(driver.getContacts().get(0).getType());
      setContact(driver.getContacts().get(0).getDetails());
    }

    if (CollectionUtils.isNotEmpty(driver.getZonePreferences())) {
      setZoneMin(driver.getZonePreferences().get(0).getMinWaypoints());
      setZoneMax(driver.getZonePreferences().get(0).getMaxWaypoints());
      setZoneCost(driver.getZonePreferences().get(0).getCost());
    }

    setUsername(driver.getUsername());
    setComments(driver.getComments());
  }

  public String getFullName() {
    return StringUtils.normalizeSpace(firstName + " " + lastName);
  }
}
