package co.nvqa.operator_v2.selenium.page.recovery.fdm;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class FailedDeliveryManagementPage extends
    SimpleReactPage<FailedDeliveryManagementPage> {

  @FindBy(css = "[data-testid='virtual-table.stats.header']")
  public PageElement fdmHeader;

  @FindBy(css = "[data-testid='apply-action-button']")
  public Button applyAction;

  @FindBy(css = "[data-testid='fdm.apply-action.download-csv-file']")
  public PageElement downloadCsvFileAction;

  @FindBy(css = "[data-testid='fdm.apply-action.reschedule-selected']")
  public PageElement rescheduleSelected;

  @FindBy(css = "[data-testid='fdm.apply-action.set-rts-to-selected']")
  public PageElement rtsSelected;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement notifMessage;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement notifDescription;

  @FindBy(xpath = "//div[@class='ant-modal reschedule-selected-dialog']")
  public RescheduleDialog rescheduleDialog;

  @FindBy(xpath = "//button//span[contains(text(),'CSV Reschedule')]")
  public PageElement csvReschedule;

  @FindBy(xpath = "//div[@class='ant-modal-title']")
  public UploadCSVDialog uploadCSVDialog;

  @FindBy(css = "[data-testid='virtual-table']")
  public FailedDeliveryTable fdmTable;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public EditRTSDetailsDialog rtsDetailsDialog;

  @FindBy(xpath = "//div[@role='document' and contains(@class,'ant-modal')]")
  public SetSelectedToRTSDialog selectedToRTSDialog;

  @FindBy(xpath = "//div[@class='ant-modal-title' and contains(.,'Updated')]")
  public ErrorDialog errorDialog;

  public static String KEY_SELECTED_ROWS_COUNT = "KEY_SELECTED_ROWS_COUNT";
  public static final String FDM_CSV_FILENAME_PATTERN = "failed-delivery-list.csv";
  public static final String RESCHEDULE_CSV_FILENAME_PATTERN = "delivery-reschedule.csv";
  private static final String XPATH_END_OF_TABLE = "//div[contains(text(),'End of Table')]";

  public FailedDeliveryManagementPage(WebDriver webDriver) {
    super(webDriver);
    fdmTable = new FailedDeliveryTable(webDriver);
  }

  public static class FailedDeliveryTable extends AntTableV2<FailedDelivery> {

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-sm ant-btn-icon-only']")
    public PageElement bulkSelectDropdown;
    @FindBy(xpath = "//div[@id='__next']//span[contains(text(),'Selected')]")
    public PageElement selectedRowCount;

    @FindBy(css = "[data-testid='virtual-table.select-all-shown']")
    public PageElement selectAll;

    @FindBy(css = "[data-testid='virtual-table.deselect-all-shown']")
    public PageElement deselectAll;

    @FindBy(css = "[data-testid='virtual-table.clear-current-selection']")
    public PageElement clearCurrentSelection;

    @FindBy(css = "[data-testid='virtual-table.show-only-selected']")
    public PageElement showOnlySelected;

    @FindBy(xpath = ".//span[@class='ant-input-suffix']")
    public PageElement clearFilter;

    public static final String ACTION_SELECT = "Select row";
    public static final String ACTION_RESCHEDULE = "Reschedule next day";

    public static final String ACTION_RTS = "RTS next day";

    public final String XPATH_TRACKING_ID_FILTER_INPUT = "//input[@data-testid='virtual-table.tracking_id.header.filter']";
    public final String XPATH_SHIPPER_NAME_FILTER_INPUT = "//input[@data-testid='virtual-table.shipper_name.header.filter']";


    public FailedDeliveryTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking_id")
          .put("type", "type")
          .put("shipperName", "shipper_name")
          .put("lastAttemptTime", "lastAttemptTimeDisplay")
          .put("failureReasonComments", "failureReasonCommentsDisplay")
          .put("attemptCount", "attempt_count")
          .put("invalidFailureCount", "invalidFailureCountDisplay")
          .put("validFailureCount", "validFailureCountDisplay")
          .put("failureReasonCodeDescription", "failureReasonCodeDescriptionsDisplay")
          .put("daysSinceLastAttempt", "daysSinceLastAttemptDisplay")
          .put("priorityLevel", "priorityLevelDisplay")
          .put("lastScannedHubName", "lastScannedHubNameDisplay")
          .put("orderTags", "tags")
          .build()
      );
      setEntityClass(FailedDelivery.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_SELECT, "//input[@class='ant-checkbox-input']",
          ACTION_RESCHEDULE, "//button[contains(@data-testid,'single-reschedule-icon')]",
          ACTION_RTS, "//button[contains(@data-testid,'single-rts-icon')]"
      ));
    }

    public void filterTableByTID(String columName, String value) {
      filterTableByColumn(XPATH_TRACKING_ID_FILTER_INPUT, columName, value);
    }

    public void filterTableByShipperName(String columName, String value) {
      filterTableByColumn(XPATH_SHIPPER_NAME_FILTER_INPUT, columName, value);
    }

    public void verifyTableisFiltered() {
      Assertions.assertThat(findElementByXpath(XPATH_END_OF_TABLE).isDisplayed())
          .as("End Of Table appear in Failed Delivery Management page").isTrue();
    }

    public void clearTIDFilter() {
      clearFilter.click();
    }

    public List<String> getFilteredValue() {
      final String FILTERED_TABLE_XPATH = "//div[contains(@class ,'BaseTable__row')]//div[@class='BaseTable__row-cell']";
      return findElementsByXpath(FILTERED_TABLE_XPATH).stream().map(WebElement::getText)
          .collect(Collectors.toList());
    }

    private void filterTableByColumn(String xPath, String columName, String value) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        findElementBy(By.xpath(f(xPath, columName))).sendKeys(
            value);
      }, 1000, 5);
    }

  }

  public void verifyBulkSelectResult() {
    String ShowingResults = fdmHeader.getText();
    String selectedRows = fdmTable.selectedRowCount.getText();
    char SPACE_CHAR = ' ';
    String numberOfSelectedRows = selectedRows.substring(0, selectedRows.lastIndexOf(SPACE_CHAR))
        .trim();
    Assertions.assertThat(ShowingResults).as("Number of selected rows are the same")
        .contains(numberOfSelectedRows);
    KEY_SELECTED_ROWS_COUNT = numberOfSelectedRows;
  }

  public static class RescheduleDialog extends AntModal {

    @FindBy(css = "[data-testid='reschedule-date']")
    public PageElement rescheduleDate;

    @FindBy(xpath = "//div[@class='ant-row']//button[contains(@class,'nv-button-inner')]//span[contains(text(),'Reschedule')]")
    public Button rescheduleButton;

    public RescheduleDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public RescheduleDialog setRescheduleDate(String value) {
      if (value != null) {
        rescheduleDate.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10));
        rescheduleDate.sendKeys(value + Keys.ENTER);
      }
      return this;
    }
  }

  public static class UploadCSVDialog extends AntModal {

    @FindBy(xpath = "//button//span[contains(text(),'Upload')]")
    public Button upload;

    public final String XPATH_UPLOAD_CSV = "//div//p[contains(text(),'Drag and drop here')]";

    public UploadCSVDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void generateRescheduleCSV(List<String> trackingIds, String rescheduleDate) {
      String csvContents = trackingIds.stream()
          .map(trackingId -> trackingId + "," + rescheduleDate)
          .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));

      csvContents = "tracking_id,delivery_date" + System.lineSeparator() + csvContents;

      File csvFile = createFile(
          String.format("csv_reschedule_%s.csv", StandardTestUtils.generateDateUniqueString()),
          csvContents);

      WebElement upload = getWebDriver().findElement(
          By.xpath(XPATH_UPLOAD_CSV));
      dragAndDrop(csvFile, upload);
    }

    public void generateNoHeaderCSV() {
      String csvContents = "NV012345,2019-01-01";
      File csvFile = createFile("No Headers File.csv", csvContents);
      WebElement upload = getWebDriver().findElement(
          By.xpath(XPATH_UPLOAD_CSV));
      dragAndDrop(csvFile, upload);
    }
  }

  public static class EditRTSDetailsDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public PageElement title;

    @FindBy(xpath = "//div[@data-testid='single-select']")
    public List<PageElement> selectionInput;

    @FindBy(xpath = "//span[@title='Unable to find address']")
    public PageElement unableToFindAddress;

    @FindBy(xpath = "//span[@title='Night Slot (6PM - 10PM)']")
    public PageElement nightSlot;

    @FindBy(xpath = "//div[.='Recipient Name']//input[@class='ant-input']")
    public PageElement recipientName;

    @FindBy(xpath = "//div[.='Recipient Contact']//input[@class='ant-input']")
    public PageElement recipientContact;

    @FindBy(xpath = "//div[.='Recipient Email']//input[@class='ant-input']")
    public PageElement recipientEmail;

    @FindBy(xpath = "//div[.='Shipper Instructions']//input[@class='ant-input ant-input-borderless']")
    public PageElement shipperInstructions;

    @FindBy(xpath = ".//div[./label[.='Date']]")
    public AntCalendarPicker scheduleDate;

    @FindBy(xpath = "//div[.='Country']//input[@class='ant-input ant-input-borderless']")
    public PageElement country;

    @FindBy(xpath = "//div[.='City']//input[@class='ant-input ant-input-borderless']")
    public PageElement city;

    @FindBy(xpath = "//div[.='Address 1']//input[@class='ant-input ant-input-borderless']")
    public PageElement address1;

    @FindBy(xpath = "//div[.='Address 2']//input[@class='ant-input ant-input-borderless']")
    public PageElement address2;

    @FindBy(xpath = "//div[.='Postal Code']//input[@class='ant-input ant-input-borderless']")
    public PageElement postalCode;

    @FindBy(xpath = "//button/span[.='Save Changes']")
    public Button saveChanges;

    @FindBy(xpath = "//button/span[.='Change Address']")
    public Button changeAddress;

    @FindBy(xpath = "//div[.='Country']//input[@class='ant-input']")
    public PageElement newCountry;

    @FindBy(xpath = "//div[.='City']//input[@class='ant-input']")
    public PageElement newCity;

    @FindBy(xpath = "//div[.='Address 1']//input[@class='ant-input']")
    public PageElement newAddress1;

    @FindBy(xpath = "//div[.='Address 2']//input[@class='ant-input']")
    public PageElement newAddress2;

    @FindBy(xpath = "//div[.='Postal Code']//input[@class='ant-input']")
    public PageElement newPostalCode;

    @FindBy(xpath = "//button/span[.='Address Finder']")
    public Button addressFinder;

    @FindBy(xpath = "//div[.='Search Term']//input[@class='ant-input']")
    public PageElement searchTerm;

    @FindBy(xpath = "//button/span[.='Search']")
    public Button search;

    @FindBy(xpath = "//button/span[.='Save Location']")
    public Button saveLocation;

    @FindBy(xpath = "//table[@data-testid='simple-table']//td[contains(.,'SG')]")
    public PageElement locationResult;

    @FindBy(xpath = "//button/span[.='Cancel Address Change']")
    public Button cancelAddressChange;


    public EditRTSDetailsDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public EditRTSDetailsDialog setDate(String value) {
      if (value != null) {
        scheduleDate.setDate(value);
      }
      return this;
    }
  }

  public static class SetSelectedToRTSDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-modal-header']")
    public PageElement dialogTitle;

    @FindBy(xpath = "//table[@data-testid='simple-table']//td[starts-with(.,'NVSG')]")
    public List<PageElement> trackingId;

    @FindBy(xpath = "//table[@data-testid='simple-table']//td[contains(.,'Pending reschedule')]")
    public PageElement status;

    @FindBy(xpath = "//button/span[.='Set Orders to RTS']")
    public Button setToRTS;

    @FindBy(xpath = "//input[@placeholder='Select date']")
    public PageElement pickDate;

    public SetSelectedToRTSDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public SetSelectedToRTSDialog setDate(String value) {
      if (value != null) {
        pickDate.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10));
        pickDate.sendKeys(value + Keys.ENTER);
      }
      return this;
    }
  }

  public static class ErrorDialog extends AntModal {

    @FindBy(xpath = "//div[@class='ant-alert-message']")
    public PageElement alertMessage;

    @FindBy(xpath = "//div[@class='ant-alert-description']//li")
    public Button alertDescription;

    @FindBy(xpath = "//button/span[.='Close']")
    public Button close;

    public ErrorDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
