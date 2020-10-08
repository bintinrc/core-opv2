package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.MovementTripActionName;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
import co.nvqa.operator_v2.selenium.elements.*;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Tristania Siagian
 */

public class TripManagementPage extends OperatorV2SimplePage {

    private static final String IFRAME_TRIP_MANAGEMENT_XPATH = "//iframe[contains(@src,'movement-trips')]";
    private static final String TRIP_MANAGEMENT_CONTAINER_XPATH = "//div[contains(@class,'TripContainer')]";
    private static final String LOAD_BUTTON_XPATH = "//button[contains(@class,'ant-btn-primary')]";
    private static final String FIELD_REQUIRED_ERROR_MESSAGE_XPATH = "//button[contains(@class,'ant-btn-primary')]";
    private static final String FILTER_OPTION_XPATH = "//div[div[div[input[@id='%s']]]]";
    private static final String TEXT_OPTION_XPATH = "//div[not(contains(@class,'dropdown-hidden'))]/div/ul/li[text()='%s']";
    private static final String DESTINATION_HUB_XPATH = "//td[contains(@class,'destinationHubName')]";
    private static final String ORIGIN_HUB_XPATH = "//td[contains(@class,'originHubName')]";
    private static final String NO_RESULT_XPATH = "//div[contains(@class,'NoResult')]";
    private static final String DEPARTURE_CALENDAR_XPATH = "//span[@id='departureDate']";
    private static final String ARRIVAL_CALENDAR_XPATH = "//span[@id='arrivalDate']";
    private static final String CALENDAR_SELECTED_XPATH = "//td[@title='%s']";
    private static final String NEXT_MONTH_BUTTON_XPATH = "//a[contains(@class,'next-month')]";
    private static final String PREV_MONTH_BUTTON_XPATH = "//a[contains(@class,'prev-month')]";
    private static final String TAB_XPATH = "//span[span[starts-with(text(),'%s')]]";
    private static final String TABLE_HEADER_FILTER_INPUT_XPATH = "//th[contains(@class,'%s')]";
    private static final String IN_TABLE_FILTER_INPUT_XPATH = "//th[contains(@class,'%s')]//span[contains(@class,'input-prefix')]/following-sibling::input";
    private static final String BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH = "//th[contains(@class,'%s')]/div/button";
    private static final String CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH = "//span[text()='%s']/preceding-sibling::label//input";
    private static final String FIRST_ROW_INPUT_FILTERED_RESULT_XPATH = "//tr[1]/td[contains(@class,'%s')]/span/mark";
    private static final String FIRST_ROW_OPTION_FILTERED_RESULT_XPATH = "//tr[1]/td[contains(@class,'%s')]";
    private static final String FIRST_ROW_TIME_FILTERED_RESULT_XPATH = "//tr[1]/td[contains(@class,'%s')]/span";
    private static final String FIRST_ROW_OF_TABLE_RESULT_XPATH = "//div[contains(@class,'table')]//tbody/tr[1]";
    private static final String FIRST_ROW_STATUS = "//tr[1]//td[contains(@class,'status')]";
    private static final String OK_BUTTON_OPTION_TABLE_XPATH = "//button[contains(@class,'btn-primary')]";
    private static final String TRIP_ID_FIRST_ROW_XPATH = "//tr[1]//td[contains(@class,'id')]/span/span";
    private static final String ACTION_COLUMN_XPATH = "//tr[1]//td[contains(@class,'action')]";
    private static final String ACTION_ICON_XPATH = "//tr[1]//td[contains(@class,'action')]/div/i[%d]";
    private static final String VIEW_ICON_ARRIVAL_ARCHIVE_XPATH = "//tr[1]//td[contains(@class,'action')]/div/a[1]";
    private static final String TRIP_ID_IN_TRIP_DETAILS_XPATH = "//div[contains(@class,'row')]/h4";

    private static final String ID_CLASS = "id";
    private static final String ORIGIN_HUB_CLASS = "originHub";
    private static final String DESTINATION_HUB_CLASS = "destinationHub";
    private static final String MOVEMENT_TYPE_CLASS = "movementType";
    private static final String EXPECTED_DEPARTURE_TIME_CLASS = "expectedDepartureTime";
    private static final String ACTUAL_DEPARTURE_TIME_CLASS = "actualDepartureTime";
    private static final String EXPECTED_ARRIVAL_TIME_CLASS = "expectedArrivalTime";
    private static final String ACTUAL_ARRIVAL_TIME_CLASS = "actualArrivalTime";
    private static final String DRIVER_CLASS = "driver";
    private static final String STATUS_CLASS = "status";
    private static final String LAST_STATUS_CLASS = "lastStatus";

