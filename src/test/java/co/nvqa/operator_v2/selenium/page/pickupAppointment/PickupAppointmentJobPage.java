package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;


import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.io.File;
import java.util.List;
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
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPage extends SimpleReactPage<PickupAppointmentJobPage> {

  Logger LOGGER = getLogger(PickupAppointmentJobPage.class);

  @FindBy(css = "#shippers")
  private PageElement shipperIDField;

  @FindBy(css = "#dateRange")
  private Button selectDateRange;

  @FindBy(css = "div.ant-collapse-extra button")
  private Button createEditJobButton;

  @FindBy(css = "[type='submit']")
  private PageElement loadSelection;


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

  public PickupAppointmentJobPage(WebDriver webDriver) {
    super(webDriver);
  }

  public PickupAppointmentJobPage clickLoadSelectionButton() {
    contentBox.click();
    loadSelection.click();
    return this;
  }
  public PickupAppointmentJobPage clearJobStatusFilter()
  {

    jobStatusInput.click();
    clearJobStatusButton.click();
    return this;
  }

  public PickupAppointmentJobPage addProofPhoto()
  {
    final ClassLoader classLoader = getClass().getClassLoader();
    File file = new File(Objects.requireNonNull(classLoader.getResource("images/dpPhotoValidSize.png")).getFile());
    uploadPhotoInput.sendKeys(file.getPath());
    return this;
  }
  public PickupAppointmentJobPage selectInprogressJobStatus()
  {

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
        By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
    Assertions.assertThat(
            webDriver.findElement(
                    By.cssSelector(String.format(DISABLE_CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart)))
                .isDisplayed())
        .as("The previous 7th day is not active for selection").isTrue();
    Assertions.assertThat(
            webDriver.findElement(
                    By.cssSelector(String.format(DISABLE_CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd)))
                .isDisplayed())
        .as("The next 7th day is not active for selection").isTrue();
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
    jobZonesInput.clear();
    jobZonesInput.sendKeys(text);
  }

  public void inputOnJobMasterShipper(String text) {
    jobMasterShipperInput.clear();
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
}
