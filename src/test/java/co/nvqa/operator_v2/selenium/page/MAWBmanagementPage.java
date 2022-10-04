package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.sort.hub.AirTrip;
import co.nvqa.commons.model.sort.hub.Airport;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.*;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.AirportTripManagementPage.AirportTable.COLUMN_AIRTRIP_ID;

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



}
