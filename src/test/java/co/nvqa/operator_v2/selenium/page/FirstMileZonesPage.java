package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.google.common.collect.ImmutableMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_NAME;

public class FirstMileZonesPage extends SimpleReactPage<FirstMileZonesPage> {

  @FindBy(css = ".loading-container")
  public PageElement loading;

  @FindBy(tagName = "iframe")
  public PageElement pageFrame;

  @FindBy(css = "[data-testid='add-zone-button']")
  public Button addFmZone;

  @FindBy(xpath = "//div[@class='ant-modal first-mile-zone-form-dialog']")
  public AddZoneDialog addFmZoneDialog;

  @FindBy(xpath = "//div[@class='ant-modal first-mile-zone-form-dialog']")
  public EditZoneDialog editFmZoneDialog;

  @FindBy(className = "ant-modal-wrap")
  public ConfirmDeleteModal confirmDeleteDialog;

  public ZonesTable zonesTable;

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public FirstMileZonesPage(WebDriver webDriver) {
    super(webDriver);
    zonesTable = new ZonesTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    halfCircleSpinner.waitUntilInvisible();
  }

  private static class ZoneParamsDialog extends AntModal {

    public ZoneParamsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[./input[@data-testid='first-mile-zone-name-input']]")
    public AntTextBox name;

    @FindBy(xpath = ".//div[./input[@data-testid='short-name-input']]")
    public AntTextBox shortName;

    @FindBy(css = "div.ant-select")
    public AntSelect hub;

    @FindBy(xpath = "//div[./input[@data-testid='latitude-input']]")
    public AntTextBox latitude;

    @FindBy(xpath = "//div[./input[@data-testid='longitude-input']]")
    public AntTextBox longitude;

    @FindBy(xpath = ".//div[./input[@data-testid='description-input']]")
    public AntTextBox description;

    @FindBy(css = "[data-testid='rts-switch']")
    public AntSwitch rts;
  }

  @Override
  public void waitUntilLoaded() {
    int timeout = addFmZone.isDisplayedFast() ? 2 : 10;
    if (loading.waitUntilVisible(timeout)) {
      loading.waitUntilInvisible();
    }
  }

  public void findZone(String zoneName) {
    zonesTable.filterByColumn(COLUMN_NAME, zoneName);
    int count = 0;
    while (zonesTable.isEmpty() && count < 10) {
      pause5s();
      zonesTable.filterByColumn(COLUMN_NAME, zoneName);
      count++;
    }
  }

  public boolean isNotificationShowUp(String message) {
    waitUntilVisibilityOfToastReact(message);

    return true;
  }

  public static class AddZoneDialog extends ZoneParamsDialog {

    public AddZoneDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='confirm-button']")
    public Button submit;
  }

  public static class EditZoneDialog extends ZoneParamsDialog {

    public EditZoneDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='confirm-button']")
    public Button update;
  }

  public static class ZonesTable extends AntTable<Zone> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?(-?[\\d.]+).*?(-?[\\d.]+).*");
    public static final String COLUMN_ID = "id";
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_SHORT_NAME = "shortName";
    public static final String COLUMN_HUB_NAME = "hubName";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";
    public static final String COLUMN_DESCRIPTION = "description";
    public static final String COLUMN_ZONE_TYPE = "type";

    public static final String ACTION_EDIT_POLYGON = "Edit Polygon";
    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_DELETE = "Delete";

    private ZonesTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "id")
          .put(COLUMN_SHORT_NAME, "short_name")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_HUB_NAME, "hubName")
          .put(COLUMN_LATITUDE, "latAndLong")
          .put(COLUMN_LONGITUDE, "latAndLong")
          .put(COLUMN_DESCRIPTION, "description")
          .put(COLUMN_ZONE_TYPE, "type")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT_POLYGON, "//tr[%d]/td[contains(@class,'action')]//button[1]",
          "Edit", "//tr[%d]/td[contains(@class,'action')]//button[2]",
          "Delete", "//tr[%d]/td[contains(@class,'action')]//button[3]"));
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
    }
  }

  public static class ConfirmDeleteModal extends AntModal {

    public ConfirmDeleteModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='confirm-button']")
    public Button confirm;
  }
}