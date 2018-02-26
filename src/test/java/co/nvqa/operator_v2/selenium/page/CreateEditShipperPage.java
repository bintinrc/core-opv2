package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class CreateEditShipperPage extends OperatorV2SimplePage
{
    public CreateEditShipperPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        wait50sUntil(()->getWebDriver().getCurrentUrl().endsWith("shippers/create"), "Current URL is not ends with 'shippers/create'.");
        waitUntilInvisibilityOfElementLocated("//tab-content[@aria-hidden='false']//md-content[@ng-if='ctrl.state.loading === true']//md-progress-circular");
    }

    public void createNewShipperV4()
    {
        waitUntilPageLoaded();

        clickButtonByAriaLabel("Active");
        selectValueFromMdSelect("ctrl.data.basic.shipperType", "Normal");

        // Shipper Details
        sendKeysById("Shipper Name", "Dummy Shipper #1");
        sendKeysById("Short Name", "T0001");
        sendKeysById("Shipper Contact", generateDateUniqueString());
        sendKeysById("shipper-email", "test@automationtest.co");
        sendKeysById("shipper-dashboard-password", "Ninjitsu89");

        // Liaison Details
        sendKeysById("Liaison Name", "LN-001");
        sendKeysById("Liaison Contact", "LN-001");
        sendKeysById("Liaison Email", "ln@automationtest.co");
        sendKeysById("Liaison Address", "LN Address #01");
        sendKeysById("Liaison Postcode", "99000");

        // Services
        selectValueFromMdSelect("ctrl.data.basic.ocVersion", "v4");
        selectMultipleValuesFromMdSelect("ctrl.data.basic.selectedOcServices", "1DAY", "2DAY", "3DAY", "SAMEDAY", "FREIGHT");
        selectValueFromMdSelect("ctrl.data.basic.trackingType", "Fixed");
        sendKeysById("Prefix", "AAAAA");

        // Pricing
        selectValueFromNvAutocomplete("ctrl.view.pricingScripts.searchText", "New DJPH PS");

        // Billing
        sendKeysById("Billing Name", "BL-001");
        sendKeysById("Billing Contact", "123456");
        sendKeysById("Billing Address", "BL Address #01");
        sendKeysById("Billing Postcode", "99000");

        // Industry & Sales
        selectValueFromNvAutocomplete("ctrl.view.industry.searchText", "Automobile Accessories");
        selectValueFromNvAutocomplete("ctrl.view.salesPerson.searchText", "CW-Changwen");
    }
}
