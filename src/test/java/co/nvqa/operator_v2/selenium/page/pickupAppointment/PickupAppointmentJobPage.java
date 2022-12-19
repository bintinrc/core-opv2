package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.model.CoreV2PickupJobsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPage extends SimpleReactPage<PickupAppointmentJobPage> {

  Logger LOGGER = getLogger(PickupAppointmentJobPage.class);

  @FindBy(css = "#shippers")
  private PageElement shipperIDField;

  @FindBy(css = "#dateRange")
  private Button selectDateRange;

  @FindBy(css = "div.ant-collapse-extra button")
  public Button createEditJobButton;

  @FindBy(css = "[type='submit']")
  public PageElement loadSelection;

  @FindBy(xpath = "//span[@class='ant-btn-loading-icon']")
  public PageElement loadingIcon;


  @FindAll(@FindBy(css = ".BaseTable__table-frozen-left .BaseTable__row-cell-text"))
  private List<PageElement> jobIdElements;

  @FindBy(css = ".ant-collapse-content-box")
  private PageElement contentBox;

  @FindBy(css = "[data-testid='resultTable.editButton']")
  private PageElement editButton;

  @FindBy(css = "#route")
  private PageElement routeIdInput;

  @FindBy(xpath = "//*[text()='Update route']/..")
  private PageElement updateRouteButton;

  @FindBy(xpath = "//span[text()='Success']/parent::button")
  public PageElement forceSuccess;

  @FindBy(xpath = "//span[text()='Fail']/parent::button")
  public PageElement forceFail;


  @FindBy(xpath = "//div[@role='tooltip' and contains(text(),'Job cannot be')]")
  public PageElement successFailToolTip;


  @FindBy(xpath = "//span[text()='Submit']/..")
  private PageElement submitButton;

  @FindBy(css = "")
  private PageElement successJobButton;

  @FindBy(css = ".BaseTable")
  private PageElement jobTable;

  @FindBy(css = "#__next")
  private CreateOrEditJobPage createOrEditJobPage;

  @FindBy(css = "#toast-container")
  private PageElement toastContainer;

  @FindBy(css = "input[placeholder='Start date']")
  private PageElement selectedStartDay;

  @FindBy(css = "input[placeholder='End date']")
  private PageElement selectedEndDay;

  @FindBy(xpath = "//input[@id='priority']/parent::span/following-sibling::span")
  private PageElement selectedPriority;

  @FindBy(css = "div.ant-collapse-header")
  private Button showOrHideFilters;

  @FindBy(xpath = "//div[@class='ant-collapse-header' and @aria-expanded='false']")
  private PageElement invisibleFiltersBlock;

  @FindBy(xpath = "//span[text()='Clear Selection']/parent::button")
  private Button clearSelectionButton;

  @FindBy(css = "#presetFilters")
  private PageElement presetFilters;

  @FindBy(xpath = "//input[@id='priority']//parent::span//parent::div")
  private PageElement priorityButton;

  @FindBy(css = "#serviceType")
  private PageElement jobServiceTypeInput;

  @FindBy(css = "#serviceLevel")
  private PageElement jobServiceLevelInput;

  @FindBy(css = "#jobStatus")
  private PageElement jobStatusInput;

  @FindBy(css = "#zones")
  private PageElement jobZonesInput;

  @FindBy(css = "#masterShippers")
  private PageElement jobMasterShipperInput;

  @FindBy(xpath = "//label[@for='jobStatus']/following::span[@aria-label='close-circle']")
  private PageElement clearJobStatusButton;

  @FindBy(xpath = "//div[text()='In Progress']")
  private PageElement inProgressFilterOption;

  @FindBy(css = "input[data-testid='successPickupAppointmentModal.photoSelect']")
  private PageElement uploadPhotoInput;

  @FindBy(css = "#priority")
  private PageElement priorityInput;

  @FindBy(css = "button.ant-dropdown-trigger")
  private Button createOrModifyPresetButton;

  @FindBy(xpath = "//li[text()='Save as Preset']")
  private Button saveAsPresetButton;

  @FindBy(css = "div.ant-modal-content")
  private PageElement presetModal;

  @FindBy(css = "input[data-testid='presetAction.presetNameInput']")
  private PageElement presetNameInput;

  @FindBy(css = "div.ant-modal-footer button")
  private Button confirmPresetButton;

  @FindBy(css = "div.ant-notification-notice")
  private PageElement newPresetCreatedPopup;

  @FindBy(css = "div.ant-select-item-option-active div")
  private PageElement selectedPresetInDropdownMenu;

  @FindBy(xpath = "//span[text()='Update Current Preset']")
  private Button updateCurrentPresetButton;

  @FindBy(xpath = "//div[text()='Current Preset Updated']")
  private PageElement currentPresetUpdatedPopup;

  @FindBy(xpath = "//span[text()='Delete']")
  private Button deletePresetButton;

  @FindBy(xpath = "//div[text()='Preset Deleted']")
  private PageElement presetDeletedPopup;

  @FindBy(css = "div.ant-notification-notice-description")
  private PageElement newPresetCreatedPopupName;

  public final String ID_NEXT = "__next";
  public final String MODAL_CONTENT_LOCAL = "div.ant-modal-content";
  public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shippers_list_0']";
  public final String VERIFY_ROUTE_FIELD_LOCATOR = "//input[@aria-activedescendant='route_list_0']";
  public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";
  public final String DISABLE_CALENDAR_DAY_BY_TITLE_LOCATOR = "td.ant-picker-cell.ant-picker-cell-disabled[title='%s']";
  public final String VALUE = "value";
  public final String TITLE = "title";
  public final String DROPDOWN_MENU_LOCATOR = ".ant-select-dropdown:not(.ant-select-dropdown-hidden)";
  public final String DROPDOWN_MENU_NO_DATA_LOCATOR = ".ant-empty";
  public final String SELECTION_LABEL_LOCATOR = "div[label='%s']";
  public final String SELECTION_ITEMS = "//input[@id='%s']//parent::span//preceding-sibling::span//span[@class='ant-select-selection-item-content']";
  public String KEY_LAST_SELECTED_ROWS_COUNT = "KEY_LAST_SELECTED_ROWS_COUNT";
  public final String PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH = "//div[@data-testid = 'tableHeaderTitle.%s']//div[contains(@data-testid,'sortIcon')]";

  public final String SELECTED_VALUE_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class,'ant-select-dropdown-hidden'))]//div[@label = '%s']";
  public BulkSelectTable bulkSelect;

  @FindBy(className = "ant-modal-wrap")
  public FilterJobByID filterJobByIDModal;

  @FindBy(className = "ant-modal-wrap")
  public JobCreatedSuccess jobCreatedSuccess;

  public ExistingUpcomingJobModal existingUpcomingJob;

  public final String ARIA_ACTIVEDESCENDANT = "aria-activedescendant";
  public final String ARIA_LABEL = "aria-label";
  public final String DROPDOWN_BOTTOM_LEFT_LOCATOR = "//div[contains(@class,'ant-dropdown-placement-bottomLeft') and not(contains(@class,'ant-dropdown-hidden'))]";
  public final String SELECTED_DAY_IN_CALENDAR_LOCATOR = "td.ant-picker-cell-selected";
  public final String SHOW_PREVIOUS_MONTH_BUTTON_LOCATION = "button.ant-picker-header-prev-btn";

  public PickupAppointmentJobPage(WebDriver webDriver) {
    super(webDriver);
    bulkSelect = new BulkSelectTable(webDriver);
    existingUpcomingJob = new ExistingUpcomingJobModal(webDriver);
  }

  public PickupAppointmentJobPage clickLoadSelectionButton() {
    contentBox.click();
    loadSelection.click();
    return this;
  }

  public PickupAppointmentJobPage clearJobStatusFilter() {

    jobStatusInput.click();
    clearJobStatusButton.click();
    return this;
  }

  public PickupAppointmentJobPage addProofPhoto() {
    final ClassLoader classLoader = getClass().getClassLoader();
    File file = new File(
        Objects.requireNonNull(classLoader.getResource("images/dpPhotoValidSize.png")).getFile());
    uploadPhotoInput.sendKeys(file.getPath());
    return this;
  }

  public PickupAppointmentJobPage selectInprogressJobStatus() {

    jobStatusInput.click();

    inProgressFilterOption.click();
    return this;
  }

  public PickupAppointmentJobPage clickEditButton() {
    waitUntilVisibilityOfElementLocated(editButton.getWebElement());
    editButton.click();

    return this;
  }

  public PickupAppointmentJobPage clickSubmitButton() {
    waitUntilVisibilityOfElementLocated(submitButton.getWebElement());
    submitButton.click();

    return this;
  }

  public PickupAppointmentJobPage clickFourceSuccessButton() {
    waitUntilVisibilityOfElementLocated(forceSuccess.getWebElement());
    forceSuccess.click();

    return this;
  }

  public PickupAppointmentJobPage setRouteId(String routeId) {
    waitUntilVisibilityOfElementLocated(routeIdInput.getWebElement());
    routeIdInput.sendKeys(routeId);
    waitUntilVisibilityOfElementLocated(VERIFY_ROUTE_FIELD_LOCATOR);
    routeIdInput.sendKeys(Keys.ENTER);
    return this;
  }

  public PickupAppointmentJobPage clickUpdateRouteButton() {
    updateRouteButton.click();
    return this;
  }

  public PickupAppointmentJobPage clickSuccessJobButton() {
    waitUntilVisibilityOfElementLocated(successJobButton.getWebElement());
    successJobButton.click();
    return this;
  }

  public List<String> getJobIdsText() {
    waitUntilVisibilityOfElementLocated(jobTable.getWebElement());
    return jobIdElements.stream().map(PageElement::getText).collect(Collectors.toList());
  }

  public PickupAppointmentJobPage setShipperIDInField(String shipperID) {
    sendTextInFieldAndChooseData(shipperIDField, shipperID, VERIFY_SHIPPER_FIELD_LOCATOR);
    return this;
  }

  private void sendTextInFieldAndChooseData(PageElement field, String data, String verifyLocator) {
    field.sendKeys(data);
    waitUntilVisibilityOfElementLocated(verifyLocator);
    field.sendKeys(Keys.ENTER);
    contentBox.click();
  }

  public PickupAppointmentJobPage selectDataRangeByTitle(String dayStart, String dayEnd) {
    selectDateRange.click();
    waitUntilVisibilityOfElementLocated(webDriver.findElement(
        By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
    webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart)))
        .click();
    webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd)))
        .click();
    return this;
  }

  public CreateOrEditJobPage clickOnCreateOrEditJob() {
    waitUntilElementIsClickable(createEditJobButton.getWebElement());
    createEditJobButton.click();
    return getCreateOrEditJobPage();
  }

  public CreateOrEditJobPage getCreateOrEditJobPage() {
    return new CreateOrEditJobPage(webDriver, getWebDriver().findElement(By.id(ID_NEXT)));
  }

  public Integer getNumberOfJobs() {
    return jobIdElements.size();
  }

  public boolean isToastContainerDisplayed() {
    try {
      return toastContainer.isDisplayed();
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  public JobCreatedModalWindowPage getJobCreatedModalWindowElement() {
    return new JobCreatedModalWindowPage(webDriver,
        getWebDriver().findElement(By.cssSelector(MODAL_CONTENT_LOCAL)));
  }

  public boolean verifyMessageInToastModalIsDisplayed(String messageBody) {
    String xpathExpression = StringUtils.isNotBlank(messageBody)
        ? f("//div[@id='toast-container']//strong[contains(text(), '%s')]", messageBody)
        : "//div[@id='toast-container']";
    return webDriver.findElement(By.xpath(xpathExpression)).isDisplayed();
  }

  public PageElement getLoadSelection() {
    return loadSelection;
  }

  public String getSelectedStartDay() {
    return selectedStartDay.getAttribute(VALUE);
  }

  public String getSelectedEndDay() {
    return selectedEndDay.getAttribute(VALUE);
  }

  public String getSelectedPriority() {
    return selectedPriority.getAttribute(TITLE);
  }

  public List<String> getAllSelectedByJobName(String selectedItem) {
    return webDriver.findElements(By.xpath(f(SELECTION_ITEMS, selectedItem)))
        .stream().map(WebElement::getText).collect(Collectors.toList());
  }

  public void clickOnShowOrHideFilters() {
    showOrHideFilters.click();
  }

  public boolean verifyIsFiltersBlockInvisible() {
    waitUntilVisibilityOfElementLocated(invisibleFiltersBlock.getWebElement());
    return invisibleFiltersBlock.isDisplayed();
  }

  public void clickOnClearSelectionButton() {
    clearSelectionButton.click();
  }

  public void clickOnPresetFilters() {
    presetFilters.click();
  }

  public void waitUntilDropdownMenuVisible() {
    waitUntilInvisibilityOfElementLocated(DROPDOWN_MENU_LOCATOR);
  }

  public boolean isFilterDropdownMenuDisplayed() {
    return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR)).isDisplayed();
  }

  public boolean isFilterDropdownMenuWithoutDataDisplayed() {
    return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(DROPDOWN_MENU_NO_DATA_LOCATOR)).isDisplayed();
  }

  public boolean isFilterDropdownMenuShipperWithDataDisplayed() {
    waitUntilInvisibilityOfElementLocated(VERIFY_SHIPPER_FIELD_LOCATOR);
    return webDriver.findElement(By.xpath(VERIFY_SHIPPER_FIELD_LOCATOR)).isDisplayed();
  }

  public void clickOnSelectStartDay() {
    selectedStartDay.click();
  }

  public void clickOnPriorityButton() {
    priorityButton.click();
  }

  public boolean isJobPriorityFilterByNameDisplayed(String priorityName) {
    return isJobSelectionFilterByNameWithLabelDisplayed(priorityName);
  }

  public void clickOnJobServiceType() {
    jobServiceTypeInput.click();
  }

  public void clickOnJobServiceLevel() {
    jobServiceLevelInput.click();
  }

  public void clickOnJobStatus() {
    jobStatusInput.click();
  }

  public void verifyDataStartToEndLimited(String dayStart, String dayEnd) {
    waitUntilVisibilityOfElementLocated(webDriver.findElement(
        By.cssSelector(SELECTED_DAY_IN_CALENDAR_LOCATOR)));
    Assertions.assertThat(
            webDriver.findElement(
                    By.cssSelector(String.format(DISABLE_CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd)))
                .isDisplayed())
        .as("The next 7th day is not active for selection").isTrue();
    webDriver.findElement(By.cssSelector(SHOW_PREVIOUS_MONTH_BUTTON_LOCATION)).click();
    Assertions.assertThat(
            webDriver.findElement(
                    By.cssSelector(String.format(DISABLE_CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart)))
                .isDisplayed())
        .as("The previous 7th day is not active for selection").isTrue();
    contentBox.click();
  }

  public void selectServiceLevel() {
    jobServiceLevelInput.sendKeys(Keys.RETURN);
  }

  public void clickOnJobZone() {
    jobZonesInput.click();
  }

  public void clickOnJobMasterShipper() {
    jobMasterShipperInput.click();
  }

  public void clickOnJobShipper() {
    shipperIDField.click();
  }

  public void inputOnJobShipper(String text) {
    clearOnJobShipper();
    shipperIDField.sendKeys(text);
  }

  public void clearOnJobShipper() {
    shipperIDField.clear();
  }

  public void inputOnJobZone(String text) {
    jobZonesInput.sendKeys(text);
  }

  public void inputOnJobMasterShipper(String text) {
    jobMasterShipperInput.sendKeys(text);
  }

  public void selectJobSelection(String selection) {
    waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LABEL_LOCATOR, selection))));
    webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LABEL_LOCATOR, selection))).click();
  }

  public boolean isJobSelectionFilterByNameWithLabelDisplayed(String selection) {
    waitUntilVisibilityOfElementLocated(
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(f(SELECTION_LABEL_LOCATOR, selection))));
    return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LABEL_LOCATOR, selection)))
        .isDisplayed();
  }

  public void selectJobStatus() {
    jobStatusInput.sendKeys(Keys.RETURN);
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


  public void selectJobStatusByString(String jobStatus) {
    jobStatusInput.click();
    int retry = 10;
    while (retry > 0 && !webDriver.findElement(
            By.id(jobStatusInput.getAttribute(ARIA_ACTIVEDESCENDANT)))
        .getAttribute(ARIA_LABEL).equals(jobStatus)) {
      jobStatusInput.sendKeys(Keys.ARROW_DOWN);
      retry--;
    }
    jobStatusInput.sendKeys(Keys.ENTER);
    clickOnJobStatus();
  }

  public void selectJobServiceLevelByString(String jobServiceLevel) {
    jobServiceLevelInput.click();
    int retry = 2;
    while (retry > 0 && !webDriver.findElement(
            By.id(jobServiceLevelInput.getAttribute(ARIA_ACTIVEDESCENDANT)))
        .getAttribute(ARIA_LABEL).equals(jobServiceLevel)) {
      jobServiceLevelInput.sendKeys(Keys.ARROW_DOWN);
      retry--;
    }
    jobServiceLevelInput.sendKeys(Keys.ENTER);
    clickOnJobServiceLevel();
  }

  public void selectPriorityByString(String priority) {
    clickOnPriorityButton();
    int retry = 2;
    priorityInput.sendKeys(Keys.ARROW_DOWN);
    while (retry > 0 && !webDriver.findElement(
            By.id(priorityInput.getAttribute(ARIA_ACTIVEDESCENDANT)))
        .getAttribute(ARIA_LABEL).equals(priority)) {
      priorityInput.sendKeys(Keys.ARROW_DOWN);
      retry--;
    }
    priorityInput.sendKeys(Keys.ENTER);
    clickOnPriorityButton();
  }

  public void clickOnCreateOrModifyPresetButton() {
    moveToElement(createOrModifyPresetButton.getWebElement());
    createOrModifyPresetButton.click();
  }

  public void clickOnSaveAsPresetButton() {
    waitUntilCreateOrModifyPresetDropdownManyIsVisible();
    saveAsPresetButton.click();
  }

  public boolean isPresetModalDisplayed() {
    return presetModal.isDisplayed();
  }

  public void fillInPresetNamefield(String presetName) {
    presetNameInput.sendKeys(presetName);
  }

  public void clickConfirmPresetModalButton() {
    confirmPresetButton.click();
  }

  public boolean isNewPresetCreatedPopupDisplayed() {
    return newPresetCreatedPopup.isDisplayed();
  }

  public String getSelectedPresetFromDropdownMenu() {
    return newPresetCreatedPopupName.getText();
  }

  public void choosePresetByName(String presetName) {
    int retry = 100;
    while (retry > 0 && !webDriver.findElement(
            By.cssSelector("div.ant-select-item-option-active div")).getText()
        .equalsIgnoreCase(presetName)) {
      presetFilters.sendKeys(Keys.ARROW_DOWN);
      retry--;
    }
    presetFilters.sendKeys(Keys.ENTER);
  }

  public void clickOnUpdateCurrentPreset() {
    waitUntilCreateOrModifyPresetDropdownManyIsVisible();
    updateCurrentPresetButton.click();
  }

//  public boolean isCurrentPresetUpdatedPopupDisplayed() {
//    waitUntilVisibilityOfElementLocated(currentPresetUpdatedPopup.getWebElement());
//    return currentPresetUpdatedPopup.isDisplayed();
//  }
//
//  public void waitUntilCurrentPresetUpdatedPopupInvisible() {
//    waitUntilInvisibilityOfElementLocated(currentPresetUpdatedPopup.getWebElement());
//  }
//
//  public void clickOnDeletePresetButton() {
//    waitUntilCreateOrModifyPresetDropdownManyIsVisible();
//    deletePresetButton.click();
//  }
//
//  public boolean isPresetDeletedPopupDisplayed() {
//    waitUntilVisibilityOfElementLocated(presetDeletedPopup.getWebElement());
//    return presetDeletedPopup.isDisplayed();
//  }
//
//  public void waitUntilPresetDeletedPopupInvisible() {
//    waitUntilInvisibilityOfElementLocated(presetDeletedPopup.getWebElement());
//  }

  public void waitUntilCreateOrModifyPresetDropdownManyIsVisible() {
    waitUntilVisibilityOfElementLocated(DROPDOWN_BOTTOM_LEFT_LOCATOR);
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
    waitUntilInvisibilityOfElementLocated("//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]");
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
      System.out.println("Test is :  "+jobCreatedSuccess.createdTime.getText());
      Assertions.assertThat(jobCreatedSuccess.createdTime.getText()).as("Time slot is the same").isEqualToIgnoringCase(data.get("timeSlot"));
    }
    if (data.get("pickupTag")!=null){
      Assertions.assertThat(isElementExist(f(jobCreatedSuccess.COLUMN_DATA_XPATH,data.get("pickupTag")))).as("Job tag is the same").isTrue();
    }

  }

}
