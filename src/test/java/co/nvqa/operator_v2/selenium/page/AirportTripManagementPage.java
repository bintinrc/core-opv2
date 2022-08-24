package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.TestUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * @author Meganathan Ramasamy
 */

public class AirportTripManagementPage extends OperatorV2SimplePage{
    private static final Logger LOGGER = LoggerFactory.getLogger(AirportTripManagementPage.class);

    public AirportTripManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    private static final String LOAD_BUTTON_XPATH = "//button[contains(@class,'ant-btn-primary')]";
    private static final String XPATH_CAL_DEPARTUREDATE = "//div[@class='ant-picker-panels']//td[@title='%s']";
    private static final String XPATH_CAL_DEPARTUREDATE_TD = "//table[@class='ant-picker-content']//td[@title='%s']";
    private static final String XPATH_FACILITIES_INPUT = "//input[@id='facilities']";
    private static final String XPATH_DIV_STARTSWITH_TEMPLATE = "//div[starts-with(.,'%s')]";
    private static final String XPATH_DEPARTURE_DATE_TEXT = "//div[contains(text(), ' - ')][./div[.='Departure Date']]";
    private static final String XPATH_FACILITIES_TEXT = "//span[contains(.,'Destination Facilities')]/parent::div/parent::div";
    private static final String FILTERS_DISABLED_XPATH = "//div[contains(@class,'ant-select-item-option-disabled')]";
    private static final String XPATH_CAL_PREV_MONTH = "//button[@class='ant-picker-header-prev-btn']";
    private static final String XPATH_END_OF_TABLE = "//div[contains(text(),'End of Table') or contains(text(),'No Results Found')]";
    private static final String XPATH_TABLE_NOT_CONTAINS_TD = "//div[contains(@class,'table-container')]//table/tbody//tr/td[%s][not(contains(.,'%s'))]";
    private static final String XPATH_TABLE_FIRST_ROW ="//div[contains(@class,'table-container')]//table/tbody//tr[%s]/td[%s]";
    private static final String XPATH_MANAGE_AIRPORT_FACILITY_LOADING ="//div[@class='ant-spin-container ant-spin-blur']";
    private static final String XPATH_AIRPORT_FACILITY_COUNTRY_TEXT ="//h4[contains(.,'Airport Facility in')]";
    private static final String XPATH_TOTAL_LIST_OF_AIRPORTS ="//h4[contains(.,'Total: ')]";
    private static final String XPATH_LOADED_LIST_OF_AIRPORTS ="//span[contains(.,'Showing %s of %s results')]";
    private static final String XPATH_DIV_TITLE = "//div[@title='%s']";
    private static final String antpickerdropdownhidden = "//div[contains(@class,'ant-picker-dropdown') and not(contains(@class,'ant-picker-dropdown-hidden'))]";
    public String departureTimeXpath = "//div[contains(@class, 'ant-picker-dropdown') and not(contains(@class , 'ant-picker-dropdown-hidden'))]//div[@class='ant-picker-content']//ul[%s]//div[text()= '%s']";

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

    @FindBy(xpath = "//th[contains(@class,'mawb')]//input")
    public PageElement airportMawbFilter;

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
    public PageElement createToFromAirportForm_duration_hours;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_duration-minutes']")
    public PageElement createToFromAirportForm_duration_minutes;

    @FindBy(xpath = "//input[@id='createToFromAirportForm_departureDate']")
    public PageElement createToFromAirportForm_departureDate;

    @FindBy(xpath = "//div[@data-testid='assign-drivers-select']")
    public PageElement createToFromAirportForm_drivers;

    @FindBy(xpath = "//textarea[@id='createToFromAirportForm_comment']")
    public PageElement createToFromAirportForm_comment;

    @FindBy(xpath = "//button[@data-testid='submit-button']")
    public PageElement createToFromAirportForm_submit;

    public static String notificationMessage = "";

    public void verifyAirportTripMovementPageItems() {
        waitUntilVisibilityOfElementLocated("//button[.='Load Trips']");
        Assertions.assertThat(isElementVisible(LOAD_BUTTON_XPATH, 5))
                .as("Load button appear in Airport trip Management page").isTrue();
        Assertions.assertThat(departureInput.isDisplayed())
                .as("Departure input appear in Airport trip Management page").isTrue();
        Assertions.assertThat(isElementEnabled("//button[.='Load Trips']"))
                .as("Load Trips appear in Airport trip Management page").isFalse();
        Assertions.assertThat(isElementVisible("//button[.='Manage Airport Facility']", 5))
                .as("Manage Airport Facility button appear in Airport trip Management page").isTrue();
        Assertions.assertThat(selectFacility.isDisplayed())
                .as("Facilities input appear in Airport trip Management page").isTrue();
    }

