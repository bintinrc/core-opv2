package co.nvqa.operator_v2.model;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Map;
import java.util.Random;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
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

  public DriverInfo() {
  }

  public DriverInfo(Map<String, ?> data) {
    super(data);
  }

  public String getHub() {
    return hub;
  }

  public void setHub(String hub) {
    this.hub = hub;
  }

  public String getUuid() {
    return uuid;
  }

  public void setUuid(String uuid) {
    this.uuid = uuid;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public void setId(String id) {
    setId(Long.valueOf(id));
  }

  public String getFirstName() {
    return firstName;
  }

  public String getDisplayName() {
    return displayName;
  }

  public void setDisplayName(String displayName) {
    if ("GENERATED".equalsIgnoreCase(displayName)) {
      displayName = "Station" + TestUtils.generateDateUniqueString();
    }
    this.displayName = displayName;
  }

  public void setFirstName(String firstName) {
    if ("GENERATED".equalsIgnoreCase(firstName)) {
      firstName = "Driver";
    }
    this.firstName = firstName;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    if ("GENERATED".equalsIgnoreCase(lastName)) {
      lastName = "Auto";
    }
    this.lastName = lastName;
  }

  public String getLicenseNumber() {
    return licenseNumber;
  }

  public void setLicenseNumber(String licenseNumber) {
    if ("GENERATED".equalsIgnoreCase(licenseNumber)) {
      licenseNumber = "D" + TestUtils.generateDateUniqueString();
    }
    this.licenseNumber = licenseNumber;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getDpmsId() {
    return dpmsId;
  }

  public void setDpmsId(String dpmsId) {
    if ("GENERATED".equalsIgnoreCase(dpmsId)) {
      dpmsId = String.valueOf(new Random().nextInt(99999));
    }
    this.dpmsId = dpmsId;
  }

  public Integer getCodLimit() {
    return codLimit;
  }

  public void setCodLimit(Integer codLimit) {
    this.codLimit = codLimit;
  }

  public void setCodLimit(String codLimit) {
    setCodLimit(Integer.valueOf(codLimit));
  }

  public String getVehicleLicenseNumber() {
    return vehicleLicenseNumber;
  }

  public void setVehicleLicenseNumber(String vehicleLicenseNumber) {
    if ("GENERATED".equalsIgnoreCase(vehicleLicenseNumber)) {
      vehicleLicenseNumber = "D" + TestUtils.generateDateUniqueString();
    }
    this.vehicleLicenseNumber = vehicleLicenseNumber;
  }

  public Integer getVehicleCapacity() {
    return vehicleCapacity;
  }

  public void setVehicleCapacity(Integer vehicleCapacity) {
    this.vehicleCapacity = vehicleCapacity;
  }

  public void setVehicleCapacity(String vehicleCapacity) {
    setVehicleCapacity(Integer.valueOf(vehicleCapacity));
  }

  public String getContactType() {
    return contactType;
  }

  public void setContactType(String contactType) {
    this.contactType = contactType;
  }

  public String getContact() {
    return contact;
  }

  public void setContact(String contact) {
    if ("GENERATED".equalsIgnoreCase(contact)) {
      final String country = StandardTestConstants.NV_SYSTEM_ID.toUpperCase();
      switch (country) {
        case "SG":
          contact = "8123" + RandomStringUtils.randomNumeric(4);
          break;
        case "ID":
          contact = "+6282188881593";
          break;
        case "MY":
          contact = "+6066567878";
          break;
        case "PH":
          contact = "+639285554697";
          break;
        case "TH":
          contact = "+66955573510";
          break;
        case "VN":
          contact = "+0812345678";
          break;
        default:
          break;
      }
    }
    this.contact = contact;
  }

  public String getZoneId() {
    return zoneId;
  }

  public void setZoneId(String zoneId) {
    this.zoneId = zoneId;
  }

  public Integer getZoneMin() {
    return zoneMin;
  }

  public void setZoneMin(Integer zoneMin) {
    this.zoneMin = zoneMin;
  }

  public void setZoneMin(String zoneMin) {
    setZoneMin(Integer.valueOf(zoneMin));
  }

  public Integer getZoneMax() {
    return zoneMax;
  }

  public void setZoneMax(Integer zoneMax) {
    this.zoneMax = zoneMax;
  }

  public void setZoneMax(String zoneMax) {
    setZoneMax(Integer.valueOf(zoneMax));
  }

  public Integer getZoneCost() {
    return zoneCost;
  }

  public void setZoneCost(Integer zoneCost) {
    this.zoneCost = zoneCost;
  }

  public void setZoneCost(String zoneCost) {
    setZoneCost(Integer.parseInt(zoneCost));
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    if ("GENERATED".equalsIgnoreCase(username)) {
      username = "D" + TestUtils.generateDateUniqueString();
    }
    this.username = username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    if ("GENERATED".equalsIgnoreCase(password)) {
      password = "Ninjitsu89";
    }
    this.password = password;
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

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public boolean hasVehicleInfo() {
    return vehicleLicenseNumber != null || vehicleCapacity != null;
  }

  public String getVehicleType() {
    return vehicleType;
  }

  public void setVehicleType(String vehicleType) {
    this.vehicleType = vehicleType;
  }

  public boolean hasContactsInfo() {
    return contact != null || contactType != null;
  }

  public boolean hasZoneInfo() {
    return zoneId != null || zoneMin != null || zoneMax != null || zoneCost != null;
  }

  public String getEmploymentStartDate() {
    return employmentStartDate;
  }

  public void setEmploymentStartDate(String employmentStartDate) {
    this.employmentStartDate = employmentStartDate;
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

    if (CollectionUtils.isNotEmpty(driver.getVehicles())) {
      setVehicleLicenseNumber(driver.getVehicles().get(0).getVehicleNo());
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
    setPassword(driver.getPassword());
    setComments(driver.getComments());
  }

  public String getEmploymentEndDate() {
    return employmentEndDate;
  }

  public void setEmploymentEndDate(String employmentEndDate) {
    this.employmentEndDate = employmentEndDate;
  }

  public String getResigned() {
    return resigned;
  }

  public void setResigned(String resigned) {
    this.resigned = resigned;
  }

  public String getFullName() {
    return StringUtils.normalizeSpace(firstName + " " + lastName);
  }
}
