package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.model.CoreV2PickupJobsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPageV2 extends SimpleReactPage<PickupAppointmentJobPageV2> {

  Logger LOGGER = getLogger(PickupAppointmentJobPage.class);

  public PickupAppointmentJobPageV2(WebDriver webDriver) {
    super(webDriver);
    bulkSelect = new BulkSelectTable(webDriver);
    existingUpcomingJob = new ExistingUpcomingJobModal(webDriver);
  }
  public BulkSelectTable bulkSelect;
  @FindBy(className = "ant-modal-wrap")
  public JobCreatedSuccess jobCreatedSuccess;
  public ExistingUpcomingJobModal existingUpcomingJob;
  @FindBy(className = "ant-modal-wrap")
  public FilterJobByID filterJobByIDModal;
  @FindBy(css = "#toast-container")
  private PageElement toastContainer;
  @FindBy(xpath = "//span[text()='Create or edit job']//ancestor::div[@id='__next']")
  public CreateOrEditJobPage createOrEditJobPage;
  @FindBy(className = "ant-modal-wrap")
  public DeletePickupJobModal deletePickupJobModal;
  @FindBy(css = ".ant-notification")
  public PickupPageNotification notificationModal;
  @FindBy(css = "[type='submit']")
  public PageElement loadSelection;
  @FindBy(css = "div.ant-collapse-extra button")
  public Button createEditJobButton;
  @FindBy(xpath = "//span[@class='ant-btn-loading-icon']")
  public PageElement loadingIcon;
  public String KEY_LAST_SELECTED_ROWS_COUNT = "KEY_LAST_SELECTED_ROWS_COUNT";
  public final String SELECTED_VALUE_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class,'ant-select-dropdown-hidden'))]//div[@label = '%s']";
  public final String PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH = "//div[@data-testid = 'tableHeaderTitle.%s']//div[contains(@data-testid,'sortIcon')]";
  public final String ACTIVE_DROPDOWN_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]";

  public boolean isToastContainerDisplayed() {
    try {
      return toastContainer.isDisplayed();
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  public PageElement getLoadSelection() {
    return loadSelection;
  }

  public void clickOnCreateOrEditJob() {
    waitUntilElementIsClickable(createEditJobButton.getWebElement());
    createEditJobButton.click();
  }

  public static class CreateOrEditJobPage extends PageElement {

    @FindBy(css = "input[id='shipper']")
    private PageElement shipperIDField;
    @FindBy(css = "input[id='shipperAddress']")
    private PageElement shipperAddressField;

    public final String shipperListItem = "//div[@legacyshipperid='%s']";
    public final String shipperAddressListItem = "//div[@label='%s']";

    public final String DELETE_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.cancel.%s']";

    public final String EDIT_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.edit.%s']";

    public CreateOrEditJobPage(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void clickDeleteButton(String jobId) {
      WebElement deleteButton = getWebDriver().findElement(
          By.cssSelector(f(DELETE_BUTTON_IN_CALENDAR_LOCATOR, jobId)));
      deleteButton.click();
    }

    public void fillShipperIdField(String shipperID) {
      shipperIDField.sendKeys(shipperID);
    }

    public void selectShipperFromList(String shipperID) {
      WebElement shipperItem = getWebDriver().findElement(By.xpath(f(shipperListItem, shipperID)));
      shipperItem.click();
    }

    public void fillShipperAddressField(String address) {
      shipperAddressField.sendKeys(address);
    }

    public void selectShipperAddressFromList(String address) {
      WebElement addressItem = getWebDriver().findElement(
          By.xpath(f(shipperAddressListItem, address)));
      addressItem.click();
    }

    public boolean isDeleteButtonByJobIdDisplayed(String jobId) {
      try {
        return webDriver.findElement(By.cssSelector(f(DELETE_BUTTON_IN_CALENDAR_LOCATOR, jobId)))
            .isDisplayed();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }

    public boolean isEditButtonByJobIdDisplayed(String jobId) {
      try {
        return webDriver.findElement(By.cssSelector(f(EDIT_BUTTON_IN_CALENDAR_LOCATOR, jobId)))
            .isDisplayed();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }
  }


  public static class DeletePickupJobModal extends AntModal {
    @FindBy(xpath = "//span[text()='Submit']/parent::button")
    public PageElement submitButton;
    public final String ITEMS_ON_DELETE_JOB_MODAL = "//div[span[text()='%s']]//following-sibling::div//span";

    public DeletePickupJobModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getFieldTextOnDeleteJobModal(String fieldName) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ITEMS_ON_DELETE_JOB_MODAL, fieldName))));
      return webDriver.findElement(By.xpath(f(ITEMS_ON_DELETE_JOB_MODAL, fieldName))).getText();
    }
  }


  public static class PickupPageNotification extends AntNotification {
    public PickupPageNotification(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class BulkSelectTable extends AntTableV2<CoreV2PickupJobsParams> {

    @FindBy(css = "[data-testid='bulkSelect.dropdown']")
    public PageElement bulkSelectDropdown;

    @FindBy(xpath = "//li[.='Select All Shown']")
    public PageElement selectAll;

    @FindBy(css = "[data-testid='bulkUpdate.dropdown']")
    public PageElement bulkUpdateDropdown;

    @FindBy(css = "[data-testid='resultTable.rowCount']")
    public AntSelect3 rowCount;

    @FindBy(css = "[data-testid='resultTable.selectedRowsCount']")
    public ForceClearTextBox selectedRowCount;

    @FindBy(css = "button[data-testid='create-button']")
    public AntButton saveChanges;

    @FindBy(xpath = "//li[.='Unselect All Shown']")
    public PageElement unSelectAll;

    @FindBy(xpath = "//li[.='Clear Selection']")
    public PageElement clearSelection;

    @FindBy(xpath = "//li[.='Display only selected']")
    public PageElement displayOnlySelected;

    @FindBy(xpath = "//button[. ='Filter by job ID']")
    public PageElement filterByJobId;
    public static final String COLUMN_TAGS = "tags";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_ID = "id";

    public static final String ACTION_EDIT = "Edit Job";
    public static final String ACTION_DETAILS = "view Job";
    public static final String ACTION_SELECTED = "Select row";

    public BulkSelectTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TAGS, "tagNames")
          .put(COLUMN_STATUS, "status")
          .put(COLUMN_ID, "pickupAppointmentJobId")
          .build()
      );
      setEntityClass(CoreV2PickupJobsParams.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT,
          "//div[@role='row'][%d]//div[@role='gridcell']//button[@data-testid='resultTable.editButton']",
          ACTION_DETAILS,
          "//div[@role='row'][%d]//div[@role='gridcell']//button[contains(@data-testid,'showDetailButton')]",
          ACTION_SELECTED,
          "//div[@role='row'][%d]//div[@role='gridcell']//input[contains(@data-testid,'checkbox')]"));
    }

    public List<String> getListIDs() {
      String PICKUP_JOBS_IDS_XPATH = "//div[contains(@class ,'BaseTable__table-frozen-left')]//div[@class='BaseTable__row-cell-text']";
      return findElementsByXpath(PICKUP_JOBS_IDS_XPATH).stream().map(WebElement::getText)
          .collect(Collectors.toList());
    }
  }

  public void verifyBulkSelectResult() {

    String ShowingResults = bulkSelect.rowCount.getText();
    String selectedRows = bulkSelect.selectedRowCount.getText();
    char SPACE_CHAR = ' ';
    String numberOfSelectedRows = selectedRows.substring(0, selectedRows.lastIndexOf(SPACE_CHAR))
        .trim();
    Assertions.assertThat(ShowingResults).as("Number of selected rows are the same")
        .contains(numberOfSelectedRows);
    KEY_LAST_SELECTED_ROWS_COUNT = numberOfSelectedRows;
  }

  public void verifyRowCountHasNotChanged() {
    String selectedRows = bulkSelect.selectedRowCount.getText();
    Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
        .contains(KEY_LAST_SELECTED_ROWS_COUNT);
  }

  public void verifyRowCountisEqualTo(String expectedRowCount) {
    String selectedRows = bulkSelect.selectedRowCount.getText();
    Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
        .contains(expectedRowCount);
  }

  public static class FilterJobByID extends AntModal {

    public FilterJobByID(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//div[text()='Filter by job ID']")
    public PageElement title;

    @FindBy(id = "jobIds")
    public TextBox inputJobId;

    @FindBy(xpath = "//span[text()='Filter Jobs']//parent::button")
    public Button confirmButton;

    public static final String ERROR_MESSAGE_XPATH = "//span[text()='%s']";

    public void verifyErrorMessages(String message) {
      Assertions.assertThat(findElementByXpath(f(ERROR_MESSAGE_XPATH, message)).isDisplayed())
          .as("Error message is the same").isTrue();
    }
  }


  public void verifyPickupJobsTable(){

    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupAppointmentJobId")).isEnabled()).as("Job ID is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"status")).isEnabled()).as("Job status is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"tagNames")).isEnabled()).as("Job tags is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"priorityLevel")).isEnabled()).as("Priority level is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"legacyShipperId")).isEnabled()).as("Shipper ID is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"shipperInfo")).isEnabled()).as("Shipper name & contact is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupAddress")).isEnabled()).as("Pickup address is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"driverName")).isEnabled()).as("Driver name is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"routeId")).isEnabled()).as("Route ID is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupReadyDatetimeStr")).isEnabled()).as("Ready by is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupLatestDatetimeStr")).isEnabled()).as("Latest by is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath("//div[@data-testid = 'tableHeaderTitle.historicalSize']").isEnabled()).as("Historical size breakdown is display").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupApproxVolume")).isEnabled()).as("Approx vol is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupServiceLevel")).isEnabled()).as("Job service level is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupServiceType")).isEnabled()).as("Job service type is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"failureReasonDescription")).isEnabled()).as("Failure reason is display and can be sorted").isTrue();
    Assertions.assertThat(findElementByXpath(f(PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,"pickupInstructions")).isEnabled()).as("Comments is display and can be sorted").isTrue();
  }

  public static class ExistingUpcomingJobModal {
    public ExistingUpcomingJobModal(WebDriver webDriver) {
      super();
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    @FindBy (xpath = "//span[text()='Enter new job to create']")
    public PageElement header;

    @FindBy (xpath = "//span[text()='Existing upcoming job']")
    public PageElement title;

    @FindBy (xpath = "//span[text()='Existing upcoming job']/following::input[@placeholder = 'Start date']")
    public PageElement startDate;

    @FindBy (xpath = "//span[text()='Existing upcoming job']/following::input[@placeholder = 'End date']")
    public PageElement endDate;

    @FindBy (id = "useExistingTimeslot")
    public  PageElement useExistingTimeslot;

    @FindBy (xpath = "//span[text()='Existing upcoming job']/following::input[@id = 'timeRange']")
    public PageElement timeRange;

    @FindBy (xpath = "//span[text()='Existing upcoming job']/following::input[@id = 'pickupTag']")
    public  PageElement pickupTag;

    @FindBy (xpath = "//span[text()='Existing upcoming job']/following::button[@type = 'submit']")
    public Button submit;
  }

  public void verifyExistingUpcomingJobPage(){
    existingUpcomingJob.header.waitUntilVisible();
    Assertions.assertThat(existingUpcomingJob.header.isDisplayed()).as("Existing upcoming job header is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.title.isDisplayed()).as("Existing upcoming job title is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.startDate.isDisplayed()).as("Existing upcoming job Start date is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.endDate.isDisplayed()).as("Existing upcoming job end date is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.timeRange.isEnabled()).as("Existing upcoming job time range is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.useExistingTimeslot.isEnabled()).as("Existing upcoming job Apply existing time slots is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.pickupTag.isEnabled()).as("Existing upcoming job pickup tag is display").isTrue();
    Assertions.assertThat(existingUpcomingJob.submit.getAttribute("disabled")).as("Existing upcoming job submit is disabled").isEqualTo("true");
  }

  public void selectItem(String item){
    waitUntilVisibilityOfElementLocated(f(SELECTED_VALUE_XPATH,item));
    findElementByXpath(f(SELECTED_VALUE_XPATH,item)).click();
    waitUntilInvisibilityOfElementLocated(ACTIVE_DROPDOWN_XPATH);
  }

  public static class JobCreatedSuccess extends AntModal {

    public JobCreatedSuccess(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//div[text()='Jobs created']")
    public PageElement title;

    @FindBy(xpath = "//span[text()='Time slot:']/following::span")
    public PageElement createdTime;

    @FindBy(xpath = "//span[text()='Ok']")
    public Button confirm;

    public final String COLUMN_DATA_XPATH = "//tbody[@class='ant-table-tbody']//td[text()='%s']";
  }

  public void verifyCreatedJobSuccess(Map<String,String> data){

    jobCreatedSuccess.title.waitUntilVisible();
    if (data.get("timeSlot")!=null){
      Assertions.assertThat(jobCreatedSuccess.createdTime.getText()).as("Time slot is the same").isEqualToIgnoringCase(data.get("timeSlot"));
    }
    if (data.get("pickupTag")!=null){
      Assertions.assertThat(isElementExist(f(jobCreatedSuccess.COLUMN_DATA_XPATH,data.get("pickupTag")))).as("Job tag is the same").isTrue();
    }

  }

}