    private static final String SUCCESS_CANCEL_TRIP_TOAST = "//div[contains(@class,'notification-notice-message') and (contains(text(),'Movement trip cancelled'))]";
    private static final String FIRST_ROW_TRACK = "//tr[1]//td[contains(@class,'track')]";

    @FindBy(className = "ant-modal-wrap")
    public CancelTripModal cancelTripModal;

    @FindBy(xpath = "//th[div[.='Status']]")
    public StatusFilter tripStatusFilter;

    @FindBy(xpath = "//th[div[.='Last Status']]")
    public StatusFilter lastStatusFilter;

    @FindBy(xpath = "//div[contains(@class,'nv-table')]//table")
    public NvTable<TripEventsRow> tripEventsRowNvTable;

    @FindBy(tagName = "iframe")
    private PageElement pageFrame;

    @FindBy(xpath = "//th[div[.='Movement Type']]")
    public MovementTypeFilter movementTypeFilter;

    @FindBy(xpath = "//th[div[.='Expected Departure Time']]")
    public TripTimeFilter expectedDepartTimeFilter;

    @FindBy(xpath = "//th[div[.='Actual Departure Time']]")
    public TripTimeFilter actualDepartTimeFilter;

    @FindBy(xpath = "//th[div[.='Expected Arrival Time']]")
    public TripTimeFilter expectedArrivalTimeFilter;

    @FindBy(xpath = "//th[div[.='Actual Arrival Time']]")
    public TripTimeFilter actualArrivalTimeFilter;

    @FindBy(xpath = LOAD_BUTTON_XPATH)
    public Button loadButton;

    public TripManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void switchTo() {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
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
        click(f(FILTER_OPTION_XPATH, filterName));
        click(f(TEXT_OPTION_XPATH, filterValue));
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
        assertEquals("Sum of Trip Management", actualTripManagementSum, tripManagementCount);

    }

