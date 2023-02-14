package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateTimeRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
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

  @FindBy(css = "[data-testid='create-route-groups.shipment-filters.shipmentCompletionTime']")
  public AntDateTimeRangePicker shipmentCompletionTime;

  @FindBy(css = "[data-testid='station-route-testid.additional-tids.textarea']")
  public ForceClearTextBox additionalTids;

  @FindBy(css = "input[type='checkbox']")
  public CheckBox alsoSearchInHub;

  @FindBy(css = "[data-pa-label='Download CSV']")
  public Button downloadCsv;

  @FindBy(css = "[data-pa-label='Assign drivers']")
  public Button assignDrivers;

  @FindBy(css = "[data-testid='next-button']")
  public Button assignDriversUpload;

  @FindBy(css = "[title='Upload CSV']")
  public Button uploadCsv;

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

  public ParcelsTable parcelsTable;
  public UploadedParcelsTable uploadedParcelsTable;

  public StationRoutePage(WebDriver webDriver) {
    super(webDriver);
    parcelsTable = new ParcelsTable(webDriver);
    uploadedParcelsTable = new UploadedParcelsTable(webDriver);
  }

  public static class ParcelsTable extends AntTableV2<Parcel> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_ADDRESS = "address";
    public static final String COLUMN_PARCEL_SIZE = "parcelSize";
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
              .put(COLUMN_DRIVER_ID, "driverId")
              .build());
      setEntityClass(Parcel.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "//div[@role='row'][%d]//button[@data-pa-label='Edit']",
          ACTION_REMOVE, "//div[@role='row'][%d]//button[@data-pa-label='Remove']"
      ));
    }
  }

  public static class Parcel extends DataEntity<Parcel> {

    private String trackingId;
    private String address;
    private String parcelSize;
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
}