package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import java.util.ArrayList;
import java.util.List;
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

public class PickupAppointmentJobPage extends OperatorV2SimplePage {

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

  @FindBy(css = "div.ant-collapse-content-inactive")
  private PageElement invisibleFiltersBlock;

  @FindBy(xpath = "//span[text()='Clear Selection']/parent::button")
  private Button clearSelectionButton;

  @FindBy(css = "#presetFilters")
  private PageElement presetFilters;

  @FindBy(xpath = "#priority")
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
  public final String DROPDOWN_MENU_WITH_DATA_LOCATOR = "#shipper_list_0";
  public final String PRIORITY_SELECTION_LOCATOR = "div[aria-label='Priority']";
  public final String NON_PRIORITY_SELECTION_LOCATOR = "div[aria-label='Non-Priority']";
  public final String PREMIUM_SELECTION_LOCATOR = "div[aria-label='Premium']";
  public final String STANDARD_SELECTION_LOCATOR = "div[aria-label='Standard']";
  public final String IN_PROGRESS_SELECTION_LOCATOR = "div[label='In Progress']";
  public final String CANCELLED_SELECTION_LOCATOR = "div[label='Cancelled']";
  public final String COMPLETED_SELECTION_LOCATOR = "div[label='Completed']";
  public final String FAILED_SELECTION_LOCATOR = "div[label='Failed']";
  public final String SELECTION_LOCATOR = "div[label='%s']";
  public final String SELECTION_ITEMS = "//parent::span//preceding-sibling::span//span[@class='ant-select-selection-item-content']";

  public PickupAppointmentJobPage(WebDriver webDriver) {
    super(webDriver);
  }

  public PickupAppointmentJobPage clickLoadSelectionButton() {
    contentBox.click();
    loadSelection.click();
    return this;
  }

  public PickupAppointmentJobPage clickEditButton() {
    editButton.click();
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
    field.clear();
    field.sendKeys(data);
    waitUntilVisibilityOfElementLocated(verifyLocator);
    field.sendKeys(Keys.ENTER);
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
    switch (selectedItem) {
      case "serviceType":
        return jobServiceTypeInput.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      case "serviceLevel":
        return jobServiceLevelInput.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      case "status":
        return jobStatusInput.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      case "zones":
        return jobZonesInput.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      case "masterShipper":
        return jobMasterShipperInput.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      case "shipper":
        return shipperIDField.findElementsBy(By.xpath(SELECTION_ITEMS))
            .stream().map(WebElement::getText).collect(Collectors.toList());
      default:
        return new ArrayList<>();
    }
  }

  public void clickOnShowOrHideFilters() {
    showOrHideFilters.click();
  }

  public boolean verifyIsFiltersBlockInvisible() {
    waitUntilVisibilityOfElementLocated(
        invisibleFiltersBlock.getWebElement().getLocation().toString());
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
    waitUntilInvisibilityOfElementLocated(DROPDOWN_MENU_WITH_DATA_LOCATOR);
    return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(DROPDOWN_MENU_WITH_DATA_LOCATOR)).isDisplayed();
  }

  public void clickOnSelectStartDay() {
    selectedStartDay.click();
  }

  public void clickOnPriorityButton() {
    priorityButton.click();
  }

  public boolean isJobPriorityFilterByNameDisplayed(String priorityName) {
    switch (priorityName) {
      case "priority":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(PRIORITY_SELECTION_LOCATOR))
            .isDisplayed();
      case "non priority":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(NON_PRIORITY_SELECTION_LOCATOR))
            .isDisplayed();
      default:
        return false;
    }
  }

  public void clickOnJobServiceType() {
    jobServiceTypeInput.click();
  }

  public void clickOnJobServiceLevel() {
    jobServiceLevelInput.click();
  }

  public boolean isJobServiceLevelFilterByNameDisplayed(String serviceLevelName) {
    switch (serviceLevelName) {
      case "premium":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(PREMIUM_SELECTION_LOCATOR))
            .isDisplayed();
      case "standard":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(STANDARD_SELECTION_LOCATOR))
            .isDisplayed();
      default:
        return false;
    }
  }

  public void clickOnJobStatus() {
    jobStatusInput.click();
  }

  public boolean isJobStatusLevelFilterByNameDisplayed(String statusName) {
    switch (statusName) {
      case "in progress":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(IN_PROGRESS_SELECTION_LOCATOR))
            .isDisplayed();
      case "cancelled":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(CANCELLED_SELECTION_LOCATOR))
            .isDisplayed();
      case "completed":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(COMPLETED_SELECTION_LOCATOR))
            .isDisplayed();
      case "failed":
        return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(FAILED_SELECTION_LOCATOR))
            .isDisplayed();
      default:
        return false;
    }
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

  public void selectServiceLevel(String serviceLevel) {
    waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(PREMIUM_SELECTION_LOCATOR)));
    switch (serviceLevel.toLowerCase()) {
      case "premium":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(PREMIUM_SELECTION_LOCATOR)).click();
        break;
      case "standard":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(STANDARD_SELECTION_LOCATOR)).click();
        break;
      default:
        LOGGER.warn("Incorrect entry service level");
    }
  }

  public void selectJobStatus(String status) {
    waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(IN_PROGRESS_SELECTION_LOCATOR)));
    switch (status.toLowerCase()) {
      case "in progress":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(IN_PROGRESS_SELECTION_LOCATOR))
            .click();
        break;
      case "cancelled":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(CANCELLED_SELECTION_LOCATOR))
            .click();
        break;
      case "completed":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(COMPLETED_SELECTION_LOCATOR))
            .click();
        break;
      case "failed":
        webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
            .findElement(By.cssSelector(FAILED_SELECTION_LOCATOR))
            .click();
        break;
      default:
        LOGGER.warn("Incorrect entry status");
    }
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
    shipperIDField.clear();
    shipperIDField.sendKeys(text);
  }

  public void inputOnJobZone(String text) {
    jobZonesInput.clear();
    jobZonesInput.sendKeys(text);
  }

  public void selectJobSelection(String selection) {
    waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LOCATOR, selection))));
    webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LOCATOR, selection))).click();
  }

  public boolean isJobSelectionFilterByNameDisplayed(String selection) {
    return webDriver.findElement(By.cssSelector(DROPDOWN_MENU_LOCATOR))
        .findElement(By.cssSelector(f(SELECTION_LOCATOR, selection)))
        .isDisplayed();
  }
}
