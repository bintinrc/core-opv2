package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.mm.model.MiddleMileDriver;
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
import co.nvqa.operator_v2.util.TestUtils;
import java.text.SimpleDateFormat;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.model.core.Order.STATUS_CANCELLED;
import static co.nvqa.commons.model.core.Order.STATUS_COMPLETED;

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
  private static final String DATE_PICKER_MODAL_XPATH = "//div[not(contains(@class, 'ant-picker-dropdown-hidden'))]/div[@class= 'ant-picker-panel-container']";
  private static final String NEXT_MONTH_BUTTON_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//span[contains(@class,'ant-picker-next-icon')]";
  private static final String PREV_MONTH_BUTTON_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//span[contains(@class,'ant-picker-prev-icon')]";
  private static final String TAB_XPATH = "//span[contains(.,'%s')]/preceding-sibling::span";
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
  private static final String DESTINATION_HUB_CLASS = "destination-hub-name";
  private static final String MOVEMENT_TYPE_CLASS = "movement-type";
  private static final String EXPECTED_DEPARTURE_TIME_CLASS = "expected-departure-time";
  private static final String ACTUAL_DEPARTURE_TIME_CLASS = "actual-start-time";
  private static final String EXPECTED_ARRIVAL_TIME_CLASS = "expected-arrival-time";
  private static final String ACTUAL_ARRIVAL_TIME_CLASS = "actual-arrival-time";
  private static final String INPUT_DRIVERS_AREA_LABEL = "//input[@aria-label='input-drivers']";
  private static final String DRIVER_CLASS = "driver";
  private static final String STATUS_CLASS = "status";
  private static final String LAST_STATUS_CLASS = "lastStatus";

  private static final String SUCCESS_CANCEL_TRIP_TOAST = "//div[contains(@class,'notification-notice-message') and (contains(text(),'Trip %d cancelled'))]";
  private static final String FIRST_ROW_TRACK = "//tr[2]//td[contains(@class,'track')]";

  private static final DateTimeFormatter BE_FORMATTER = DateTimeFormatter
      .ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSz");

  private static final String DETAIL_PAGE_TRIP_ID_XPATH = "//h4[@class='ant-typography' and normalize-space()]";
  private static final String DETAIL_PAGE_STATUS_XPATH = "//span[text()='Status']/ancestor::div[@class='ant-col']";
  private static final String DETAIL_PAGE_ORIGIN_HUB_XPATH = "//div[@class='ant-card-body']//span[text()='Origin Hub']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_DESTINATION_HUB_XPATH = "//div[@class='ant-card-body']//span[text()='Destination Hub']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_MOVEMENT_TYPE_XPATH = "//div[@class='ant-card-body']//span[text()='Movement Type']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_EXPECTED_DEPARTURE_XPATH = "//div[@class='ant-card-body']//span[text()='Expected Departure Time']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_EXPECTED_ARRIVAL_XPATH = "//div[@class='ant-card-body']//span[text()='Expected Arrival Time']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_ACTUAL_DEPARTURE_XPATH = "//div[@class='ant-card-body']//span[text()='Actual Departure Time']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_ACTUAL_ARRIVAL_XPATH = "//div[@class='ant-card-body']//span[text()='Actual Arrival Time']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_SHIPMENTS_XPATH = "//div[@class='ant-card-body']//span[text()='Shipments']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_PARCELS_XPATH = "//div[@class='ant-card-body']//span[text()='Parcels']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_TRIP_PASSWORD_XPATH = "//div[@class='ant-card-body']//span[text()='Trip Password']//ancestor::div[@class='ant-space-item']";
  private static final String DETAIL_PAGE_DRIVERS_XPATH = "//div[@class='ant-card-body']//span[text()='Driver']//ancestor::div[@class='ant-space-item']//div[@class='ant-spin-container']";
  private static final String DETAIL_PAGE_SHIPMENTS_TAB_XPATH = "//div[text()='Shipments' and @role='tab']";
  private static final String DETAIL_PAGE_TRIP_EVENTS_TAB_XPATH = "//div[text()='Trip Events' and @role='tab']";
  private static final String DETAIL_PAGE_ASSIGN_DRIVER_XPATH = "//span[@data-testid='assign-driver-icon']"; //Helpful for the future - Add driver from detail page, do not remove
  private static final String SHIPMENTS_TAB_SHIPMENT_ID_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-shipment-id']";
  private static final String SHIPMENTS_TAB_ORIGIN_HUB_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-origin-hub-name']";
  private static final String SHIPMENTS_TAB_CURRENT_HUB_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-last-inbound-hub-name']";
  private static final String SHIPMENTS_TAB_DEST_HUB_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-destination-hub-name']";
  private static final String SHIPMENTS_TAB_STATUS_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-shipment-status' and text()='Status']";
  private static final String SHIPMENTS_TAB_SLA_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-sla']";
  private static final String SHIPMENTS_TAB_PARCELS_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-orders-count']";
  private static final String SHIPMENTS_TAB_SHIPMENT_TYPE_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-shipment-type']";
  private static final String SHIPMENTS_TAB_TABLE_BODY_XPATH = "//div[contains(@id,'shipments')]//div[contains(@class,'ant-table-body')]";

  private static final String TRIP_DEPARTURE_PAGE_MESSAGE_XPATH = "//div[@class='ant-modal-content']//span[@class='ant-typography']/strong";
  private static final String TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH = "//div[@class='ant-modal-content']//span[text()='Origin Hub']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH = "//div[@class='ant-modal-content']//span[text()='Destination Hub']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH = "//div[@class='ant-modal-content']//span[text()='Movement Type']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_EXPECTED_DEPARTURE_TIME_XPATH = "//div[@class='ant-modal-content']//span[text()='Expected Departure Time']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_EXPECTED_ARRIVAL_TIME_XPATH = "//div[@class='ant-modal-content']//span[text()='Expected Arrival Time']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_SHIPMENTS_XPATH = "//div[@class='ant-modal-content']//span[text()='Shipments']/ancestor::div[contains(@class,'ant-col')]";
  private static final String TRIP_DEPARTURE_PAGE_DRIVER_XPATH = "//div[@class='ant-modal-content']//span[text()='Driver']/ancestor::div[contains(@class,'ant-col')]";

  private static final String TRIP_ASSIGN_DRIVER_PAGE_UNASSIGN_DRIVER_XPATH = "//div[@class='ant-modal-content']//span[text()='Unassign All']";
  private static final String TRIP_ASSIGN_DRIVER_PAGE_ADD_DRIVER_DISABLE_XPATH = "//button[@data-testid='add-driver-button' and @disabled]";
  private static final String TRIP_ASSIGN_DRIVER_PAGE_DRIVER_LABLE_XPATH = "//label[@class='ant-form-item-required']";

  private static final String TRIP_CANCEL_PAGE_REASON_XPATH = "//label[text()='Cancellation reason']/following::input";
  private static final String TRIP_CANCEL_PAGE_MESSAGE_XPATH = "(//div[@class='ant-select-item-option-content'])[%d]";
  private static final String TRIP_CANCEL_PAGE_MESSAGE_LIST_XPATH = "//div[@class='ant-select-item-option-content']";
  private static final String TRIP_CANCEL_PAGE_NO_BUTTON = "//div[@class='ant-modal-content']//button[@data-testid ='cancel-modal-cancel-button']";
  private static final String TRIP_CANCEL_PAGE_CANCEL_BUTTON = "//div[@class='ant-modal-content']//button[@data-testid ='cancel-modal-confirm-button']";
  private static final String TRIP_CANCEL_PAGE_CANCELLATION_REASON = "//label[@title='Cancellation reason']";

  private static final String MOVEMENT_TRIPS_PAGE_CREATE_ONE_TIME_TRIP_XAPTH = "//span[text()=' Create One Time Trip']";
  private static final String MOVEMENT_TRIPS_PAGE_DEPARTURE_XAPTH = "//span[contains(@class,'ant-radio-button-checked')]/following::span[text()='Departure']";
  private static final String MOVEMENT_TRIPS_PAGE_ARRIVAL_XAPTH = "//label[@class='ant-radio-button-wrapper']//span[text()='Arrival']";
  private static final String MOVEMENT_TRIPS_PAGE_ARCHIVE_XAPTH = "//label[@class='ant-radio-button-wrapper']//span[text()='Archive']";
  private static final String MOVEMENT_TRIPS_PAGE_TEXT_LABEL_XAPTH = "//div[text()='Select an Origin Hub to continue']";
  private static final String MOVEMENT_TRIPS_PAGE_DEPARTURE_DATE_XAPTH = "//input[@id = 'departureDate']";

  private static final String CREATE_TRIP_PAGE_SUBMIT_BUTTON_XPATH = "//button[@data-testid='submit-button']";
  private static final String CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH = "//input[@id='createAdhocTripForm_originHub']";
  private static final String CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH = "//input[@id='createAdhocTripForm_destinationHub']";
  private static final String CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH = "//input[@id='createAdhocTripForm_movementType']";
  private static final String CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH = "//input[@id ='createAdhocTripForm_drivers']";
  private static final String CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH = "//input[@id = 'createAdhocTripForm_departureTime']";
  private static final String CREATE_TRIP_PAGE_DURATION_DAYS_XPATH = "//input[@id = 'createAdhocTripForm_durationDays']";
  private static final String CREATE_TRIP_PAGE_ORIGIN_HUB_ERRORS_XPATH = "//input[@id='createAdhocTripForm_originHub']/ancestor::div[@class='ant-form-item-control-input']//following-sibling::div/div[@class='ant-form-item-explain-error']";
  private static final String CREATE_TRIP_PAGE_DESTINATION_HUB_ERRORS_XPATH = "//input[@id='createAdhocTripForm_destinationHub']/ancestor::div[@class='ant-form-item-control-input']//following-sibling::div/div[@class='ant-form-item-explain-error']";

  private static final String CREATE_TRIP_PAGE_DURATION_HOURS_XPATH = "//input[@id = 'createAdhocTripForm_durationHours']";
  private static final String CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH = "//input[@id = 'createAdhocTripForm_durationMinutes']";
  private static final String CREATE_TRIP_PAGE_DEPARTURE_DATE_XPATH = "//input[@id = 'createAdhocTripForm_departureDate']";
  private static final String CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]//div[contains(text(),'%s')]";
  private static final List<String> LIST_OF_CANCELLATION_MESSAGE = Arrays.asList("Natural disasters / Force majeure", "Cancellation of flight", "Change of schedule", "Low parcel volume", "Not onboard on MMDA yet", "System Issues");
  private static final String TRIP_ASSIGNED_DRIVERS_XPATH = "//td[text()='Loading drivers...']";

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

  @FindBy(xpath = "//button[.='Cancel Trip']")
  public Button CancelTrip;

  @FindBy(xpath = "//button[.='Submit']")
  public Button SubmitButton;

  @FindBy(xpath = "//button[.='Add Driver']")
  public Button AddDriverButton;

  @FindBy(xpath = "//input[@id='originHub']")
  public AntSelect originHubFilter;

  @FindBy(xpath = "//input[@id='destinationHub']")
  public AntSelect destinationHubFilter;

  @FindBy(id = "movementType")
  public AntSelect movementTypeFilterPage;

  @FindBy(xpath = "//label[text()='Cancellation reason']/following::input")
  public TextBox cancellationReasonInput;

  private static String originHub = "//input[@id='originHub']";
  private static String movementType = "//input[@id='movementType']";
  private static String destinationHub = "//input[@id='destinationHub']";
  private static String movementTripFilterTextXpath = "//span[@title='%s']";

  @FindBy(xpath = "(//td[contains(@class,'action')]//i)[1]")
  public Button tripDetailButton;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  public static String actualToastMessageContent = "";

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
    pause5s();
    if (filterName.equalsIgnoreCase("originhub")) {
      TestUtils.findElementAndClick(originHub, "xpath", getWebDriver());
      sendKeysAndEnter(originHub, filterValue);
      Assertions.assertThat(!TestUtils.isBlank(getText(String.format(movementTripFilterTextXpath, filterValue))))
          .as("Origin hub is found. Proceeds to the next step...")
          .isTrue();
    } else if (filterName.equalsIgnoreCase("movementtype")) {
      movementTypeFilterPage.click();
      sendKeysAndEnter(movementType, filterValue);
      Assertions.assertThat(!TestUtils.isBlank(getText(String.format(movementTripFilterTextXpath, filterValue))))
          .as("Movement type is found. Proceeds to the next step...")
          .isTrue();
    } else if (filterName.equalsIgnoreCase("destinationhub")) {
      TestUtils.findElementAndClick(destinationHub, "xpath", getWebDriver());
      sendKeysAndEnter(destinationHub, filterValue);
      Assertions.assertThat(!TestUtils.isBlank(getText(String.format(movementTripFilterTextXpath, filterValue))))
          .as("Destination hub is found. Proceeds to the next step...")
          .isTrue();
    } else if (filterName.equalsIgnoreCase("OneTimeOriginHub")) {
      TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
      sendKeysAndEnter(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, filterValue);
    } else if (filterName.equalsIgnoreCase("OneTimeDestinationHub")) {
      TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, "xpath",
          getWebDriver());
      sendKeysAndEnter(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, filterValue);
    } else if (filterName.equalsIgnoreCase("OneTimeMovementType")) {
      TestUtils.findElementAndClick(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, "xpath", getWebDriver());
      sendKeysAndEnter(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, filterValue);
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
    Assertions.assertThat(actualTripManagementSum)
        .as("Sum of Trip Management")
        .isEqualTo(tripManagementCount);
  }

  public void verifiesSumOfTripManagement(String tabName, int tripManagementCount) {
    List<WebElement> tripManagementList = new ArrayList<>();

    switch (tabName) {
      case "departure":
        tripManagementList = findElementsByXpath(DESTINATION_HUB_XPATH);
        break;
      case "arrival":
        tripManagementList = findElementsByXpath(ORIGIN_HUB_XPATH);
        break;
      default:
        NvLogger.warn("No Tab Name Found!");
    }

    int actualTripManagementSum = tripManagementList.size();
    Assertions.assertThat(actualTripManagementSum)
        .as("Sum of Trip Management is correct: %d", actualTripManagementSum)
        .isEqualTo(tripManagementCount);
  }

  public void searchAndVerifiesTripManagementIsExistedById(Long tripManagementId) {

    waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS));
    sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), tripManagementId.toString());
    waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));

    String actualTripManagementId = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
   Assertions.assertThat(actualTripManagementId).as("Trip Management ID").isEqualTo(tripManagementId.toString());


  }

  public void searchAndVerifiesTripManagementIsExistedByDestinationHubName(
      String destinationHubName) {
    waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, 1));
    sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, 1), destinationHubName);
    waitUntilVisibilityOfElementLocated(
        f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));

    String actualDestinationHubName = getText(
        f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));
   Assertions.assertThat(actualDestinationHubName).as("Destination Hub Name").isEqualTo(destinationHubName);
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
        TestUtils.findElementAndClick(DEPARTURE_CALENDAR_XPATH, "xpath", getWebDriver());
        break;

      case ARCHIVE_ARRIVAL_DATE:
        TestUtils.findElementAndClick(ARRIVAL_CALENDAR_XPATH, "xpath", getWebDriver());
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

    // Get the newest record for today
    int index = 0;
    for (int loop = tripManagementDetailsData.getData().size() - 1; loop >= 0; loop--) {
      String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
      String expectedDepartTime = tripManagementDetailsData.getData().get(loop)
          .getExpectedDepartureTime().toString();
      if (expectedDepartTime.contains(todayDate)) {
        index = loop;
        break;
      }
    }

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
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS) + "//input",
            filterValue);
        break;

      case ORIGIN_HUB:
        filterValue = tripManagementDetailsData.getData().get(index).getOriginHubName();
        waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS));
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS) + "//input",
            filterValue);
        break;

      case TRIP_ID:
        filterValue = tripManagementDetailsData.getData().get(index).getId().toString();
        waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ID_CLASS));
        sendKeysAndEnter(f(TABLE_HEADER_FILTER_INPUT_XPATH, ID_CLASS) + "//input", filterValue);
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
        String normalizedExpDepartDate = shipmentInfo.normalisedDate(
            expectedDepartTime.toString().replaceAll("Z", ":00Z"));
        normalizedExpDepartDate = normalizedExpDepartDate.replace(" ", "T") + ".000Z";
        expectedDepartTime = ZonedDateTime.parse(normalizedExpDepartDate, BE_FORMATTER);
        expectedDepartTimeFilter.openButton.click();
        expectedDepartTimeFilter.ok.waitUntilClickable();
        expectedDepartTimeFilter.selectDate(expectedDepartTime);
        expectedDepartTimeFilter.selectTime(expectedDepartTime);
        expectedDepartTimeFilter.ok.click();
        break;

      case ACTUAL_DEPARTURE_TIME:
        ZonedDateTime actualDepartureTime = tripManagementDetailsData.getData().get(index)
            .getExpectedArrivalTime();
        String normalizedDepartDate = shipmentInfo.normalisedDate(
            actualDepartureTime.toString().replaceAll("Z", ":00Z"));
        normalizedDepartDate = normalizedDepartDate.replace(" ", "T") + ".000Z";
        actualDepartureTime = ZonedDateTime.parse(normalizedDepartDate, BE_FORMATTER);
        actualDepartTimeFilter.openButton.click();
        actualDepartTimeFilter.selectTime(actualDepartureTime);
        actualDepartTimeFilter.ok.click();
        break;

      case EXPECTED_ARRIVAL_TIME:
        ZonedDateTime expectedArrivalTime = tripManagementDetailsData.getData().get(index)
            .getExpectedArrivalTime();
        String normalizedArrivalDate = shipmentInfo.normalisedDate(
            expectedArrivalTime.toString().replaceAll("Z", ":00Z"));
        normalizedArrivalDate = normalizedArrivalDate.replace(" ", "T") + ".000Z";
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
        filterValue = driverConverted(driverUsername).substring(1);
        tripStatusFilter.scrollIntoView();
        sendKeysAndEnter(
            f(TABLE_HEADER_FILTER_INPUT_XPATH, DRIVER_CLASS) + INPUT_DRIVERS_AREA_LABEL,
            filterValue);
        break;

      case STATUS:
        filterValue = tripManagementDetailsData.getData().get(index).getStatus();
        tripStatusFilter.scrollIntoView();
        TestUtils.callJavaScriptExecutor("arguments[0].click();", tripStatusFilter.openButton.getWebElement(),
                getWebDriver());
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

    // Get the newest record for today
    int index = 0;
    for (int loop = tripManagementDetailsData.getData().size() - 1; loop >= 0; loop--) {
      String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
      String expectedDepartTime = tripManagementDetailsData.getData().get(loop)
          .getExpectedDepartureTime().toString();
      if (expectedDepartTime.contains(todayDate)) {
        index = loop;
        break;
      }
    }

    String actualValue;
    String expectedValue;

    switch (tripManagementFilteringType) {
      case DESTINATION_HUB:
        expectedValue = tripManagementDetailsData.getData().get(index).getDestinationHubName();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));
       Assertions.assertThat(actualValue).as("Destination Hub").isEqualTo(expectedValue);
        break;

      case ORIGIN_HUB:
        expectedValue = tripManagementDetailsData.getData().get(index).getOriginHubName();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ORIGIN_HUB_CLASS));
       Assertions.assertThat(actualValue).as("Origin Hub").isEqualTo(expectedValue);
        break;

      case TRIP_ID:
        expectedValue = tripManagementDetailsData.getData().get(index).getId().toString();
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
       Assertions.assertThat(actualValue).as("Trip ID").isEqualTo(expectedValue);
        break;

      case MOVEMENT_TYPE:
        expectedValue = movementTypeConverter(
            tripManagementDetailsData.getData().get(index).getMovementType());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, MOVEMENT_TYPE_CLASS));
       Assertions.assertThat(actualValue).as("Movement Type").isEqualTo(expectedValue);
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
       Assertions.assertThat(actualValue.contains(expectedValue)).as("Actual Departure Time").isTrue();
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case DRIVER:
        expectedValue = driverConverted(driverUsername);
        actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DRIVER_CLASS));
        Assertions.assertThat(actualValue).as("Driver").contains(expectedValue.substring(1));
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case STATUS:
        expectedValue = statusConverted(tripManagementDetailsData.getData().get(index).getStatus());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, STATUS_CLASS));
        Assertions.assertThat(actualValue).as("Status").isEqualToIgnoringCase(expectedValue);
        ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
        break;

      case LAST_STATUS:
        expectedValue = statusConverted(tripManagementDetailsData.getData().get(index).getStatus());
        actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, LAST_STATUS_CLASS));
       Assertions.assertThat(actualValue).as("Last Status").isEqualTo(expectedValue);
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
    pause3s();
    assignTripModal.assignDriver(driverId);
    pause2s();
    verifyAddDriverUnclickable();
    assignTripModal.saveButton.click();
    assignTripModal.saveButton.waitUntilInvisible();
  }

  public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
    waitUntilVisibilityOfElementLocated("//div[.='Assign Driver']");
    assignTripModal.addDriver.click();
    pause3s();
    assignTripModal.assignDriverWithAdditional(primaryDriver, additionalDriver);
    verifyAddDriverUnclickable();
    assignTripModal.saveButton.click();
    assignTripModal.saveButton.waitUntilInvisible();
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

    waitUntilPageLoaded(30);
    waitUntilVisibilityOfElementLocated(DETAIL_PAGE_TRIP_ID_XPATH, 90);
    waitUntilVisibilityOfElementLocated(DETAIL_PAGE_DRIVERS_XPATH, 90);
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_DRIVERS_XPATH, 5))
        .as("Assigned Driver appear in Trip Details page").isTrue();
    Assertions.assertThat(getText(DETAIL_PAGE_TRIP_ID_XPATH)).as("Trip ID is correct").contains(tripId);
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_STATUS_XPATH, 5))
        .as("Trip Status appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Origin Hub appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("Destination Hub appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_EXPECTED_DEPARTURE_XPATH, 5))
        .as("Expected Departure Time appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_EXPECTED_ARRIVAL_XPATH, 5))
        .as("Expected Arrival Time appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_ACTUAL_DEPARTURE_XPATH, 5))
        .as("Actual Departure Time appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_ACTUAL_ARRIVAL_XPATH, 5))
        .as("Actual Arrival Time appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_SHIPMENTS_XPATH, 5))
        .as("Shipments appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_PARCELS_XPATH, 5))
        .as("Parcels appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_TRIP_PASSWORD_XPATH, 5))
        .as("Trip Password appear in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_SHIPMENTS_TAB_XPATH, 5))
        .as("Shipments tab in Trip Details page").isTrue();
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_TRIP_EVENTS_TAB_XPATH, 5))
        .as("Trip Events appear in Trip Details page").isTrue();
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
      case "Cancel Flight Trip":
        cancelTripModal.cancelFlightTrip.click();
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
    doWithRetry(() -> {
      waitUntilVisibilityOfElementLocated(
          "//div[contains(@class,'notification-notice-message')]");
      WebElement toast = findElementByXpath(
          "//div[contains(@class,'notification-notice-message')]");
      actualToastMessageContent = toast.getText();
      waitUntilElementIsClickable("//a[@class='ant-notification-notice-close']");
      findElementByXpath("//a[@class='ant-notification-notice-close']").click();
    }, "Retrying until toast shown", 1000, 10);
  }

  public void verifyToastContainingMessageIsShown(String expectedToastMessage) {
    doWithRetry(() -> {
      if (actualToastMessageContent.equals("")) {
        readTheToastMessage();
      }
      Assertions.assertThat(actualToastMessageContent)
          .as("Trip Management toast message is shown: %s", actualToastMessageContent).contains(expectedToastMessage);
    }, "Retrying until toast shown...", 1000, 10);
  }

  public void verifyToastContainingMessageIsShownWithoutClosing(String expectedToastMessage) {
    doWithRetry(() -> {
      try {
        waitUntilVisibilityOfElementLocated(
            "//div[contains(@class,'notification-notice-message')]");
        WebElement toast = findElementByXpath(
            "//div[contains(@class,'notification-notice-message')]");
        String actualToastMessage = toast.getText();
       Assertions.assertThat(actualToastMessage).as("Trip Management toast message is the same").contains(expectedToastMessage);
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

  public void departTripWithDrivers() {
    doWithRetry(() -> {
      waitUntilInvisibilityOfElementLocated(TRIP_ASSIGNED_DRIVERS_XPATH, 5);
      departTrip();
    }, "Waiting for drivers loaded, and then depart trip...", 1000,10);
  }

  public void departTrip() {
    pause3s();
    departTripButton.waitUntilClickable();
    departTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MESSAGE_XPATH, 5))
        .as("Trip Departure message appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DRIVER_XPATH, 5))
        .as("Driver appear in Trip Departure page").isTrue();
    tripDepartureArrivalModal.submitTripDeparture.click();

  }

  public void arriveTrip() {
    arriveTripButton.waitUntilClickable();
    arriveTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MESSAGE_XPATH, 5))
        .as("Trip Departure message appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DRIVER_XPATH, 5))
        .as("Driver appear in Trip Departure page").isTrue();
    tripDepartureArrivalModal.submitTripDeparture.click();
    tripDepartureArrivalModal.waitUntilInvisible();
  }

  public void completeTrip() {
    completeTripButton.waitUntilClickable();
    completeTripButton.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MESSAGE_XPATH, 5))
        .as("Trip Departure message appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DRIVER_XPATH, 5))
        .as("Driver appear in Trip Departure page").isTrue();
    tripDepartureArrivalModal.submitTripDeparture.click();
    tripDepartureArrivalModal.waitUntilInvisible();
  }

  public void forceCompleteTrip() {
    forceTripCompletion.waitUntilClickable();
    forceTripCompletion.click();
    tripDepartureArrivalModal.waitUntilVisible();
    tripDepartureArrivalModal.submitTripDeparture.waitUntilClickable();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MESSAGE_XPATH, 5))
        .as("Trip Departure message appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Departure page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DRIVER_XPATH, 5))
        .as("Driver appear in Trip Departure page").isTrue();
    tripDepartureArrivalModal.submitTripDeparture.click();
    tripDepartureArrivalModal.waitUntilInvisible();
  }

  public void clickAssignDriverButtonOnDetailPage() {
    waitUntilVisibilityOfElementLocated(DETAIL_PAGE_ASSIGN_DRIVER_XPATH);
    findElementByXpath(DETAIL_PAGE_ASSIGN_DRIVER_XPATH).click();
    tripDepartureArrivalModal.waitUntilVisible();
    verifyItemsDisplayOnAssignDriverPage();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_SHIPMENTS_XPATH, 5))
        .as("Shipments appear in Trip Assign Driver page").isTrue();
  }

  public void verifyItemsDisplayOnAssignDriverPage() {
    tripDepartureArrivalModal.waitUntilVisible();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Assign Driver page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Assign Driver page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Assign Driver page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_EXPECTED_DEPARTURE_TIME_XPATH, 5))
        .as("Expected Departure Time appear in Trip Assign Driver page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_EXPECTED_ARRIVAL_TIME_XPATH, 5))
        .as("Expected Arrival Time appear in Trip Assign Driver page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_ASSIGN_DRIVER_PAGE_UNASSIGN_DRIVER_XPATH, 5))
        .as("Unassign All Driver appear in Trip Assign Driver page").isTrue();
  }

  public void clickUnassignAllOnAssignDriverPage() {
    waitUntilVisibilityOfElementLocated(TRIP_ASSIGN_DRIVER_PAGE_UNASSIGN_DRIVER_XPATH);
    findElementByXpath(TRIP_ASSIGN_DRIVER_PAGE_UNASSIGN_DRIVER_XPATH).click();
    assignTripModal.saveButton.click();
    assignTripModal.waitUntilInvisible();
  }

  public void CancelTrip() {
    pause3s();
    CancelTrip.waitUntilClickable();
    CancelTrip.click();
    tripDepartureArrivalModal.waitUntilVisible();
    String script = "return window.getComputedStyle(document.querySelector('label.ant-form-item-required'),':before').getPropertyValue('content')";
    String content = (String) executeScript(script);
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MESSAGE_XPATH, 5))
        .as("Trip Departure message appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Start Hub appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("End Hub appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_MOVEMENT_TYPE_XPATH, 5))
        .as("Movement Type appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_DEPARTURE_PAGE_DRIVER_XPATH, 5))
        .as("Driver appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_CANCEL_PAGE_NO_BUTTON, 5))
        .as("No button appear in Trip Cancel page").isTrue();
    Assertions.assertThat(isElementVisible(TRIP_CANCEL_PAGE_CANCELLATION_REASON, 5))
        .as("Cancellation reason appear in Trip Cancel page ").isTrue();
    Assertions.assertThat(content.contains("*")).as("Cancellation reason is mandatory field")
        .isTrue();
  }

  public void selectCancellationReason() {
    // Create random integer from 1 to 6 and click nth option based on it
    String cancellationMessage = String.format(TRIP_CANCEL_PAGE_MESSAGE_XPATH, new Random().nextInt(5) + 1);
    cancellationReasonInput.waitUntilClickable();
    cancellationReasonInput.click();
    waitUntilElementIsClickable(cancellationMessage);
    click(cancellationMessage);
  }

  public void verifyCancellationMessage() {
    /*
      Use getAttribute("innerText") instead of getText() for elements that exist
      but not visible on the page such as these options
    */
    List<WebElement> messageListElements = findElementsByXpath(TRIP_CANCEL_PAGE_MESSAGE_LIST_XPATH);
    List<String> messageList = messageListElements.stream().map(we -> we.getAttribute("innerText")).collect(
        Collectors.toList());

    Assertions.assertThat(messageList)
        .as("Cancellation messages displayed on dropdown are CORRECT")
        .containsAll(LIST_OF_CANCELLATION_MESSAGE);
  }

  public void CancelTripButtonStatus(String status) {
    switch (status) {
      case "disable":
        Assertions.assertThat(isClickable(TRIP_CANCEL_PAGE_CANCEL_BUTTON,1)).as("Cancel Trip button is disabled").isFalse();
        break;
      case "enable":
        Assertions.assertThat(isClickable(TRIP_CANCEL_PAGE_CANCEL_BUTTON,1)).as("Cancel Trip button is enabled").isTrue();
        break;

    }
  }

  public void clickCancelTripButton() {
    TestUtils.findElementAndClick(TRIP_CANCEL_PAGE_CANCEL_BUTTON, "xpath", getWebDriver());
  }

  public void clickShipmentTab() {
    waitUntilVisibilityOfElementLocated(DETAIL_PAGE_SHIPMENTS_TAB_XPATH);
    findElementByXpath(DETAIL_PAGE_SHIPMENTS_TAB_XPATH).click();

  }

  public void verifyShipmentTabElements() {
    waitUntilVisibilityOfElementLocated(SHIPMENTS_TAB_TABLE_BODY_XPATH);
    WebElement TableBody = findElementByXpath(SHIPMENTS_TAB_TABLE_BODY_XPATH);
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_SHIPMENT_ID_XPATH, 5))
        .as("Shipment ID appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_ORIGIN_HUB_XPATH, 5))
        .as("Origin Hub appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_CURRENT_HUB_XPATH, 5))
        .as("Last Inbound Hub appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_DEST_HUB_XPATH, 5))
        .as("Destination Hub appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_SHIPMENT_TYPE_XPATH, 5))
        .as("Shipment type appear in Shipment Table").isTrue();
    executeScript("arguments[0].scrollLeft = arguments[0].offsetWidth;", TableBody);
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_SLA_XPATH, 5))
        .as("SLA appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_PARCELS_XPATH, 5))
        .as("Parcels appear in Shipment Table").isTrue();
    Assertions.assertThat(isElementVisible(SHIPMENTS_TAB_STATUS_XPATH, 5))
        .as("Status appear in Shipment Table").isTrue();
  }

  public void verifyAddDriverUnclickable() {
    List<WebElement> listDrivers = findElementsByXpathFast(
        TRIP_ASSIGN_DRIVER_PAGE_DRIVER_LABLE_XPATH);
    if (listDrivers.size() == 4) {
      Assertions.assertThat(isElementVisible(TRIP_ASSIGN_DRIVER_PAGE_ADD_DRIVER_DISABLE_XPATH))
          .as("Add Driver in Trip Assign Driver page is diable").isTrue();
    } else {
      Assertions.assertThat(isElementVisible(TRIP_ASSIGN_DRIVER_PAGE_ADD_DRIVER_DISABLE_XPATH))
          .as("Add Driver in Trip Assign Driver page is enable because Assigned Drivers are less than 4")
          .isFalse();
    }
  }

  public void verifyAssignDriverInvisible() {
    Assertions.assertThat(isElementVisible(DETAIL_PAGE_ASSIGN_DRIVER_XPATH))
        .as("Assign Driver button is not visible.").isFalse();
  }

  public void clickCreateOneTimeTripButton() {
    findElementByXpath(MOVEMENT_TRIPS_PAGE_CREATE_ONE_TIME_TRIP_XAPTH).click();
    switchToNewWindow();
    this.switchTo();
    waitUntilVisibilityOfElementLocated(
        "//input[@id ='createAdhocTripForm_originHub']/parent::span/following-sibling::span[text()='Search or Select']",
        30);
    //pause5s();
  }

  public void verifyCreateOneTimeTripPage() {

    //waitUntilVisibilityOfElementLocated(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH,10);
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, 5))
        .as("Origin Hub appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, 5))
        .as("Destination Hub appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH, 5))
        .as("Departure Time appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_DURATION_DAYS_XPATH, 5))
        .as("Duration Day appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_DURATION_HOURS_XPATH, 5))
        .as("Duration Hours appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementVisible(CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH, 5))
        .as("Duration Minutes appear in Create One Time Trip page").isTrue();
    Assertions.assertThat(isElementExist(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, 5))
        .as("Assign Drivers appear in Create One Time Trip page").isTrue();
  }

  public void createOneTimeTrip(Map<String, String> resolvedMapOfData,
      List<MiddleMileDriver> middleMileDrivers) {
    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, resolvedMapOfData.get("originHub"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH,
        resolvedMapOfData.get("destinationHub"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, resolvedMapOfData.get("movementType"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH, resolvedMapOfData.get("departureTime"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_DAYS_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_DAYS_XPATH, resolvedMapOfData.get("durationDays"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_HOURS_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_HOURS_XPATH, resolvedMapOfData.get("durationHours"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH,
        resolvedMapOfData.get("durationMinutes"));

    click(CREATE_TRIP_PAGE_DEPARTURE_DATE_XPATH);
    waitUntilVisibilityOfElementLocated(DATE_PICKER_MODAL_XPATH);
    click(f(CALENDAR_SELECTED_XPATH, resolvedMapOfData.get("departureDate")));
    int numberOfDrivers = middleMileDrivers.size();
    int maxAssignDrivers = Math.min(numberOfDrivers, 4);
    for (int i = 0; i < maxAssignDrivers; i++) {
      doWithRetry(() -> {
        TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, "xpath", getWebDriver());
        waitUntilVisibilityOfElementLocated("//div[@data-testid='assign-drivers-select' and contains(@class,'ant-select-open')]", 1);
      }, "Click until dropdown shows up...", 1000, 20);
      sendKeys(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, middleMileDrivers.get(i).getUsername());
      click(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH, middleMileDrivers.get(i).getUsername()));
    }
    if (numberOfDrivers > 4) {
      verifyCanNotAssignMoreThan4Drivers(middleMileDrivers);
    }
  }

  public void createOneTimeTripWithoutDriver(Map<String, String> resolvedMapOfData){

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, resolvedMapOfData.get("originHub"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, resolvedMapOfData.get("destinationHub"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_MOVEMENT_TYPE_XPATH, resolvedMapOfData.get("movementType"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DEPARTURE_TIME_XPATH, resolvedMapOfData.get("departureTime"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_DAYS_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_DAYS_XPATH, resolvedMapOfData.get("durationDays"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_HOURS_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_HOURS_XPATH, resolvedMapOfData.get("durationHours"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DURATION_MINUTES_XPATH, resolvedMapOfData.get("durationMinutes"));

    click(CREATE_TRIP_PAGE_DEPARTURE_DATE_XPATH);
    waitUntilVisibilityOfElementLocated(DATE_PICKER_MODAL_XPATH);
    click(f(CALENDAR_SELECTED_XPATH, resolvedMapOfData.get("departureDate")));
  }

  public void clickSubmitButtonOnCreateOneTripPage() {
    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_SUBMIT_BUTTON_XPATH, "xpath", getWebDriver());
  }

  public void verifyCanNotAssignMoreThan4Drivers(List<MiddleMileDriver> middleMileDrivers) {
    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, "xpath", getWebDriver());
    sendKeys(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH,
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername());
    click(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH,
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername()));
    Boolean isDriverSelected = findElementByXpath(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH,
        middleMileDrivers.get(middleMileDrivers.size() - 1).getUsername())).isSelected();

    Assertions.assertThat(isDriverSelected).as(" Can not select more than 4 drivers").isFalse();
  }

  public void verifyInvalidItem(String name, String value) {
    switch (name) {
      case "origin hub":
        String originHubName = value;
        TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
        sendKeys(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, originHubName);
        Assertions.assertThat(
                isElementExist(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH, originHubName), 1L))
            .as("Disable Origin Hub is not displayed").isFalse();
        findElementByXpath(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH).clear();
        break;

      case "destination hub":
        String destinationHubName = value;
        TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, "xpath",
            getWebDriver());
        sendKeys(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, destinationHubName);
        Assertions.assertThat(
                isElementExist(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH, destinationHubName), 1L))
            .as("Disable Destination Hub is not displayed").isFalse();
        findElementByXpath(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH).clear();
        break;

      case "driver":
        String driverUsername = value;
        TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, "xpath",
            getWebDriver());
        sendKeys(CREATE_TRIP_PAGE_ASSIGN_DRIVER_XPATH, driverUsername);
        Assertions.assertThat(
                isElementExist(f(CREATE_TRIP_PAGE_DROPDOWN_LIST_XPATH, driverUsername), 1L))
            .as("Invalid Driver has not been displayed").isFalse();
        break;
    }
  }

  public void readAndVerifyTheToastMessageOfOneTimeTrip() {
    retryIfAssertionErrorOccurred(() -> {
      try {
        waitUntilVisibilityOfElementLocated(
            "//div[@class='ant-message']//div[contains(@class,'ant-message-success')]");
        WebElement toast = findElementByXpath(
            "//div[@class='ant-message']//div[contains(@class,'ant-message-success')]/span[not(contains(@role,'img'))]");
        actualToastMessageContent = toast.getText();
        Assertions.assertThat(actualToastMessageContent.isEmpty()).as(actualToastMessageContent)
            .isFalse();

      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
      }
    }, getCurrentMethodName(), 1000, 5);
  }

  public void verifyTripMovementPageItems() {
    waitUntilVisibilityOfElementLocated("//button[.='Load Trips']");
    Assertions.assertThat(isElementVisible(LOAD_BUTTON_XPATH, 5))
        .as("Load button appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(originHub, 5))
        .as("Origin Hub appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(movementType, 5))
        .as("Movement Type appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(MOVEMENT_TRIPS_PAGE_CREATE_ONE_TIME_TRIP_XAPTH, 5))
        .as("Create one time trip button appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(MOVEMENT_TRIPS_PAGE_DEPARTURE_XAPTH, 5))
        .as("Departure tab appear in Movement Trips page as default open tab").isTrue();
    Assertions.assertThat(isElementVisible(MOVEMENT_TRIPS_PAGE_ARRIVAL_XAPTH, 5))
        .as("Arrival tab appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(MOVEMENT_TRIPS_PAGE_ARCHIVE_XAPTH, 5))
        .as("Archive tab appear in Movement Trips page").isTrue();
    Assertions.assertThat(isElementVisible(MOVEMENT_TRIPS_PAGE_TEXT_LABEL_XAPTH, 5))
        .as("Select an Origin Hub to continue appear in Movement Trips page").isTrue();
    Assertions.assertThat(checkDepartureOnMovementTripPage())
        .as("Departure Date appear in Movement Trips page and value is current day").isTrue();

  }

  public boolean checkDepartureOnMovementTripPage() {
    if (isElementVisible(MOVEMENT_TRIPS_PAGE_DEPARTURE_DATE_XAPTH, 5)) {
      String actualDate = findElementByXpath(MOVEMENT_TRIPS_PAGE_DEPARTURE_DATE_XAPTH).getAttribute(
          "value");
      String currentDay = new SimpleDateFormat("EEEE, dd MMMM yyyy").format(new Date());
      if (actualDate.equalsIgnoreCase(currentDay)) {
        return true;
      }
    }
    return false;
  }

  public void createOneTimeTripUsingSameHub(Map<String, String> resolvedMapOfData) {
    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_ORIGIN_HUB_XPATH, resolvedMapOfData.get("originHub"));

    TestUtils.findElementAndClick(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH, "xpath", getWebDriver());
    sendKeysAndEnter(CREATE_TRIP_PAGE_DESTINATION_HUB_XPATH,
        resolvedMapOfData.get("destinationHub"));

  }

  public void getAndVerifySameHubErrorMessage() {
    String originHubErrorMsg = findElementByXpath(
        CREATE_TRIP_PAGE_ORIGIN_HUB_ERRORS_XPATH).getText();
    String destinationHubErrorMsg = findElementByXpath(
        CREATE_TRIP_PAGE_DESTINATION_HUB_ERRORS_XPATH).getText();
    boolean errorVerification = (
        originHubErrorMsg.equals("Origin Hub and Destination Hub cannot be the same")
            && destinationHubErrorMsg.equals("Origin Hub and Destination Hub cannot be the same"));

    Assertions.assertThat(errorVerification).as("Origin Hub and Destination Hub cannot be the same")
        .isTrue();
  }

  public void verifySubmitButtonIsDisable() {
    Assertions.assertThat(findElementByXpath(CREATE_TRIP_PAGE_SUBMIT_BUTTON_XPATH).isEnabled())
        .as("Submit Button is disable on Create One Trip page").isFalse();
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

      case "TRANSIT":
        statusConverted = "Transit";
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

    @FindBy(xpath = hiddenDropdown + "//div[div[.='Date']]//ul//li[1]")
    public TextBox firstDateText;

    @FindBy(xpath = "(//div[div[.='Date']]//ul//li[1]//input)")
    public CheckBox firstDate;

    @FindBy(xpath = hiddenDropdown + "//div[div[.='Date']]//ul//li[2]")
    public TextBox secondDateText;

    @FindBy(xpath = "(//div[div[.='Date']]//ul//li[2]//input)")
    public CheckBox secondDate;

    @FindBy(xpath = hiddenDropdown + "//div[div[.='Date']]//ul//li[3]")
    public TextBox thirdDateText;

    @FindBy(xpath = "(//div[div[.='Date']]//ul//li[3]//input)")
    public CheckBox thirdDate;

    @FindBy(xpath = hiddenDropdown + "//div[div[.='Date']]//ul//li[4]")
    public TextBox fourthDateText;

    @FindBy(xpath = "(//div[div[.='Date']]//ul//li[4]//input)")
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
      if (isElementExistWait1Second(hiddenDropdown + "//div[div[.='Date']]//ul//li[2]")) {
        if (secondDateText.getText().contains(stringDate)) {
          secondDate.check();
          return;
        }
      }
      if (isElementExistWait0Second(hiddenDropdown + "//div[div[.='Date']]//ul//li[3]")) {
        if (thirdDateText.getText().contains(stringDate)) {
          thirdDate.check();
          return;
        }
      }
      if (isElementExistWait0Second(hiddenDropdown + "//div[div[.='Date']]//ul//li[4]")) {
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

    @FindBy(xpath = "//button[.='Cancel Flight Trip']")
    public Button cancelFlightTrip;

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

    @FindBy(xpath = "//div[contains(@class, 'remove-link')]")
    public Button removeDriver;

    @FindBy(xpath = "//button[.='Unassign All']")
    public Button unassignAllDrivers;

    public void assignDriver(String driverName, int inputIndex) {
      String inputXpath = f("//input[@id='%s']", f(assignDriverInput, inputIndex));
      WebElement input = findElementByXpath(inputXpath);
      waitUntilVisibilityOfElementLocated(input, 5);
      doWithRetry(() -> {
        sendKeys(input, driverName);
        waitUntilVisibilityOfElementLocated(f("//div[contains(@title,'%s')]", driverName), 1);
        input.sendKeys(Keys.ENTER);
      }, "Retrying until driver list is showing...", 1000, 5);
    }

    public void assignDriver(String driverName) {
      assignDriver(driverName, 0);
    }

    public void assignDriverWithAdditional(String primaryDriver, String additionalDriver) {
      List<String> usernames = Arrays.asList(primaryDriver, additionalDriver);

      for (int i=0; i<usernames.size(); i++) {
        assignDriver(usernames.get(i), i);

        if (i< usernames.size()-1) {
          addDriver.waitUntilClickable();
          addDriver.click();
        }
      }
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
      String inputXpath = f("//input[@id='%s']", f(assignDriverInput, 0));
      WebElement input = findElementByXpath(inputXpath);
      waitUntilVisibilityOfElementLocated(input, 5);
      doWithRetry(() -> {
        sendKeys(input, driverName);
        waitUntilVisibilityOfElementLocated(f("//div[contains(@title,'%s')]", driverName), 1);
        input.sendKeys(Keys.ENTER);
      }, "Retrying until driver list is showing...", 1000, 5);
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

  public void verifyTripMessageSuccessful(String expectedMessage){
    antNotificationMessage.waitUntilVisible();
    String actualMessage = getAntTopTextV2();
    Assertions.assertThat(actualMessage).as("Trip Message is shown successfuly").isEqualTo(expectedMessage);
  }
}
