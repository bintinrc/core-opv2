package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestUtils;
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

    public void createNewShipperV4(Shipper shipper)
    {
        waitUntilPageLoaded();

        clickButtonByAriaLabel("Active");
        selectValueFromMdSelect("ctrl.data.basic.shipperType", shipper.getType());

        // Shipper Details
        sendKeysById("Shipper Name", shipper.getName());
        sendKeysById("Short Name", shipper.getShortName());
        sendKeysById("Shipper Contact", shipper.getContact());
        sendKeysById("shipper-email", shipper.getEmail());
        sendKeysById("shipper-dashboard-password", shipper.getShipperDashboardPassword());

        // Liaison Details
        sendKeysById("Liaison Name", shipper.getLiaisonName());
        sendKeysById("Liaison Contact", shipper.getLiaisonContact());
        sendKeysById("Liaison Email", shipper.getLiaisonEmail());
        sendKeysById("Liaison Address", shipper.getLiaisonAddress());
        sendKeysById("Liaison Postcode", shipper.getLiaisonPostcode());

        // Services
        OrderCreate orderCreate = shipper.getOrderCreate();
        selectValueFromMdSelect("ctrl.data.basic.ocVersion", orderCreate.getVersion());
        selectMultipleValuesFromMdSelect("ctrl.data.basic.selectedOcServices", orderCreate.getServicesAvailable().toArray(new String[]{}));
        selectValueFromMdSelect("ctrl.data.basic.trackingType", orderCreate.getTrackingType());

        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            String generatedPrefix = generateUpperCaseAlphaNumericString(5);
            orderCreate.setPrefix(generatedPrefix);
            sendKeysById("Prefix", generatedPrefix);
            click("//label[@for='Prefix']");
            pause500ms();
            boolean isPrefixAlreadyUsed = isElementExistWait3Seconds("//div[text()='Prefix already used']");

            if(isPrefixAlreadyUsed)
            {
                throw new NvTestRuntimeException("Prefix already used. Regenerate new prefix.");
            }
        });

        // Pricing
        Pricing pricing = shipper.getPricing();
        selectValueFromNvAutocomplete("ctrl.view.pricingScripts.searchText", pricing.getScriptName());

        // Billing
        sendKeysById("Billing Name", shipper.getBillingName());
        sendKeysById("Billing Contact", shipper.getBillingContact());
        sendKeysById("Billing Address", shipper.getBillingAddress());
        sendKeysById("Billing Postcode", shipper.getBillingPostcode());

        // Industry & Sales
        selectValueFromNvAutocomplete("ctrl.view.industry.searchText", shipper.getIndustryName());
        selectValueFromNvAutocomplete("ctrl.view.salesPerson.searchText", shipper.getSalesPerson());
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void test(Shipper shipper)
    {

    }
}
