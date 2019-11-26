package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.GlobalInboundParams;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class ShipmentGlobalInboundPage extends OperatorV2SimplePage
{
    private static final String MD_SELECT_VALUE_SELECTION_XPATH = "//md-select-value[contains(@id,'select_value_label')]/span[contains(text(),'%s')]";
    private static final String MD_SELECT_HEADER_INPUT_XPATH = "//md-select-header[not(contains(@class,'ng-hide'))]/input[contains(@ng-model,'searchTerm')]";
    private static final String MD_OPTION_HUB_FIRST_ELEMENT = "//md-select-header[not(contains(@class,'ng-hide'))]/following-sibling::md-option[contains(@ng-repeat,'filter:searchTerm')][1]";
    private static final String MD_OPTION_SHIPMENT_ID_FIRST_ELEMENT = "//md-select-header[not(contains(@class,'ng-hide'))]/following-sibling::md-option[contains(@ng-repeat,'filter:searchTerm') and @value='%s'][1]";
    private static final String MD_OPTION_SHIPMENT_TYPE_SELECTION_XPATH = "//md-option[contains(@value,'%s')]";
    private static final String INPUT_SHIPMENT_ID_XPATH = "//div[contains(@class,'md-scroll-mask')]/following-sibling::div[contains(@id,'select_container')]//md-select-header/input[contains(@ng-model,'searchTerm')]";
    private static final String SHIPMENT_INPUT_LIST_XPATH = "//div[@ng-repeat='shipment in ctrl.data.selectedShipmentIds']/span[text()='%s']";
    private static final String SCANNER_FIELD_XPATH = "//input[@aria-label='Scan a new parcel / Enter a tracking ID']";
    private static final String LAST_HUB_SHOWN_XPATH = "//h3[@ng-if='!ctrl.state.ready']";
    private static final String LATEST_SCANNED_TRACKING_ID_XPATH = "//div[text()=' Last Scanned : %s ']";
    private static final String TOAST_TEXT_XPATH = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div[text()='%s']";
    private static final String LOADING_XPATH = "//div[contains(@class, 'loading-sheet')]/md-progress-circular";

    private static final String SELECT_HUB_TEXT = "Select Hub";
    private static final String SHIPMENT_TYPE_TEXT = "Shipment Type";
    private static final String SELECT_SHIPMENT_IDS_TEXT = "Select Shipment ID(s)";
    private static final String ADD_SHIPMENT_ICON_ARIA_LABEL = "Add Shipment ID";
    private static final String CONTINUE_BUTTON_ARIA_LABEL = "Continue";

    private static final String DEFAULT_PRIORITY_COLOR_XPATH = "//div[contains(@class,'priority-container')]";
    private static final String WARNING_PRIORITY_COLOR_XPATH = "//div[contains(@class,'priority-container') and contains(@class,'%s')]";

    public ShipmentGlobalInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectShipmentDestinationHub(String hubName)
    {
        selectValueFromMdSelectById("container.global-inbound.hub", hubName);
    }

    public void selectShipmentType(String shipmentType)
    {
        clickMdSelectValue(SHIPMENT_TYPE_TEXT);
        click(f(MD_OPTION_SHIPMENT_TYPE_SELECTION_XPATH, shipmentType));
    }

    public void selectShipmentId(Long shipmentId)
    {
        selectValueFromNvAutocompleteByItemTypes("Shipment ID", String.valueOf(shipmentId));
    }

    public void clickAddShipmentThenContinue(Long shipmentId)
    {
        //clickButtonByAriaLabel(ADD_SHIPMENT_ICON_ARIA_LABEL);
        //isElementExistWait3Seconds(f(SHIPMENT_INPUT_LIST_XPATH, String.valueOf(shipmentId)));
        clickButtonByAriaLabel(CONTINUE_BUTTON_ARIA_LABEL);
        waitUntilVisibilityOfElementLocated(SCANNER_FIELD_XPATH);
    }

    public void inputScannedTrackingId(String trackingId, boolean orderIsValid)
    {
        sendKeysAndEnter(SCANNER_FIELD_XPATH, trackingId);
        //closeToast();

        if(orderIsValid)
        {
            waitUntilVisibilityOfElementLocated(LAST_HUB_SHOWN_XPATH);
            waitUntilVisibilityOfElementLocated(f(LATEST_SCANNED_TRACKING_ID_XPATH, trackingId));
        }
    }

    public void checkAlert(String toastText)
    {
        waitUntilVisibilityOfElementLocated(TOAST_TEXT_XPATH, toastText);
        if(StringUtils.isNotBlank(toastText))
        {
            assertEquals("Toast text", toastText, getToastTopText());
            waitUntilInvisibilityOfToast(toastText, false);
        }
    }

    public void verifiesPriorityLevelInfoIsCorrect(int expectedPriorityLevel, String expectedPriorityLevelColor)
    {
        String actualPriorityLevel = getText("//div[contains(text(), 'Priority Level')]/following-sibling::div[1]/span");

        assertEquals("Priority Level", String.valueOf(expectedPriorityLevel), actualPriorityLevel);
        if (expectedPriorityLevelColor == "" || expectedPriorityLevelColor.isEmpty() || expectedPriorityLevelColor == null)
        {
            isElementExist(DEFAULT_PRIORITY_COLOR_XPATH);
        } else {
            isElementExist(f(WARNING_PRIORITY_COLOR_XPATH, expectedPriorityLevelColor));
        }
    }

    public void shipmentGlobalInbound(GlobalInboundParams globalInboundParams)
    {
        overrideSize(globalInboundParams.getOverrideSize());
        overrideWeight(globalInboundParams.getOverrideWeight());
        overrideDimHeight(globalInboundParams.getOverrideDimHeight());
        overrideDimWidth(globalInboundParams.getOverrideDimWidth());
        overrideDimLength(globalInboundParams.getOverrideDimLength());
    }

    private void clickMdSelectValue(String mdSelectValueText)
    {
        String xpath = f(MD_SELECT_VALUE_SELECTION_XPATH, mdSelectValueText);
        waitUntilVisibilityOfElementLocated(xpath);
        click(xpath);
    }

    private void sendKeysForMdSelectHeaderInput(String key)
    {
        sendKeys(MD_SELECT_HEADER_INPUT_XPATH, key);
    }

    private void overrideSize(String overrideSize)
    {
        if(overrideSize==null)
        {
            if(isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.manual']"))
            {
                clickNvIconTextButtonByName("container.global-inbound.manual");
            }
        }
        else
        {
            if(isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.retain']"))
            {
                clickNvIconTextButtonByName("container.global-inbound.retain");
                selectValueFromMdSelectById("size", overrideSize);
            }
        }
    }

    private void overrideWeight(Double overrideWeight)
    {
        setOverrideValue("input-weight", overrideWeight);
    }

    private void overrideDimHeight(Double overrideDimHeight)
    {
        setOverrideValue("input-height", overrideDimHeight);
    }

    private void overrideDimWidth(Double overrideDimWidth)
    {
        setOverrideValue("input-width", overrideDimWidth);
    }

    private void overrideDimLength(Double overrideDimLength)
    {
        setOverrideValue("input-length", overrideDimLength);
    }

    private void setOverrideValue(String inputId, Double value)
    {
        if(value==null)
        {
            clearf("//input[@id='%s']", inputId);
        }
        else
        {
            sendKeysById(inputId, NO_TRAILING_ZERO_DF.format(value));
        }
    }
}
