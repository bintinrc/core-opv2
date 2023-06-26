package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.google.common.collect.ImmutableMap;
import io.restassured.internal.common.assertion.Assertion;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_SHORT_NAME;

public class FirstMileZonesPage extends SimpleReactPage<FirstMileZonesPage> {

  @FindBy(css = ".loading-container")
  public PageElement loading;

  @FindBy(css = ".ant-btn-loading-icon")
  public PageElement loadingIcon;

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
  @FindBy(xpath = "//button[.='View Selected Polygons']")
  public Button viewSelectedPolygons;
  @FindBy(xpath = "//button[@data-testid='bulk-edit-polygons-button']")
  public Button bulkEditPolygons;
  @FindBy(xpath = "//input[@accept='.kml']")
  public FileInput uploadKmlFileInput;
  @FindBy(css = "div.ant-modal-content")
  public EditDriverZoneModal editDriverZoneModal;
  @FindBy(xpath = "//button[@data-testid='select-button']")
  public FileInput selectKmlFile;
  public static final String FIRST_MILE_ZONE_PAGE_ELEMENT_XPATH = "//button[@data-testid='edit-driver-zones-button']";
  public static final String SAVE_CHANGES_BUTTON_XPATH = "//button[@data-testid='save-changes-button']";

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement message;
  public ZonesTable zonesTable;

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public FirstMileZonesPage(WebDriver webDriver) {
    super(webDriver);
    zonesTable = new ZonesTable(webDriver);
  }

  public void loadFirstMileZonePage() {
    getWebDriver().manage().window().maximize();
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/first-mile-zones");
  }

  public void clickButton() {
    String elementXpath = null;
    elementXpath = FIRST_MILE_ZONE_PAGE_ELEMENT_XPATH;
    WebElement buttonXpath = getWebDriver().findElement(By.xpath(elementXpath));
    buttonXpath.click();
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    halfCircleSpinner.waitUntilInvisible();
  }

  public void validateInvalidFileErrorMessageIsShown() {
    Assertions.assertThat(message.getText().equals("FM zones updated!"));
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

    @FindBy(xpath = "//div[@class='driver-select-wrapper']")
    public AntSelect driver;

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

  public void findZone(String zoneShortName) {
    zonesTable.filterByColumn(COLUMN_SHORT_NAME, zoneShortName);
  }

  public boolean isNotificationShowUp(String message) {
    waitUntilVisibilityOfToastReact(message);

    return true;
  }

  public static class EditDriverZoneModal extends ZoneParamsDialog {

    public static final String EDIT_DRIVER_ZONE_HUBS_XPATH = "//div[contains(text(),'%s')]";
    public static final String EDIT_DRIVER_HUBS_XPATH = "//label[contains(text(),'%s')]";
    public static final String EDIT_DRIVER_ZONE_BUTTONS_XPATH = "//button[@data-testid='%s']";
    public static final String EDIT_DRIVER_ZONE_NAME_XPATH = "//input[@data-testid='table-column-filter-editDriver-name']";
    public static final String EDIT_DRIVER_ZONE_TABLE_XPATH = "//td[@class='%s']";
    public static final String EDIT_DRIVER_ZONE_DRIVER_TABLE_XPATH = "//span[text()='Select a driver']";

    public EditDriverZoneModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getModalTitle(String itemName) {
      return findElementByXpath(f(EDIT_DRIVER_ZONE_HUBS_XPATH, itemName)).getText();
    }

    public String getHubText(String itemName) {
      return findElementByXpath(f(EDIT_DRIVER_HUBS_XPATH, itemName)).getText();
    }

    public Boolean getButton(String itemName) {
      return findElementByXpath(f(EDIT_DRIVER_ZONE_BUTTONS_XPATH, itemName)).isDisplayed();
    }

    public void getZoneByName(String zoneName){
      findElementByXpath(EDIT_DRIVER_ZONE_NAME_XPATH).sendKeys(zoneName);
    }

    public String verifyZoneTableValues(String itemName) {
      return findElementByXpath(f(EDIT_DRIVER_ZONE_TABLE_XPATH, itemName)).getText();
    }

    public void searchForDriver(String zoneName) {
      findElementByXpath(EDIT_DRIVER_ZONE_DRIVER_TABLE_XPATH).click();
      findElementByXpath(EDIT_DRIVER_ZONE_DRIVER_TABLE_XPATH).sendKeys(zoneName);
      findElementByXpath(EDIT_DRIVER_ZONE_DRIVER_TABLE_XPATH).sendKeys(Keys.ENTER);
    }

    public void clickOnSaveChangesButton() {
      String elementXpath = null;
      elementXpath = SAVE_CHANGES_BUTTON_XPATH;
      WebElement buttonXpath = getWebDriver().findElement(By.xpath(elementXpath));
      buttonXpath.click();
    }
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