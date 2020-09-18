package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.model.core.hub.trip_management.TripManagementDetailsData;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.MovementTripActionName;
import co.nvqa.operator_v2.model.TripManagementFilteringType;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 *
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

    @FindBy(className = "ant-modal-wrap")
    public CancelTripModal cancelTripModal;

    @FindBy(xpath = "//th[div[.='Status']]")
    public StatusFilter tripStatusFilter;

    public TripManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void verifiesTripManagementIsLoaded() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        isElementExist(TRIP_MANAGEMENT_CONTAINER_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void clickLoadButton() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        click(LOAD_BUTTON_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesFieldReqiredErrorMessageShown() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        isElementExist(FIELD_REQUIRED_ERROR_MESSAGE_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void selectValueFromFilterDropDown(String filterName, String filterValue) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        click(f(FILTER_OPTION_XPATH, filterName));
        waitUntilVisibilityOfElementLocated(f(TEXT_OPTION_XPATH, filterValue));
        click(f(TEXT_OPTION_XPATH, filterValue));
        getWebDriver().switchTo().parentFrame();
    }

    public void selectValueFromFilterDropDownDirectly(String filterName, String filterValue) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        click(f(FILTER_OPTION_XPATH, filterName));
        click(f(TEXT_OPTION_XPATH, filterValue));
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesSumOfTripManagement(MovementTripType tabName, Long tripManagementCount) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
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
        getWebDriver().switchTo().parentFrame();
    }

    public void searchAndVerifiesTripManagementIsExistedById(Long tripManagementId) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), tripManagementId.toString());
        waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));

        String actualTripManagementId = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, ID_CLASS));
        assertEquals("Trip Management ID", tripManagementId.toString(), actualTripManagementId);

        getWebDriver().switchTo().parentFrame();
    }

    public void searchAndVerifiesTripManagementIsExistedByDestinationHubName(String destinationHubName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, DESTINATION_HUB_CLASS), destinationHubName);
        waitUntilVisibilityOfElementLocated(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));

        String actualDestinationHubName = getText(f(FIRST_ROW_INPUT_FILTERED_RESULT_XPATH, DESTINATION_HUB_CLASS));
        assertEquals("Destination Hub Name", destinationHubName, actualDestinationHubName);

        getWebDriver().switchTo().parentFrame();
    }

    public void selectsDate(MovementTripType movementTripType, String tomorrowDate) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));

        switch (movementTripType) {
            case DEPARTURE :
                click(DEPARTURE_CALENDAR_XPATH);
                break;

            case ARRIVAL :
                click(ARRIVAL_CALENDAR_XPATH);
                break;

            default :
                NvLogger.warn("Tab is not found!");
        }

        while (!isElementExistFast(f(CALENDAR_SELECTED_XPATH, tomorrowDate))) {
            click(NEXT_MONTH_BUTTON_XPATH);
        }
        click(f(CALENDAR_SELECTED_XPATH, tomorrowDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void selectsDateArchiveTab(MovementTripType movementTripType, String date) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));

        switch (movementTripType) {
            case ARCHIVE_DEPARTURE_DATE :
                click(DEPARTURE_CALENDAR_XPATH);
                break;

            case ARCHIVE_ARRIVAL_DATE :
                click(ARRIVAL_CALENDAR_XPATH);
                break;

            default :
                NvLogger.warn("Tab is not found!");
        }

        while (!isElementExistFast(f(CALENDAR_SELECTED_XPATH, date))) {
            click(PREV_MONTH_BUTTON_XPATH);
        }
        click(f(CALENDAR_SELECTED_XPATH, date));
        getWebDriver().switchTo().parentFrame();
    }

    public void clickTabBasedOnName(String tabName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        click(f(TAB_XPATH, tabName));
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesNoResult() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        isElementExistFast(NO_RESULT_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void tableFiltering(TripManagementFilteringType tripManagementFilteringType,
                               TripManagementDetailsData tripManagementDetailsData, String driverUsername) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));

        // Get the newest record
        int index = tripManagementDetailsData.getData().size() - 1;

        if (tripManagementDetailsData.getCount() == null || tripManagementDetailsData.getCount() == 0) {
            verifiesNoResult();
            getWebDriver().switchTo().parentFrame();
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
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, MOVEMENT_TYPE_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, MOVEMENT_TYPE_CLASS));
                waitUntilVisibilityOfElementLocated(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, filterValue));
                click(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, filterValue));
                click(OK_BUTTON_OPTION_TABLE_XPATH);
                pause3s();
                break;

            case EXPECTED_DEPARTURE_TIME:
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, EXPECTED_DEPARTURE_TIME_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, EXPECTED_DEPARTURE_TIME_CLASS));
                selectDateTime(tripManagementDetailsData.getData().get(index).getExpectedDepartureTime());
                break;

            case ACTUAL_DEPARTURE_TIME:
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ACTUAL_DEPARTURE_TIME_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, ACTUAL_DEPARTURE_TIME_CLASS));
                selectDateTime(tripManagementDetailsData.getData().get(index).getActualStartTime());
                break;

            case EXPECTED_ARRIVAL_TIME:
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, EXPECTED_ARRIVAL_TIME_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, EXPECTED_ARRIVAL_TIME_CLASS));
                selectDateTime(tripManagementDetailsData.getData().get(index).getExpectedArrivalTime());
                break;

            case ACTUAL_ARRIVAL_TIME:
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, ACTUAL_ARRIVAL_TIME_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, ACTUAL_ARRIVAL_TIME_CLASS));
                selectDateTime(tripManagementDetailsData.getData().get(index).getActualEndTime());
                break;

            case DRIVER:
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
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
                ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='50%'");
                pause3s();
                filterValue = statusConverted(tripManagementDetailsData.getData().get(index).getStatus());
                waitUntilVisibilityOfElementLocated(f(TABLE_HEADER_FILTER_INPUT_XPATH, LAST_STATUS_CLASS));
                click(f(BUTTON_TABLE_HEADER_FILTER_INPUT_XPATH, LAST_STATUS_CLASS));
                waitUntilVisibilityOfElementLocated(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, filterValue));
                click(f(CHECKBOX_OPTION_HEADER_FILTER_INPUT_XPATH, filterValue));
                click(OK_BUTTON_OPTION_TABLE_XPATH);
                pause3s();
                break;

            default:
                NvLogger.warn("Filtering type is not found");
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void tableFiltering(TripManagementFilteringType tripManagementFilteringType, TripManagementDetailsData tripManagementDetailsData) {
        tableFiltering(tripManagementFilteringType, tripManagementDetailsData, null);
    }

    public void verifyResult(TripManagementFilteringType tripManagementFilteringType,
                             TripManagementDetailsData tripManagementDetailsData, String driverUsername) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
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

        getWebDriver().switchTo().parentFrame();
    }

    public void verifyResult(TripManagementFilteringType tripManagementFilteringType, TripManagementDetailsData tripManagementDetailsData) {
        verifyResult(tripManagementFilteringType, tripManagementDetailsData, null);
    }

    public String getTripIdAndClickOnActionIcon(MovementTripActionName actionName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        String tripId = null;
        if (isElementExistFast(ACTION_COLUMN_XPATH)) {
            tripId = getText(TRIP_ID_FIRST_ROW_XPATH);

            switch (actionName) {
                case VIEW:
                    if (isElementExistFast(f(ACTION_ICON_XPATH,1))) {
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
        getWebDriver().switchTo().parentFrame();
        return tripId;
    }

    public void verifiesTripDetailIsOpened(String tripId, String windowHandle) {
        switchToNewWindow();
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));

        waitUntilVisibilityOfElementLocated(TRIP_ID_IN_TRIP_DETAILS_XPATH);
        String actualTripId = getText(TRIP_ID_IN_TRIP_DETAILS_XPATH);
        assertTrue("Trip ID", actualTripId.contains(tripId));

        getWebDriver().close();
        getWebDriver().switchTo().window(windowHandle);

        getWebDriver().switchTo().parentFrame();
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
            case "PENDING" :
                statusConverted = "Pending";
                break;

            case "IN_TRANSIT" :
                statusConverted = "In Transit";
                break;

            case "COMPLETED" :
                statusConverted = "Completed";
                break;

            case "CANCELLED" :
                statusConverted = "Cancelled";
                break;

            default :
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

    public void clickButtonOnCancelDialog(String buttonValue) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        cancelTripModal.waitUntilVisible();
        switch (buttonValue){
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

    public static class TableFilterPopup extends PageElement
    {
        public TableFilterPopup(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//button")
        public Button openButton;

        @FindBy(xpath = ".//button[.='OK']")
        public Button ok;

        @FindBy(xpath = ".//button[.='Reset']")
        public Button reset;
    }

    public static class StatusFilter extends TableFilterPopup
    {
        public StatusFilter(WebDriver webDriver, WebElement webElement)
        {
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

        public void selectType(String type)
        {
            switch (type.toLowerCase())
            {
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
    public static class CancelTripModal extends AntModal
    {
        public CancelTripModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = "//button[.='Cancel Trip']")
        public Button cancelTrip;

        @FindBy(xpath = "//button[.='No']")
        public Button no;
    }
}
