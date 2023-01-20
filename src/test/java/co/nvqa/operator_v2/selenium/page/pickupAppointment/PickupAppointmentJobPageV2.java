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
import co.nvqa.operator_v2.selenium.page.ToastInfo;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPageV2 extends SimpleReactPage<PickupAppointmentJobPageV2> {

  static Logger LOGGER = getLogger(PickupAppointmentJobPageV2.class);

  public PickupAppointmentJobPageV2(WebDriver webDriver) {
    super(webDriver);
    bulkSelect = new BulkSelectTable(webDriver);
    existingUpcomingJob = new ExistingUpcomingJobModal(webDriver);
    editPAJob = new EditPAJobModel(webDriver);
  }

  public BulkSelectTable bulkSelect;
  @FindBy(className = "ant-modal-wrap")
  public JobCreatedSuccess jobCreatedSuccess;
  public ExistingUpcomingJobModal existingUpcomingJob;
  public EditPAJobModel editPAJob;
  @FindBy(className = "ant-modal-wrap")
  public FilterJobByID filterJobByIDModal;
  @FindBy(css = "#toast-container")
  private PageElement toastContainer;
  @FindBy(css = "[type='submit']")
  public PageElement loadSelection;
  @FindBy(xpath = "//button[.='Create / edit job']")
  public Button createEditJobButton;
  @FindBy(xpath = "//span[text()='Create or edit job']//ancestor::div[@id='__next']")
  public CreateOrEditJobPage createOrEditJobPage;
  @FindBy(className = "ant-modal-wrap")
  public DeletePickupJobModal deletePickupJobModal;

  @FindBy(className = "ant-modal-wrap")
  public JobCreatedModal jobCreatedModal;
  @FindBy(css = ".ant-notification")
  public PickupPageNotification notificationModal;
  @FindBy(xpath = "//div[@id='toast-container']")
  public PickupPageErrorNotification pickupPageErrorNotification;

  @FindBy(xpath = "//span[@class='ant-btn-loading-icon']")
  public PageElement loadingIcon;


  public static String KEY_LAST_SELECTED_ROWS_COUNT = "KEY_LAST_SELECTED_ROWS_COUNT";
  public final String SELECTED_VALUE_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class,'ant-select-dropdown-hidden'))]//div[contains(@label,'%s')]";
  public final String PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH = "//div[@data-testid = 'tableHeaderTitle.%s']//div[contains(@data-testid,'sortIcon')]";
  public final String PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH = "//div[@data-testid = 'searchInput.%s']";

  public static final String ACTIVE_DROPDOWN_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]";

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
    @FindBy(xpath = "//span[text()='Create']/parent::button")
    private Button createButton;
    @FindBy(xpath = "//span[text()='Save']/parent::button")
    private Button saveButton;
    @FindBy(css = "#dateRange")
    private Button selectDateRange;

    @FindBy(css = "input[aria-owns=timeRange_list]")
    private PageElement selectTimeRange;

    @FindBy(css = "#tags")
    private PageElement tagsField;
    @FindBy(css = "#readyBy")
    private PageElement readyByField;
    @FindBy(css = "#latestBy")
    private PageElement latestByField;
    @FindBy(css = "#comments")
    public PageElement commentsInput;
    @FindBy(xpath = "//label[@for='tags']/following::span[@aria-label='close-circle']")
    public PageElement clearJobTags;

    @FindBy(xpath = "//label[@for='timeRange']/following::span[@aria-label='close-circle']")
    public PageElement clearJobTimeRange;
    public final String timeScrollBar = ".rc-virtual-list-scrollbar";
    public final String shipperListItem = "//div[@legacyshipperid='%s']";
    public final String shipperAddressListItem = "//div[contains(@label,'%s')]";

    public final String DELETE_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.cancel.%s']";

    public final String EDIT_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.edit.%s']";
    public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";

    public final String TIME_RANGE_FILTER_BY_LABEL_LOCATOR = "div[label='%s']";
    public final String JOB_TAG_FILTER_LOCATOR = "div[label='%s']";
    public final String JOB_CUSTOM_TIME_FILTER_LOCATOR = "//div[@label='%s']";

    public final String LAST_ITEM_IN_TIME_LIST = "//div[@class='rc-virtual-list-holder-inner']/descendant::div[@class='ant-select-item ant-select-item-option'][last()]";

    public final String Time_LIST_LOCATR = "//div[@id='%s']/parent::div";

    public final String STAR_IN_CALENDAR_LOCATOR = "//div[@data-testid='paJob.cancel.%s']//ancestor::div[@status='%s']//span[@data-testid='paJob.priority']";
    public final String TAG_IN_CALENDAR_LOCATOR = "//div[@class='ant-popover-content']//span[contains(text(),'%s')]";

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
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        WebElement shipperItem = getWebDriver().findElement(
            By.xpath(f(shipperListItem, shipperID)));
        shipperItem.click();
      }, 1000, 3);
    }

    public void fillShipperAddressField(String address) {
      shipperAddressField.sendKeys(address);
    }

    public void selectShipperAddressFromList(String address) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        WebElement addressItem = getWebDriver().findElement(
            By.xpath(f(shipperAddressListItem, address)));
        addressItem.click();
      }, 1000, 3);
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


    public boolean isCreateButtonDisabled() {
      try {

        return createButton.isEnabled();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }

    public boolean isSaveButtonDisabled() {
      try {

        return saveButton.isEnabled();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }


    public void clickCreateButton() {
      createButton.click();
    }

    public void selectDataRangeByTitle(String dayStart, String dayEnd) {
      selectDateRange.click();
      waitUntilVisibilityOfElementLocated(webDriver.findElement(
          By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
      webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart)))
          .click();
      webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd)))
          .click();
    }

    public void selectTimeRange(String timeRange) {

      retryIfRuntimeExceptionOccurred(() -> {
        selectTimeRange.click();

        WebElement customTimeRange = webDriver.findElement(
            By.cssSelector(f(TIME_RANGE_FILTER_BY_LABEL_LOCATOR, timeRange)));
        customTimeRange.click();
      });

    }

    public void selectTagInJobTagsField(String tag) {
      tagsField.click();
      tagsField.sendKeys(tag);
      WebElement tagElement = webDriver.findElement(By.cssSelector(f(JOB_TAG_FILTER_LOCATOR, tag)));

      tagElement.click();
      tagsField.sendKeys(Keys.ESCAPE);
    }


    public void selectReadybyTime(String time) {
      readyByField.click();
      scrollToTimeIfNeeded(time, "readyBy_list");

      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "readyBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();
      }, 2000, 10);

    }


    public void selectLatestbyTime(String time) {
      latestByField.click();
      scrollToTimeIfNeeded(time, "latestBy_list");

      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "latestBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();
      }, 2000, 10);

    }

    public void scrollToTimeIfNeeded(String time, String listName) {
      int neededTime = Integer.parseInt(List.of(time.split(":")).get(0));

      String lastElementTime = webDriver.findElement(
          By.xpath(f(Time_LIST_LOCATR, listName) + LAST_ITEM_IN_TIME_LIST)).getAttribute("label");
      Integer lastTime = Integer.parseInt(List.of(lastElementTime.split(":")).get(0));
      Integer tempLastTime = -1;
      while (lastTime <= neededTime && lastTime != tempLastTime) {
        tempLastTime = lastTime;

        LOGGER.debug(String.valueOf(lastTime));
        moveToElementWithXpath(f(Time_LIST_LOCATR, listName));
        WebElement readyTimeList = webDriver.findElement(By.xpath(f(Time_LIST_LOCATR, listName)));
        WebElement timeToScroll = readyTimeList.findElement(
            By.xpath(f(JOB_CUSTOM_TIME_FILTER_LOCATOR, lastElementTime)));
        scrollIntoView(timeToScroll, true);
        lastElementTime = webDriver.findElement(
            By.xpath(f(Time_LIST_LOCATR, listName) + LAST_ITEM_IN_TIME_LIST)).getAttribute("label");
        lastTime = Integer.parseInt(List.of(lastElementTime.split(":")).get(0));

      }
    }

    public void addJobComments(String comment) {
      commentsInput.sendKeys(comment);
    }

    public void clearJobComments() {
      commentsInput.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
    }

    public void clickEditButton(String jobId) {
      WebElement deleteButton = getWebDriver().findElement(
          By.cssSelector(f(EDIT_BUTTON_IN_CALENDAR_LOCATOR, jobId)));
      deleteButton.click();
    }

    public boolean isStarByJobIdDisplayed(String jobId, String status) {
      try {
        return webDriver.findElement(By.xpath(f(STAR_IN_CALENDAR_LOCATOR, jobId, status)))
            .isDisplayed();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }

    public boolean isTagDisplayed(String tag) {
      try {
        return webDriver.findElement(By.xpath(f(TAG_IN_CALENDAR_LOCATOR, tag)))
            .isDisplayed();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }

    public void clickSaveButton() {
      saveButton.click();
    }

    public void hoverOnEditButton(String jobID) {

      moveToElement(
          webDriver.findElement(By.cssSelector(f(EDIT_BUTTON_IN_CALENDAR_LOCATOR, jobID))));
    }

    public void clearTagsInput() {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        clearJobTags.click();
      }, 1000, 5);
    }

    public void clearTimeRangeInput() {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        clearJobTimeRange.click();
      }, 1000, 5);
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


  public static class JobCreatedModal extends AntModal {

    @FindBy(xpath = "//div[text()='Job created']")
    public PageElement title;

    @FindBy(xpath = "//span[text()='Ok']/parent::button")
    public PageElement okButton;
    public final String ITEMS_ON_JOB_CREATED_MODAL = "//span[text()='%s']//following-sibling::span";
    public final String ERROR_MESSAGE_XPATH = "//div[contains(@class,'ant-alert-error')]//span[contains(text(),'%s')]";
    public final String ALERT_TEXT = "//span[contains(text(),'%s')]";

    public JobCreatedModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getFieldTextOnJobCreatedModal(String fieldName) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ITEMS_ON_JOB_CREATED_MODAL, fieldName))));
      return webDriver.findElement(By.xpath(f(ITEMS_ON_JOB_CREATED_MODAL, fieldName))).getText();
    }

    public String getErrorMessageWithText(String message) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ALERT_TEXT, message))));
      return webDriver.findElement(By.xpath(f(ALERT_TEXT, message))).getText();
    }
  }


  public static class PickupPageNotification extends AntNotification {

    public PickupPageNotification(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class PickupPageErrorNotification extends ToastInfo {

    public PickupPageErrorNotification(WebDriver webDriver, WebElement webElement) {
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

    @FindBy(css = "[data-testid='resultTable.editButton']")
    public PageElement editButton;
    @FindBy(xpath = "//button[. ='Filter by job ID']")
    public PageElement filterByJobId;
    public static final String COLUMN_TAGS = "tags";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_ID = "id";

    public static final String ACTION_EDIT = "Edit Job";
    public static final String ACTION_DETAILS = "view Job";
    public static final String ACTION_SELECTED = "Select row";
    public final String PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH = "//input[@data-testid = 'searchInput.%s']";
    public final String PICKUP_JOBS_COLUMN_EDIT_BUTTON = "//button[@data-testid = 'resultTable.editButton']";

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

    public void filterTableUsing(String columName, String value) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        findElementBy(By.xpath(f(PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH, columName))).sendKeys(
            value);
      }, 1000, 5);
    }

    public void clickEditButton() {
      findElementBy(By.xpath(PICKUP_JOBS_COLUMN_EDIT_BUTTON)).click();
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

  public static class ExistingUpcomingJobModal {

    public ExistingUpcomingJobModal(WebDriver webDriver) {
      super();
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    @FindBy(xpath = "//span[text()='Enter new job to create']")
    public PageElement header;

    @FindBy(xpath = "//span[text()='Existing upcoming job']")
    public PageElement title;

    @FindBy(xpath = "//span[text()='Existing upcoming job']/following::input[@placeholder = 'Start date']")
    public PageElement startDate;

    @FindBy(xpath = "//span[text()='Existing upcoming job']/following::input[@placeholder = 'End date']")
    public PageElement endDate;

    @FindBy(id = "useExistingTimeslot")
    public PageElement useExistingTimeslot;

    @FindBy(xpath = "//span[text()='Existing upcoming job']/following::input[@id = 'timeRange']")
    public PageElement timeRange;

    @FindBy(xpath = "//span[text()='Existing upcoming job']/following::input[@id = 'pickupTag']")
    public PageElement pickupTag;

    @FindBy(xpath = "//span[text()='Existing upcoming job']/following::button[@type = 'submit']")
    public Button submit;
  }

  public void selectItem(String item) {
    waitUntilVisibilityOfElementLocated(f(SELECTED_VALUE_XPATH, item));
    findElementByXpath(f(SELECTED_VALUE_XPATH, item)).click();
    waitUntilInvisibilityOfElementLocated(ACTIVE_DROPDOWN_XPATH);
  }

  public static class JobCreatedSuccess extends AntModal {

    public JobCreatedSuccess(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//div[text()='Jobs created']")
    public PageElement title;

    @FindBy(xpath = "//div[text()='Job created']")
    public PageElement title2;

    @FindBy(xpath = "//span[text()='Time slot:']/following::span")
    public PageElement createdTime;

    @FindBy(xpath = "//span[text()='Ok']")
    public Button confirm;

    public final String COLUMN_DATA_XPATH = "//tbody[@class='ant-table-tbody']//td[text()='%s']";

    @FindBy(xpath = "//span[text()='Ready by:']/following-sibling::span")
    public PageElement startTime;

    @FindBy(xpath = "//span[text()='Latest by:']/following-sibling::span")
    public PageElement endTime;

    @FindBy(xpath = "//span[text()='Jobs created for the following dates:']/following-sibling::span")
    public PageElement followingDates;


  }

  public static class EditPAJobModel {

    public EditPAJobModel(WebDriver webDriver) {
      super();
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    @FindBy(xpath = "//button[@class = 'ant-drawer-close']")
    public PageElement close;

    @FindBy(id = "route")
    public PageElement AddNewRoute;

    @FindBy(xpath = "//button[. = 'Update route']")
    public Button updateRoute;

    @FindBy(xpath = "//span[text()='Current route']/following-sibling::span")
    public PageElement currentRoute;

    @FindBy(xpath = "//*[@data-testid='pickupAppointmentDrawer.title']/parent::div/following-sibling::div/span")
    public PageElement status;

    @FindBy(xpath = "//button[. = 'Update job tags']")
    public Button updateTags;

    @FindBy(id = "tagIds")
    public PageElement AddNewTag;

    String JOB_TAG_REMOVE_XPATH = "//span[@class='ant-select-selection-item-content' and text()='%s']/following-sibling::span[contains(@class,'item-remove')]";

    @FindBy(xpath = "//button[. = 'Create new job']")
    public Button createNewJob;

  }

  public void setRouteOnEditPAJobPage(String routeId) {
    editPAJob.AddNewRoute.click();
    editPAJob.AddNewRoute.sendKeys(routeId);
    waitUntilVisibilityOfElementLocated(f(SELECTED_VALUE_XPATH, routeId));
    findElementByXpath(f(SELECTED_VALUE_XPATH, routeId)).click();
    editPAJob.updateRoute.waitUntilClickable();
  }

  public void updateRouteOnEditPAJobPage() {
    editPAJob.updateRoute.waitUntilClickable();
    editPAJob.updateRoute.click();
    loadingIcon.waitUntilInvisible();
  }

  public void setTagsOnEditPAJobPage(String tag) {
    editPAJob.AddNewTag.click();
    editPAJob.AddNewTag.sendKeys(tag);
    waitUntilVisibilityOfElementLocated(f(SELECTED_VALUE_XPATH, tag));
    findElementByXpath(f(SELECTED_VALUE_XPATH, tag)).click();
    editPAJob.status.click();
  }

  public void updateTagsOnEditPAJobPage() {
    editPAJob.updateTags.waitUntilClickable();
    editPAJob.updateTags.click();
    loadingIcon.waitUntilInvisible();
  }

  public void removeTagOnEditJobpage(String tagName) {
    findElementByXpath(f(editPAJob.JOB_TAG_REMOVE_XPATH, tagName)).click();
    editPAJob.updateTags.waitUntilClickable();
  }
}