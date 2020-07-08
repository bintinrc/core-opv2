package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.hub.trip_management.MovementTripType;
import co.nvqa.commons.util.NvLogger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tristania Siagian
 */

public class TripManagementPage extends OperatorV2SimplePage {

    private static final String IFRAME_TRIP_MANAGEMENT_XPATH = "//iframe[contains(@src,'trip-management')]";
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
    private static final String TAB_XPATH = "//span[span[text()='%s']]";
    private static final String IN_TABLE_FILTER_INPUT_XPATH = "//th[contains(@class,'%s')]//span[contains(@class,'input-prefix')]/following-sibling::input";
    private static final String FIRST_ROW_RESULT_XPATH = "//td[contains(@class,'%s')]//mark";
    private static final String IN_TABLE_FILTER_RESULT_XPATH = "//td[contains(@class,'%s')]//mark[text()='%s']";

    private static final String ID_CLASS = "id";
    private static final String ORIGIN_HUB_CLASS = "originHub";
    private static final String DESTINATION_HUB_CLASS = "destinationHub";
    private static final String DRIVER_CLASS = "driver";

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

    public void searchAndVerifiesTripManagementIsExisted(Long tripManagementId) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_TRIP_MANAGEMENT_XPATH));
        waitUntilVisibilityOfElementLocated(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS));
        sendKeys(f(IN_TABLE_FILTER_INPUT_XPATH, ID_CLASS), tripManagementId.toString());
        waitUntilVisibilityOfElementLocated(f(FIRST_ROW_RESULT_XPATH, ID_CLASS));

        String actualTripManagementId = getText(f(IN_TABLE_FILTER_RESULT_XPATH, ID_CLASS, tripManagementId.toString()));
        assertEquals("Trip Management ID", tripManagementId.toString(), actualTripManagementId);

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
        isElementExistFast(NO_RESULT_XPATH);
    }
}
