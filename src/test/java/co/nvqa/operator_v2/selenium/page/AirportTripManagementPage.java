package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.commons.model.sort.hub.Airport;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.ACTION_ASSIGN_DRIVER;
import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.ACTION_DISABLED_BUTTON;
import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.COLUMN_AIRTRIP_ID;

/**
 * @author Meganathan Ramasamy
 */

public class AirportTripManagementPage extends OperatorV2SimplePage{
    private static final Logger LOGGER = LoggerFactory.getLogger(AirportTripManagementPage.class);

    public AirportTripManagementPage(WebDriver webDriver) {
        super(webDriver);
        airportTable = new AirportTripManagementPage.AirportTable(webDriver);
        assignMawbModal = new AssignMawbModal(webDriver);
    }

    private static final String LOAD_BUTTON_XPATH = "//button[contains(@class,'ant-btn-primary')]";
//    private static final String XPATH_CAL_DEPARTUREDATE = "//div[@class='ant-picker-panels']//td[@title='%s']";
    private static final String XPATH_CAL_DEPARTUREDATE_TD_DISABLE = "//table[@class='ant-picker-content']//td[@title='%s' and contains(@class,'ant-picker-cell-disabled')]";
    private static final String XPATH_FACILITIES_INPUT = "//input[@id='facilities']";
    private static final String XPATH_DIV_STARTSWITH_TEMPLATE = "//div[starts-with(.,'%s')]";
    private static final String XPATH_DEPARTURE_DATE_TEXT = "//div[contains(text(), ' - ')][./div[.='Departure Date']]";
    private static final String XPATH_FACILITIES_TEXT = "//span[contains(.,'Destination Facilities')]/parent::div/parent::div";
    private static final String FILTERS_DISABLED_XPATH = "//div[contains(@class,'ant-select-item-option-disabled')]";
    private static final String XPATH_END_OF_TABLE = "//div[contains(text(),'End of Table') or contains(text(),'No Results Found')]";
    private static final String XPATH_TABLE_NOT_CONTAINS_TD = "//div[contains(@class,'table-container')]//table/tbody//tr/td[%s][not(contains(.,'%s'))]";
    private static final String XPATH_TABLE_FIRST_ROW ="//div[contains(@class,'table-container')]//table/tbody//tr[%s]/td[%s]";
    private static final String XPATH_MANAGE_AIRPORT_FACILITY_LOADING ="//div[@class='ant-spin-container ant-spin-blur']";
    private static final String XPATH_AIRPORT_FACILITY_COUNTRY_TEXT ="//h4[contains(.,'Airport Facility in')]";
    private static final String XPATH_TOTAL_LIST_OF_AIRPORTS ="//h4[contains(.,'Total: ')]";
    private static final String XPATH_LOADED_LIST_OF_AIRPORTS ="//span[contains(.,'Showing %s of %s results')]";
    private static final String XPATH_DIV_TITLE = "//div[@title='%s']";
    private static final String antpickerdropdownhidden = "//div[contains(@class,'ant-picker-dropdown') and not(contains(@class,'ant-picker-dropdown-hidden'))]";

    private static final String AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH = "//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]//div[text()='%s']";
    private static final String AIRPORT_TRIP_PAGE_ERRORS_XPATH = "//input[@id='%s']/ancestor::div[@class='ant-form-item-control-input']//following-sibling::div/div[@class='ant-form-item-explain-error']";
    private static final String AIRPORT_TRIP_CLEAR_BUTTON_XPATH = "//input[@id='%s']/ancestor::div[@class='ant-select-selector']/following-sibling::span[@class ='ant-select-clear']";
    private static final String AIRPORT_TRIP_PAGE_ASSIGN_DRIVER_XPATH = "//input[@id='assignDriversForm_driverNames_%d']";
    private static final String AIRPORT_TRIP_DETAIL_PAGE_TRIP_ID_XPATH = "//h4[@class='ant-typography' and normalize-space()]";
    private static final String AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH = "//div[text()='%s' and @role='tab']";
    private static final String AIRPORT_TRIP_DETAIL_PAGE_TAB_TABLE_BODY_XPATH = "//div[contains(@id,'%s')]//div[contains(@class,'ant-table-body')]";
    private static final String AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH = "//div[@class='ant-spin-container']//span[@data-testid='column-title-%s']";
    private static final String AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH = "//span[text()='%s']/ancestor::div[@class='ant-col']";
    private static final String AIRPORT_TRIP_DETAILS_PAGE_STATUS_XPATH = "//ancestor::div[@class='ant-col' and contains(.,'%s')]";

    private static final String TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_DRIVER_XPATH = "//div[@class='ant-card-body']//div[text()='Driver']//ancestor::div[@class='ant-spin-container']";
    private static final String TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_COMMENTS_XPATH = "//div[@class='ant-card-body']//span[text()='Comments']//ancestor::div[@class='ant-space-item']";
    private static final String TO_FROM_AIRPORT_TRIP_ASSIGN_DRIVER_PAGE_MESSAGE_XPATH = "//div[@class='ant-space-item']//div[@class='ant-row']//div[contains(text(),'Assign')]";
    private static final String TO_FROM_AIRPORT_TRIP_ON_ASSIGN_DRIVER_POPUP_XPATH = "//div[@class='ant-modal-content']//span[text()='%s']/ancestor::div[contains(@class,'ant-col')]";

    private static final String CREATE_FLIGHT_TRIP_SELECTED_TEXT_XPATH = "//input[@id='%s']/parent::span/following-sibling::span[@class='ant-select-selection-item']";
    private static final String createFlightTrip_originAirportId = "editForm_originAirport";
    private static final String createFlightTrip_destinationAirportId = "editForm_destinationAirport";
    private static final String createFlightTrip_departureTimeId = "editForm_departureTime";
    private static final String createFlightTrip_durationHoursId = "editForm_duration-hours";
    private static final String createFlightTrip_durationMinutesId = "editForm_duration-minutes";
    private static final String createFlightTrip_departureDateId = "editForm_departureDate";
    private static final String createFlightTrip_originProcessingTimeHoursId = "editForm_originProcessingTime-hours";
    private static final String createFlightTrip_originProcessingTimeMinutesId = "editForm_originProcessingTime-minutes";
    private static final String createFlightTrip_destinationProcessingTimeHoursId = "editForm_destinationProcessingTime-hours";
    private static final String createFlightTrip_destinationProcessingTimeMinutesId = "editForm_destinationProcessingTime-minutes";
    private static final String createFlightTrip_flightNoId = "editForm_flightNo";
    private static final String createFlightTrip_mawbId = "editForm_mawb";
    private static final String createFlightTrip_commentId = "editForm_comment";
    public String departureTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//div[@class='ant-picker-content']//ul[%s]//div[text()= '%s']";
    private static final String TOAST_ERROR_MESSAGES_XPATH = "//div[contains(@class,'ant-notification-notice ant-notification-notice-error')]//span[normalize-space(.)]";

    @FindBy(xpath = "//input[@id='departure']")
    public PageElement departureInput;

    @FindBy(xpath = "//span[.='Select one or multiple facilities']")
    public PageElement selectFacility;

    @FindBy(xpath = "//button[.='Load Trips']")
    public Button loadTrips;

    @FindBy(xpath = "//button[.='Reload Search']")
    public Button reloadSearch;

    @FindBy(xpath = "//a[.='Create To/from Airport Trip']")
    public PageElement createToFromAirportTrip;

    @FindBy(xpath = "//a[.='Create Flight Trip']")
    public PageElement createFlightTrip;

    @FindBy(xpath = "//input[@id='facilities']")
    public PageElement facilitiesInput;

    @FindBy(xpath = "//th[contains(@class,'destination_hub_id')]//input")
    public PageElement airportDestHubFilter;

    @FindBy(xpath = "//th[contains(@class,'trip_id')]//input")
    public PageElement airportTripIdFilter;

    @FindBy(xpath = "//th[contains(@class,'origin_hub_id')]//input")
    public PageElement airportOriginHubFilter;

    @FindBy(xpath = "//th[contains(@class,'departure_date_time')]//input")
    public PageElement airportDepartDateTimeFilter;

    @FindBy(xpath = "//th[contains(@class,'duration')]//input")
    public PageElement airportDurationFilter;

    @FindBy(xpath = "//th[contains(@class,'flight_no')]//input")
    public PageElement airportFlightFilter;

    @FindBy(xpath = "//th[contains(@class,'drivers')]//input")
    public PageElement airportDriversFilter;

    @FindBy(xpath = "//th[contains(@class,'status')]//input")
    public PageElement airportStatusFilter;

    @FindBy(xpath = "//th[contains(@class,'comment')]//input")
    public PageElement airportCommentsFilter;

    @FindBy(xpath = "//button[.='Manage Airport Facility']")
    public Button manageAirportFacility;

    @FindBy(xpath = "//button[.='New Airport']")
    public Button addNewAirport;

    @FindBy(xpath = "//a[.='Looking for warehouse facility?']")
    public PageElement lookingForWarehouseFacility;

    @FindBy(xpath = "//input[@aria-label='input-id']")
    public PageElement airportIdFilter;

    @FindBy(xpath = "//input[@aria-label='input-airport_code']")
    public PageElement airportCodeFilter;

    @FindBy(xpath = "//input[@aria-label='input-airport_name']")
    public PageElement airportNameFilter;

    @FindBy(xpath = "//input[@aria-label='input-city']")
    public PageElement airportCityFilter;

    @FindBy(xpath = "//input[@aria-label='input-region']")
    public PageElement airportRegionFilter;

    @FindBy(xpath = "//input[@aria-label='input-_latitudeLongitude']")
    public PageElement airportLatitudeLongitudeFilter;

    @FindBy(xpath = "//button[contains(@data-testid,'edit-airport-button')]")
    public PageElement editAirportButton;

    @FindBy(xpath = "//button[contains(@data-testid,'activate-airport-button')]")
    public PageElement activateAirportButton;

    @FindBy(xpath = "//button[contains(@data-testid,'disable-airport-button')]")
    public PageElement disableAirportButton;

    @FindBy(xpath = "//div[@class='ant-modal-header']/div[text()='Add New Airport']")
    public PageElement addNewAirportPanel;

    @FindBy(xpath = "//div[@class='ant-modal-header']/div[text()='Edit Airport']")
    public PageElement editAirportPanel;

    @FindBy(xpath = "//div[@class='ant-modal-header']/div[text()='Disable Airport?']")
    public PageElement disableAirportPanel;

