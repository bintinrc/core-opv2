package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;
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

    }

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

    public void addShipmentToSearchBox(List<String> shipmentIDs){
        searchByMAWBTextBox.click();
        shipmentIDs.forEach((id) -> {
            searchByMAWBTextBox.sendKeys(id);
            searchByMAWBTextBox.sendKeys(Keys.RETURN);
        });
        verifyMAWBCounterAfterInputWAMB(shipmentIDs);
        verifySearchByMAWBbuttonIsEnable();
    }

    public void verifyMAWBCounterAfterInputWAMB(List<String> shipmentIDs){
        String expected ="";
        // we can also use Function.identity() instead of c->c
        Map<String ,Long > map = shipmentIDs.stream()
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


}
