package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.model.CoreV2PickupJobsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.imageio.ImageIO;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PickupAppointmentJobPageV2 extends SimpleReactPage<PickupAppointmentJobPageV2> {

  private static final Logger LOGGER = LoggerFactory.getLogger(PickupAppointmentJobPageV2.class);

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
  @FindBy(xpath = "//button[@data-testid='resultTable.showDetailButton']")
  public PageElement viewJobDetailButton;
  @FindBy(css = "[type='submit']")
  public PageElement loadSelection;
  @FindBy(className = "ant-collapse-header")
  public Button showHideFiltersHeader;
  @FindBy(xpath = "//button[.='Create / edit job']")
  public Button createEditJobButton;
  @FindBy(xpath = "//span[text()='Create or edit job']//ancestor::div[@id='__next']")
  public CreateOrEditJobPage createOrEditJobPage;
  @FindBy(className = "ant-modal-wrap")
  public DeletePickupJobModal deletePickupJobModal;
  @FindBy(css = "div.ant-modal-content")
  public ViewJobDetailModal viewJobDetailModal;
  @FindBy(className = "ant-modal-wrap")
  public JobCreatedModal jobCreatedModal;
  @FindBy(css = ".ant-notification")
  public PickupPageNotification notificationModal;

  @FindBy(xpath = "div[@class='ant-notification-notice-message']")
  public PageElement messageNot;
  @FindBy(xpath = "//div[@id='toast-container']")
  public PickupPageErrorNotification pickupPageErrorNotification;

  @FindBy(xpath = "//span[@class='ant-btn-loading-icon']")
  public PageElement loadingIcon;
  @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-modal-title'][contains(text(),'Assign Tags')]")
  public EditJobTagModel editJobTagModel;

  @FindBy(className = "ant-modal-wrap")
  public BulkUpdateSuccessModal bulkUpdateSuccess;

  @FindBy(xpath = "//div[@class='ant-drawer-content']//h5[contains(text(),'Bulk update route ID')]//ancestor::div[@class='ant-drawer-content']")
  public EditJobRouteModal editJobRouteModal;

  @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-modal-title'][contains(text(),'Bulk remove route')]")
  public RemoveJobRouteModal removeJobRouteModal;
  @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-modal-title'][contains(text(),'Fail job')]")
  public BulkFailJobsModal bulkFailJobsModal;

  @FindBy(xpath = "//button//span[@text =]")
  public static String KEY_LAST_SELECTED_ROWS_COUNT = "KEY_LAST_SELECTED_ROWS_COUNT";

  @FindBy(css = "button.ant-dropdown-trigger")
  public Button createOrModifyPresetButton;

  @FindBy(xpath = "//li[text()='Save as Preset']")
  public Button saveAsPresetButton;
  @FindBy(xpath = "//span[text()='Update Current Preset']")
  public Button updateCurrentPresetButton;

  @FindBy(xpath = "//span[text()='Delete']")
  public Button deletePresetButton;

  @FindBy(xpath = "//span[text()='Save as New Preset']")
  public Button saveAsNewPresetButton;

  @FindBy(css = "div.ant-modal-content")
  public PresetModal presetModal;

  @FindBy(css = ".ant-modal")
  public JobDetailsModal jobDetailsModal;

  @FindBy(css = "#presetFilters")
  public PageElement presetFilters;

  public final String SELECTED_VALUE_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class,'ant-select-dropdown-hidden'))]//div[contains(@label,'%s')]";
  public final String PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH = "//div[@data-testid = 'tableHeaderTitle.%s']//div[contains(@data-testid,'sortIcon')]";
  public final String PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH = "//div[@data-testid = 'searchInput.%s']";

  public static final String ACTIVE_DROPDOWN_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]";
  private static final String FILEPATH = TestConstants.TEMP_DIR;

  public static final String ACTIVE_PRESET_OPTION = "div.ant-select-item-option-active div";

  public boolean isToastContainerDisplayed() {
    try {
      return toastContainer.isDisplayed();
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  public void clickOnJobDetailsButton() {
    viewJobDetailButton.waitUntilClickable();
    viewJobDetailButton.click();
  }

  public void verifyPresetByNameNotInList(String presetName) {
    HashMap<String, String> keys = new HashMap<>();
    presetFilters.sendKeys(Keys.ARROW_UP);
    while (true) {
      String name = webDriver.findElement(
          By.cssSelector(ACTIVE_PRESET_OPTION)).getText();
      if (name.equalsIgnoreCase(presetName)) {
        throw new java.util.NoSuchElementException("the preset name is in the list");

      }
      if (keys.containsKey(name)) {
        break;
      }
      keys.put(name, "founded");
      presetFilters.sendKeys(Keys.ARROW_DOWN);
    }
  }

  public void choosePresetByName(String presetName) {
    presetFilters.sendKeys(presetName);
    presetFilters.sendKeys(Keys.ENTER);
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
    @FindBy(xpath = "//label[@for='comments']/following::span[@aria-label='close-circle']")
    public PageElement clearJobComments;
    @FindBy(xpath = "//label[@for='tags']/following::span[@aria-label='close-circle']")
    public PageElement clearJobTags;
    @FindBy(xpath = "//label[@for='timeRange']/following::span[@aria-label='close-circle']")
    public PageElement clearJobTimeRange;

    @FindBy(xpath = "//label[@for='latestBy']/following::span[@aria-label='close-circle']")
    public PageElement clearLatestByTimeRange;

    @FindBy(xpath = "//label[@for='readyBy']/following::span[@aria-label='close-circle']")
    public PageElement clearReadyByTimeRange;
    public final String timeScrollBar = ".rc-virtual-list-scrollbar";
    public final String shipperListItem = "//div[@legacyshipperid='%s']";
    public final String shipperAddressListItem = "//div[contains(text(),'%s')]";

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
      doWithRetry(() -> {
        scrollToTimeIfNeeded(time, "readyBy_list");
        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "readyBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();
      }, "scrollIfNeeded", 2000, 5);
    }

    public void selectLatestbyTime(String time) {
      latestByField.click();
      doWithRetry(() -> {
        scrollToTimeIfNeeded(time, "readyBy_list");
        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "latestBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();
      }, "scrollIfNeeded", 2000, 5);
    }

    public void scrollToTimeIfNeeded(String time, String listName) {

      int neededTime = Integer.parseInt(List.of(time.split(":")).get(0));
      String lastElementTime = webDriver.findElement(
          By.xpath(f(Time_LIST_LOCATR, listName) + LAST_ITEM_IN_TIME_LIST)).getAttribute("label");
      Integer lastTime = Integer.parseInt(List.of(lastElementTime.split(":")).get(0));
      Integer tempLastTime = -1;
      while (lastTime <= neededTime && lastTime != tempLastTime) {
        tempLastTime = lastTime;

        WebElement timeToScroll = webDriver.findElement(
            By.xpath(f(Time_LIST_LOCATR, listName) + f(JOB_CUSTOM_TIME_FILTER_LOCATOR,
                lastElementTime)));
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

      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        clearJobComments.click();
      }, 1000, 5);
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

    public void clearCustomTimeRangeInput() {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        clearReadyByTimeRange.click();
        clearLatestByTimeRange.click();
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

  public static class ViewJobDetailModal extends AntModal {

    public static final String JOB_DETAIL_ITEMS_XPATH = "//span[contains(text(),'%s')]";
    public static final String JOB_IMAGES_ITEMS_XPATH = "//div[@class='ant-image-preview-mask']";
    public static final String JOB_SIGNATURE_IMAGE_ITEMS_XPATH = "//img[@alt='signature']";

    public static final String JOB_SIGNATURE_IMAGE_CANCEL_ITEMS_XPATH = "//li[@class='ant-image-preview-operations-operation']/span[@aria-label='close']";

    public static final String JOB_SECOND_PICK_UP_PROOF_ITEMS_XPATH = "//span[@data-testid='proof-1']";

    public ViewJobDetailModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getJobDetailItemsXpath(String itemName) {
      return findElementByXpath(f(JOB_DETAIL_ITEMS_XPATH, itemName)).getText();
    }

    public Boolean getButtonsOnJobDetailsPage(String itemName) {
      return findElementByXpath(f(JOB_DETAIL_ITEMS_XPATH, itemName)).isEnabled();
    }

    public Boolean getImagesOnJobDetailsPage() {
      return findElementByXpath(JOB_IMAGES_ITEMS_XPATH).isEnabled();
    }

    public void clickOnButtons(String itemName) {
      findElementByXpath(f(JOB_DETAIL_ITEMS_XPATH, itemName)).click();
    }

    public void clickOnSignatureImage() {
      findElementByXpath(JOB_SIGNATURE_IMAGE_ITEMS_XPATH).click();
    }

    public void clickOnSignatureImageToCancel() {
      findElementByXpath(JOB_SIGNATURE_IMAGE_CANCEL_ITEMS_XPATH).click();
    }

    public void verifyThatCsvFileIsDownloadedWithFilename(String fileName) {
      String downloadedCsvFile = getLatestDownloadedFilename(
          fileName);
      Assertions.assertThat(fileName).isEqualTo(downloadedCsvFile);
    }

    public void clickOnSecondPickUpProofButton() {
      findElementByXpath(JOB_SECOND_PICK_UP_PROOF_ITEMS_XPATH).click();
    }
  }

  public static class PresetModal extends AntModal {

    @FindBy(css = "input[data-testid='presetAction.presetNameInput']")
    public PageElement presetNameInput;

    @FindBy(css = "div.ant-modal-footer button")
    public Button savePresetButton;

    public PresetModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void fillPresetName(String name) {
      presetNameInput.sendKeys(name);
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

//    @FindBy(xpath = "div[@class='ant-notification-notice-message']")
//    public PageElement messageNot;
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

    @FindBy(xpath = "//li[contains(@class,'ant-dropdown-menu-item')]//span[contains(text(),'Assign job tag')]")
    public PageElement assignJobTag;

    @FindBy(xpath = "//li[contains(@class,'ant-dropdown-menu-item')]//span[contains(text(),'Route ID')]")
    public PageElement routeId;
    @FindBy(xpath = "//li[contains(@class,'ant-dropdown-menu-item')]//span[contains(text(),'Remove route')]")
    public PageElement removeRoute;
    @FindBy(xpath = "//li[contains(@class,'ant-dropdown-menu-item')]//span[contains(text(),'Fail job')]")
    public PageElement failJob;

    @FindBy(xpath = "//li[contains(@class,'ant-dropdown-menu-item')]//span[contains(text(),'Remove route')]//ancestor::li[contains(@class,'ant-dropdown-menu-item')]")
    public PageElement removeRouteMenuItem;

    @FindBy(xpath = "//div[contains(text(),'Clear All')]")
    public PageElement dropDownClearAll;

    @FindBy(css = "div[data-testid='filterInput.status']")
    public PageElement jobStatusDropDown;
    public static final String COLUMN_TAGS = "tags";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_ID = "id";
    public static final String COLUMN_ROUTE = "routeid";
    public static final int COLUMN_ROUTE_POS = 7;

    public static final String ACTION_EDIT = "Edit Job";
    public static final String ACTION_DETAILS = "view Job";
    public static final String ACTION_SELECTED = "Select row";
    public final String PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH = "//input[@data-testid = 'searchInput.%s']";
    public final String PICKUP_JOBS_COLUMN_EDIT_BUTTON = "//button[@data-testid = 'resultTable.editButton']";
    public final String PICKUP_JOB_ROW_TAGS = "//span[contains(@class,'ant-tag') and contains(text(),'%s')]";
    public static final String BULK_UPDATE_ITEMS = "//div[contains(@class,'ant-dropdown') and not(contains(@class,'ant-dropdown-hidden'))]//span[text() = '%s']/ancestor::li";
    public final String PICKUP_JOB_ROW_ROUTE = "//a[@data-testid='navigatorLink' and contains(text(),'%s')]";
    public final String PICKUP_JOB_ROW_COL_TEXT = "//div[contains(@class,'BaseTable__row-cell-text') and contains(text(),'%s')]";
    public final String PICKUP_JOB_ROW_COL = "//div[contains(@class,'BaseTable__row-cell') and contains(text(),'%s')]";
    public final String PICKUP_JOB_ROW_COL_ROUTE = "//a[contains(@data-testid,'navigatorLink') and contains(text(),'%s')]";
    public final String PICKUP_JOB_STATUS_SELECT = "input[data-testid='%s']";

    public boolean removeRouteStatus() {

      return Boolean.parseBoolean(removeRouteMenuItem.getAttribute("aria-disabled"));

    }

    public BulkSelectTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TAGS, "tagNames")
          .put(COLUMN_STATUS, "status")
          .put(COLUMN_ID, "pickupAppointmentJobId")
          .put(COLUMN_ROUTE, "routeId")
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

    public List<String> getTagsListWithName(String name) {
      return findElementsByXpath(f(PICKUP_JOB_ROW_TAGS, name)).stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());
    }

    public List<String> getRouteListWithId(String id) {
      return findElementsByXpath(f(PICKUP_JOB_ROW_ROUTE, id)).stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());
    }

    public void clickColumnRoute(String value) {
      JavascriptExecutor js = (JavascriptExecutor) webDriver;
      js.executeScript("arguments[0].scrollIntoView();",
          findElementBy(By.xpath(f(PICKUP_JOB_ROW_COL_ROUTE, value))));
      js.executeScript("arguments[0].click();",
          findElementBy(By.xpath(f(PICKUP_JOB_ROW_COL_ROUTE, value))));
//      findElementBy(By.xpath(f(PICKUP_JOB_ROW_COL_ROUTE, value))).click();
    }

    public List<String> getColListByValue(String value) {

      List<String> resultList = new ArrayList<>();

//      List<String> colSelector1 = findElementsByXpath(f(PICKUP_JOB_ROW_COL_TEXT, value)).stream()
//          .map(WebElement::getText)
//          .collect(Collectors.toList());
      List<String> colSelector2 = findElementsByXpath(f(PICKUP_JOB_ROW_COL_ROUTE, value)).stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());
      List<String> colSelector3 = findElementsByXpath(f(PICKUP_JOB_ROW_COL, value)).stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());
      Stream.of(colSelector2, colSelector3).forEach(resultList::addAll);
      return resultList;
    }

    public List<String> getRouteListByValue(String value) {
      return findElementsByXpath(f(PICKUP_JOB_ROW_COL_ROUTE, value)).stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());
    }


    public List<String> getListIDs() {
      String PICKUP_JOBS_IDS_XPATH = "//div[contains(@class ,'BaseTable__table-frozen-left')]//div[@class='BaseTable__row-cell-text']";
      return findElementsByXpath(PICKUP_JOBS_IDS_XPATH).stream().map(WebElement::getText)
          .collect(Collectors.toList());
    }

    public void filterTableUsing(String columName, String value) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        JavascriptExecutor js = (JavascriptExecutor) webDriver;
        js.executeScript("arguments[0].scrollIntoView();",
            findElementBy(By.xpath(f(PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH, columName))));
        findElementBy(By.xpath(f(PICKUP_JOBS_COLUMN_HEADER_INPUT_XPATH, columName))).sendKeys(
            value);
      }, 1000, 5);
    }

    public void selectStatusInTableUsing(String status) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        jobStatusDropDown.click();
        WebElement element = findElementBy(By.cssSelector(f(PICKUP_JOB_STATUS_SELECT, status)));
        JavascriptExecutor js = (JavascriptExecutor) webDriver;
        js.executeScript("arguments[0].click();", element);

        jobStatusDropDown.click();
      }, 3000, 5);
    }


    public void clickEditButton() {
      findElementBy(By.xpath(PICKUP_JOBS_COLUMN_EDIT_BUTTON)).click();
    }

    public boolean verifyBulkSelectOption(String optionName, String status) {
      String actualStatus = findElementByXpath(f(BULK_UPDATE_ITEMS, optionName)).getAttribute(
          "aria-disabled");
      String expectedStatus = status.trim().equalsIgnoreCase("disable") ? "true" : "false";
      return actualStatus.trim().equalsIgnoreCase(expectedStatus.trim());
    }

    public void clickBulkUpdateOption(String optionName) {
      waitUntilVisibilityOfElementLocated(f(BULK_UPDATE_ITEMS, optionName));
      findElementByXpath(f(BULK_UPDATE_ITEMS, optionName)).click();
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


  public static class BulkFailJobsModal extends AntModal {

    public BulkFailJobsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//span[text()='Submit']/parent::button")
    public Button submitButton;

    String JOB_FAIL_MENU_OPEN_BUTTON = "//tr[@data-row-key='%s']//*[@data-testid='bulkFailureReason.editButton']";
    String JOB_FAIL_MENU_APPLY_ALL_BUTTON = "//tr[@data-row-key='%s']//a[contains(text(),'Apply this to all')]";

    String JOB_FAIL_MENU_ERROR_MESSAGE = "//span[contains(text(),'Error: Job %s cannot be failed because it is not Routed')]";

    public void clickSelectFailReasonForJob(String jobId) {
      webDriver.findElement(By.xpath(f(JOB_FAIL_MENU_OPEN_BUTTON, jobId))).click();
    }

    public void clickApplyFailReasonToAll(String jobId) {
      webDriver.findElement(By.xpath(f(JOB_FAIL_MENU_APPLY_ALL_BUTTON, jobId))).click();
    }

    public boolean checkCannotFailedErrorMessageForJob(String jobId) {
      return webDriver.findElement(By.xpath(f(JOB_FAIL_MENU_ERROR_MESSAGE, jobId))).isDisplayed();
    }

  }

  public static class RemoveJobRouteModal extends AntModal {

    public RemoveJobRouteModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//span[text()='Submit']/parent::button")
    public Button submitButton;

  }

  public static class EditJobRouteModal extends AntModal {

    public EditJobRouteModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//span[text()='Update Route ID']/parent::button")
    public Button updateRouteId;

    @FindBy(xpath = "//a[text()='Apply this ID to all']")
    public Button ApplyThisIdToAll;
    String JOB_ROUTE_SELECT_INPUT = "//div[@data-testid='bulkUpdateRouteId.selectRoute-%s']";
    String ROUTE_OPTION = "//div[@id='pickupAppointments.%s_list']//ancestor::div[contains(@class,'ant-select-dropdown')]//div[contains(@label,'%s')]";


    public void selectRouteForJob(String routeName, String jobId) {
      webDriver.findElement(
          By.xpath(f(JOB_ROUTE_SELECT_INPUT, jobId))).click();
      webDriver.findElement(
          By.xpath(f(JOB_ROUTE_SELECT_INPUT, jobId) + "//input")).sendKeys(routeName);
      webDriver.findElement(By.xpath((f(ROUTE_OPTION, jobId, routeName)))).click();
    }
  }

  public static class EditJobTagModel extends AntModal {

    public EditJobTagModel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//div[@data-testid='assignJobTag.select']//input")
    public PageElement tagsField;
    String JOB_TAG_FILTER_LOCATOR = "div[label='%s']";

    public void selectTagInJobTagsField(String tag) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        tagsField.click();
        tagsField.sendKeys(tag);
        WebElement tagElement = webDriver.findElement(
            By.cssSelector(f(JOB_TAG_FILTER_LOCATOR, tag)));

        tagElement.click();

      }, 1000, 3);

    }
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

  public static class BulkUpdateSuccessModal extends AntModal {

    public BulkUpdateSuccessModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Submit']")
    public PageElement submitButton;

    @FindAll(@FindBy(css = "[data-testid = 'successReason.photoSelect']"))
    public List<FileInput> proofUploadFiles;

    String SUCCESS_JOB_PAGE_ERROR_XPATH = "//tr[@data-row-key='%s']//following-sibling::tr[1]";

    public String getErrorMessage(String jobId) {
      waitUntilVisibilityOfElementLocated(f(SUCCESS_JOB_PAGE_ERROR_XPATH, jobId));
      String errorMessage = findElementByXpath(f(SUCCESS_JOB_PAGE_ERROR_XPATH, jobId)).getText();
      return errorMessage;
    }
  }

  public void setProofUploadFile() {
    String FILENAME = RandomStringUtils.randomAlphanumeric(3, 8) + ".png";
    String fullPath = FILEPATH + FILENAME;
    createRandomImage(fullPath);
    bulkUpdateSuccess.proofUploadFiles.forEach(
        proofUploadFile -> proofUploadFile.setValue(fullPath));
  }

  private void createRandomImage(String fullPath) {
    int width = 640, height = 320;
    BufferedImage img = null;
    img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
    File f = null;

    // create random values pixel by pixel
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int a = (int) (Math.random() * 256);
        int r = (int) (Math.random() * 256);
        int g = (int) (Math.random() * 256);
        int b = (int) (Math.random() * 256);
        int p = (a << 24) | (r << 16) | (g << 8) | b;
        img.setRGB(x, y, p);
      }
    }
    try {
      f = new File(fullPath);
      ImageIO.write(img, "png", f);
    } catch (IOException e) {
      LOGGER.warn("Can not create random image file: {}", e);
    }
  }

  public static class JobDetailsModal extends AntModal {

    @FindBy(xpath = ".//div[./span[.='Status']]/span[2]")
    public PageElement status;

    @FindBy(xpath = ".//div[./span[.='Removed TID']]/span[2]")
    public PageElement removedTid;

    @FindBy(xpath = ".//div[./span[.='Scanned at Shipper Count']]/span[2]")
    public PageElement scannedAtShipperCount;

    @FindBy(xpath = ".//span[.='No details yet']")
    public PageElement noDetailsYet;

    @FindBy(xpath = ".//div[./span[.=\"Scanned at Shipper's\"]]/span[position()>1]")
    public List<PageElement> scannedAtShippers;

    @FindBy(xpath = ".//button[.='Download Parcel List']")
    public Button downloadParcelList;

    public JobDetailsModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

  }


}