    public void fillDepartureDateDetails(Map<String, String> mapOfData) {
        departureInput.click();
        String startDate = DateUtil.getPastFutureDate(mapOfData.get("startDate"), "yyyy-MM-dd");
        String endDate = DateUtil.getPastFutureDate(mapOfData.get("endDate"), "yyyy-MM-dd");
        if(mapOfData.get("startDate").startsWith("D-")){
            click(XPATH_CAL_PREV_MONTH);
        }
        moveToElement(findElementByXpath(f(XPATH_CAL_DEPARTUREDATE, startDate)));
        click(f(XPATH_CAL_DEPARTUREDATE, startDate));
        click(f(XPATH_CAL_DEPARTUREDATE, endDate));
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
        String expDepartDate = DateUtil.getPastFutureDate(mapOfData.get("startDate"), "dd MMMM yyyy") + " - " +
                DateUtil.getPastFutureDate(mapOfData.get("endDate"), "dd MMMM yyyy");
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
        Assertions.assertThat(airportMawbFilter.isDisplayed())
                .as("Mawb Filter appear in Airport trip Management page").isTrue();
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

    public void createNewFlightTrip(Map<String, String> mapOfData) {
        createFlightTrip.click();
        switchToOtherWindow();
        waitUntilPageLoaded();
        switchTo();
        Assertions.assertThat(findElementByXpath("//h3[.='Create Flight Trip']").isDisplayed())
                .as("End Of Table appear in Airport trip Management page").isTrue();
        Assertions.assertThat(findElementByXpath("//input[@id='editForm_originAirport']").isDisplayed())
                .as("End Of Table appear in Airport trip Management page").isTrue();
    }

    public HashMap filterTheAirportTripsTable(String filter, String invalidData) {
        HashMap<String, String> map = new HashMap<>();
        String searchData = "";
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
            case "MAWB":
                map.put("COLUMN_NO", "6");
                searchData = invalidData.equals("") ? findElementByXpath(f(XPATH_TABLE_FIRST_ROW, 1, 6)).getText() : invalidData;
                map.put("FIRST_DATA", searchData);
                airportMawbFilter.click();
                sendKeys(airportMawbFilter.getWebElement(), map.get("FIRST_DATA"));
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
        String actMessage = getAntTopText();
        Assertions.assertThat(actMessage).as("Success message is same").isEqualTo(airportName);
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

    public void verifyTheValidationErrorInAirportCreation(String expError) {
        Assertions.assertThat(validationAlert.getText()).as("Validation error message is same")
                .contains(expError);
        Assertions.assertThat(createOrEditAirportSubmit.isEnabled())
                .as("New airport submit button is disabled").isFalse();
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
        Assertions.assertThat(findElementByXpath("//h3[.='Create To/from Airport Trip']").isDisplayed())
                .as("Create To/from Airport Trip Title is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_originFacility.isDisplayed())
                .as("Origin Facility is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_destinationFacility.isDisplayed())
                .as("Destination facility is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_departureTime.isDisplayed())
                .as("Departure time is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_duration_hours.isDisplayed())
                .as("Duration hours is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_duration_minutes.isDisplayed())
                .as("Duration minutes is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_departureDate.isDisplayed())
                .as("Departure Date is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_drivers.isDisplayed())
                .as("Drivers field is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_comment.isDisplayed())
                .as("Comment field is displayed").isTrue();
        Assertions.assertThat(createToFromAirportForm_submit.isEnabled())
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

        createToFromAirportForm_duration_hours.click();
        TestUtils.findElementAndClick(f(XPATH_DIV_TITLE, mapOfData.get("durationhour")), "xpath", getWebDriver());

        createToFromAirportForm_duration_minutes.click();
        sendKeysAndEnterById("createToFromAirportForm_duration-minutes", mapOfData.get("durationminutes"));


        createToFromAirportForm_departureDate.click();
        String departureDate = DateUtil.getPastFutureDate(mapOfData.get("departureDate"), "yyyy-MM-dd");

        if(mapOfData.get("departureDate").startsWith("D-")){
            click(XPATH_CAL_PREV_MONTH);
        }
        moveToElement(findElementByXpath(f(XPATH_CAL_DEPARTUREDATE_TD, departureDate)));
        click(f(XPATH_CAL_DEPARTUREDATE_TD, departureDate));

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

        createToFromAirportForm_submit.click();
    }

    public void verifyAirportTripCreationSuccessMessage(String message) {
        String actMessage = getAntTopText();
        Assertions.assertThat(actMessage).as("Success message is same").contains(message);
        Assertions.assertThat(findElementByXpath("//a[.='View Details']").isDisplayed()).as("View Details link is visible");
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
}
