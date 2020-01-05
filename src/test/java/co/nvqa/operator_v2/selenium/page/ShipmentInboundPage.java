package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 * @author Tristania Siagian
 */
public class ShipmentInboundPage extends OperatorV2SimplePage
{
    private static final String LOCATOR_SPINNER = "//md-progress-circular";
    private static final String SHIPMENT_ID_SELECTION_XPATH = ".//md-autocomplete-wrap/input[starts-with(@id, 'input')]";
    private static final String SHIPMENT_ID_XPATH = "//li[@ng-click='$mdAutocompleteCtrl.select($index)']";
    private static final String HUB_COMBOBOX_XPATH = "//md-select[contains(@name,'commons.hub')]";
    private static final String HUB_COMBOBOX_TEXTAREA_XPATH = "//input[@ng-model='searchTerm']";
    private static final String SELECTED_HUB_NAME_XPATH = "//md-option[div[text()=' %s ']]";

    public ShipmentInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHubAndShipmentId(String hubName, String shipmentId)
    {
        pause3s();
        selectValueFromMdSelectById("commons.hub", hubName);
        waitUntilVisibilityOfElementLocated(SHIPMENT_ID_SELECTION_XPATH);
        sendKeys(SHIPMENT_ID_SELECTION_XPATH, shipmentId);
        click(SHIPMENT_ID_XPATH);
        pause1s();
    }

    public void selectPreciseHubAndShipmentId(String hubName, String shipmentId)
    {
        pause3s();
        click(HUB_COMBOBOX_XPATH);
        pause1s();
        sendKeys(HUB_COMBOBOX_TEXTAREA_XPATH, hubName);
        pause1s();
        click(f(SELECTED_HUB_NAME_XPATH, hubName));
        waitUntilVisibilityOfElementLocated(SHIPMENT_ID_SELECTION_XPATH);
        sendKeys(SHIPMENT_ID_SELECTION_XPATH, shipmentId);
        click(SHIPMENT_ID_XPATH);
        pause1s();
    }

    public void clickContinueButton()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Continue");
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    }

    public void enterTrackingId(String trackingId)
    {
        sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
    }

    public void addPrefix(String prefix)
    {
        clickNvIconTextButtonByName("container.parcel-sweeper.add-prefix");
        waitUntilVisibilityOfMdDialogByTitle("Set Prefix");
        sendKeysById("container.global-inbound.prefix", prefix);
        clickNvIconTextButtonByName("Save");
        waitUntilInvisibilityOfMdDialogByTitle("Set Prefix");
    }
}
