package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.commons.model.sort.hub.MawbEvent;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;

import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.MAWBmanagementPage.amwbTableModal.*;

/**
 * @author Son Ha
 */

public class MAWBmanagementPage extends SimpleReactPage<MAWBmanagementPage>{
    private static final Logger LOGGER = LoggerFactory.getLogger(MAWBmanagementPage.class);

    public MAWBmanagementPage(WebDriver webDriver) {
        super(webDriver);
        mawbtable = new MAWBmanagementPage.amwbTableModal(webDriver);
        mawbEventsTable = new MawbEventsTable(webDriver);
    }
    public amwbTableModal mawbtable;
    public MawbEventsTable mawbEventsTable;
    private static final String MAWB_MANAGEMENR_SEARCH_HEADER_XPATH = "//h4[text() = '%s']";
    private static final String MAWB_MANAGEMENR_CLEAR_BUTTON_XPATH = "//input[@id='%s']/ancestor::div[@class='ant-select-selector']/following-sibling::span[@class ='ant-select-clear']";
    private static final String MAWB_MANAGEMENR_PAGE_ERRORS_XPATH = "//input[@id='%s']/ancestor::div[@class='ant-form-item-control-input']//following-sibling::div/div[@class='ant-form-item-explain-error']";
    private static final String MAWB_MANIFEST_UPLOAD_FILE_INFOR = "//div[@class='ant-upload-list-item-info']//a[contains(@title,'%s')]";
    private static final String TOAST_ERROR_MESSAGES_XPATH = "//div[contains(@class,'ant-notification-notice ant-notification-notice-error')]//span[normalize-space(.)]";
    private static final String searchByMAWBTextBoxId = "search-by-mawb-ref-form_searchMawbRefs";
    private static final String searchByVendor_mawbVendorId = "search-by-vendor-form_mawbVendor";
    private static final String searchByVendor_mawbOriginAirportId = "search-by-vendor-form_mawbOriginAirport";
    private static final String searchByVendor_mawbDestinationAirportId = "search-by-vendor-form_mawbDestinationAirport";
    private static final String searchByVendor_flightTripDepartureDateId = "search-by-vendor-form_flightTripDepartureDate";
    private static final String searchByFlight_flightNumberId = "search-by-flight-form_flightNumber";
    private static final String searchByFlight_flightTripDepartureDateId = "search-by-flight-form_flightTripDepartureDate";

    private static final String FILEPATH = TestConstants.TEMP_DIR;

    @FindBy(xpath = "//span[@class='ant-typography']")
    public PageElement searchMAWBtextInfor;

    @FindBy(id = searchByMAWBTextBoxId)
    public TextBox searchByMAWBTextBox;

    @FindBy(id = searchByVendor_mawbOriginAirportId)
    public TextBox mawbOriginAirportTextBox;

    @FindBy(id = searchByVendor_mawbVendorId)
    public TextBox mawbVendorTextBox;

    @FindBy(id = searchByVendor_mawbDestinationAirportId)
    public TextBox mawbDestinationAirportTextBox;

    @FindBy(id = searchByVendor_flightTripDepartureDateId)
    public TextBox flightTripDepartureDateTextBox;

    @FindBy(id = searchByFlight_flightNumberId)
    public TextBox flightNumberTextBox;

    @FindBy(id = searchByFlight_flightTripDepartureDateId)
    public TextBox searchByFlight_flightTripDepartureDateTextBox;
    @FindBy(css = "[data-testid = 'mawb-counter']")
    public PageElement mawbCounter;

    @FindBy(css = "[data-testid = 'search-by-mawb-button']")
    public Button searchByMAWBbutton;

    @FindBy(css = "[data-testid = 'search-by-flight-button']")
    public Button searchByFlightbutton;

    @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-modal-confirm-content']")
    public PageElement ErrorMessage;

    @FindBy(xpath = "//button[@data-testid='result-error-close-button']//span")
    public Button closeButton;

    @FindBy(css = "[data-testid = 'search-by-vendor-button']")
    public Button searchByVendorButton;

    @FindBy(className = "ant-modal-wrap")
    public RecordOffloadModal recordOffload;

    @FindBy(xpath ="//div[contains(@class,'ant-notification-notice ant-notification-notice-error')]")
    public PageElement noticeErrorMessage;