    public void searchAndVerifiesTripManagementIsExistedById(Long tripManagementId) {

        waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), tripManagementId.toString());
        waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));

        String actualTripManagementId = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
        assertEquals("Trip Management ID", tripManagementId.toString(), actualTripManagementId);


    }

    public void searchAndVerifiesTripManagementIsExistedByDestinationHubName(String destinationHubName) {
        waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS), destinationHubName);
        waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));

        String actualDestinationHubName = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));
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
        click(f(CALENDAR_SELECTED_XPATH, tomorrowDate));

    }

    public void selectsDateArchiveTab(MovementTripType movementTripType, String date) {


        switch (movementTripType) {
            case ARCHIVE_DEPARTURE_DATE:
                click(DEPARTURE_CALENDAR_XPATH);
                break;

            case ARCHIVE_ARRIVAL_DATE:
                click(ARRIVAL_CALENDAR_XPATH);
                break;

            default:
                NvLogger.warn("Tab is not found!");
        }

        while (!isElementExistFast(f(CALENDAR_SELECTED_XPATH, date))) {
            click(PREV_MONTH_BUTTON_XPATH);
        }
        click(f(CALENDAR_SELECTED_XPATH, date));

    }

    public void clickTabBasedOnName(String tabName) {

        click(f(TAB_XPATH, tabName));

    }

    public void verifiesNoResult() {

        isElementExistFast(NO_RESULT_XPATH);

    }

    public void tableFiltering(TripManagementFilteringType tripManagementFilteringType,
                               TripManagementDetailsData tripManagementDetailsData, String driverUsername) {


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
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS));
                sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS), filterValue);
                break;

            case ORIGIN_HUB:
                filterValue = tripManagementDetailsData.getData().get(index).getOriginHubName();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS));
                sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ORIGIN_HUB_CLASS), filterValue);
                break;

            case TRIP_ID:
                filterValue = tripManagementDetailsData.getData().get(index).getId().toString();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ID_CLASS));
                sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), filterValue);
                break;

            case MOVEMENT_TYPE:
                filterValue = movementTypeConverter(tripManagementDetailsData.getData().get(index).getMovementType());
                movementTypeFilter.openButton.click();
                movementTypeFilter.selectType(filterValue.toLowerCase());
                movementTypeFilter.ok.click();
                pause3s();
                break;

            case EXPECTED_DEPARTURE_TIME:
                ZonedDateTime expectedDepartTime = tripManagementDetailsData.getData().get(index).getExpectedDepartureTime();
                expectedDepartTimeFilter.openButton.click();
                expectedDepartTimeFilter.ok.waitUntilClickable();
                expectedDepartTimeFilter.selectDate(expectedDepartTime);
                expectedDepartTimeFilter.selectTime(expectedDepartTime);
                expectedDepartTimeFilter.ok.click();
                break;

            case ACTUAL_DEPARTURE_TIME:
                ZonedDateTime actualDepartureTime = tripManagementDetailsData.getData().get(index).getExpectedArrivalTime();
                actualDepartTimeFilter.openButton.click();
                actualDepartTimeFilter.selectDate(actualDepartureTime);
                actualDepartTimeFilter.selectTime(actualDepartureTime);
                actualDepartTimeFilter.ok.click();
                break;

            case EXPECTED_ARRIVAL_TIME:
                ZonedDateTime expectedArrivalTime = tripManagementDetailsData.getData().get(index).getExpectedArrivalTime();
                expectedArrivalTimeFilter.openButton.click();
                expectedArrivalTimeFilter.selectDate(expectedArrivalTime);
                expectedArrivalTimeFilter.selectTime(expectedArrivalTime);
                expectedArrivalTimeFilter.ok.click();
                break;

            case ACTUAL_ARRIVAL_TIME:
                ZonedDateTime actualArrivalTime = tripManagementDetailsData.getData().get(index).getExpectedArrivalTime();
                actualArrivalTimeFilter.openButton.click();
                actualArrivalTimeFilter.selectDate(actualArrivalTime);
                actualArrivalTimeFilter.selectTime(actualArrivalTime);
                actualArrivalTimeFilter.ok.click();
                break;

            case DRIVER:
                filterValue = driverConverted(driverUsername);
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, DRIVER_CLASS));
                sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, DRIVER_CLASS), filterValue);
                break;

            case STATUS:
                filterValue = tripManagementDetailsData.getData().get(index).getStatus();
                tripStatusFilter.openButton.click();
                tripStatusFilter.selectType(filterValue);
                tripStatusFilter.ok.click();
                break;

            case LAST_STATUS:
                filterValue = tripManagementDetailsData.getData().get(index).getStatus();
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

        tripStatusFilter.openButton.click();
        tripStatusFilter.selectType(filterValue);
        tripStatusFilter.ok.click();

    }

    public void tableFiltering(TripManagementFilteringType tripManagementFilteringType, TripManagementDetailsData tripManagementDetailsData) {
        tableFiltering(tripManagementFilteringType, tripManagementDetailsData, null);
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
                expectedValue = movementTypeConverter(tripManagementDetailsData.getData().get(index).getMovementType());
                actualValue = getText(f(FIRST_ROW_OPTION_FILTERED_RESULT_XPATH, MOVEMENT_TYPE_CLASS));
                assertEquals("Movement Type", expectedValue, actualValue);
                break;

            case EXPECTED_DEPARTURE_TIME:
                expectedValue = expectedValueDateTime(tripManagementDetailsData.getData().get(index).getExpectedDepartureTime());
                actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, EXPECTED_DEPARTURE_TIME_CLASS));
                assertTrue("Expected Departure Time", actualValue.contains(expectedValue));
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
                break;

            case ACTUAL_DEPARTURE_TIME:
                expectedValue = expectedValueDateTime(tripManagementDetailsData.getData().get(index).getActualStartTime());
                actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, ACTUAL_DEPARTURE_TIME_CLASS));
                assertTrue("Actual Departure Time", actualValue.contains(expectedValue));
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
                break;

            case EXPECTED_ARRIVAL_TIME:
                expectedValue = expectedValueDateTime(tripManagementDetailsData.getData().get(index).getExpectedArrivalTime());
                actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, EXPECTED_ARRIVAL_TIME_CLASS));
                assertTrue("Expected Arrival Time", actualValue.contains(expectedValue));
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
                break;

            case ACTUAL_ARRIVAL_TIME:
                expectedValue = expectedValueDateTime(tripManagementDetailsData.getData().get(index).getActualEndTime());
                actualValue = getText(f(FIRST_ROW_TIME_FILTERED_RESULT_XPATH, ACTUAL_ARRIVAL_TIME_CLASS));
                assertTrue("Actual Departure Time", actualValue.contains(expectedValue));
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
                break;

            case DRIVER:
                expectedValue = driverConverted(driverUsername);
                actualValue = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DRIVER_CLASS));
                assertEquals("Driver", expectedValue, actualValue);
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

    public void verifyResult(TripManagementFilteringType tripManagementFilteringType, TripManagementDetailsData tripManagementDetailsData) {
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

    public void verifiesTripDetailIsOpened(String tripId, String windowHandle) {
        switchToNewWindow();

        this.switchTo();
        waitUntilVisibilityOfElementLocated(TRIP_ID_IN_TRIP_DETAILS_XPATH);
        String actualTripId = getText(TRIP_ID_IN_TRIP_DETAILS_XPATH);
        assertTrue("Trip ID", actualTripId.contains(tripId));

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

    public void verifiesSuccessCancelTripToastShown() {

        waitUntilVisibilityOfElementLocated(SUCCESS_CANCEL_TRIP_TOAST);
        click(SUCCESS_CANCEL_TRIP_TOAST);

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

            case "COMPLETED":
                statusConverted = "Completed";
                break;

            case "CANCELLED":
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

        @FindBy(xpath = ".//button")
        public Button openButton;

        @FindBy(xpath = ".//button[.='OK']")
        public Button ok;

        @FindBy(xpath = ".//button[.='Reset']")
        public Button reset;
    }

    public static class TripTimeFilter extends TableFilterPopup {

        public TripTimeFilter(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li)[1]")
        public TextBox firstDateText;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li//input)[1]")
        public CheckBox firstDate;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li)[2]")
        public TextBox secondDateText;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li//input)[2]")
        public CheckBox secondDate;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li)[3]")
        public TextBox thirdDateText;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li//input)[3]")
        public CheckBox thirdDate;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li)[4]")
        public TextBox fourthDateText;

        @FindBy(xpath = "(.//div[p[.='Date']]//ul//li//input)[4]")
        public CheckBox fourthDate;

        @FindBy(xpath = ".//li[.='-']//input")
        public CheckBox none;

        @FindBy(xpath = ".//li[.='00:00 - 06:00']//input")
        public CheckBox earlyMorning;

        @FindBy(xpath = ".//li[.='06:00 - 12:00']//input")
        public CheckBox morning;

        @FindBy(xpath = ".//li[.='12:00 - 18:00']//input")
        public CheckBox afterNoon;

        @FindBy(xpath = ".//li[.='18:00 - 00:00']//input")
        public CheckBox night;

        public void selectDate(ZonedDateTime dateTime) {
            DateTimeFormatter DD_MMMM_FORMAT = DateTimeFormatter.ofPattern("dd MMMM");
            String stringDate = dateTime.format(DD_MMMM_FORMAT);
            firstDateText.waitUntilVisible();
            if (firstDateText.getText().contains(stringDate)) {
                firstDate.check();
                return;
            }
            if (secondDateText.getText().contains(stringDate)) {
                secondDate.check();
                return;
            }
            if (thirdDateText.getText().contains(stringDate)) {
                thirdDate.check();
                return;
            }
            if (fourthDateText.getText().contains(stringDate)) {
                fourthDate.check();
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

    public static class MovementTypeFilter extends TableFilterPopup {

        public MovementTypeFilter(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//li[.='Air Haul']//input")
        public CheckBox airHaul;

        @FindBy(xpath = ".//li[.='Land Haul']//input")
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

        @FindBy(xpath = ".//li[.='Pending']//input")
        public CheckBox pending;

        @FindBy(xpath = ".//li[.='In Transit']//input")
        public CheckBox inTransit;

        @FindBy(xpath = ".//li[.='Completed']//input")
        public CheckBox completed;

        @FindBy(xpath = ".//li[.='Cancelled']//input")
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
}