    @FindBy(xpath = "//div[@class='ant-modal-header']/div[text()='Confirm activation']")
    public PageElement activateAirportPanel;

    @FindBy(xpath = "//div[@class='ant-modal-content']//button[.='Disable']")
    public PageElement disableButton;

    @FindBy(xpath = "//div[@class='ant-modal-content']//button[.='Cancel']")
    public PageElement cancelButton;

    @FindBy(xpath = "//div[@class='ant-modal-content']//button[.='Activate']")
    public PageElement activateButton;

    @FindBy(xpath = "//input[@data-testid='airport-code-input']")
    public PageElement airportCodeInput;

    @FindBy(xpath = "//input[@data-testid='airport-name-input']")
    public PageElement airportNameInput;

    @FindBy(xpath = "//input[@data-testid='city-input']")
    public PageElement airportCityInput;

    @FindBy(xpath = "//input[@id='createAirportForm_region']")
    public PageElement airportRegionInput;

    @FindBy(xpath = "//input[@data-testid='latitude-input']")
    public PageElement airportLatitudeInput;

    @FindBy(xpath = "//input[@data-testid='longitude-input']")
    public PageElement airportLongitudeInput;

    @FindBy(xpath = "//button[@data-testid='confirm-createAirport-button']")
    public PageElement newAirportSubmit;

    @FindBy(xpath = "//button[@data-testid='confirm-editAirport-button']")
    public PageElement editAirportSubmit;

    @FindBy(xpath = "//button[@data-testid='confirm-editAirport-button' or @data-testid='confirm-createAirport-button']")
    public PageElement createOrEditAirportSubmit;

    @FindBy(xpath = "//div[.='No data']")
    public PageElement noDataElement;

    @FindBy(xpath = "//div[.='No Results Found']")
    public PageElement noResultsFound;

    @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
    public PageElement antNotificationMessage;

    @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
    public PageElement antNotificationDescription;

    @FindBy(xpath = "//div[@class='ant-modal-body']")
    public PageElement antModalBody;

    @FindBy(xpath = "//div[@role='alert']")
    public PageElement validationAlert;

    @FindBy(xpath = "//button//strong[.='Back']")
    public PageElement backButton;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_originFacility']")
    public PageElement createToFromAirportForm_originFacility;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_destinationFacility']")
    public PageElement createToFromAirportForm_destinationFacility;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_departureTime']")
    public PageElement createToFromAirportForm_departureTime;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_duration-hours']")
    public PageElement createToFromAirportForm_durationHours;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_duration-minutes']")
    public PageElement createToFromAirportForm_duration_minutes;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_departureDate']")
    public PageElement createToFromAirportForm_departureDate;

    @FindBy(xpath = "//div[@data-testid='assign-drivers-select']")
    public PageElement createToFromAirportForm_drivers;

    @FindBy(xpath = "//textarea[@id='createToFromAirportForm_comment']")
    public PageElement createToFromAirportForm_comment;

    @FindBy(xpath = "//button[@data-testid='submit-button']")
    public PageElement submitButton;

    @FindBy(xpath = "//input[@placeholder='End date']")
    public TextBox Departure_EndDate;

    @FindBy(xpath = "//input[@placeholder='Start date']")
    public TextBox Departure_StartDate;

    @FindBy(id =createFlightTrip_originAirportId)
    public PageElement createFlightTrip_originAirport;

    @FindBy(id =createFlightTrip_destinationAirportId)
    public PageElement createFlightTrip_destinationAirport;

    @FindBy(id =createFlightTrip_departureTimeId)
    public PageElement createFlightTrip_departureTime;

    @FindBy(id =createFlightTrip_durationHoursId)
    public PageElement createFlightTrip_durationHours;

    @FindBy(id =createFlightTrip_durationMinutesId)
    public PageElement createFlightTrip_durationMinutes;

    @FindBy(id =createFlightTrip_departureDateId)
    public PageElement createFlightTrip_departureDate;

    @FindBy(id =createFlightTrip_originProcessingTimeHoursId)
    public PageElement createFlightTrip_originProcessingTimeHours;

    @FindBy(id =createFlightTrip_originProcessingTimeMinutesId)
    public PageElement createFlightTrip_originProcessingTimeMinutes;

    @FindBy(id =createFlightTrip_destinationProcessingTimeHoursId)
    public PageElement createFlightTrip_destinationProcessingTimeHours;

    @FindBy(id =createFlightTrip_destinationProcessingTimeMinutesId)
    public PageElement createFlightTrip_destinationProcessingTimeMinutes;

    @FindBy(id =createFlightTrip_flightNoId)
    public PageElement createFlightTrip_flightNo;

    @FindBy(id =createFlightTrip_mawbId)
    public PageElement createFlightTrip_mawb;

    @FindBy(id =createFlightTrip_commentId)
    public PageElement createFlightTrip_comment;

    @FindBy(css = "[data-testid$='confirm-button']")
    public Button confirmButton;

    public static String notificationMessage = "";

    public AirportTable airportTable;
    public AssignMawbModal assignMawbModal;

    @FindBy(className = "ant-modal-wrap")
    public TripDepartureArrivalModal tripDepartureArrivalModal;

    @FindBy(className = "ant-modal-wrap")
    public AssignDriversToTripModal assignDriversToTripModal;

    @FindBy(xpath = "//span[@data-testid='assign-driver-icon']")
    public Button assignDriverOnAirportTripDetails;

    @FindBy(xpath = "//a[@class='ant-typography']")
    public static Button viewDetailsActionLink;

    @FindBy(css = ".ant-spin-dot")
    public PageElement spinner;
    
    public void verifyAirportTripMovementPageItems() {
        waitUntilVisibilityOfElementLocated("//button[.='Load Trips']");
        Assertions.assertThat(isElementVisible(LOAD_BUTTON_XPATH, 5))
            .as("Load button appear in Airport trip Management page").isTrue();
        Assertions.assertThat(departureInput.isDisplayed())
            .as("Departure input appear in Airport trip Management page").isTrue();
        Assertions.assertThat(isElementEnabled("//button[.='Load Trips']"))
            .as("Load Trips appear in Airport trip Management page").isFalse();
        Assertions.assertThat(isElementVisible("//button[.='Manage Airport Facility']", 5))
                .as("Manage Port Facility button appear in Airport Trip Management page").isTrue();
        Assertions.assertThat(selectFacility.isDisplayed())
                .as("Facilities input appear in Airport trip Management page").isTrue();
    }

    public void fillDepartureDateDetails(Map<String, String> mapOfData) {

        String startDate = mapOfData.get("startDate");
        String endDate = mapOfData.get("endDate");

        Departure_StartDate.click();
        Departure_StartDate.sendKeys(startDate);
        Departure_EndDate.click();
        Departure_EndDate.sendKeys(endDate);
        Departure_EndDate.sendKeys(Keys.ENTER);
    }

    public void fillOrigDestDetails(Map<String, String> mapOfData) {
        if(mapOfData.containsKey("originOrDestination")){
            String[] values = mapOfData.get("originOrDestination").split(";");
            facilitiesInput.click();
            for(String value : values){
                sendKeysAndEnter(XPATH_FACILITIES_INPUT, value);
                click(f(XPATH_DIV_STARTSWITH_TEMPLATE, value));
            }
        }
    }

    public void verifyMaxOrigDestDetails() {
        facilitiesInput.click();
        Assertions.assertThat(
                        findElementsByXpath(FILTERS_DISABLED_XPATH).size())
                .as("Other filters options are DISABLED")
                .isNotZero();
    }

    public void clickOnLoadTripsAirportManagementDetails() {
        loadTrips.click();
        waitUntilPageLoaded();
        pause2s();
        backButton.waitUntilVisible();
    }

