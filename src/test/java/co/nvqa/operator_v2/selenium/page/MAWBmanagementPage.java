package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import com.google.common.collect.ImmutableMap;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

/**
 * @author Son Ha
 */

public class MAWBmanagementPage extends OperatorV2SimplePage{
    private static final Logger LOGGER = LoggerFactory.getLogger(MAWBmanagementPage.class);

    public MAWBmanagementPage(WebDriver webDriver) {
        super(webDriver);
        mawbtable = new amwbTableModal(webDriver);
    }
    public amwbTableModal mawbtable;
    private static final String MAWB_MANAGEMENR_SEARCH_HEADER_XPATH = "//h4[text() = '%s']";
    private static final String searchByMAWBTextBoxId = "search-by-mawb-ref-form_searchMawbRefs";


    @FindBy(xpath = "//span[@class='ant-typography']")
    public PageElement searchMAWBtextInfor;

    @FindBy(id = searchByMAWBTextBoxId)
    public TextBox searchByMAWBTextBox;

    @FindBy(css = "[data-testid = 'mawb-counter']")
    public PageElement mawbCounter;

    @FindBy(css = "[data-testid = 'search-by-mawb-button']")
    public Button searchByMAWBbutton;

    @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-modal-confirm-content']")
    public PageElement ErrorMessage;

    @FindBy(xpath = "//button[@data-testid='result-error-close-button']//span")
    public Button closeButton;


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

    public static class amwbTableModal extends AntTableV3 {

        public static final String ACTION_OFFLOAD = "Offload";
        public static final String ACTION_DETAILS = "Details";
        public amwbTableModal(WebDriver webDriver) {
            super(webDriver);
//            setActionButtonLocatorTemplate(
//                    "//tbody/tr[%d]//td[contains(@class,'actions')]//*[contains(text(),'%s')]");
//            setActionButtonsLocators(
//                    ImmutableMap.of(
//                            ACTION_DETAILS, "View Details",
//                            ACTION_OFFLOAD, "Record Offload"));
        }

        @FindBy(css = "[data-testid='back-to-filter-button']")
        public Button backToFilter;

        @FindBy(xpath = "//span[contains(@class,'table-stats')]/div")
        public PageElement TotalSearchResult;

        @FindBy(xpath = "//button[@class='ant-btn ant-btn-primary']")
        public PageElement ManifestButton;

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

    public void verifyErrorMessage(String expectedMessage){
        ErrorMessage.waitUntilVisible();
        Assertions.assertThat(ErrorMessage.getText()).as("Error message is the same").isEqualTo(expectedMessage);
        Assertions.assertThat(closeButton.isDisplayed()).as("Go back or Confirm button is displayed").isTrue();
    }



}
