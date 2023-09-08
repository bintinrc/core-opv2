package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateTimeRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class StationRoutePage extends SimpleReactPage<StationRoutePage> {

  @FindBy(css = "[data-testid='station-route-testid.select-hub']")
  public AntSelect3 hub;

  @FindBy(css = "[data-testid='single-select']")
  public AntSelect3 hubUpload;

  @FindBy(css = "[data-testid='station-route-testid.select-drivers-on-leave']")
  public AntSelect3 driversOnLeave;

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentType']")
  public AntSelect3 shipmentType;

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentDate']")
  public AntDateTimeRangePicker shipmentDate;

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentDate.label'] + div + span")
  public PageElement shipmentDateError;

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentCompletionTime.label'] + div + span")
  public PageElement shipmentCompletionTimeError;

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentCompletionTime']")
  public AntDateTimeRangePicker shipmentCompletionTime;

  @FindBy(css = "[data-testid='station-route-testid.additional-tids.textarea']")
  public ForceClearTextBox additionalTids;

  @FindBy(css = "input[type='checkbox']")
  public CheckBox alsoSearchInHub;

  @FindBy(css = "[data-testid='station-route-testid.assign-drivers.download-csv.button']")
  public Button downloadCsv;

  @FindBy(css = "[data-testid='station-route-testid.assign-drivers.button']")
  public Button assignDrivers;

  @FindBy(css = "[data-testid='next-button']")
  public Button assignDriversUpload;

  @FindBy(css = "[title='Upload CSV']")
  public Button uploadCsv;

  @FindBy(css = "[data-testid='station-route-testid.check-assignment']")
  public Button checkAssignment;

  @FindBy(css = "[data-testid='station-route-testid.mass-manual-assign-driver.select']")
  public AntSelect3 massAssignDrivers;

  @FindBy(css = "[data-testid='station-route-testid.create-new-routes.radio']")
  public Button createNewRoutes;

  @FindBy(css = "[data-testid='station-route-testid.add-to-existing-routes.radio']")
  public Button addToExistingRoutes;

  @FindBy(xpath = ".//div[./span[.='Driver count']]/span[2]")
  public PageElement rcDriverCount;

  @FindBy(xpath = ".//div[./span[.='Parcel count']]/span[2]")
  public PageElement rcParcelCount;

  @FindBy(css = "[data-testid='station-route-testid.back.button']")
  public Button back;

  @FindBy(css = "[data-testid='station-route-testid.next-to-routing-action.button']")
  public Button next;
  @FindBy(css = "[data-pa-label='Add to existing routes']")
  public Button next2;

  @FindBy(css = "input[type='file']")
  public FileInput uploadFile;

  @FindBy(xpath = ".//div[./span[contains(.,'Number of shipments')]]/b")
  public PageElement numberOfShipments;

  @FindBy(xpath = ".//div[./span[contains(.,'Parcel count')]]/b")
  public PageElement parcelCount;

  @FindBy(xpath = ".//div[./span[contains(.,'Additional parcels')]]/b")
  public PageElement additionalParcels;

  @FindBy(xpath = ".//div[./span[contains(.,'Total parcels')]]/b")
  public PageElement totalParcels;

  @FindBy(xpath = ".//div[./span[contains(.,'Active drivers')]]/b")
  public PageElement activeDrivers;

  @FindBy(xpath = ".//div[./span[contains(.,'Average parcels')]]/b")
  public PageElement averageParcels;

  @FindBy(xpath = ".//div[.='To check assignment and create routes, there should be no \"UNASSIGNED\" for the \"Assigned driver\" column.']")
  public PageElement banner;

  @FindBy(css = "span > span.area-match")
  public List<PageElement> areaMatch;

  @FindBy(css = "span > span.keyword-match")
  public List<PageElement> keywordMatch;

  @FindBy(css = ".ant-modal")
  public InvalidInputDialog invalidInputDialog;

  @FindBy(css = ".ant-modal")
  public ErrorsDialog errorsDialog;

  @FindBy(css = "div.route-date")
  public AntPicker crRouteDate;

  @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Route tags']]//div[contains(@class,'ant-select')]")
  public AntSelect3 crRouteTags;

  @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Zone']]//div[contains(@class,'ant-select')]")
  public AntSelect3 crZone;

  @FindBy(css = "[data-testid='station-route-testid.create-new-route-form.route-use-preferred-zone.field']")
  public CheckBox crUsePreferredZone;
  @FindBy(xpath = ".//div[contains(@class,'create-route-field')][.//label[.='Hub']]//div[contains(@class,'ant-select')]")
  public AntSelect3 crHub;

  @FindBy(css = "[data-testid='station-route-testid.mass-manual-assign-driver.select']")
  public AntSelect3 selectDrivers;

  @FindBy(xpath = ".//span[./input[@placeholder='Comment']]")
  public AntTextBox crComments;

  @FindBy(css = "[data-testid='station-route-testid.create-routes.button']")
  public Button createRoutes;

  @FindBy(css = "[data-testid='station-route-testid.remove-all-selected-parcels.button']")
  public Button removeAllSelectedParcels;

  @FindBy(xpath = "//label[.='Show only matching area but no keyword']//input")
  public CheckBox showOnlyMatchingArea;

  @FindBy(css = "[data-testid='station-route-testid.isRemoved.header.filter']")
  public AntSelect3 actionsFilter;

  public ParcelsTable parcelsTable;
  public DriversTable driversTable;
  public DriversRouteTable driversRouteTable;
  public CreatedRoutesDetailsTable createdRoutesDetailsTable;
  public UploadedParcelsTable uploadedParcelsTable;

  public StationRoutePage(WebDriver webDriver) {
    super(webDriver);
    parcelsTable = new ParcelsTable(webDriver);
    driversTable = new DriversTable(webDriver);
    driversRouteTable = new DriversRouteTable(webDriver);
    createdRoutesDetailsTable = new CreatedRoutesDetailsTable(webDriver);
    uploadedParcelsTable = new UploadedParcelsTable(webDriver);
  }

  public static class ParcelsTable extends AntTableV2<Parcel> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_ADDRESS = "address";
    public static final String COLUMN_PARCEL_SIZE = "parcelSize";
    public static final String COLUMN_ORDER_TAGS = "orderTags";
    public static final String COLUMN_DRIVER_ID = "driverId";

    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_REMOVE = "Remove";

    public ParcelsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_TRACKING_ID, "id")
              .put(COLUMN_ADDRESS, "address")
              .put(COLUMN_PARCEL_SIZE, "parcelSize")
              .put(COLUMN_ORDER_TAGS, "_orderTagsRender")
              .put(COLUMN_DRIVER_ID, "driverId")
              .build());
      setEntityClass(Parcel.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "//div[@role='row'][%d]//button[@data-pa-label='Edit']",
          ACTION_REMOVE, "//div[@role='row'][%d]//button[@data-pa-label='Remove']"
      ));
    }

    public void assignDriver(String driverName, int index) {
      clickActionButton(index, ACTION_EDIT);
      new AntSelect3(getWebDriver(),
          f("//div[@role='row'][%d]//div[contains(@data-testid,'assign-driver-field')]",
              index)).fillSearchTermAndEnter(driverName);
    }

    public boolean isRowRemoved(int index) {
      return StringUtils.contains(getAttribute(getRowLocator(index), "class"), "base-row-disabled");
    }
  }

  public static class Parcel extends DataEntity<Parcel> {

    private String trackingId;
    private String address;
    private String parcelSize;
    private List<String> orderTags;
    private String driverId;

    public Parcel() {
    }

    public Parcel(Map<String, ?> data) {
      super(data);
    }

    public String getTrackingId() {
      return trackingId;
    }

    public void setTrackingId(String trackingId) {
      this.trackingId = trackingId;
    }

    public String getAddress() {
      return address;
    }

    public void setAddress(String address) {
      this.address = address;
    }

    public String getParcelSize() {
      return parcelSize;
    }

    public void setParcelSize(String parcelSize) {
      this.parcelSize = parcelSize;
    }

    public String getDriverId() {
      return driverId;
    }

    public void setDriverId(String driverId) {
      this.driverId = driverId;
    }

    public List<String> getOrderTags() {
      return orderTags;
    }

    public void setOrderTags(List<String> orderTags) {
      this.orderTags = orderTags;
    }

    public void setOrderTags(String orderTags) {
      splitAndNormalize(orderTags);
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) {
        return true;
      }
      if (o == null || getClass() != o.getClass()) {
        return false;
      }
      Parcel parcel = (Parcel) o;
      return Objects.equals(trackingId, parcel.trackingId) && Objects.equals(
          address, parcel.address) && Objects.equals(parcelSize, parcel.parcelSize)
          && Objects.equals(driverId, parcel.driverId);
    }

    @Override
    public int hashCode() {
      return Objects.hash(trackingId, address, parcelSize, driverId);
    }
  }

  public static class InvalidInputDialog extends AntModal {

    @FindBy(xpath = "(.//div[@role='table'])[1]//div[contains(@data-testid,'cell')]")
    public List<PageElement> trackingIds;

    @FindBy(xpath = "(.//div[@role='table'])[2]//div[contains(@data-testid,'cell')]")
    public List<PageElement> drivers;

    @FindBy(css = "[data-testid='invalid-data.cancel-button']")
    public Button cancel;

    public InvalidInputDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ErrorsDialog extends AntModal {

    @FindBy(xpath = ".//tr/td[2]")
    public List<PageElement> error;

    @FindBy(css = "[data-testid='bulk-progress-cancel.button']")
    public Button cancel;

    public ErrorsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UploadedParcelsTable extends AntTableV2<Parcel> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_DRIVER_ID = "driverId";
    public static final String COLUMN_ADDRESS = "address";

    public UploadedParcelsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_DRIVER_ID, "0")
              .put(COLUMN_TRACKING_ID, "1")
              .put(COLUMN_ADDRESS, "2")
              .build());
      setEntityClass(Parcel.class);
    }
  }

  public static class DriversTable extends AntTableV2<DriversTableRecord> {

    public static final String COLUMN_DRIVER_NAME = "driverName";
    public static final String COLUMN_PARCEL_COUNT = "parcelCount";

    public DriversTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_DRIVER_NAME, "0")
              .put(COLUMN_PARCEL_COUNT, "1")
              .build());
      setEntityClass(DriversTableRecord.class);
    }
  }

  public static class DriversTableRecord extends DataEntity<DriversTableRecord> {

    private String driverName;
    private String parcelCount;

    public DriversTableRecord() {
    }

    public DriversTableRecord(Map<String, ?> data) {
      fromMap(data);
    }

    public String getDriverName() {
      return driverName;
    }

    public void setDriverName(String driverName) {
      this.driverName = driverName;
    }

    public String getParcelCount() {
      return parcelCount;
    }

    public void setParcelCount(String parcelCount) {
      this.parcelCount = parcelCount;
    }
  }

  public static class DriversRouteTable extends AntTableV2<DriversRouteTableRecord> {

    public static final String COLUMN_DRIVER_NAME = "driverName";
    public static final String COLUMN_ROUTE_ID = "routeId";

    public DriversRouteTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_DRIVER_NAME, "driverName")
              .put(COLUMN_ROUTE_ID, "routeIds")
              .build());
      setEntityClass(DriversRouteTableRecord.class);
    }
  }

  public static class DriversRouteTableRecord extends DataEntity<DriversRouteTableRecord> {

    private String driverName;
    private String routeId;

    public DriversRouteTableRecord() {
    }

    public DriversRouteTableRecord(Map<String, ?> data) {
      fromMap(data);
    }

    public String getDriverName() {
      return driverName;
    }

    public void setDriverName(String driverName) {
      this.driverName = driverName;
    }

    public String getRouteId() {
      return routeId;
    }

    public void setRouteId(String routeId) {
      this.routeId = routeId;
    }
  }

  public static class CreatedRoutesDetailsTable extends
      AntTableV2<CreatedRoutesDetailsTableRecord> {

    public CreatedRoutesDetailsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put("driverName", "0")
              .put("parcelCount", "1")
              .put("routeId", "2")
              .put("routeDate", "3")
              .put("routeTags", "4")
              .put("zone", "5")
              .put("hub", "6")
              .put("comment", "7")
              .build());
      setEntityClass(CreatedRoutesDetailsTableRecord.class);
    }
  }

  public static class CreatedRoutesDetailsTableRecord extends
      DataEntity<CreatedRoutesDetailsTableRecord> {

    private String driverName;
    private String parcelCount;
    private String routeId;
    private String routeDate;
    private String routeTags;
    private String zone;
    private String hub;
    private String comment;

    public CreatedRoutesDetailsTableRecord() {
    }

    public CreatedRoutesDetailsTableRecord(Map<String, ?> data) {
      fromMap(data);
    }

    public String getDriverName() {
      return driverName;
    }

    public void setDriverName(String driverName) {
      this.driverName = driverName;
    }

    public String getParcelCount() {
      return parcelCount;
    }

    public void setParcelCount(String parcelCount) {
      this.parcelCount = parcelCount;
    }

    public String getRouteId() {
      return routeId;
    }

    public void setRouteId(String routeId) {
      this.routeId = routeId;
    }

    public String getRouteDate() {
      return routeDate;
    }

    public void setRouteDate(String routeDate) {
      this.routeDate = routeDate;
    }

    public String getRouteTags() {
      return routeTags;
    }

    public void setRouteTags(String routeTags) {
      this.routeTags = routeTags;
    }

    public String getZone() {
      return zone;
    }

    public void setZone(String zone) {
      this.zone = zone;
    }

    public String getHub() {
      return hub;
    }

    public void setHub(String hub) {
      this.hub = hub;
    }

    public String getComment() {
      return comment;
    }

    public void setComment(String comment) {
      this.comment = comment;
    }
  }
}