    @FindBy(className = "ant-modal-wrap")
    public ManifestMAWBModal manifestModal;

    public void switchToOtherWindow() {
        waitUntilNewWindowOrTabOpened();
        Set<String> windowHandles = getWebDriver().getWindowHandles();

        for (String windowHandle : windowHandles) {
            getWebDriver().switchTo().window(windowHandle);
        }
    }

    public void verifySearchByMawbUI(){
        waitUntilVisibilityOfElementLocated(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by MAWB Number"));
        Assertions.assertThat(findElementByXpath(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by MAWB Number")).isDisplayed())
                .as("Search by MAWB Number Header is display").isTrue();
        String textInfor = "*A maximum of 100 MAWB numbers can be processed at a time. Each MAWB number should be separated with a new line.";
        Assertions.assertThat(searchMAWBtextInfor.getText()).as("Text infor is the same").isEqualTo(textInfor);
        Assertions.assertThat(searchByMAWBTextBox.isDisplayed()).as("Search by MAWB Textbox is display").isTrue();
        Assertions.assertThat(searchByMAWBTextBox.getAttribute("placeholder")).as("Enter MAWB number text is display").isEqualTo("Enter MAWB Number");
        mawbCounter.waitUntilVisible();
        Assertions.assertThat(mawbCounter.getText()).as("counter is zero").contains("0 entered");
        Assertions.assertThat(searchByMAWBbutton.getAttribute("disabled")).as("Search by MAWB button is disable").isEqualTo("true");
    }

    public void verifySearchByVendorUI(){
        waitUntilVisibilityOfElementLocated(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by Vendor"));
        Assertions.assertThat(findElementByXpath(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by Vendor")).isDisplayed())
                .as("Search by Vendor Header is display").isTrue();
        Assertions.assertThat(mawbVendorTextBox.isDisplayed()).as("MAWB Vendor dropdown is display").isTrue();
        Assertions.assertThat(mawbOriginAirportTextBox.isDisplayed()).as("MAWB Origin Airport dropdown is display").isTrue();
        Assertions.assertThat(mawbDestinationAirportTextBox.isDisplayed()).as("MAWB Destination Airport dropdown is display").isTrue();
        Assertions.assertThat(flightTripDepartureDateTextBox.isDisplayed()).as("Flight Trip Departure Date dropdown is display").isTrue();
        Assertions.assertThat(searchByVendorButton.getAttribute("disabled")).as("Search by Vendor button is disable").isEqualTo("true");
    }

    public void verifySearchByFlightUI(){
        waitUntilVisibilityOfElementLocated(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by Flight"));
        Assertions.assertThat(findElementByXpath(f(MAWB_MANAGEMENR_SEARCH_HEADER_XPATH,"Search by Flight")).isDisplayed())
            .as("Search by Flight Header is display").isTrue();
        Assertions.assertThat(flightNumberTextBox.isDisplayed()).as("Flight number is display").isTrue();
        Assertions.assertThat(searchByFlight_flightTripDepartureDateTextBox.isDisplayed()).as("Flight Trip Departure Date dropdown is display").isTrue();
        Assertions.assertThat(searchByFlightbutton.getAttribute("disabled")).as("Search by Flight button is disable").isEqualTo("true");
    }

    public void addShipmentToSearchBox(List<String> listMAWBs){
        searchByMAWBTextBox.click();
        listMAWBs.forEach((id) -> {
            searchByMAWBTextBox.sendKeys(id);
            searchByMAWBTextBox.sendKeys(Keys.RETURN);
        });
        verifyMAWBCounterAfterInputMAWB(listMAWBs);
        verifySearchByMAWBbuttonIsEnable();
    }

    public void verifyMAWBCounterAfterInputMAWB(List<String> listMAWBs){
        String expected ="";
        // we can also use Function.identity() instead of c->c
        Map<String ,Long > map = listMAWBs.stream()
                .collect( Collectors.groupingBy(c ->c , Collectors.counting())); ;

        AtomicReference<Long> duplicatedCount = new AtomicReference<>(0L);
        map.forEach((k , v ) -> duplicatedCount.set(duplicatedCount.get() + v - 1));

        if (duplicatedCount.get()>0)
            expected = f("%s entered (%s duplicate)",Integer.toString(map.size()),Long.toString(duplicatedCount.get()));
         else
            expected = f("%s entered",Integer.toString(map.size()));

        Assertions.assertThat(mawbCounter.getText().trim()).as("counter is the same").isEqualTo(expected);

    }

    public void verifySearchByMAWBbuttonIsEnable(){
        Assertions.assertThat(searchByMAWBbutton.getAttribute("disabled")).as("Search by MAWB button is enable").isEqualTo(null);
    }

    public static class amwbTableModal extends AntTableV3<AirTrip> {


        public static final String COLUMN_MAWB = "mawb_ref";
        public static final String COLUMN_STATUS = "status";
        public static final String COLUMN_VENDOR_NAME = "vendor_name";
//        public static final String COLUMN_NO = "_counter";
        public static final String ACTION_OFFLOAD = "Offload";
        public static final String ACTION_DETAILS = "Details";
        public amwbTableModal(WebDriver webDriver) {
            super(webDriver);
            setColumnLocators(
                    ImmutableMap.<String, String>builder().put(COLUMN_MAWB, "mawb")
                            .put(COLUMN_STATUS, "status")
                            .put(COLUMN_VENDOR_NAME, "vendor_name").build());
            setActionButtonLocatorTemplate(
                    "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(text(),'%s')]");
            setActionButtonsLocators(
                    ImmutableMap.of(
                            ACTION_DETAILS, "View Details",
                            ACTION_OFFLOAD, "Record Offload"));
        }

        @FindBy(css = "[data-testid='back-to-filter-button']")
        public Button backToFilter;

        @FindBy(xpath = "//span[contains(@class,'table-stats')]/div")
        public PageElement TotalSearchResult;

        @FindBy(xpath = "//button[@class='ant-btn ant-btn-primary']")
        public PageElement ManifestButton;

        @FindBy(xpath ="//span[text()='Reload Search']")
        public Button reloadButton;

        @FindBy(xpath ="//button[@class='ant-btn']//span[@class='anticon anticon-sync anticon-spin']")
        public PageElement reloadSpin;

        @FindBy(xpath = "//button//span[contains(text(),'Manifest MAWB')]")
        public PageElement manifestButton;

        public void VerifySearchResultPage(){
            String LIST_OF_MAWB_ELEMENTS = "//div[contains(@class,'table-container')]//table//tr//th[contains(@class,'%s')]";
            backToFilter.waitUntilVisible();
            Assertions.assertThat(backToFilter.isDisplayed()).as("Back button is shown").isTrue();
            Assertions.assertThat(TotalSearchResult.isDisplayed()).as("Total result is shown").isTrue();
            Assertions.assertThat(ManifestButton.isDisplayed()).as("Manifest button is shown").isTrue();

            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"_counter")).isDisplayed()).as("No. column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"mawb_ref")).isDisplayed()).as("MAWB column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"status")).isDisplayed()).as("MAWB Status column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"vendor_name")).isDisplayed()).as("Vendor column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"origin_airport_code")).isDisplayed()).as("Origin Airport column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"destination_airport_code")).isDisplayed()).as("Destination Airport column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"flight_no")).isDisplayed()).as("Flight Number column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"flight_date_time")).isDisplayed()).as("Flight Date Time column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"total_shipments")).isDisplayed()).as("Booked Pcs column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"total_weight")).isDisplayed()).as("Booked Weight column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"total_kgv")).isDisplayed()).as("Booked Volume column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"total_shipments_offload")).isDisplayed()).as("Pcs of Offload column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"pcs_of_unscanned")).isDisplayed()).as("Pcs of unscanned column is shown").isTrue();
            Assertions.assertThat(findElementByXpath(f(LIST_OF_MAWB_ELEMENTS,"_checkbox fixed")).isDisplayed()).as("Checkbox select ALl column is shown").isTrue();

        }
        public List<String> ListOfItems(String xpath) {
            List<WebElement> ListOfElements = findElementsByXpath(xpath);
            List<String> Items = new ArrayList<>();
            ListOfElements.forEach(element -> {
                Items.add(element.getText().trim());
            });
            return Items;
        }

        public void verifyTotalSearchRecord(String expectedResult){
            Assertions.assertThat(TotalSearchResult.getText()).as("Total result is the same").isEqualTo(expectedResult);
        }
    }

    public void waitWhileTableIsLoading() {
        Wait<MAWBmanagementPage.amwbTableModal> fWait = new FluentWait<>(mawbtable)
                .withTimeout(Duration.ofSeconds(20))
                .pollingEvery(Duration.ofSeconds(1))
                .ignoring(NoSuchElementException.class);
        fWait.until(table -> table.getRowsCount() > 0);
    }

    public void filterMAWB(String mawb) {
        mawbtable.filterByColumn(COLUMN_MAWB, mawb);
        waitWhileTableIsLoading();
        mawbtable.clickActionButton(1,ACTION_OFFLOAD);
    }
    public void verifyErrorMessage(String expectedMessage){
        ErrorMessage.waitUntilVisible();
        Assertions.assertThat(ErrorMessage.getText()).as("Error message is the same").isEqualTo(expectedMessage);
        Assertions.assertThat(closeButton.isDisplayed()).as("Go back or Confirm button is displayed").isTrue();
    }

    public void SearchByVendorInputData(Map<String,String> resolvedMapOfData){

        if(resolvedMapOfData.get("mawbVendor") !=null){
            mawbVendorTextBox.click();
            sendKeysAndEnterById(searchByVendor_mawbVendorId, resolvedMapOfData.get("mawbVendor"));
        }
        if(resolvedMapOfData.get("mawbOriginAirport") !=null){
            mawbOriginAirportTextBox.click();
            sendKeysAndEnterById(searchByVendor_mawbOriginAirportId, resolvedMapOfData.get("mawbOriginAirport"));
        }
        if(resolvedMapOfData.get("mawbDestinationAirport") !=null){
            mawbDestinationAirportTextBox.click();
            sendKeysAndEnterById(searchByVendor_mawbDestinationAirportId, resolvedMapOfData.get("mawbDestinationAirport"));
        }
        if(resolvedMapOfData.get("flightTripDepartureDate") !=null){
            flightTripDepartureDateTextBox.click();
            sendKeysAndEnterById(searchByVendor_flightTripDepartureDateId, resolvedMapOfData.get("flightTripDepartureDate"));
        }
    }

    public void SearchByFlightInputData(Map<String,String> resolvedMapOfData){

        if(resolvedMapOfData.get("flight_no") !=null){
            flightNumberTextBox.click();
            sendKeysAndEnterById(searchByFlight_flightNumberId, resolvedMapOfData.get("flight_no"));
        }
        if(resolvedMapOfData.get("flightTripDepartureDate") !=null){
            searchByFlight_flightTripDepartureDateTextBox.click();
            sendKeysAndEnterById(searchByFlight_flightTripDepartureDateId, resolvedMapOfData.get("flightTripDepartureDate"));
        }
    }

    public void clearTextonField(String fieldName){
        String MAWB_MANAGEMENT_DEPARTURE_DATE_CLEAR_XPATH= "//input[@id='search-by-vendor-form_flightTripDepartureDate']/following-sibling::span[contains(@class ,'clear')]";
        String SEARCH_BY_FLIGHT_DEPARTURE_DATE_CLEAR_XPATH= "//input[@id='search-by-flight-form_flightTripDepartureDate']/following-sibling::span[contains(@class ,'clear')]";

        switch (fieldName){
            case "MAWB Vendor":
                findElementByXpath(f(MAWB_MANAGEMENR_CLEAR_BUTTON_XPATH,searchByVendor_mawbVendorId)).click();
                break;
            case "MAWB Origin Airport":
                findElementByXpath(f(MAWB_MANAGEMENR_CLEAR_BUTTON_XPATH,searchByVendor_mawbOriginAirportId)).click();
                break;
            case "MAWB Destination Airport":
                findElementByXpath(f(MAWB_MANAGEMENR_CLEAR_BUTTON_XPATH,searchByVendor_mawbDestinationAirportId)).click();
                break;
            case "Flight Trip Departure Date":
                findElementByXpath(MAWB_MANAGEMENT_DEPARTURE_DATE_CLEAR_XPATH).click();
                break;
            case "Flight Number":
                flightNumberTextBox.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));;
                break;
            case "Search by Flight_Flight Trip Departure Date":
                findElementByXpath(SEARCH_BY_FLIGHT_DEPARTURE_DATE_CLEAR_XPATH).click();

        }
    }

    public void verifyMandatoryFieldErrorMessageMAWBPage(String fieldName){
        String actualMessage ="";
        String expectedMessage = "Please enter "+fieldName;
        switch (fieldName){
            case "MAWB Vendor":
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByVendor_mawbVendorId)).getText();
                break;
            case "MAWB Origin Airport":
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByVendor_mawbOriginAirportId)).getText();
                break;
            case "MAWB Destination Airport":
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByVendor_mawbDestinationAirportId)).getText();
                break;
            case "Flight Trip Departure Date":
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByVendor_flightTripDepartureDateId)).getText();
                break;
            case "Flight Number":
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByFlight_flightNumberId)).getText();
                break;
            case "Search by Flight_Flight Trip Departure Date":
                expectedMessage = "Please enter Flight Trip Departure Date";
                actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,searchByFlight_flightTripDepartureDateId)).getText();
                break;
        }
        Assertions.assertThat(actualMessage).as("Mandatory require error message is the same").isEqualTo(expectedMessage);
    }

    public void verifySearchByVendorbuttonIsEnable(){
        Assertions.assertThat(searchByVendorButton.getAttribute("disabled")).as("Search by Vendor button is enable").isEqualTo(null);
    }

    public static class RecordOffloadModal extends AntModal {

        public RecordOffloadModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }
        public static final String OFFLOAD_REASON_MESSAGE_XPATH = "(//div[@class='ant-select-item-option-content'])[%d]";
        public static final String offloadTotalId = "offloadForm_total_offload";
        public static final String offloadTotalWeightId = "offloadForm_total_offload_weight";
        public static final String offloadNextFlightNoId = "offloadForm_next_flight_no";
        public static final String offloadDepartureTimeId = "offloadForm_next_flight_departure_time";
        public static final String offloadArrivalTimeId = "offloadForm_next_flight_arrival_time";
        public static final String offloadCommentsId = "offloadForm_comments";


        @FindBy(id = offloadTotalId)
        public PageElement OffloadTotal;

        @FindBy(id = offloadTotalWeightId)
        public PageElement OffloadTotalWeight;

        @FindBy(id = offloadNextFlightNoId)
        public PageElement OffloadNextFlightNo;

        @FindBy(id = offloadDepartureTimeId)
        public PageElement OffloadDepartureTime;

        @FindBy(id = offloadArrivalTimeId)
        public PageElement OffloadArrivalTime;

        @FindBy(xpath = "//label[text()='Reasons of Offload']/following::input")
        public TextBox OffloadReasonInput;

        @FindBy(id = offloadCommentsId)
        public PageElement OffloadComments;

        @FindBy(css ="[data-testid = 'update-record-offload-button']")
        public Button OffloadUpdateButton;

        public void selectOffloadReason() {
            // Create random integer from 1 to 7 and click nth option based on it
            String offloadReasonMessage = String.format(OFFLOAD_REASON_MESSAGE_XPATH, new Random().nextInt(6) + 1);
            OffloadReasonInput.click();
            waitUntilElementIsClickable(offloadReasonMessage);
            click(offloadReasonMessage);
        }

    }

    public void fillOffloadData(Map<String,String> data){
        pause300ms();
        recordOffload.OffloadTotal.waitUntilVisible();

        if (data.get("totalOffloadedWeight")!=null){
            recordOffload.OffloadTotalWeight.click();
            sendKeysAndEnterById(recordOffload.offloadTotalWeightId,data.get("totalOffloadedWeight"));
        }
        if (data.get("nextFlight")!=null){
            recordOffload.OffloadNextFlightNo.click();
            sendKeysAndEnterById(recordOffload.offloadNextFlightNoId,data.get("nextFlight"));
        }
        if (data.get("departerTime")!=null){
            recordOffload.OffloadDepartureTime.click();
            sendKeysAndEnterById(recordOffload.offloadDepartureTimeId,data.get("departerTime"));

        }
        if (data.get("arrivalTime")!=null){
            recordOffload.OffloadArrivalTime.click();
            sendKeysAndEnterById(recordOffload.offloadArrivalTimeId,data.get("arrivalTime"));

        }
        if (data.get("comments")!=null){
            recordOffload.OffloadComments.click();
            recordOffload.OffloadComments.sendKeys(data.get("comments"));

        }
        if (data.get("offload_reason")!=null){
            recordOffload.selectOffloadReason();
        }
        recordOffload.OffloadTotal.click();
        recordOffload.OffloadTotal.sendKeys(data.get("totalOffloadedPcs"));
    }

    public void verifyOffloadMessageSuccessful(String expectedMessage){
        retryIfAssertionErrorOrRuntimeExceptionOccurred(()->{
            String actMessage = getAntTopText();
            Assertions.assertThat(actMessage).as("Success message is same").contains(expectedMessage);
        },"Verify MAWB Offload message", 500, 3);
    }

    public void verifyExplainErrorMessage(String expectedMessage, String fieldId){
        String actualMessage = findElementByXpath(f(MAWB_MANAGEMENR_PAGE_ERRORS_XPATH,fieldId)).getText();
        Assertions.assertThat(actualMessage.equalsIgnoreCase(expectedMessage)).as("Error message is the same!").isTrue();
    }

    public void verifyAllRecordOffloadFieldsIsEmpty(){
        Assertions.assertThat(recordOffload.OffloadTotal.getAttribute("value")).as("Total Offloaded pcs is empty").isEqualTo("");
        Assertions.assertThat(recordOffload.OffloadTotalWeight.getAttribute("value")).as("Total Offloaded Weight is empty").isEqualTo("");
        Assertions.assertThat(recordOffload.OffloadNextFlightNo.getAttribute("value")).as("Next Flight Number is empty").isEqualTo("");
        Assertions.assertThat(recordOffload.OffloadDepartureTime.getAttribute("value")).as("Estimated Flight Departure Date & Time is empty").isEqualTo("");
        Assertions.assertThat(recordOffload.OffloadArrivalTime.getAttribute("value")).as("Estimated Flight Arrival Date & Time is empty").isEqualTo("");
        Assertions.assertThat(recordOffload.OffloadComments.getText()).as("Comments is empty").isEqualTo("");
    }

    public static class ManifestMAWBModal extends AntModal{
        public ManifestMAWBModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy (xpath ="//div[text()='Manifest MAWB']")
        public PageElement pageTile;

        @FindBy (xpath = "//button[@class='ant-modal-close']")
        public Button close;

        @FindBy (xpath = "//span[text()='Total Booked Pcs']")
        public PageElement totalBookedPcs;

        @FindBy (xpath = "//span[text()='Total Booked Weight']")
        public PageElement totalBookedWeight;

        @FindBy (xpath = "//span[text()='Total Booked Volume']")
        public PageElement totalBookedVolumn;

        @FindBy(css = "[data-testid = 'upload-manifest-attachment']")
        public FileInput manifestUploadFile;

        @FindBy(xpath = "//div[@class='ant-upload-list-item-progress']")
        public PageElement fileUploadProgress;

        @FindBy(id = "manifest_form_comments")
        public TextBox comments;

        @FindBy(id = "manifest_form_is_aware")
        public PageElement manifestConfirmCheckbox;

        @FindBy(css ="[data-testid = 'submit-manifest-button']")
        public Button submitManifest;
    }

    public void verifyManifestMAWBPage(){
        manifestModal.pageTile.waitUntilVisible();
        Assertions.assertThat(manifestModal.pageTile.isDisplayed()).as("Manifest Page title is display").isTrue();
        Assertions.assertThat(manifestModal.close.isDisplayed()).as("Manifest close button is display").isTrue();
        Assertions.assertThat(manifestModal.totalBookedPcs.isDisplayed()).as("Manifest total Booked Pcs is display").isTrue();
        Assertions.assertThat(manifestModal.totalBookedWeight.isDisplayed()).as("Manifest total Booked Weight is display").isTrue();
        Assertions.assertThat(manifestModal.totalBookedVolumn.isDisplayed()).as("Manifest total Booked Volumn is display").isTrue();
        Assertions.assertThat(manifestModal.comments.isDisplayed()).as("Manifest comments is display").isTrue();
        Assertions.assertThat(manifestModal.submitManifest.isDisplayed()).as("Manifest submit button is display").isTrue();
    }

    public void manifestMAWB(){
        manifestModal.pageTile.waitUntilVisible();
        manifestModal.manifestConfirmCheckbox.click();
        manifestModal.submitManifest.click();
        manifestModal.submitManifest.waitUntilInvisible();
    }
    public void uploadFileOnManifestPage(Long sizeInBytes){
        String FILENAME = RandomStringUtils.randomAlphanumeric(3,8)+".txt";
        String fullPath = FILEPATH+FILENAME;
        createTemporaryFile(fullPath, sizeInBytes);
        pause300ms();
        manifestModal.manifestUploadFile.setValue(fullPath);
        if (sizeInBytes>=10485760){
            String actMessage = getAntTopText();
            Assertions.assertThat(actMessage).as("File must be smaller than 10 MB").isEqualToIgnoringCase("File must be smaller than 10 MB");
        }else {
            waitUntilVisibilityOfElementLocated(f(MAWB_MANIFEST_UPLOAD_FILE_INFOR,FILENAME));
            manifestModal.fileUploadProgress.waitUntilInvisible(30);
            mawbEventsTable.filename = FILENAME;
        }
    }

    private void createTemporaryFile(final String filename, final long sizeInBytes) {
        try{
            File file = new File(filename);
            file.createNewFile();

            RandomAccessFile raf = new RandomAccessFile(file, "rw");
            raf.setLength(sizeInBytes);
            raf.close();
        }catch (Throwable ex) {
            LOGGER.debug("Can not create random file .. !");
            throw new NvTestRuntimeException(ex);
        }
    }

    public void verifyToastErrorMessage(List<String> expectedMessages){

        List<WebElement> ErrorMessagesElement = findElementsByXpath(TOAST_ERROR_MESSAGES_XPATH);

        List<String> actualMessages = new ArrayList<>();
        ErrorMessagesElement.forEach(e -> actualMessages.add(e.getText()));
        Boolean compareResult = expectedMessages.containsAll(actualMessages) && actualMessages.containsAll(expectedMessages);
        Assertions.assertThat(compareResult).as("Error message is the same").isTrue();

    }

    public static class MawbEventsTable extends AntTableV3<MawbEvent> {

        public static final String SOURCE = "source";
        public static final String USER = "user";
        public static final String RESULT = "result";
        public static final String STATUS = "status";
        public static final String WHEN = "when";
        public static final String MAWB_DETAILS_PAGE_ITEMS_XPATH= "//div[@class='ant-card-body']//span[text()='%s']";
        public static final String MANIFEST_ATTACHMENT_XPATH = "//div[@class='ant-upload-list-item-info']//a[@title='%s']";
        public static String filename = "filename";
        public MawbEventsTable(WebDriver webDriver) {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                .put(SOURCE, "source")
                .put(USER, "user-id")
                .put(RESULT, "result")
                .put(STATUS, "status")
                .put(WHEN, "created-at")
                .build());
            setEntityClass(MawbEvent.class);
            setTableLocator("//div[@data-testid='mawb-event-table-table']");
        }

        @FindBy(xpath = "//span[text()='Comments']/ancestor::div[contains(@class,'ant-col')]")
        public PageElement manifestComments;
    }

    public void verifyMAWBDetailsItems(){
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"MAWB")).isDisplayed()).as("MAWB is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"MAWB Status")).isDisplayed()).as("MAWB Status is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Vendor")).isDisplayed()).as("Vendor is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Origin Airport")).isDisplayed()).as("Origin Airport is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Destination Airport")).isDisplayed()).as("Destination Airport is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Booked Pcs")).isDisplayed()).as("Booked Pcs is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Booked Weight")).isDisplayed()).as("Booked Weight is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Booked Volume")).isDisplayed()).as("Booked Volume is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Flight Number")).isDisplayed()).as("Flight Number is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Flight Date Time")).isDisplayed()).as("Flight Date Time is display").isTrue();
        Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MAWB_DETAILS_PAGE_ITEMS_XPATH,"Pcs of Offload")).isDisplayed()).as("Pcs of Offload is display").isTrue();

    }

    public void verifyManifestOnDetailsPage(Map<String,String> data){
        if (data.get("uploadFile")!=null)
            Assertions.assertThat(findElementByXpath(f(mawbEventsTable.MANIFEST_ATTACHMENT_XPATH,mawbEventsTable.filename)).isDisplayed())
                .as("Manifest attachment file is display").isTrue();
        if(data.get("comments")!=null)
            Assertions.assertThat(mawbEventsTable.manifestComments.getText()).as("Comment message is the same").contains(data.get("comments"));


    }

}