    public void verifyLoadedTripsPageInAirportManagementDetails(Map<String, String> mapOfData) {
        backButton.waitUntilVisible();
        Assertions.assertThat(reloadSearch.isDisplayed())
                .as("Reload appear in Airport trip Management page").isTrue();

        String departureDate = findElementByXpath(XPATH_DEPARTURE_DATE_TEXT).getText();
        Format dateFormat = new SimpleDateFormat("dd MMMM yyyy");
        String expDepartDate;
        try {
            expDepartDate = dateFormat.format(new SimpleDateFormat("yyyy-MM-dd").parse(
                mapOfData.get("startDate"))) + " - " +
                dateFormat.format(new SimpleDateFormat("yyyy-MM-dd").parse(
                    mapOfData.get("endDate")));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        Assertions.assertThat(departureDate.split("\n")[1])
                .as("Departure Date value appear in Airport trip Management page")
                .isEqualTo(expDepartDate);

        String actOriginOrDestination = findElementByXpath(XPATH_FACILITIES_TEXT).getText();
        Assertions.assertThat(actOriginOrDestination.split("\n")[1])
                .as("Origin / Destination Facilities value appear in Airport trip Management page")
                .isEqualTo(mapOfData.get("originOrDestination"));

        Assertions.assertThat(reloadSearch.isEnabled())
                .as("Reload Search button appear in Airport trip Management page").isTrue();
        Assertions.assertThat(createToFromAirportTrip.isDisplayed())
                .as("Create To/from Airport Trip button appear in Airport trip Management page").isTrue();
        Assertions.assertThat(createFlightTrip.isDisplayed())
                .as("Create Flight Trip button appear in Airport trip Management page").isTrue();

        verifyAirportTripsTable();

    }

    public void verifyAirportTripsTable(){
        Assertions.assertThat(airportDestHubFilter.isDisplayed())
                .as("Destination Hub Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportTripIdFilter.isDisplayed())
                .as("Trip Id Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportOriginHubFilter.isDisplayed())
                .as("Origin Hub Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportDepartDateTimeFilter.isDisplayed())
                .as("Departure Date Time Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportDurationFilter.isDisplayed())
                .as("Duration Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportFlightFilter.isDisplayed())
                .as("Flight Number Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportDriversFilter.isDisplayed())
                .as("Drivers Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportStatusFilter.isDisplayed())
                .as("Status Filter appear in Airport trip Management page").isTrue();
        Assertions.assertThat(airportCommentsFilter.isDisplayed())
                .as("Comments Filter appear in Airport trip Management page").isTrue();

        scrollToEndOfAirportTripsTable();

        Assertions.assertThat(findElementByXpath(XPATH_END_OF_TABLE).isDisplayed())
                .as("End Of Table appear in Airport trip Management page").isTrue();
    }

    public void switchToOtherWindow() {
        waitUntilNewWindowOrTabOpened();
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        for (String windowHandle : windowHandles) {
            getWebDriver().switchTo().window(windowHandle);
        }
    }

    public HashMap filterTheAirportTripsTable(String filter, String invalidData) {
        HashMap<String, String> map = new HashMap<>();
        String searchData;
        map.put("COLUMN", filter);
        switch (filter) {
            case "Destination Facility":
                map.put("COLUMN_NO", "1");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 1)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportDestHubFilter.click();
                sendKeys(airportDestHubFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Trip ID":
                map.put("COLUMN_NO", "2");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 2)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportTripIdFilter.click();
                sendKeys(airportTripIdFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Origin Facility":
                map.put("COLUMN_NO", "3");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 3)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportOriginHubFilter.click();
                sendKeys(airportOriginHubFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Departure Date Time":
                map.put("COLUMN_NO", "4");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 4)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportDepartDateTimeFilter.click();
                sendKeys(airportDepartDateTimeFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Duration":
                map.put("COLUMN_NO", "5");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 5)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                sendKeys(airportDurationFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Flight Number":
                map.put("COLUMN_NO", "6");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 6)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportFlightFilter.click();
                sendKeys(airportFlightFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Driver":
                map.put("COLUMN_NO", "7");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 7)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportDriversFilter.click();
                sendKeys(airportDriversFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Status":
                map.put("COLUMN_NO", "8");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 8)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportStatusFilter.click();
                sendKeys(airportStatusFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            case "Comments":
                map.put("COLUMN_NO", "9");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 9)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportCommentsFilter.click();
                sendKeys(airportCommentsFilter.getWebElement(), map.get("FIRST_DATA"));
                break;
            default:
                LOGGER.warn("Search type is not found");
        }
        return map;
    }

    public void verifyFilteredResultsInAirportTripsTable(HashMap<String, String> map) {
        scrollToEndOfAirportTripsTable();
        Assertions.assertThat(
                findElementsByXpath(f(XPATH_TABLE_NOT_CONTAINS_TD, map.get("COLUMN_NO"), map.get("FIRST_DATA"))).size())
                .as(f("All the records with %s as '%s' are displayed.", map.get("COLUMN"), map.get("FIRST_DATA")))
                .isZero();
    }

    private void scrollToEndOfAirportTripsTable(){
        if(findElementsByXpath(XPATH_END_OF_TABLE).size()==0){
            do {
                WebElement element = getWebDriver().findElement(By.xpath("//div[contains(@class,'table-container')]//table/tbody//tr[last()]"));
                TestUtils.callJavaScriptExecutor("arguments[0].scrollIntoView();", element, getWebDriver());
            }while (findElementsByXpath(XPATH_END_OF_TABLE).size()==0);
        }
    }

    public void operatorOpenManageAirportFacility(){
        manageAirportFacility.click();
        waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated(XPATH_MANAGE_AIRPORT_FACILITY_LOADING);
        Assertions.assertThat(findElementByXpath(XPATH_AIRPORT_FACILITY_COUNTRY_TEXT).isDisplayed())
                .as("Airport Facility in text is displayed").isTrue();
        Assertions.assertThat(addNewAirport.isDisplayed()).as("Add new Airport is displayed").isTrue();
        Assertions.assertThat(findElementByXpath(XPATH_TOTAL_LIST_OF_AIRPORTS).isDisplayed())
                .as("Total Airports list is displayed").isTrue();
        String total = findElementByXpath(XPATH_TOTAL_LIST_OF_AIRPORTS).getText().replace("Total: ", "");
        Assertions.assertThat(findElementByXpath(f(XPATH_LOADED_LIST_OF_AIRPORTS, total, total)).isDisplayed())
                .as("Showing n of n results is displayed").isTrue();
        Assertions.assertThat(lookingForWarehouseFacility.isDisplayed()).as("Looking for warehouse facility? is displayed").isTrue();

        Color actualColor = Color.fromString(lookingForWarehouseFacility.getCssValue("color"));
        Assertions.assertThat(actualColor.asHex()).as("Color of Looking for warehouse facility? is blue").isEqualTo("#1890ff");

        verifyAirportFacilitiesTable();
    }

    public void verifyAirportFacilitiesTable(){
        Assertions.assertThat(airportIdFilter.isDisplayed())
                .as("Airport Id Filter appear in Airport list table").isTrue();
        Assertions.assertThat(airportCodeFilter.isDisplayed())
                .as("Airport Code Filter appear in Airport list table").isTrue();
        Assertions.assertThat(airportNameFilter.isDisplayed())
                .as("Airport Name Filter appear in Airport list table").isTrue();
        Assertions.assertThat(airportCityFilter.isDisplayed())
                .as("Airport City Filter appear in Airport list table").isTrue();
        Assertions.assertThat(airportRegionFilter.isDisplayed())
                .as("Airport Region Filter appear in Airport list table").isTrue();
        Assertions.assertThat(airportLatitudeLongitudeFilter.isDisplayed())
                .as("Airport Latitude Longitude Filter appear in Airport list table").isTrue();
        Assertions.assertThat(findElementByXpath("//th[.='Actions']").isDisplayed())
                .as("Airport Actions Column appear in Airport list table").isTrue();
        Assertions.assertThat(editAirportButton.isDisplayed())
                .as("Edit Airport button appear in Airport list table").isTrue();
        Assertions.assertThat(disableAirportButton.isDisplayed())
                .as("Disable Airport button appear in Airport list table").isTrue();
    }

    public void createNewAirport(Map<String, String> map) {
        addNewAirport.click();
        Assertions.assertThat(newAirportSubmit.isEnabled())
                .as("New airport submit button is disabled").isFalse();
        addNewAirportPanel.waitUntilVisible();
        airportCodeInput.sendKeys(map.get("airportCode"));
        airportNameInput.sendKeys(map.get("airportName"));
        airportCityInput.sendKeys(map.get("city"));
        airportRegionInput.click();
        sendKeysAndEnterById("createAirportForm_region", map.get("region"));
        airportLatitudeInput.sendKeys(map.get("latitude"));
        airportLongitudeInput.sendKeys(map.get("longitude"));
        newAirportSubmit.click();
    }

    public void verifyAirportCreationSuccessMessage(String airportName) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->{
            String actMessage = getAntTopText();
            Assertions.assertThat(actMessage).as("Success message is same").isEqualTo(airportName);
        },"Verify airport creation message", 500,2);

    }

    public void verifyNewlyCreatedAirport(Map<String, String> map) {
        clearWebField(airportCodeFilter.getWebElement());
        airportCodeFilter.sendKeys(map.get("airportCode"));
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();
        Assertions.assertThat(findElementByXpath(f(XPATH_TABLE_FIRST_ROW,2, 2)).getText()).as("Airport Code is same")
                .isEqualTo(map.get("airportCode"));
        Assertions.assertThat(findElementByXpath(f(XPATH_TABLE_FIRST_ROW,2, 3)).getText()).as("Airport Name is same")
                .isEqualTo(map.get("airportName"));
        Assertions.assertThat(findElementByXpath(f(XPATH_TABLE_FIRST_ROW,2, 4)).getText()).as("Airport city is same")
                .isEqualTo(map.get("city"));
        Assertions.assertThat(findElementByXpath(f(XPATH_TABLE_FIRST_ROW,2, 5)).getText()).as("Airport region is same")
                .isEqualTo(map.get("region"));
        Assertions.assertThat(findElementByXpath(f(XPATH_TABLE_FIRST_ROW,2, 6)).getText()).as("Airport latitude & longitude is same")
                .isEqualTo(map.get("latitude") + ", " + map.get("longitude"));
    }

    public void captureErrorNotification() {
        antNotificationMessage.waitUntilVisible();
        if(antNotificationMessage.isDisplayed()){
            if(antNotificationDescription.isDisplayed()){
                notificationMessage = antNotificationDescription.getText();
                if(notificationMessage.trim().equals("")){
                    notificationMessage = antNotificationMessage.getText();
                }
            }
        }
    }

    public void verifyTheErrorInAirportCreation(String expError) {
        Assertions.assertThat(notificationMessage).as("Error message is same").contains(expError);
    }

    public void searchAirport(PageElement filter, String value){
        clearWebField(filter.getWebElement());
        filter.sendKeys(value);
        pause500ms();
    }
    public void verifySearchedAirport(Airport airport) {
        String LIST_OF_AIRPORT_ELEMENTS = "//div[contains(@class,'table-container')]//table/tbody//tr/td[%s]";

        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();
        Assertions.assertThat(ListOfItems(f(LIST_OF_AIRPORT_ELEMENTS, 2)))
            .as("Airport Code is same")
            .contains(airport.getAirport_code());
        Assertions.assertThat(ListOfItems(f(LIST_OF_AIRPORT_ELEMENTS, 3)))
            .as("Airport Name is same")
            .contains(airport.getAirport_name());
        Assertions.assertThat(ListOfItems(f(LIST_OF_AIRPORT_ELEMENTS, 4)))
            .as("Airport city is same")
            .contains(airport.getCity());
        Assertions.assertThat(ListOfItems(f(LIST_OF_AIRPORT_ELEMENTS, 5)))
            .as("Airport region is same")
            .contains(airport.getRegion());
        Assertions.assertThat(ListOfItems(f(LIST_OF_AIRPORT_ELEMENTS, 6)))
            .as("Airport latitude & longitude is same")
            .contains(airport.getLatitude().toString() + ", " + airport.getLongitude().toString());
    }

    public List<String> ListOfItems(String xpath) {
        List<WebElement> ListOfElements = findElementsByXpath(xpath);
        List<String> Items = new ArrayList<>();
        ListOfElements.forEach(element -> {
            Items.add(element.getText().trim());
        });
        return Items;
    }

    public void verifyTheValidationErrorInAirportCreation(String expError) {
        Assertions.assertThat(validationAlert.getText()).as("Validation error message is same")
                .contains(expError);
        Assertions.assertThat(createOrEditAirportSubmit.isEnabled())
                .as("New airport submit button is disabled").isFalse();

    }

    public void verifyNodataDisplay(){
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are not present")
                .isTrue();
    }

    public void editExistingAirport(String editField, Map<String, String> updatedMap, Map<String, String> origMap) {
        clearWebField(airportCodeFilter.getWebElement());
        airportCodeFilter.sendKeys(origMap.get("airportCode"));
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();

        editAirportButton.click();
        editAirportPanel.waitUntilVisible();

        switch (editField) {
            case "airportCode":
                clearWebField(airportCodeInput.getWebElement());
                airportCodeInput.sendKeys(updatedMap.get(editField));
                break;
            case "airportName":
                clearWebField(airportNameInput.getWebElement());
                airportNameInput.sendKeys(updatedMap.get(editField));
                break;
            case "city":
                clearWebField(airportCityInput.getWebElement());
                airportCityInput.sendKeys(updatedMap.get(editField));
                break;
            case "region":
                clearWebField(airportRegionInput.getWebElement());
                airportRegionInput.click();
                sendKeysAndEnterById("createAirportForm_region", updatedMap.get(editField));
                break;
            case "latitude":
                clearWebField(airportLatitudeInput.getWebElement());
                airportLatitudeInput.sendKeys(updatedMap.get(editField));
                break;
            case "longitude":
                clearWebField(airportLongitudeInput.getWebElement());
                airportLongitudeInput.sendKeys(updatedMap.get(editField));
                break;
            default:
                LOGGER.warn("Search type is not found");
        }
        editAirportSubmit.click();
    }

    public void disableExistingAirport(Map<String, String> map) {
        clearWebField(airportCodeFilter.getWebElement());
        airportCodeFilter.sendKeys(map.get("airportCode"));
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();

        disableAirportButton.click();
        disableAirportPanel.waitUntilVisible();

        String message = antModalBody.getText();

        Assertions.assertThat(message).as("Are you sure you want to submit changes?")
                .contains("Warning: Disabling the selected airport will result in the following. " +
                        "Are you sure you want to submit changes?");
        Assertions.assertThat(message).as("Remove some shipment schedules")
                .contains("Remove some shipment schedules");
        Assertions.assertThat(message).as("Remove some shipment paths")
                .contains("Remove some shipment paths");
        Assertions.assertThat(message).as("Remove all sort airport currently tie to the hub")
                .contains("Remove all sort airport currently tie to the hub");
        Assertions.assertThat(message).as("Current zone mapping tied to this airport will need to be updated")
                .contains("Current zone mapping tied to this airport will need to be updated");
        Assertions.assertThat(message).as("Selected airport ACJ will be removed and disabled.")
                .contains(f("Selected airport %s will be removed and disabled.", map.get("airportCode")));
    }

    public void clickOnCancelOrDisable(String buttonName) {
        retryIfAssertionErrorOccurred(() ->
        {
            try {
                if(buttonName.equalsIgnoreCase("Disable")){
                    disableButton.click();
                    pause3s();
                    Assertions.assertThat(disableAirportPanel.isDisplayed()).as("Disable panel displayed")
                            .isFalse();
                } else if(buttonName.equalsIgnoreCase("Cancel")){
                    cancelButton.click();
                }else if(buttonName.equalsIgnoreCase("Activate")){
                    activateButton.click();
                    pause3s();
                    Assertions.assertThat(activateAirportPanel.isDisplayed()).as("Activate panel displayed")
                            .isFalse();
                }
            } catch (AssertionError ex) {
                throw ex;
            }
        }, "retry", 500, 3);

    }

    public void verifyButton(Map<String, String> map, String buttonName) {
        clearWebField(airportCodeFilter.getWebElement());
        airportCodeFilter.sendKeys(map.get("airportCode"));
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();
        if(buttonName.equalsIgnoreCase("Activate")){
            Assertions.assertThat(activateAirportButton.isDisplayed()).as("Activate button is displayed")
                    .isTrue();
        }else if(buttonName.equalsIgnoreCase("Disable")){
            Assertions.assertThat(disableAirportButton.isDisplayed()).as("Disable button is displayed")
                    .isTrue();
        }
    }

    public void activateExistingAirport(Map<String, String> map) {
        clearWebField(airportCodeFilter.getWebElement());
        airportCodeFilter.sendKeys(map.get("airportCode"));
        Assertions.assertThat(noDataElement.isDisplayed()).as("Records are present")
                .isFalse();

        activateAirportButton.click();
        activateAirportPanel.waitUntilVisible();

        String message = antModalBody.getText();

        Assertions.assertThat(message).as("This action will RE-ACTIVATE selected Airport, continue?")
                .contains("This action will RE-ACTIVATE selected Airport, continue?");
    }

    public void verifyNoResultsFound(){
        Assertions.assertThat(noResultsFound.isDisplayed()).as("Records are not present")
                .isTrue();
    }

    public void clickOnCreateToFromAirportTrip(){
        createToFromAirportTrip.click();
        switchToOtherWindow();
        waitUntilPageLoaded();
        switchTo();
        Assertions.assertThat(findElementByXpath("//h3[.='Create To/from Airport Trip']",30).isDisplayed())
                .as("Create To/from Airport Trip Title is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_originFacility.isDisplayed())
                .as("Origin Facility is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_destinationFacility.isDisplayed())
                .as("Destination facility is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_departureTime.isDisplayed())
                .as("Departure time is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_durationHours.isDisplayed())
                .as("Duration hours is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_duration_minutes.isDisplayed())
                .as("Duration minutes is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_departureDate.isDisplayed())
                .as("Departure Date is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_drivers.isDisplayed())
                .as("Drivers field is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_comment.isDisplayed())
                .as("Comment field is displayed").isTrue();
        Assertions.assertThat(submitButton.isEnabled())
                .as("Submit button is disabled").isFalse();
        waitUntilInvisibilityOfElementLocated("//div[.='Loading...']", 180);
    }

    public void createNewAirportTrip(Map<String, String> mapOfData) {
        createToFromAirportForm_originFacility.click();
        sendKeysAndEnterById("createToFromAirportForm_originFacility", mapOfData.get("originFacility"));

        createToFromAirportForm_destinationFacility.click();
        sendKeysAndEnterById("createToFromAirportForm_destinationFacility", mapOfData.get("destinationFacility"));

        String[] hourtime = mapOfData.get("departureTime").split(":");
        String hour = f(departureTimeXpath, 1, hourtime[0]);
        String time = f(departureTimeXpath, 2, hourtime[1]);

        createToFromAirportForm_departureTime.click();
        moveToElementWithXpath(antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[1]");
        TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
        moveToElementWithXpath(antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[2]");
        TestUtils.findElementAndClick(time, "xpath", getWebDriver());
        TestUtils.findElementAndClick(antpickerdropdownhidden + "//li[@class='ant-picker-ok']",
                "xpath", getWebDriver());

        createToFromAirportForm_durationHours.click();
        TestUtils.findElementAndClick(f(XPATH_DIV_TITLE, mapOfData.get("durationhour")), "xpath", getWebDriver());

        createToFromAirportForm_duration_minutes.click();
        sendKeysAndEnterById("createToFromAirportForm_duration-minutes", mapOfData.get("durationminutes"));

        String departureDate = mapOfData.get("departureDate");
        createToFromAirportForm_departureDate.click();
        createToFromAirportForm_departureDate.sendKeys(departureDate);
        createToFromAirportForm_departureDate.sendKeys(Keys.ENTER);

        if(!mapOfData.get("drivers").equals("-")){
            String[] drivers = mapOfData.get("drivers").split(";");
            int count = 0;
            for(String driver : drivers){
                createToFromAirportForm_drivers.click();
                sendKeysAndEnterById("createToFromAirportForm_drivers", driver);
                count++;
                if(count>4){
                    int selected = findElementsByXpath("//div[@class='ant-select-selection-overflow-item']").size();
                    Assertions.assertThat(selected)
                            .as("Total maximum seleted drivers are 4").isEqualTo(4);
                }
            }
        }

        createToFromAirportForm_comment.sendKeys(mapOfData.get("comments"));

        submitButton.click();
    }

    public void clickOnCreateFlightTrip(){
        createFlightTrip.click();
        switchToOtherWindow();
        waitUntilPageLoaded();
        switchTo();
        Assertions.assertThat(findElementByXpath("//h3[.='Create Flight Trip']",30).isDisplayed())
                .as("Create To/from Airport Trip Title is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_originAirport.isDisplayed())
                .as("Origin Facility is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_destinationAirport.isDisplayed())
                .as("Destination facility is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_departureTime.isDisplayed())
                .as("Departure time is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_durationHours.isDisplayed())
                .as("Duration hours is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_durationMinutes.isDisplayed())
                .as("Duration minutes is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_departureDate.isDisplayed())
                .as("Departure Date is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_originProcessingTimeHours.isDisplayed())
                .as("Processing Time Hours at Origin Airport is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_originProcessingTimeMinutes.isDisplayed())
                .as("Processing Time Minutes at Origin Airport is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_destinationProcessingTimeHours.isDisplayed())
                .as("Processing Time Hours at Destination Airport is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_destinationProcessingTimeMinutes.isDisplayed())
                .as("Processing Time Minutes at Destination Airport is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_flightNo.isDisplayed())
                .as("Flight Number is displayed").isTrue();
        Assertions.assertThat(createFlightTrip_comment.isDisplayed())
                .as("Comment field is displayed").isTrue();
        Assertions.assertThat(submitButton.isEnabled())
                .as("Submit button is disabled").isFalse();
        waitUntilInvisibilityOfElementLocated("//div[.='Loading...']", 180);
    }

    public Boolean createFlightTrip(Map<String, String> mapOfData) {

        if (mapOfData.get("originFacility")!=null){
            createFlightTrip_originAirport.click();
            sendKeysAndEnterById(createFlightTrip_originAirportId, mapOfData.get("originFacility"));
        }

        if (mapOfData.get("destinationFacility")!=null){
            createFlightTrip_destinationAirport.click();
            sendKeysAndEnterById(createFlightTrip_destinationAirportId, mapOfData.get("destinationFacility"));
        }

        if(mapOfData.get("departureTime")!=null){
            String[] hourtime = mapOfData.get("departureTime").split(":");
            String hour = f(departureTimeXpath, 1, hourtime[0]);
            String time = f(departureTimeXpath, 2, hourtime[1]);

            createFlightTrip_departureTime.click();
            moveToElementWithXpath(antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[1]");
            TestUtils.findElementAndClick(hour, "xpath", getWebDriver());
            moveToElementWithXpath(antpickerdropdownhidden + "//div[@class='ant-picker-content']//ul[2]");
            TestUtils.findElementAndClick(time, "xpath", getWebDriver());
            TestUtils.findElementAndClick(antpickerdropdownhidden + "//li[@class='ant-picker-ok']",
                    "xpath", getWebDriver());
        }

        if(mapOfData.get("durationhour")!=null)
            SetValueFromDropdownList(createFlightTrip_durationHours,mapOfData.get("durationhour"));

        if(mapOfData.get("durationminutes")!=null)
            SetValueFromDropdownList(createFlightTrip_durationMinutes,mapOfData.get("durationminutes"));

        if(mapOfData.get("departureDate")!=null)
            createFlightTrip_departureDate.ClickSendKeysAndEnter(mapOfData.get("departureDate"));

        if(mapOfData.get("originProcesshours")!=null)
            SetValueFromDropdownList(createFlightTrip_originProcessingTimeHours,mapOfData.get("originProcesshours"));

        if(mapOfData.get("originProcessminutes")!=null)
            SetValueFromDropdownList(createFlightTrip_originProcessingTimeMinutes,mapOfData.get("originProcessminutes"));

        if(mapOfData.get("destProcesshours")!=null)
            SetValueFromDropdownList(createFlightTrip_destinationProcessingTimeHours,mapOfData.get("destProcesshours"));

        if(mapOfData.get("destProcessminutes")!=null)
            SetValueFromDropdownList(createFlightTrip_destinationProcessingTimeMinutes,mapOfData.get("destProcessminutes"));

        if (mapOfData.get("flightnumber")!=null)
            createFlightTrip_flightNo.sendKeys(mapOfData.get("flightnumber"));

        if (mapOfData.get("mawb")!=null)
            createFlightTrip_mawb.sendKeys(mapOfData.get("mawb"));

        if (mapOfData.get("comments")!=null) createFlightTrip_comment.sendKeys(mapOfData.get("comments"));

        if (submitButton.isEnabled()) {
            submitButton.click();
            if (isElementVisible("//div[@class='ant-message-notice']//span[2]",2)) return true;
        }
        return false;
    }

    private void SetValueFromDropdownList(PageElement element,String value){
        try{
            if (Integer.parseInt(value) <10){
                element.click();
                pause500ms();
                WebElement scrollBar = findElementByXpath("//div[contains(@class,'ant-select-dropdown') and not(contains(@class, 'ant-select-dropdown-hidden'))]//div[contains(@class,'rc-virtual-list-scrollbar-thumb')]");
                scrollToElement(scrollBar,f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH,value),1500,50);
                TestUtils.findElementAndClick(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, value), "xpath", getWebDriver());
            } else element.ClickSendKeysAndEnter(value);
        } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        throw ex;
        }
    }
    public void verifyAirportTripCreationSuccessMessage(String message) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(()->{
            String actMessage = getAntTopText();
            Assertions.assertThat(actMessage).as("Success message is same").contains(message);
            Assertions.assertThat(findElementByXpath("//a[.='View Details']").isDisplayed())
                .as("View Details link is visible").isTrue();
        },"Verify Airport creation message", 500, 2);
    }

    public String getAirportTripId(){
        String actMessage = getAntTopText();
        if (actMessage !=null){
            Matcher m = Pattern.compile("Trip(.+?)from").matcher(actMessage);
            if (m.find()){
                return m.group(1).trim();
            }
        }
        return null;
    }

    public void verifyDriverNotDisplayed(String driver) {
        retryIfRuntimeExceptionOccurred(() -> {
            try {
                waitUntilVisibilityOfElementLocated("//span[.='Select to assign drivers']");
                createToFromAirportForm_drivers.click();
                sendKeysAndEnterById("createToFromAirportForm_drivers", driver);
                int selected = findElementsByXpath("//div[@class='ant-select-selection-overflow-item']").size();
                Assertions.assertThat(selected)
                        .as("Invalid driver not displayed").isZero();
            } catch (Throwable ex) {
                LOGGER.error(ex.getMessage());
                LOGGER.info("Searched element is not found, retrying after 2 seconds...");
                refreshPage();
                switchTo();
                throw new NvTestRuntimeException(ex.getCause());
            }
        }, 2);
    }

    public void verifyInvalidItem(String name, String value) {
        switch (name) {
            case "origin facility":
                createToFromAirportForm_originFacility.click();
                createToFromAirportForm_originFacility.sendKeys(value);
                Assertions.assertThat(
                                isElementExist(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, value), 1L))
                        .as("Disable Origin Hub is not displayed").isFalse();
                createToFromAirportForm_originFacility.clear();
                break;

            case "destination facility":
                createToFromAirportForm_destinationFacility.click();
                createToFromAirportForm_destinationFacility.sendKeys(value);
                Assertions.assertThat(
                                isElementExist(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, value), 1L))
                        .as("Disable Destination Hub is not displayed").isFalse();
                createToFromAirportForm_destinationFacility.clear();
                break;

            case "driver":
                waitUntilVisibilityOfElementLocated("//span[.='Select to assign drivers']");
                createToFromAirportForm_drivers.click();
                createToFromAirportForm_drivers.sendKeys(value);
                Assertions.assertThat(
                                isElementExist(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, value), 1L))
                        .as("Invalid Driver has not been displayed").isFalse();
                break;
        }
    }

    public void getAndVerifySameHubErrorMessage(String pageName) {
        switch (pageName){
            case "Create Airport Trip":
                String originHubErrorMsg = findElementByXpath(
                        f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_originFacility")).getText();
                String destinationHubErrorMsg = findElementByXpath(
                        f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_destinationFacility")).getText();
                boolean errorVerification = (
                        originHubErrorMsg.equals("Invalid. Please create warehouse to/from airport.")
                                && destinationHubErrorMsg.equals("Invalid. Please create warehouse to/from airport."));

                Assertions.assertThat(errorVerification).as("Invalid. Please create warehouse to/from airport.")
                        .isTrue();
                break;
            case "Create Flight Trip":
                String originAirportMessage = findElementByXpath(
                        f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_originAirportId)).getText();
                String destinationAirportMessage = findElementByXpath(
                        f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_destinationAirportId)).getText();
                boolean errorMessage = (
                        originAirportMessage.equals("Origin Airport and Destination Airport cannot be the same")
                                && destinationAirportMessage.equals("Origin Airport and Destination Airport cannot be the same"));

                Assertions.assertThat(errorMessage).as("Origin Airport and Destination Airport cannot be the same")
                        .isTrue();
                break;
        }

    }

    public void getAndVerifyZeroDurationTimeErrorMessage(String pageName){
        String ZeroDurationTimeErrorMessage ="";
        switch (pageName){
            case "Create Airport Trip":
                ZeroDurationTimeErrorMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_duration-hours")).getText();
                Assertions.assertThat(ZeroDurationTimeErrorMessage).as("Duration must be greater than 0")
                        .isEqualTo("Duration must be greater than 0");
                break;
            case "Create Flight Trip":
                ZeroDurationTimeErrorMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_durationHoursId)).getText();
                Assertions.assertThat(ZeroDurationTimeErrorMessage).as("Duration must be greater than 0")
                        .isEqualTo("Flight Duration must be greater than 0");
                break;
        }


    }

    public void createAirportTripUsingData(Map<String,String> resolvedMapOfData){

        if (resolvedMapOfData.get("originFacility")!=null){
            createToFromAirportForm_originFacility.click();
            sendKeysAndEnterById("createToFromAirportForm_originFacility", resolvedMapOfData.get("originFacility"));
        }
        if (resolvedMapOfData.get("destinationFacility")!=null){
            createToFromAirportForm_destinationFacility.click();
            sendKeysAndEnterById("createToFromAirportForm_destinationFacility", resolvedMapOfData.get("destinationFacility"));
        }
        if (resolvedMapOfData.get("durationhour")!=null){
            createToFromAirportForm_durationHours.click();
            pause1s();
            TestUtils.findElementAndClick(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, resolvedMapOfData.get("durationhour")), "xpath", getWebDriver());
        }
        if (resolvedMapOfData.get("durationminutes")!=null){
            createToFromAirportForm_duration_minutes.click();
            pause1s();
            TestUtils.findElementAndClick(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, resolvedMapOfData.get("durationminutes")), "xpath", getWebDriver());
        }
    }

    public void verifySubmitButtonDisable(){
        Assertions.assertThat(submitButton.isEnabled())
                .as("Submit button is disabled").isFalse();
    }

    public void verifyPastDayDisable(String date, String pageName){
        switch (pageName){
            case "Create Airport Trip":
                createToFromAirportForm_departureDate.click();
                break;
            case "Create Flight Trip":
                createFlightTrip_departureDate.click();
                break;
        }

        Assertions.assertThat(isElementExist(f(XPATH_CAL_DEPARTUREDATE_TD_DISABLE,date),2)).as("Date picker for past date is disable").isTrue();
    }

    public void clearTextonField(String fieldName){

        switch (fieldName){
            case "Origin Facility":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_originFacility")).click();
                break;
            case "Destination Facility":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_destinationFacility")).click();
                break;
            case "Departure Time":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_departureTime")).click();
                break;
            case "Duration":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_duration-hours")).click();
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_duration-minutes")).click();
                break;
            case "Departure Date":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,"createToFromAirportForm_departureDate")).click();
                break;
        }
    }

    public void verifyMandatoryFieldErrorMessageAirportPage(String fieldName){
        String actualMessage ="";
        String expectedMessage = "Please enter "+fieldName;
        switch (fieldName){
            case "Origin Facility":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_originFacility")).getText();
                break;
            case "Destination Facility":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_destinationFacility")).getText();
                break;
            case "Departure Time":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_departureTime")).getText();
                break;
            case "Duration":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_duration-hours")).getText();
                break;
            case "Departure Date":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,"createToFromAirportForm_departureDate")).getText();
                break;
        }
        Assertions.assertThat(actualMessage).as("Mandatory require error message is the same").isEqualTo(expectedMessage);
    }

    public void verifyMandatoryFieldErrorMessageFlightTripPage(String fieldName){
        String actualMessage ="";
        String expectedMessage = "Please enter "+fieldName;
        switch (fieldName){
            case "Origin Airport":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_originAirportId)).getText();
                break;
            case "Destination Airport":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_destinationAirportId)).getText();
                break;
            case "Flight Schedule Departure Time":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_departureTimeId)).getText();
                break;
            case "Flight Duration":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_durationHoursId)).getText();
                break;
            case "Flight Departure Date":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_departureDateId)).getText();
                break;
            case "Processing Time at Origin Airport":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_originProcessingTimeHoursId)).getText();
                break;
            case "Processing Time at Destination Airport":
                actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_destinationProcessingTimeHoursId)).getText();
                break;
        }
        Assertions.assertThat(actualMessage).as("Mandatory require error message is the same").isEqualTo(expectedMessage);
    }

    public void clearTextonFieldOnFlightTrip(String fieldName){
        switch (fieldName){
            case "Origin Airport":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_originAirportId)).click();
                break;
            case "Destination Airport":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_destinationAirportId)).click();
                break;
            case "Flight Schedule Departure Time":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_departureTimeId)).click();
                break;
            case "Flight Duration":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_durationHoursId)).click();
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_durationMinutesId)).click();
                break;
            case "Flight Departure Date":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_departureDateId)).click();
                break;
            case "Processing Time at Origin Airport":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_originProcessingTimeHoursId)).click();
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_originProcessingTimeMinutesId)).click();
                break;
            case "Processing Time at Destination Airport":
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_destinationProcessingTimeHoursId)).click();
                findElementByXpath(f(AIRPORT_TRIP_CLEAR_BUTTON_XPATH,createFlightTrip_destinationProcessingTimeMinutesId)).click();
                break;
        }
    }
    public void verifyMAWBerrorMessage(){
        String actualMessage = findElementByXpath(f(AIRPORT_TRIP_PAGE_ERRORS_XPATH,createFlightTrip_mawbId)).getText();
        Assertions.assertThat(actualMessage).as("MAWB error message is the same").isEqualTo("Invalid MAWB Format");
    }

    public void verifyToastErrorMessage(List<String> expectedMessages){

        List<WebElement> ErrorMessagesElement = findElementsByXpath(TOAST_ERROR_MESSAGES_XPATH);
        List<String> actualMessages = new ArrayList<>();
        ErrorMessagesElement.forEach(e -> actualMessages.add(e.getText()));
        Boolean compareResult = expectedMessages.containsAll(actualMessages) && actualMessages.containsAll(expectedMessages);
        Assertions.assertThat(compareResult).as("Error message is the same").isTrue();

    }

    public static class AirportTable extends AntTableV3<AirTrip> {

        public static final String COLUMN_START_HUB = "origin_hub_name";
        public static final String COLUMN_AIRTRIP_ID = "trip_id";
        public static final String COLUMN_END_HUB = "destination_hub_name";
        public static final String COLUMN_DEPARTURE_DATETIME = "departure_date_time";
        public static final String COLUMN_MAWB = "mawb";
        public static final String COLUMN_STATUS = "status";
        public static final String COLUMN_COMMENTS = "comment";

        public static final String ACTION_EDIT = "Edit";
        public static final String ACTION_DETAILS = "Details";
        public static final String ACTION_DELETE = "Cancel";
        public static final String ACTION_ASSIGN_DRIVER = "assignDriver";
        public static final String ACTION_DISABLED_ASSIGN_DRIVER = "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(@data-testid,'assign-driver-icon') and @disabled]";
        public static final String ACTION_ASSIGN_MAWB = "assignMAWB";
        public static final String ACTION_DISABLED_BUTTON = "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(@data-testid,'%s') and @disabled]";

        @FindBy(xpath = "//button[.='Depart']")
        public Button departTripButton;

        @FindBy(xpath = "//button[.='Arrive']")
        public Button arriveTripButton;

        @FindBy(xpath = "//button[.='Complete']")
        public Button completeTripButton;

        @FindBy(xpath = "//i[.='Completed']")
        public PageElement completedTrackText;

        @FindBy(xpath = "//i[.='Cancelled']")
        public PageElement cancelledTrackText;

        public AirportTable(WebDriver webDriver) {
            super(webDriver);
            setColumnLocators(
                    ImmutableMap.<String, String>builder().put(COLUMN_END_HUB, "destination_hub_id")
                            .put(COLUMN_AIRTRIP_ID, "trip_id").put(COLUMN_START_HUB, "origin_hub_id")
                            .put(COLUMN_DEPARTURE_DATETIME, "departure_date_time")
                            .put(COLUMN_MAWB, "mawb").put(COLUMN_STATUS, "status")
                            .put(COLUMN_COMMENTS, "comment").build());
            setEntityClass(AirTrip.class);
            setActionButtonLocatorTemplate(
                    "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(@data-testid,'%s')]");
            setActionButtonsLocators(
                    ImmutableMap.of(
                            ACTION_DETAILS, "view-trip-icon",
                            ACTION_EDIT, "edit-trip-icon",
                            ACTION_DELETE, "delete-trip-icon",
                            ACTION_ASSIGN_DRIVER, "assign-driver-icon",
                            ACTION_ASSIGN_MAWB, "assign-mawb-button"));
        }
    }

    private void waitWhileTableIsLoading() {
        Wait<AirportTable> fWait = new FluentWait<>(airportTable)
                .withTimeout(Duration.ofSeconds(20))
                .pollingEvery(Duration.ofSeconds(1))
                .ignoring(NoSuchElementException.class);
        fWait.until(table -> table.getRowsCount() > 0);
    }
    public void validateAirTripInfo(Long AirtripId, AirTrip expectedAirtrip) {
        airportTable.filterByColumn(COLUMN_AIRTRIP_ID, String.valueOf(AirtripId));
        waitWhileTableIsLoading();
        AirTrip actualAirTripInfo = airportTable.readEntity(1);
        expectedAirtrip.compareWithActual(actualAirTripInfo);
    }

    public void verifyDisableItemsOnEditPage(String pageName){
        switch (pageName){
            case "Flight Trip":
                waitUntilVisibilityOfElementLocated("//h3[.='Edit Flight Trip']");
                Assertions.assertThat(createFlightTrip_originAirport.getAttribute("disabled")).as("Edit origin Airport is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_destinationAirport.getAttribute("disabled")).as("Edit Destination Airport is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_departureDate.getAttribute("disabled")).as("Edit Departure Date is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_departureTime.getAttribute("disabled")).as("Edit Departure Time is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_durationHours.getAttribute("disabled")).as("Edit Duration Hours is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_durationMinutes.getAttribute("disabled")).as("Edit Duration Minutes is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_originProcessingTimeHours.getAttribute("disabled")).as("Edit Processing Time at Origin Airport is disabled").isEqualTo("true");
                Assertions.assertThat(createFlightTrip_destinationProcessingTimeHours.getAttribute("disabled")).as("Edit Processing Time at Destination Airport is disabled").isEqualTo("true");
                break;
            case "ToFrom Airport Trip":
                waitUntilVisibilityOfElementLocated("//h3[.='Edit To/from Airport Trip']");
                Assertions.assertThat(createToFromAirportForm_originFacility.getAttribute("disabled")).as("Edit Origin Facility is disabled").isEqualTo("true");
                Assertions.assertThat(createToFromAirportForm_destinationFacility.getAttribute("disabled")).as("Edit Destination Facility is disabled").isEqualTo("true");
                Assertions.assertThat(createToFromAirportForm_departureDate.getAttribute("disabled")).as("Edit Departure Date is disabled").isEqualTo("true");
                Assertions.assertThat(createToFromAirportForm_departureTime.getAttribute("disabled")).as("Edit Departure Time is disabled").isEqualTo("true");
                Assertions.assertThat(createToFromAirportForm_durationHours.getAttribute("disabled")).as("Edit Duration is disabled").isEqualTo("true");
                break;
        }
    }

    public void editAirportTripItems(Map<String,String> data){
        String pageName = data.get("tripType");
        switch (pageName){
            case "Flight Trip":
                if (data.get("comment")!=null)
                    createFlightTrip_comment.clearAndSendkeysV2(data.get("comment"));
                if (data.get("flight_no")!=null)
                    createFlightTrip_flightNo.clearAndSendkeysV2(data.get("flight_no"));
                if (data.get("mawb")!=null){
                    if (!data.get("mawb").trim().equals("-")){
                        createFlightTrip_mawb.clearAndSendkeysV2(data.get("mawb"));
                    } else createFlightTrip_mawb.sendKeys(Keys.chord(Keys.CONTROL,"a", Keys.DELETE));
                }
                break;
            case "ToFrom Airport Trip":
                if (data.get("comment")!=null)
                    createToFromAirportForm_comment.clearAndSendkeysV2(data.get("comment"));
                if(!data.get("drivers").equals("-")){
                    retryIfRuntimeExceptionOccurred(() ->{
                        waitUntilInvisibilityOfElementLocated("//input[@id='createToFromAirportForm_drivers' and @disabled]",30);
                        waitUntilVisibilityOfElementLocated("//span[.='Select to assign drivers']");
                        String[] drivers = data.get("drivers").split(",");
                        int count = 0;
                        for(String driver : drivers){
                            createToFromAirportForm_drivers.click();
                            sendKeysAndEnterById("createToFromAirportForm_drivers", driver);
                            count++;
                            if(count>4){
                                int selected = findElementsByXpath("//div[@class='ant-select-selection-overflow-item']").size();
                                Assertions.assertThat(selected)
                                        .as("Total maximum seleted drivers are 4").isEqualTo(4);
                            }
                        }
                    },5);
                }
                break;

        }
        pause1s();
        submitButton.click();
    }
    public void verifyListDriver(List<Driver> middleMileDrivers) {
        Boolean result = true;
        String ActualDrivers = findElementByXpath("(//td[@class='drivers']//span)[last()]").getText();
        List<String> AcutalDriversUsername = Arrays.asList(ActualDrivers.split(","));
        List<String> ExpectedDriversUsename = getListDriverUsername(middleMileDrivers);
        for (String driver : AcutalDriversUsername) {
            driver = driver.replace("(main)", "").trim();
            if (!ExpectedDriversUsename.contains(driver))
                result = false;
        }
        Assertions.assertThat(result).as("Drivers are shown on Airport Trip Management page as expected")
                .isTrue();
    }
    public List<String> getListDriverUsername(List<Driver> middleMileDrivers) {
        List<String> ExpectedList = new ArrayList<>();
        middleMileDrivers.forEach((e) -> {
            ExpectedList.add(e.getFullName());
        });
        return ExpectedList;
    }

    public static class TripDepartureArrivalModal extends AntModal {

        public TripDepartureArrivalModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[@class='ant-typography']/strong")
        public PageElement PageMessage;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Origin Facility']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement originFacility;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Destination Facility']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement destinationFacility;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Expected Departure Time']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement expectedDepartureTime;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Expected Duration']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement expectedDuration;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Driver']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement Driver;

        @FindBy(xpath = "//button[.='Submit']")
        public Button confirmTrip;

        @FindBy(xpath = "//button[.='No']")
        public Button no;
    }

    public void departTrip() {
        airportTable.departTripButton.waitUntilClickable();
        airportTable.departTripButton.click();
        tripDepartureArrivalModal.waitUntilVisible();
        tripDepartureArrivalModal.confirmTrip.waitUntilClickable();
        Assertions.assertThat(tripDepartureArrivalModal.PageMessage.isDisplayed())
                .as("Trip Departure message appear in Trip Departure page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.originFacility.isDisplayed())
                .as("Origin Facility appear in Trip Departure page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.destinationFacility.isDisplayed())
                .as("Destination Facility appear in Trip Departure page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDepartureTime.isDisplayed())
                .as("Expected Departure Time appear in Trip Departure page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDuration.isDisplayed())
                .as("Expected Duration appear in Trip Departure page").isTrue();
        tripDepartureArrivalModal.confirmTrip.click();
        pause1s();
    }

    public void verifyDepartedTripSuccessful(String expectedMessage){
        antNotificationMessage.waitUntilVisible();
        String actualMessage = getAntTopTextV2();
        Assertions.assertThat(actualMessage).as("Trip departed successfully").isEqualTo(expectedMessage);
    }

    public void verifyActionButtonsAreDisabled(List<String> actionButtons){
        actionButtons.forEach((button) ->{
            Assertions.assertThat(airportTable.getActionButton(1,button).getAttribute("disabled")).as(f("Button %s is disabled",button)).isEqualTo("true");
        });
    }

    public void verifyDriverErrorMessages(List<String> expectedMessages){
        antNotificationMessage.waitUntilVisible();
        List<WebElement> messageLocators = findElementsByXpath("//div[@class='ant-notification-notice-message']//div");
        List<String> actualMessages = new ArrayList<>();
        messageLocators.forEach((element) -> {
            actualMessages.add(element.getText());
        });
        Boolean result = expectedMessages.containsAll(actualMessages) && actualMessages.containsAll(expectedMessages);
        Assertions.assertThat(result).as("Error message(s) are the same").isTrue();
    }

    public void ArriveTripAndVerifyItems() {
        airportTable.arriveTripButton.waitUntilClickable();
        airportTable.arriveTripButton.click();
        tripDepartureArrivalModal.waitUntilVisible();
        tripDepartureArrivalModal.confirmTrip.waitUntilClickable();
        Assertions.assertThat(tripDepartureArrivalModal.PageMessage.isDisplayed())
                .as("Trip Arrival message appear in Trip Arrival page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.originFacility.isDisplayed())
                .as("Origin Facility appear in Trip Arrival page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.destinationFacility.isDisplayed())
                .as("Destination Facility appear in Trip Arrival page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDepartureTime.isDisplayed())
                .as("Expected Departure Time appear in Trip Arrival page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDuration.isDisplayed())
                .as("Expected Duration appear in Trip Arrival page").isTrue();
        tripDepartureArrivalModal.confirmTrip.click();
        pause1s();
    }

    public void verifyTripMessageSuccessful(String expectedMessage){
        antNotificationMessage.waitUntilVisible();
        String actualMessage = getAntTopTextV2();
        Assertions.assertThat(actualMessage).as("Meesage is the same").isEqualTo(expectedMessage);
    }

    public void verifyButtonIsShown(String button){
        switch (button.toUpperCase()){
            case "COMPLETE":
                Assertions.assertThat(airportTable.completeTripButton.isDisplayed()).as(f("%s button is shown",button.toUpperCase())).isTrue();
                break;
            case "ARRIVE":
                Assertions.assertThat(airportTable.arriveTripButton.isDisplayed()).as(f("%s button is shown",button.toUpperCase())).isTrue();
                break;
            case "DEPART":
                Assertions.assertThat(airportTable.departTripButton.isDisplayed()).as(f("%s button is shown",button.toUpperCase())).isTrue();
                break;
            case "COMPLETED":
                Assertions.assertThat(airportTable.completedTrackText.isDisplayed()).as(f("%s text is shown",button.toUpperCase())).isTrue();
                break;
            case "CANCELLED":
                Assertions.assertThat(airportTable.cancelledTrackText.isDisplayed()).as(f("%s text is shown",button.toUpperCase())).isTrue();
                break;
        }
    }

    public void CompleteTripAndVerifyItems() {
        airportTable.completeTripButton.waitUntilClickable();
        airportTable.completeTripButton.click();
        tripDepartureArrivalModal.waitUntilVisible();
        tripDepartureArrivalModal.confirmTrip.waitUntilClickable();
        Assertions.assertThat(tripDepartureArrivalModal.PageMessage.isDisplayed())
                .as("Trip Arrival message appear in Trip Completion page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.originFacility.isDisplayed())
                .as("Origin Facility appear in Trip Completion page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.destinationFacility.isDisplayed())
                .as("Destination Facility appear in Trip Completion page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDepartureTime.isDisplayed())
                .as("Expected Departure Time appear in Trip Completion page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDuration.isDisplayed())
                .as("Expected Duration appear in Trip Completion page").isTrue();
        tripDepartureArrivalModal.confirmTrip.click();
        pause1s();
    }

    public void CancelTripAndVerifyItems(){
        airportTable.clickActionButton(1,ACTION_DELETE);
        tripDepartureArrivalModal.waitUntilVisible();
        Assertions.assertThat(tripDepartureArrivalModal.PageMessage.isDisplayed())
                .as("Trip Arrival message appear in Trip Cancelled page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.originFacility.isDisplayed())
                .as("Origin Facility appear in Trip Cancelled page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.destinationFacility.isDisplayed())
                .as("Destination Facility appear in Trip Cancelled page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDepartureTime.isDisplayed())
                .as("Expected Departure Time appear in Trip Cancelled page").isTrue();
        Assertions.assertThat(tripDepartureArrivalModal.expectedDuration.isDisplayed())
                .as("Expected Duration appear in Trip Cancelled page").isTrue();
    }

    public static class AssignDriversToTripModal extends AntModal {

        public AssignDriversToTripModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-col' and contains(text(),'Assign')]")
        public PageElement PageMessage;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Origin Facility']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement originFacility;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Destination Facility']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement destinationFacility;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Expected Departure Time']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement expectedDepartureTime;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Expected Duration']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement expectedDuration;

        @FindBy(xpath = "//button[.='Add Driver']")
        public Button addDriver;

        @FindBy(xpath = "//button[.='Add Driver' and @disabled]")
        public Button disabledAddDriver;

        @FindBy(xpath = "//div[contains(@class, 'remove-link')]")
        public Button removeDriver;

        @FindBy(xpath = "//button[.='Unassign All']")
        public Button unassignAllDrivers;

        @FindBy(xpath = "//button[.='Save']")
        public Button saveButton;
    }

    public void AssignDriversAndVerifyItems(){
        airportTable.clickActionButton(1,ACTION_ASSIGN_DRIVER);
        assignDriversToTripModal.waitUntilVisible();
        Assertions.assertThat(assignDriversToTripModal.PageMessage.isDisplayed())
                .as("Trip Arrival message appear in Assign Driver popup").isTrue();
        Assertions.assertThat(assignDriversToTripModal.originFacility.isDisplayed())
                .as("Origin Facility appear in Assign Driver popup").isTrue();
        Assertions.assertThat(assignDriversToTripModal.destinationFacility.isDisplayed())
                .as("Destination Facility appear in Assign Driver popup").isTrue();
        Assertions.assertThat(assignDriversToTripModal.expectedDepartureTime.isDisplayed())
                .as("Expected Departure Time appear in Assign Driver popup").isTrue();
        Assertions.assertThat(assignDriversToTripModal.expectedDuration.isDisplayed())
                .as("Expected Duration appear in Assign Driver popupe").isTrue();
    }

    public void selectMultipleDrivers(Map<String, String> resolvedMapOfData, List<Driver> middleMileDrivers){
        int numberOfDrivers = Integer.parseInt(resolvedMapOfData.get("assignDrivers"));
        int maxAssignDrivers = numberOfDrivers > 4 ? 4 : numberOfDrivers;
        for (int i = 0; i < maxAssignDrivers; i++) {
            assignDriversToTripModal.addDriver.click();
            TestUtils.findElementAndClick(f(AIRPORT_TRIP_PAGE_ASSIGN_DRIVER_XPATH, i), "xpath", getWebDriver());
            sendKeysAndEnter(f(AIRPORT_TRIP_PAGE_ASSIGN_DRIVER_XPATH, i), middleMileDrivers.get(i).getUsername());
        }
        if (numberOfDrivers > maxAssignDrivers) {
            assignDriversToTripModal.disabledAddDriver.isDisplayed();
        }
    }

    public void verifyInvalidDriver(String driverUsername) {
        int i = 0;
        TestUtils.findElementAndClick(f(AIRPORT_TRIP_PAGE_ASSIGN_DRIVER_XPATH, i), "xpath", getWebDriver());
        sendKeys(f(AIRPORT_TRIP_PAGE_ASSIGN_DRIVER_XPATH, i), driverUsername);
        Assertions.assertThat(
                        isElementExist(f(AIRPORT_TRIP_PAGE_DROPDOWN_LIST_XPATH, driverUsername), 1L))
                .as("Invalid Driver has not been displayed").isFalse();
    }

    public void verifySuccessUnassignAllDrivers(String message) {
        antNotificationMessage.waitUntilVisible();
        String actualMessage = getAntTopTextV2();
        Assertions.assertThat(actualMessage).as("Message is the same").isEqualTo(message);

    }

    public void SaveAssignDriver(){
        assignDriversToTripModal.saveButton.click();
    }

    public void verifyAirportTripDetailPageItem(String pageName, String tripId) {
        switch (pageName){
            case "ToFrom Airport Trip":
                waitUntilVisibilityOfElementLocated(AIRPORT_TRIP_DETAIL_PAGE_TRIP_ID_XPATH);
                String actualToFromTripId = getText(AIRPORT_TRIP_DETAIL_PAGE_TRIP_ID_XPATH);
                Assertions.assertThat(actualToFromTripId).as("Trip ID is correct").contains(tripId);
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Status"), 5)).as("Trip Status appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Origin Facility"), 5)).as("Origin Facility appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Destination Facility"), 5)).as("Destination Facility appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Expected Departure Date Time"), 5)).as("Expected Departure Date Time appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Expected Duration Time"), 5)).as("Expected Duration Time appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Actual Departure Time"), 5)).as("Actual Departure Time appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Actual Arrival Time"), 5)).as("Actual Arrival Time appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Shipments"), 5)).as("Shipments appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Parcels"), 5)).as("Parcels appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Trip Password"), 5)).as("Trip Password appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_DRIVER_XPATH, 5)).as("Driver appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_COMMENTS_XPATH, 5)).as("Comments appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isClickable(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Trip Events"), 5)).as("Trip Events tab appear in To From Airport Trip details page").isTrue();
                Assertions.assertThat(isClickable(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Shipments"), 5)).as("Shipments tab appear in To From Airport Trip details page").isTrue();
                break;
            case "Flight Trip":
                waitUntilVisibilityOfElementLocated(AIRPORT_TRIP_DETAIL_PAGE_TRIP_ID_XPATH);
                String actualFlightTripId = getText(AIRPORT_TRIP_DETAIL_PAGE_TRIP_ID_XPATH);
                Assertions.assertThat(actualFlightTripId).as("Trip ID is correct").contains(tripId);
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Status"), 5)).as("Trip Status appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Origin Facility"), 5)).as("Origin Facility appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Destination Facility"), 5)).as("Destination Facility appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Expected Flight Departure Date Time"), 5)).as("Expected Flight Departure Date Time appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Expected Duration Time"), 5)).as("Expected Duration Time appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Processing Time at Origin Airport"), 5)).as("Processing Time At Origin Airport appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Processing Time at Destination Airport"), 5)).as("Processing Time At Destination Airport appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Actual Departure Time"), 5)).as("Actual Departure Time appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Actual Arrival Time"), 5)).as("Actual Arrival Time appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Parcels"), 5)).as("Parcels appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Trip Password"), 5)).as("Trip Password appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_BODY_XPATH, "Flight Number"), 5)).as("Flight Number appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isElementVisible(TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_COMMENTS_XPATH, 5)).as("Comments appear in Airport Flight Trip details page").isTrue();
                Assertions.assertThat(isClickable(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Trip Events"), 5)).as("Trip Events tab appear in Airport Flight Trip details page").isTrue();
                break;
        }
    }

    public void verifyAssignDriverItemsOnTripDetail() {
        assignDriversToTripModal.waitUntilVisible();
        Assertions.assertThat(isElementVisible(TO_FROM_AIRPORT_TRIP_ASSIGN_DRIVER_PAGE_MESSAGE_XPATH, 5)).as("Assign Driver message appear in Assign Driver popup To From Airport Trip Details page").isTrue();
        Assertions.assertThat(isElementVisible(f(TO_FROM_AIRPORT_TRIP_ON_ASSIGN_DRIVER_POPUP_XPATH, "Origin Facility"), 5)).as("Origin Facility appear in Assign Driver popup To From Airport Trip Details page").isTrue();
        Assertions.assertThat(isElementVisible(f(TO_FROM_AIRPORT_TRIP_ON_ASSIGN_DRIVER_POPUP_XPATH, "Destination Facility"), 5)).as("Destination Facility appear in Assign Driver popup To From Airport Trip Details page").isTrue();
        Assertions.assertThat(isElementVisible(f(TO_FROM_AIRPORT_TRIP_ON_ASSIGN_DRIVER_POPUP_XPATH, "Expected Departure Time"), 5)).as("Expected Departure Time appear in Assign Driver popup To From Airport Trip Details page").isTrue();
        Assertions.assertThat(isElementVisible(f(TO_FROM_AIRPORT_TRIP_ON_ASSIGN_DRIVER_POPUP_XPATH, "Expected Duration"), 5)).as("Expected Duration appear in Assign Driver popup To From Airport Trip Details page").isTrue();
    }

    public void verifyAssignDriverFieldNotAppearInAirportFlightTripDetail() {
        Assertions.assertThat(isElementVisible(TO_FROM_AIRPORT_TRIP_DETAIL_PAGE_DRIVER_XPATH, 5)).as("Driver field doesn't appear in Airport Flight Trip details page").isFalse();
    }

    public void verifyTabElementOnAirportTripDetailsPage(String tabName) {
        switch (tabName) {
            case "Trip Events":
                waitUntilVisibilityOfElementLocated(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Trip Events"));
                findElementByXpath(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Trip Events")).click();
                WebElement tripEventsTableBody = findElementByXpath(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_TABLE_BODY_XPATH, "events"));
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "created-at"), 5)).as("Time appear in Trip Events tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "event"), 5)).as("Event appear in Trip Events tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "status"), 5)).as("Status appear in Trip Events tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "hub-name"), 5)).as("Inbound Hub appear in Trip Events tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "user-id"), 5)).as("User ID appear in Trip Events tab table").isTrue();
                executeScript("arguments[0].scrollLeft = arguments[0].offsetWidth;", tripEventsTableBody);
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "distance"), 5)).as("Distance appear in Trip Events tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "approver"), 5)).as("Approver appear in Trip Events tab table").isTrue();
                break;
            case "Shipments":
                waitUntilVisibilityOfElementLocated(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Shipments"));
                findElementByXpath(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_XPATH, "Shipments")).click();
                WebElement shipmentsTableBody = findElementByXpath(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_TABLE_BODY_XPATH, "shipments"));
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "shipment-id"), 5)).as("Shipment ID appear in Shipments tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "origin-hub-name"), 5)).as("Origin Hub appear in Shipments table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "last-inbound-hub-name"), 5)).as("Last Inbound Hub appear in Shipments tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "destination-hub-name"), 5)).as("Destination Hub appear in Shipments tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "shipment-type"), 5)).as("Shipment Type appear in Shipments tab table").isTrue();
                executeScript("arguments[0].scrollLeft = arguments[0].offsetWidth;", shipmentsTableBody);
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "shipment-status"), 5)).as("Status appear in Shipments tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "sla"), 5)).as("SLA appear in Shipments tab table").isTrue();
                Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAIL_PAGE_TAB_ELEMENT_XPATH, "orders-count"), 5)).as("Parcels appear in Shipments tab table").isTrue();
                break;
        }
    }

    public void verifyTripStatusOnAirportTripDetailsPage(String tripStatus) {
        waitUntilVisibilityOfElementLocated(f(AIRPORT_TRIP_DETAILS_PAGE_STATUS_XPATH, tripStatus));
        Assertions.assertThat(isElementVisible(f(AIRPORT_TRIP_DETAILS_PAGE_STATUS_XPATH, tripStatus), 5)).as("Trip Status appear in Airport Trip Management page").isTrue();
    }

    public void verifyActionsButtonIsDisabledOnAirportTripPage(String actionsButton) {
        switch (actionsButton) {
            case "Assign Driver":
                Assertions.assertThat(isElementVisible(f(ACTION_DISABLED_BUTTON, 1, "assign-driver-icon"), 5)).as("Assign Driver button is disabled on Airport Trip page").isTrue();
                break;
            case "Assign MAWB":
                Assertions.assertThat(isElementVisible(f(ACTION_DISABLED_BUTTON, 1, "assign-mawb-button"), 5)).as("Assign MAWB button is disabled on Airport Trip page").isTrue();
                break;
        }
    }

    public static class AssignMawbModal {
        public AssignMawbModal(WebDriver webDriver) {
            super();
            PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
        }

        public static final String MAWB_CHECKBOX_XPATH = "//td[text()='%s']//preceding-sibling::td[contains(@class,'ant-table-selection-column')]//input[@class='ant-checkbox-input']";
        public static final String mawbSelectedMessage = "//div[text()='Selected %s MAWB, %s Booked Pcs, %s Booked Weight, %s Book Volume']";

        @FindBy(xpath = "//span[text()='Flight Trip Origin - Destination Airport']/ancestor::div[@class='ant-col']")
        public PageElement flightTripAirports;

        @FindBy(xpath = "//label[text()='MAWB Origin - Destination Airport']//ancestor::div[@class = 'ant-row ant-form-item']//input")
        public PageElement mawbAirports;

        @FindBy(xpath = "//strong[text()= 'Search Unassigned MAWB to Assign to Flight Trip']")
        public PageElement searchUnassignedMawb;

        @FindBy(id = "vendor")
        public PageElement mawbVendor;

        @FindBy(xpath = "//div[@class='ant-modal-content']//span[text()='Expected Duration']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement expectedDuration;

        @FindBy(css = "[data-testid = 'assign-to-trip-button']")
        public Button assignToTrip;

        @FindBy(xpath = "//div[@class='ant-typography ant-typography-danger']")
        public Button warningMessage;

        @FindBy(css = "[data-testid = 'find-mawb-button']")
        public Button findMAWB;

    }

    public void verifyAssignedMawbPage(){
        backButton.waitUntilVisible();
        Assertions.assertThat(assignMawbModal.flightTripAirports.isDisplayed()).as("Flight Trip Origin - Destination Airport is display").isTrue();
        Assertions.assertThat(assignMawbModal.mawbAirports.isDisplayed()).as("MAWB Origin - Destination Airport is display").isTrue();
        Assertions.assertThat(assignMawbModal.searchUnassignedMawb.isDisplayed()).as("Search Unassigned MAWB to Assign to Flight Trip is display").isTrue();
        Assertions.assertThat(assignMawbModal.mawbVendor.isDisplayed()).as("MAWB Vendor is display").isTrue();
        Assertions.assertThat(assignMawbModal.assignToTrip.isDisplayed()).as("Assign to Trip is display").isTrue();
        Assertions.assertThat(assignMawbModal.assignToTrip.getAttribute("disabled")).as("Assign to Trip is disable").isEqualTo("true");
    }

    public void assignMawb(String vendor, String mawb){
        backButton.waitUntilVisible();
        assignMawbModal.mawbVendor.sendKeys(vendor);
        assignMawbModal.mawbVendor.sendKeys(Keys.ENTER);
        assignMawbModal.findMAWB.waitUntilClickable();
        assignMawbModal.findMAWB.click();
        spinner.waitUntilInvisible();
        findElementByXpath(f(assignMawbModal.MAWB_CHECKBOX_XPATH,mawb)).click();
        assignMawbModal.assignToTrip.waitUntilClickable();
        Assertions.assertThat(assignMawbModal.warningMessage.isDisplayed()).as("Warning message is display").isTrue();
        assignMawbModal.assignToTrip.click();
        pause500ms();
    }

    public void verifyAssignMawbSuccessMessage(){
        String message = getAntTopText();
        Assertions.assertThat(message).as("Message is the same").isEqualTo("Successfully assigned MAWB.");
    }

}
