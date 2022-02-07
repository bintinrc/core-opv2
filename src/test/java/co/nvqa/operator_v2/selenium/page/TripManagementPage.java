package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.MovementTripActionName;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import co.nvqa.operator_v2.util.TestUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.model.core.Order.STATUS_CANCELLED;
import static co.nvqa.commons.model.core.Order.STATUS_COMPLETED;
import static co.nvqa.commons.model.core.hub.trip_management.MovementTripType.ARCHIVE_ARRIVAL_DATE;
import static co.nvqa.commons.model.core.hub.trip_management.MovementTripType.ARCHIVE_DEPARTURE_DATE;

/**
 * @author Tristania Siagian
 */

public class TripManagementPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(TripManagementPage.class);

  private static final String TRIP_MANAGEMENT_CONTAINER_XPATH = "//div[contains(@class,'TripContainer')]";
  private static final String LOAD_BUTTON_XPATH = "//button[contains(@class,'ant-btn-primary')]";
  private static final String FIELD_REQUIRED_ERROR_MESSAGE_XPATH = "//button[contains(@class,'ant-btn-primary')]";
  private static final String FILTER_OPTION_XPATH = "//div[div[div[input[@id='%s']]]]";
  private static final String SELECT_FILTER_VALUE_XPATH = "//div[not(contains(@class,'ant-select-dropdown-hidden'))]//div[contains(@class,'ant-select-item-option')]//div[text()= '%s']";
  private static final String TEXT_OPTION_XPATH = "//div[not(contains(@class,'dropdown-hidden'))]/div/ul/li[text()='%s']";
  private static final String DESTINATION_HUB_XPATH = "//tr[contains(@class, 'ant-table-row')]/td[1]";
  private static final String ORIGIN_HUB_XPATH = "//tr[contains(@class, 'ant-table-row')]/td[1]";
  private static final String NO_RESULT_XPATH = "//div[contains(@class,'NoResult')]";
  private static final String DEPARTURE_CALENDAR_XPATH = "//input[@id='departureDate']";
  private static final String ARRIVAL_CALENDAR_XPATH = "//input[@id='arrivalDate']";
  private static final String CALENDAR_SELECTED_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//td[@title='%s']";
  private static final String NEXT_MONTH_BUTTON_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//span[contains(@class,'ant-picker-next-icon')]";
  private static final String PREV_MONTH_BUTTON_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//span[contains(@class,'ant-picker-prev-icon')]";
  private static final String TAB_XPATH = "//span[.='%s']/preceding-sibling::span";
  private static final String TABLE_HEADER_FILTER_INPUT_XPATH = "//th[contains(@class,'%s')]";
  private static final String IN_TABLE_FILTER_INPUT_XPATH = "//tr//th[%d]//input";
  private static final String CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH = "//span[text()='%s']/preceding-sibling::label//input";
  private static final String FIRST_ROW_INPUT_FILTERED_RESULT_XPATH = "//tbody[@class='ant-table-tbody']//tr[contains(@class, 'ant-table-row ')][1]//td[contains(@class, '%s')]";
  private static final String FIRST_ROW_OPTION_FILTERED_RESULT_XPATH = "//tr[2]/td[contains(@class,'%s')]";
  private static final String FIRST_ROW_TIME_FILTERED_RESULT_XPATH = "//tr[2]/td[contains(@class,'%s')]";
  private static final String FIRST_ROW_OF_TABLE_RESULT_XPATH = "//div[contains(@class,'table')]//tbody/tr[2]";
  private static final String FIRST_ROW_STATUS = "//tr[contains(@class,'ant-table-row')][1]//td[7]";
  private static final String OK_BUTTON_OPTION_TABLE_XPATH = "//button[contains(@class,'btn-primary')]";
  private static final String TRIP_ID_FIRST_ROW_XPATH = "//tr[contains(@class,'ant-table-row')][1]//td[2]";
  private static final String ACTION_COLUMN_XPATH = "//tr[contains(@class, 'ant-table-row')]/td[contains(@class, 'ant-table-cell-fix-right')][last()]";
  private static final String ACTION_ICON_XPATH = "//tr[contains(@class, 'ant-table-row')]/td[contains(@class, 'ant-table-cell-fix-right')][last()]//div[@class='ant-space-item'][%d]";
  private static final String VIEW_ICON_ARRIVAL_ARCHIVE_XPATH = "//tr[contains(@class, 'ant-table-row')]/td[contains(@class, 'ant-table-cell-fix-right')]//a";

  private static final String ID_CLASS = "id";
  private static final String ORIGIN_HUB_CLASS = "origin-hub-name";
  private static final String DESTINATION_HUB_CLASS = "destinationHub";
  private static final String MOVEMENT_TYPE_CLASS = "movement-type";
  private static final String EXPECTED_DEPARTURE_TIME_CLASS = "expected-departure-time";
  private static final String ACTUAL_DEPARTURE_TIME_CLASS = "actual-start-time";
  private static final String EXPECTED_ARRIVAL_TIME_CLASS = "expected-arrival-time";
  private static final String ACTUAL_ARRIVAL_TIME_CLASS = "actual-arrival-time";
  private static final String INPUT_DRIVERS_AREA_LABEL ="//input[@aria-label='input-drivers']";
  private static final String DRIVER_CLASS = "driver";
  private static final String STATUS_CLASS = "status";
  private static final String LAST_STATUS_CLASS = "lastStatus";

  private static final String SUCCESS_CANCEL_TRIP_TOAST = "//div[contains(@class,'notification-notice-message') and (contains(text(),'Trip %d cancelled'))]";
  private static final String FIRST_ROW_TRACK = "//tr[2]//td[contains(@class,'track')]";

  private static final DateTimeFormatter BE_FORMATTER = DateTimeFormatter
          .ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSz");

  @FindBy(className = "ant-modal-wrap")
  public CancelTripModal cancelTripModal;

  @FindBy(className = "ant-modal-content")
  public AssignTripModal assignTripModal;

  @FindBy(className = "ant-modal-wrap")
  public TripDepartureArrivalModal tripDepartureArrivalModal;

  @FindBy(xpath = "//th[.//div[.='Status']]")
  public StatusFilter tripStatusFilter;

  @FindBy(xpath = "//th[div[.='Last Status']]")
  public StatusFilter lastStatusFilter;

  @FindBy(xpath = "//div[contains(@class,'nv-table')]//table")
  public NvTable<TripEventsRow> tripEventsRowNvTable;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//th[contains(@class,'movement-type')]")
  public MovementTypeFilter movementTypeFilter;

  @FindBy(xpath = "//th[contains(@class,'expected-departure-time')]")
  public TripTimeFilter expectedDepartTimeFilter;

  @FindBy(xpath = "//th[contains(@class,'actual-start-time')]")
  public TripTimeFilter actualDepartTimeFilter;

  @FindBy(xpath = "//th[contains(@class,'expected-arrival-time')]")
  public TripTimeFilter expectedArrivalTimeFilter;

  @FindBy(xpath = "//th[contains(@class,'actual-arrival-time')]")
  public TripTimeFilter actualArrivalTimeFilter;

  @FindBy(xpath = LOAD_BUTTON_XPATH)
  public Button loadButton;

  @FindBy(xpath = "//button[.='Force Completion']")
  public Button forceTripCompletion;

  @FindBy(xpath = "//button[.='Depart']")
  public Button departTripButton;

  @FindBy(xpath = "//button[.='Arrive']")
  public Button arriveTripButton;

  @FindBy(xpath = "//button[.='Complete']")
  public Button completeTripButton;

  @FindBy(xpath = "//input[@id='originHub']")
  public AntSelect originHubFilter;

  @FindBy(xpath = "//input[@id='destinationHub']")
  public AntSelect destinationHubFilter;

  @FindBy(id = "movementType")
  public AntSelect movementTypeFilterPage;

  private static String movementType = "//input[@id='movementType']";
  private static String destinationHub = "//input[@id='destinationHub']";

  @FindBy(xpath = "(//td[contains(@class,'action')]//i)[1]")
  public Button tripDetailButton;

  public static String actualToastMessageContent="";

  public TripManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void switchToOtherWindow() {
    waitUntilNewWindowOrTabOpened();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      getWebDriver().switchTo().window(windowHandle);
    }
  }

  public void verifiesTripManagementIsLoaded() {

    isElementExist(TRIP_MANAGEMENT_CONTAINER_XPATH);

  }

  public void clickLoadButton() {
    loadButton.click();
    loadButton.waitUntilInvisible();
  }

  public void verifiesFieldReqiredErrorMessageShown() {

    isElementExist(FIELD_REQUIRED_ERROR_MESSAGE_XPATH);

  }

  public void selectValueFromFilterDropDown(String filterName, String filterValue) {

    click(f(FILTER_OPTION_XPATH, filterName));
    waitUntilVisibilityOfElementLocated(f(TEXT_OPTION_XPATH, filterValue));
    click(f(TEXT_OPTION_XPATH, filterValue));

  }

  public void selectValueFromFilterDropDownDirectly(String filterName, String filterValue) {
    if (filterName.equalsIgnoreCase("originhub")) {
      originHubFilter.selectValue(filterValue);
    } else if (filterName.equalsIgnoreCase("movementtype")) {
      movementTypeFilterPage.click();
      sendKeysAndEnter(movementType, filterValue);
    } else if (filterName.equalsIgnoreCase("destinationhub")) {
      TestUtils.findElementAndClick(destinationHub, "xpath", getWebDriver());
      sendKeysAndEnter(destinationHub, filterValue);
    }
  }

  public void verifiesSumOfTripManagement(MovementTripType tabName, Long tripManagementCount) {

    List<WebElement> tripManagementList = new ArrayList<>();

    switch (tabName) {
      case DEPARTURE:
        tripManagementList = findElementsByXpath(DESTINATION_HUB_XPATH);
        break;

      case ARRIVAL:
        tripManagementList = findElementsByXpath(ORIGIN_HUB_XPATH);
        break;

      default:
        NvLogger.warn("No Tab Name Found!");
    }

    Long actualTripManagementSum = (long) tripManagementList.size();
    assertThat("Sum of Trip Management", actualTripManagementSum, equalTo(tripManagementCount));

  }

  public void searchAndVerifiesTripManagementIsExistedById(Long tripManagementId) {

    waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS));
    sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), tripManagementId.toString());
    waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));

    String actualTripManagementId = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
    assertEquals("Trip Management ID", tripManagementId.toString(), actualTripManagementId);


  }

  public void searchAndVerifiesTripManagementIsExistedByDestinationHubName(
      String destinationHubName) {
    waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, 1));
    sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, 1), destinationHubName);
    waitUntilVisibilityOfElementLocated(
        f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, 1));

    String actualDestinationHubName = getText(
        f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, 1));
    assertEquals("Destination Hub Name", destinationHubName, actualDestinationHubName);
  }

  public void selectsDate(MovementTripType movementTripType, String tomorrowDate) {

    switch (movementTripType) {
      case DEPARTURE:
        click(DEPARTURE_CALENDAR_XPATH);
        break;

      case ARRIVAL:
        click(ARRIVAL_CALENDAR_XPATH);
        break;

      default:
        NvLogger.warn("Tab is not found!");
    }

    while (!isElementExistFast(f(CALENDAR_SELECTED_XPATH, tomorrowDate))) {
      click(NEXT_MONTH_BUTTON_XPATH);
    }
    TestUtils.callJavaScriptExecutor("arguments[0].click();",
            getWebDriver().findElement(By.xpath(f(CALENDAR_SELECTED_XPATH, tomorrowDate))),
            getWebDriver());
  }

  public void selectsDateArchiveTab(MovementTripType movementTripType, String date) {

    switch (movementTripType) {
      case ARCHIVE_DEPARTURE_DATE:
        TestUtils.findElementAndClick(DEPARTURE_CALENDAR_XPATH,"xpath", getWebDriver());
        break;

      case ARCHIVE_ARRIVAL_DATE:
        TestUtils.findElementAndClick(ARRIVAL_CALENDAR_XPATH,"xpath", getWebDriver());
        break;

      default:
        NvLogger.warn("Tab is not found!");
    }

    while (!isElementExistFast(f(CALENDAR_SELECTED_XPATH, date))) {
      click(PREV_MONTH_BUTTON_XPATH);
    }
    TestUtils.callJavaScriptExecutor("arguments[0].click();",
            getWebDriver().findElement(By.xpath(f(CALENDAR_SELECTED_XPATH, date))),
            getWebDriver());
  }

  public void clickTabBasedOnName(String tabName) {

    click(f(TAB_XPATH, tabName));

  }

  public void verifiesNoResult() {

    isElementExistFast(NO_RESULT_XPATH);

  }

  public void tableFiltering(TripManagementFilteringType tripManagementFilteringType,
      TripManagementDetailsData tripManagementDetailsData, String driverUsername) {
    ShipmentInfo shipmentInfo = new ShipmentInfo();
    // Get the newest record
    int index = tripManagementDetailsData.getData().size() - 1;

    if (tripManagementDetailsData.getCount() == null || tripManagementDetailsData.getCount() == 0) {
      verifiesNoResult();

      return;
    }

    String filterValue;

    switch (tripManagementFilteringType) {
      case DESTINATION_HUB:
        filterValue = tripManagementDetailsData.getData().get(index).getDestinationHubName();
        waitUntilVisibilityOfElementLocated(
            f(TABLE_HEADER_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS), filterValue);
        break;

      case ORIGIN_HUB:
        filterValue = tripManagementDetailsData.getData().get(index).getOriginHubName();
        waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS));
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS)+"//input", filterValue);
        break;

      case TRIP_ID:
        filterValue = tripManagementDetailsData.getData().get(index).getId().toString();
        waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ID_CLASS));
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, ID_CLASS)+"//input", filterValue);
        break;

      case MOVEMENT_TYPE:
        filterValue = movementTypeConverter(
            tripManagementDetailsData.getData().get(index).getMovementType());
        movementTypeFilter.openButton.click();
        movementTypeFilter.selectType(filterValue.toLowerCase());
        movementTypeFilter.ok.click();
        pause3s();
        break;

      case EXPECTED_DEPARTURE_TIME:
        ZonedDateTime expectedDepartTime = tripManagementDetailsData.getData().get(index)
            .getExpectedDepartureTime();
        expectedDepartTimeFilter.openButton.click();
        expectedDepartTimeFilter.ok.waitUntilClickable();
        expectedDepartTimeFilter.selectDate(expectedDepartTime);
        expectedDepartTimeFilter.selectTime(expectedDepartTime);
        expectedDepartTimeFilter.ok.click();
        break;

      case ACTUAL_DEPARTURE_TIME:
        ZonedDateTime actualDepartureTime = tripManagementDetailsData.getData().get(index)
            .getExpectedArrivalTime();
        String normalizedDepartDate = shipmentInfo.normalisedDate(actualDepartureTime.toString().replaceAll("Z", ":00.000Z"));
        normalizedDepartDate = normalizedDepartDate.replace(" ", "T").replace(":00", ":00.000Z");
        actualDepartureTime = ZonedDateTime.parse(normalizedDepartDate, BE_FORMATTER);
        actualDepartTimeFilter.openButton.click();
        actualDepartTimeFilter.selectTime(actualDepartureTime);
        actualDepartTimeFilter.ok.click();
        break;

      case EXPECTED_ARRIVAL_TIME:
        ZonedDateTime expectedArrivalTime = tripManagementDetailsData.getData().get(index)
            .getExpectedArrivalTime();
        String normalizedArrivalDate = shipmentInfo.normalisedDate(expectedArrivalTime.toString().replaceAll("Z", ":00.000Z"));
        normalizedArrivalDate = normalizedArrivalDate.replace(" ", "T").replace(":00", ":00.000Z");
        expectedArrivalTime = ZonedDateTime.parse(normalizedArrivalDate, BE_FORMATTER);
        expectedArrivalTimeFilter.scrollIntoView();
        expectedArrivalTimeFilter.openButton.click();
        expectedArrivalTimeFilter.selectDate(expectedArrivalTime);
        expectedArrivalTimeFilter.selectTime(expectedArrivalTime);
        expectedArrivalTimeFilter.ok.click();
        break;

      case ACTUAL_ARRIVAL_TIME:
        ZonedDateTime actualArrivalTime = tripManagementDetailsData.getData().get(index)
            .getExpectedArrivalTime();
        actualArrivalTimeFilter.openButton.click();
        actualArrivalTimeFilter.selectDate(actualArrivalTime);
        actualArrivalTimeFilter.selectTime(actualArrivalTime);
        actualArrivalTimeFilter.ok.click();
        break;

      case DRIVER:
        filterValue = driverConverted(driverUsername);
        tripStatusFilter.scrollIntoView();
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, DRIVER_CLASS)+INPUT_DRIVERS_AREA_LABEL, filterValue);
        break;

      case STATUS:
        filterValue = tripManagementDetailsData.getData().get(index).getStatus();
        tripStatusFilter.scrollIntoView();
        tripStatusFilter.openButton.click();
        tripStatusFilter.selectType(filterValue);
        tripStatusFilter.ok.click();
        break;

      case LAST_STATUS:
        filterValue = tripManagementDetailsData.getData().get(index).getStatus();
        lastStatusFilter.scrollIntoView();
        lastStatusFilter.openButton.click();
        lastStatusFilter.selectType(filterValue);
        lastStatusFilter.ok.click();
        pause3s();
        break;

      default:
        NvLogger.warn("Filtering type is not found");
    }

  }

  public void tableFilterByStatus(String filterValue) {
    tripStatusFilter.scrollIntoView();
    tripStatusFilter.openButton.click();
    tripStatusFilter.selectType(filterValue);
    tripStatusFilter.ok.click();

  }

  public void tableFiltering(TripManagementFilteringType tripManagementFilteringType,
      TripManagementDetailsData tripManagementDetailsData) {
    tableFiltering(tripManagementFilteringType, tripManagementDetailsData, null);
  }

  public String getTripIdFromTable() {
    return getText(TRIP_ID_FIRST_ROW_XPATH);
  }

  public void verifyResult(TripManagementFilteringType tripManagementFilteringType,
      TripManagementDetailsData tripManagementDetailsData, String driverUsername) {

    if (!(isElementExistFast(FIRST_ROW_OF_TABLE_RESULT_XPATH))) {
      verifiesNoResult();
      return;
    }

    if (tripManagementDetailsData.getCount() == null || tripManagementDetailsData.getCount() == 0) {
      verifiesNoResult();
      return;
    }

    // Get Newest Record
    int index = tripManagementDetailsData.getData().size() - 1;

    String actualValue;
    String expectedValue;

    switch (tripManagementFilteringType) {
      case DESTINATION_HUB:
        expectedValue = tripManagementDetailsData.getData().get(index).getDestinationHubName();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));
        assertEquals("Destination Hub", expectedValue, actualValue);
        break;

      case ORIGIN_HUB:
        expectedValue = tripManagementDetailsData.getData().get(index).getOriginHubName();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ORIGIN_HUB_CLASS));
        assertEquals("Origin Hub", expectedValue, actualValue);
        break;

      case TRIP_ID:
        expectedValue = tripManagementDetailsData.getData().get(index).getId().toString();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
        assertEquals("Trip ID", expectedValue, actualValue);
        break;

      case MOVEMENT_TYPE:
        expectedValue = movementTypeConverter(
            tripManagementDetailsData.getData().get(index).getMovementType());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, MOVEMENT_TYPE_CLASS));
        assertEquals("Movement Type", expectedValue, actualValue);
        break;

      case EXPECTED_DEPARTURE_TIME:
        expectedValue = expectedValueDateTime(
            tripManagementDetailsData.getData().get(index).getExpectedDepartureTime());
        actualValue = getText(
            f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, EXPECTED_DEPARTURE_TIME_CLASS));
        Assertions.assertThat(actualValue).as("Expected Departure Time").contains(expectedValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case ACTUAL_DEPARTURE_TIME:
        expectedValue = expectedValueDateTime(
            tripManagementDetailsData.getData().get(index).getActualStartTime());
        actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, ACTUAL_DEPARTURE_TIME_CLASS));
        Assertions.assertThat(actualValue).as("Actual Departure Time").contains(expectedValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case EXPECTED_ARRIVAL_TIME:
        expectedValue = expectedValueDateTime(
            tripManagementDetailsData.getData().get(index).getExpectedArrivalTime());
        actualValue = getText(
            f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, EXPECTED_ARRIVAL_TIME_CLASS));
        Assertions.assertThat(actualValue).as("Actual Arrival Time").contains(expectedValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case ACTUAL_ARRIVAL_TIME:
        expectedValue = expectedValueDateTime(
            tripManagementDetailsData.getData().get(index).getActualEndTime());
        actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, ACTUAL_ARRIVAL_TIME_CLASS));
        assertTrue("Actual Departure Time", actualValue.contains(expectedValue));
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case DRIVER:
        expectedValue = driverConverted(driverUsername);
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DRIVER_CLASS));
        Assertions.assertThat(actualValue).as("Driver").isEqualTo(expectedValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case STATUS:
        expectedValue = statusConverted(tripManagementDetailsData.getData().get(index).getStatus());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, STATUS_CLASS));
        assertEquals("Status", expectedValue, actualValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case LAST_STATUS:
        expectedValue = statusConverted(tripManagementDetailsData.getData().get(index).getStatus());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, LAST_STATUS_CLASS));
        assertEquals("Last Status", expectedValue, actualValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      default:
        NvLogger.warn("Filtering type is not found");
    }


  }

  public void verifyResult(TripManagementFilteringType tripManagementFilteringType,
      TripManagementDetailsData tripManagementDetailsData) {
    verifyResult(tripManagementFilteringType, tripManagementDetailsData, null);
  }

  public String getTripIdAndClickOnActionIcon(MovementTripActionName actionName) {

    String tripId = null;
    if (isElementExistFast(ACTION_COLUMN_XPATH)) {
      tripId = getText(TRIP_ID_FIRST_ROW_XPATH);

      switch (actionName) {
        case VIEW:
          if (isElementExistFast(f(ACTION_ICON_XPATH, 1))) {
            click(f(ACTION_ICON_XPATH, 1));
          } else {
            click(VIEW_ICON_ARRIVAL_ARCHIVE_XPATH);
          }
          break;

        case ASSIGN_DRIVER:
          click(f(ACTION_ICON_XPATH, 2));
          break;

        case CANCEL:
          click(f(ACTION_ICON_XPATH, 3));
          break;

        default:
          NvLogger.warn("Movement Trip Action Name is not found!");
      }
    }

    return tripId;
  }

  public void assignDriver(String driverId) {
    waitUntilVisibilityOfElementLocated("//div[.='Assign Driver']");
    assignTripModal.addDriver.click();
    assignTripModal.assignDriver(driverId);
    assignTripModal.saveButton.click();
    assignTripModal.waitUntilInvisible();
  }

  public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
    waitUntilVisibilityOfElementLocated("//div[.='Assign Driver']");
    assignTripModal.addDriver.click();
    assignTripModal.assignDriverWithAdditional(primaryDriver, additionalDriver);
    assignTripModal.saveButton.click();
    assignTripModal.waitUntilInvisible();
  }

  public void clearAssignedDriver() {
    waitUntilVisibilityOfElementLocated("//div[.='Assign Driver']");
    assignTripModal.clearAssignedDriver();
    assignTripModal.saveButton.click();
    assignTripModal.waitUntilInvisible();
  }

  public void verifiesTripDetailIsOpened(String tripId, String windowHandle) {
    switchToNewWindow();

    this.switchTo();
//    TODO: WIP by MM Dev team

//    waitUntilVisibilityOfElementLocated(TRIP_ID_IN_TRIP_DETAILS_XPATH);
//    String actualTripId = getText(TRIP_ID_IN_TRIP_DETAILS_XPATH);
//    assertThat("Trip ID is correct", actualTripId, containsString(tripId));

    getWebDriver().close();
    getWebDriver().switchTo().window(windowHandle);


  }

  public void clickButtonOnCancelDialog(String buttonValue) {

    cancelTripModal.waitUntilVisible();
    switch (buttonValue) {
      case "Cancel Trip":
        cancelTripModal.cancelTrip.click();
        break;
      case "No":
        cancelTripModal.no.click();
        break;
      default:
        NvLogger.warn("Button value is not found!");
    }
    cancelTripModal.waitUntilInvisible();

  }

  public void verifiesSuccessCancelTripToastShown(Long tripId) {
    waitUntilVisibilityOfElementLocated(f(SUCCESS_CANCEL_TRIP_TOAST, tripId));
    click(f(SUCCESS_CANCEL_TRIP_TOAST, tripId));
  }

  public void readTheToastMessage() {
    retryIfAssertionErrorOccurred(() -> {
      try {
        waitUntilVisibilityOfElementLocated("//div[contains(@class,'notification-notice-message')]");
        WebElement toast = findElementByXpath("//div[contains(@class,'notification-notice-message')]");
        actualToastMessageContent = toast.getText();
        waitUntilElementIsClickable("//a[@class='ant-notification-notice-close']");
        findElementByXpath("//a[@class='ant-notification-notice-close']").click();
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 1000, 5);
  }

  public void verifyToastContainingMessageIsShown(String expectedToastMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        if(actualToastMessageContent.equals("")){
          readTheToastMessage();
        }
        Assertions.assertThat(actualToastMessageContent).as("Trip Management toast message:").contains(expectedToastMessage);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 1000, 5);
  }

  public void verifyToastContainingMessageIsShownWithoutClosing(String expectedToastMessage) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        waitUntilVisibilityOfElementLocated(
            "//div[contains(@class,'notification-notice-message')]");
        WebElement toast = findElementByXpath(
            "//div[contains(@class,'notification-notice-message')]");
        String actualToastMessage = toast.getText();
        assertThat("Trip Management toast message is the same", actualToastMessage,
            containsString(expectedToastMessage));
      } catch (Throwable ex) {
        NvLogger.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 1000, 5);
  }

  public void forceTripCompletion() {
    forceTripCompletion.waitUntilClickable();
    forceTripCompletion.click();
    pause5s();
  }

  public void departTrip() {
    departTripButton.waitUntilClickable();
    departTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    tripDepartureArrivalModal.submitTripDeparture.click();
  }

  public void arriveTrip() {
    arriveTripButton.waitUntilClickable();
    arriveTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    tripDepartureArrivalModal.submitTripDeparture.click();
    tripDepartureArrivalModal.waitUntilInvisible();
  }

  public void completeTrip() {
    completeTripButton.waitUntilClickable();
    completeTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    tripDepartureArrivalModal.submitTripDeparture.click();
    tripDepartureArrivalModal.waitUntilInvisible();
  }

  public void verifyStatusValue(String expectedTripId, String expectedStatusValue) {
    waitUntilVisibilityOfElementLocated(TRIP_ID_FIRST_ROW_XPATH);
    String actualTripId = getText(TRIP_ID_FIRST_ROW_XPATH);
    assertEquals(expectedTripId, actualTripId);

    waitUntilVisibilityOfElementLocated(FIRST_ROW_STATUS);
    String actualStatusValue = getText(FIRST_ROW_STATUS).toLowerCase();
    assertEquals(expectedStatusValue, actualStatusValue);
  }

  public void verifyTripHasDeparted() {
    waitUntilVisibilityOfElementLocated(TRIP_ID_FIRST_ROW_XPATH);
    String actualTrackValue = getText(FIRST_ROW_TRACK).toLowerCase();
    assertEquals("departed", actualTrackValue.toLowerCase());
  }

  public void verifyEventExist(String event, String status) {
    waitUntilVisibilityOfElementLocated("//table");
    List<TripEventsRow> tripEvents = tripEventsRowNvTable.rows;
    int departedRow = -1;
    int counter = 0;
    for (TripEventsRow singleTripEvent : tripEvents) {
      String actualEvent = singleTripEvent.event.getText().toLowerCase();
      if (actualEvent.equals(event.toLowerCase())) {
        departedRow = counter;
      }
      counter += 1;
    }
    if (departedRow == -1) {
      assertEquals(status, "");
    }
    String actualStatus = tripEvents.get(departedRow).status.getText().toLowerCase();
    assertEquals(status, actualStatus);
  }

  public Boolean isActionButtonEnabled(MovementTripActionName actionName) {

    boolean result = false;
    if (isElementExistFast(ACTION_COLUMN_XPATH)) {
      switch (actionName) {
        case VIEW:
          if (isElementExistFast(f(ACTION_ICON_XPATH, 1))) {
            result = isElementEnabled(f(ACTION_ICON_XPATH, 1));
          } else {
            result = isElementEnabled(VIEW_ICON_ARRIVAL_ARCHIVE_XPATH);
          }
          break;

        case ASSIGN_DRIVER:
          result = isElementEnabled(f(ACTION_ICON_XPATH, 2));
          break;

        case CANCEL:
          result = isElementEnabled(f(ACTION_ICON_XPATH, 3));
          break;

        default:
          NvLogger.warn("Movement Trip Action Name is not found!");
      }
    }

    return result;
  }

  private static boolean isBetween(int x, int lower, int upper) {
    return lower <= x && x <= upper;
  }


  private String movementTypeConverter(String movementType) {
    String movementTypeConverted;
    if ("LAND_HAUL".equalsIgnoreCase(movementType)) {
      movementTypeConverted = "Land Haul";
    } else if ("AIR_HAUL".equalsIgnoreCase(movementType)) {
      movementTypeConverted = "Air Haul";
    } else {
      movementTypeConverted = null;
      NvLogger.warn("Movement Type is not found!");
    }

    return movementTypeConverted;
  }

  private String driverConverted(String driverUsername) {
    String driver;
    if (driverUsername == null || driverUsername.isEmpty()) {
      driver = "Not assigned";
    } else {
      driver = driverUsername;
    }

    return driver;
  }

  private String statusConverted(String status) {
    String statusConverted = null;
    switch (status) {
      case "PENDING":
        statusConverted = "Pending";
        break;

      case "IN_TRANSIT":
        statusConverted = "In Transit";
        break;

      case STATUS_COMPLETED:
        statusConverted = "Completed";
        break;

      case STATUS_CANCELLED:
        statusConverted = "Cancelled";
        break;

      default:
        NvLogger.warn("Status is not found!");
    }

    return statusConverted;
  }

  private void selectDateTime(ZonedDateTime dateTime) {
    DateTimeFormatter DD_MMMM_FORMAT = DateTimeFormatter.ofPattern("dd MMMM");
    String date = null;
    String time = null;

    if (dateTime != null) {
      date = dateTime.format(DD_MMMM_FORMAT);
      time = "18:00 - 00:00";
    }

    if (dateTime == null && isElementExist(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, "-"))) {
      click(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, "-"));
    } else if (!(isElementExistFast(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, date)))) {
      click(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, time));
    } else {
      click(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, date));
    }

    pause1s();
    click(OK_BUTTON_OPTION_TABLE_XPATH);
    pause3s();
  }

  private String expectedValueDateTime(ZonedDateTime dateTime) {
    DateTimeFormatter DD_MMMM_FORMAT = DateTimeFormatter.ofPattern("dd MMMM");
    String expectedValue;

    if (dateTime != null) {
      expectedValue = dateTime.format(DD_MMMM_FORMAT);
    } else {
      expectedValue = "-";
    }
    return expectedValue;
  }

  public static class TableFilterPopup extends PageElement {

    public TableFilterPopup(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//button[.//span[.='Filter']]")
    public Button openButton;

    @FindBy(xpath = "//button[.='OK']")
    public Button ok;

    @FindBy(xpath = "//button[.='Reset']")
    public Button reset;
  }

  public static class TripTimeFilter extends TableFilterPopup {

    public TripTimeFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public final String hiddenDropdown = "//div[contains(@class, 'ant-dropdown') and not(contains(@class , 'ant-dropdown-hidden'))]";

    @FindBy(xpath = hiddenDropdown + "//div[p[.='Date']]//ul//li[1]")
    public TextBox firstDateText;

    @FindBy(xpath = "(//div[p[.='Date']]//ul//li[1]//input)")
    public CheckBox firstDate;

    @FindBy(xpath = hiddenDropdown + "//div[p[.='Date']]//ul//li[2]")
    public TextBox secondDateText;

    @FindBy(xpath = "(//div[p[.='Date']]//ul//li[2]//input)")
    public CheckBox secondDate;

    @FindBy(xpath = hiddenDropdown + "//div[p[.='Date']]//ul//li[3]")
    public TextBox thirdDateText;

    @FindBy(xpath = "(//div[p[.='Date']]//ul//li[3]//input)")
    public CheckBox thirdDate;

    @FindBy(xpath = hiddenDropdown + "//div[p[.='Date']]//ul//li[4]")
    public TextBox fourthDateText;

    @FindBy(xpath = "(//div[p[.='Date']]//ul//li[4]//input)")
    public CheckBox fourthDate;

    @FindBy(xpath = hiddenDropdown + "//li[.='-']//input")
    public CheckBox none;

    @FindBy(xpath = hiddenDropdown + "//li[.='00:00 - 06:00']//input")
    public CheckBox earlyMorning;

    @FindBy(xpath = hiddenDropdown + "//li[.='06:00 - 12:00']//input")
    public CheckBox morning;

    @FindBy(xpath = hiddenDropdown + "//li[.='12:00 - 18:00']//input")
    public CheckBox afterNoon;

    @FindBy(xpath = hiddenDropdown + "//li[.='18:00 - 00:00']//input")
    public CheckBox night;

    public void selectDate(ZonedDateTime dateTime) {
      DateTimeFormatter DD_MMMM_FORMAT = DateTimeFormatter.ofPattern("dd MMMM");
      String stringDate = dateTime.format(DD_MMMM_FORMAT);
      firstDateText.waitUntilVisible();
      if (firstDateText.getText().contains(stringDate)) {
        firstDate.check();
        return;
      }
      if (isElementExistWait1Second(hiddenDropdown + "//div[p[.='Date']]//ul//li[2]")) {
        if (secondDateText.getText().contains(stringDate)) {
          secondDate.check();
          return;
        }
      }
      if (isElementExistWait0Second(hiddenDropdown + "//div[p[.='Date']]//ul//li[3]")) {
        if (thirdDateText.getText().contains(stringDate)) {
          thirdDate.check();
          return;
        }
      }
      if (isElementExistWait0Second(hiddenDropdown + "//div[p[.='Date']]//ul//li[4]")) {
        if (fourthDateText.getText().contains(stringDate)) {
          fourthDate.check();
        }
      }
    }

    public void selectTime(ZonedDateTime dateTime) {
      if (dateTime != null) {
        int hour = dateTime.getHour();
        if (isBetween(hour, 0, 6)) {
          earlyMorning.check();
          return;
        }
        if (isBetween(hour, 6, 12)) {
          morning.check();
          return;
        }
        if (isBetween(hour, 12, 18)) {
          afterNoon.check();
          return;
        }
        if (isBetween(hour, 18, 23)) {
          night.check();
          return;
        }
      }
      none.check();
    }
  }

  public static class TripDepartureArrivalModal extends AntModal {

    public TripDepartureArrivalModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Submit']")
    public Button submitTripDeparture;

    @FindBy(xpath = "//button[.='No']")
    public Button no;
  }

  public static class MovementTypeFilter extends TableFilterPopup {

    public MovementTypeFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//li[.='Air Haul']//input")
    public CheckBox airHaul;

    @FindBy(xpath = "//li[.='Land Haul']//input")
    public CheckBox landHaul;

    public void selectType(String type) {
      switch (type.toLowerCase()) {
        case "air haul":
          airHaul.check();
          break;
        case "land haul":
          landHaul.check();
          break;
      }
    }
  }

  public static class StatusFilter extends TableFilterPopup {

    public StatusFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//li[.='Pending']//input")
    public CheckBox pending;

    @FindBy(xpath = "//li[.='In Transit']//input")
    public CheckBox inTransit;

    @FindBy(xpath = "//li[.='Completed']//input")
    public CheckBox completed;

    @FindBy(xpath = "//li[.='Cancelled']//input")
    public CheckBox cancelled;

    public void selectType(String type) {
      switch (type.toLowerCase()) {
        case "pending":
          pending.check();
          break;
        case "in transit":
          inTransit.check();
          break;
        case "completed":
          completed.check();
          break;
        case "cancelled":
          cancelled.check();
          break;
      }
    }
  }

  public static class CancelTripModal extends AntModal {

    public CancelTripModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Cancel Trip']")
    public Button cancelTrip;

    @FindBy(xpath = "//button[.='No']")
    public Button no;
  }

  public static class TripEventsRow extends NvTable.NvRow {

    public TripEventsRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public TripEventsRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(className = "event")
    public PageElement event;

    @FindBy(className = "userId")
    public PageElement userId;

    @FindBy(className = "status")
    public PageElement status;

    @FindBy(className = "hubName")
    public PageElement hubName;

    @FindBy(className = "createdAt")
    public PageElement createdAt;
  }

  public static class AssignTripModal extends AntModal {

    public AssignTripModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Save']")
    public Button saveButton;

    @FindBy(xpath = "//button[.='Save Driver']")
    public Button saveDriver;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancel;

    public String assignDriverInput = "assignDriversForm_driverNames_%s";

    @FindBy(xpath = "//button[.='Add Another Driver']")
    public Button addAnotherDriver;

    @FindBy(xpath = "//button[.='Add Driver']")
    public Button addDriver;

    @FindBy(xpath= "//div[contains(@class, 'remove-link')]")
    public Button removeDriver;

    @FindBy(xpath = "//button[.='Unassign All']")
    public Button unassignAllDrivers;

    public void assignDriver(String driverName) {
      sendKeysAndEnterById(f(assignDriverInput, 0), driverName);
    }

    public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
      sendKeysAndEnterById(f(assignDriverInput, 0), primaryDriver);
      pause1s();
      addDriver.waitUntilClickable();
      addDriver.click();
      pause1s();
      sendKeysAndEnterById(f(assignDriverInput, 1), additionalDriver);
    }

    public void clearAssignedDriver() {
      addDriver.click();
      pause500ms();
      unassignAllDrivers.click();
    }
  }


  public static class AssignTripModalOld extends AntModal {

    public AssignTripModalOld(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = "//button[.='Save']")
    public Button saveButton;

    @FindBy(xpath = "//button[.='Save Driver']")
    public Button saveDriver;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancel;

    public String assignDriverInput = "assignDriversForm_driverNames_%s";

    @FindBy(xpath = "//button[.='Add Another Driver']")
    public Button addAnotherDriver;

    @FindBy(xpath = "//button[.='Add Driver']")
    public Button addDriver;

    @FindBy(xpath = "//div[contains(@class, 'remove-link')]")
    public Button removeDriver;

    @FindBy(xpath = "//button[.='Unassign All']")
    public Button unassignAllDrivers;

    public void assignDriver(String driverName) {
      sendKeysAndEnterById(f(assignDriverInput, 0), driverName);
    }

    public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
      sendKeysAndEnterById(f(assignDriverInput, 0), primaryDriver);
      pause1s();
      addDriver.waitUntilClickable();
      addDriver.click();
      pause1s();
      sendKeysAndEnterById(f(assignDriverInput, 1), additionalDriver);
    }

    public void clearAssignedDriver() {
      addDriver.click();
      pause500ms();
      unassignAllDrivers.click();
    }
  }
}
