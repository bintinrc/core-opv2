package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
public class ZonesPage extends OperatorV2SimplePage {

  private static final String CSV_FILENAME = "zones.csv";

  @FindBy(name = "Add Zone")
  public NvIconTextButton addZone;

  @FindBy(name = "View Selected Polygons")
  public NvIconTextButton viewSelectedPolygons;

  @FindBy(name = "Download CSV File")
  public NvApiTextButton downloadCsvFile;

  @FindBy(name = "commons.refresh")
  public NvIconButton refresh;

  @FindBy(css = "md-dialog")
  public AddZoneDialog addZoneDialog;

  @FindBy(css = "md-dialog")
  public EditZoneDialog editZoneDialog;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(xpath = "//md-switch[@aria-label='commons.rts']//div[contains(@class,'ink-ripple')]")
  public PageElement rtsToggle;

  @FindBy(xpath = "//td[@class='zone-type']")
  public PageElement rtsValue;

  public ZonesTable zonesTable;

  public ZonesPage(WebDriver webDriver) {
    super(webDriver);
    zonesTable = new ZonesTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    halfCircleSpinner.waitUntilInvisible();
  }

  public void verifyCsvFileDownloadedSuccessfully(Zone zone) {
    String name = zone.getName();
    String shortName = zone.getShortName();
    String hubName = zone.getHubName();
    String expectedText = String.format("\"%s\",\"%s\",\"%s\"", shortName, name, hubName);
    verifyFileDownloadedSuccessfully(CSV_FILENAME, expectedText);
  }

  public void clickRefreshCache() {
    refresh.click();
    waitUntilInvisibilityOfToast("Zones cache refreshed!");
  }

  private static class ZoneParamsDialog extends MdDialog {

    public ZoneParamsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='commons.name']")
    public TextBox name;

    @FindBy(css = "[id^='commons.short-name']")
    public TextBox shortName;

    @FindBy(css = "[id^='commons.hub']")
    public MdSelect hub;

    @FindBy(css = "[id^='commons.latitude']")
    public TextBox latitude;

    @FindBy(css = "[id^='commons.longitude']")
    public TextBox longitude;

    @FindBy(id = "commons.description")
    public TextBox description;
  }

  public void findZone(Zone zone) {
    zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
    if (zonesTable.isEmpty()) {
      clickRefreshCache();
      refreshPage();
      zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
    }
  }

  public static class AddZoneDialog extends ZoneParamsDialog {

    public AddZoneDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "Submit")
    public NvApiTextButton submit;
  }

  public static class EditZoneDialog extends ZoneParamsDialog {

    public EditZoneDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(name = "Update")
    public NvApiTextButton update;
  }

  public static class ZonesTable extends MdVirtualRepeatTable<Zone> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?(-?[\\d.]+).*?(-?[\\d.]+).*");
    public static final String COLUMN_ID = "id";
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_SHORT_NAME = "shortName";
    public static final String COLUMN_HUB_NAME = "hubName";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";
    public static final String COLUMN_DESCRIPTION = "description";

    public static final String ACTION_EDIT_POLYGON = "Edit Polygon";
    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_DELETE = "Delete";

    private ZonesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "id")
          .put(COLUMN_SHORT_NAME, "short_name")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_HUB_NAME, "hub-name")
          .put(COLUMN_LATITUDE, "lat-lng")
          .put(COLUMN_LONGITUDE, "lat-lng")
          .put(COLUMN_DESCRIPTION, "description")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT_POLYGON, "Edit Polygon",
          "Edit", "commons.edit",
          "Delete", "commons.delete"));
      setColumnValueProcessors(ImmutableMap.of(
          COLUMN_LATITUDE, value ->
          {
            Matcher m = LATLONG_PATTERN.matcher(value);
            return m.matches() ? m.group(1) : null;
          },
          COLUMN_LONGITUDE, value ->
          {
            Matcher m = LATLONG_PATTERN.matcher(value);
            return m.matches() ? m.group(2) : null;
          }
      ));
      setEntityClass(Zone.class);
      setMdVirtualRepeat("zone in getTableData()");
    }
  }
}