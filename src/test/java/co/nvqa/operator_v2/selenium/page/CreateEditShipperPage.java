package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

    public void waitUntilPageLoaded(String expectedUrlEndsWith)
    {
        super.waitUntilPageLoaded();
        final String expectedUrlContains = "shippers/create";

        waitUntil(()->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("CreateEditShipperPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
            return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));

        waitUntilInvisibilityOfElementLocated("//tab-content[@aria-hidden='false']//md-content[@ng-if='ctrl.state.loading === true']//md-progress-circular");
    }

    public void createNewShipper(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/create");
        fillTheForm(shipper);
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void updateShipper(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/"+shipper.getLegacyId());
        fillTheForm(shipper);
        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    private void fillTheForm(Shipper shipper)
    {
        boolean isCreateForm = getCurrentUrl().endsWith("shippers/create");

        String shipperStatusAriaLabel = convertBooleanToString(shipper.getActive(), "Active", "Disabled");

        clickToggleButton("ctrl.data.basic.status", shipperStatusAriaLabel);
        selectValueFromMdSelect("ctrl.data.basic.shipperType", shipper.getType());

        // Shipper Details
        sendKeysById("Shipper Name", shipper.getName());
        sendKeysById("Short Name", shipper.getShortName());
        sendKeysById("Shipper Contact", shipper.getContact());

        if(isCreateForm)
        {
            sendKeysById("shipper-email", shipper.getEmail());
            sendKeysById("shipper-dashboard-password", shipper.getShipperDashboardPassword());
        }

        // Liaison Details
        sendKeysById("Liaison Name", shipper.getLiaisonName());
        sendKeysById("Liaison Contact", shipper.getLiaisonContact());
        sendKeysById("Liaison Email", shipper.getLiaisonEmail());
        sendKeysById("Liaison Address", shipper.getLiaisonAddress());
        sendKeysById("Liaison Postcode", shipper.getLiaisonPostcode());

        // Services
        OrderCreate orderCreate = shipper.getOrderCreate();
        selectValueFromMdSelect("ctrl.data.basic.ocVersion", orderCreate.getVersion());

        if(isCreateForm)
        {
            selectMultipleValuesFromMdSelect("ctrl.data.basic.selectedOcServices", orderCreate.getServicesAvailable());
        }

        selectValueFromMdSelect("ctrl.data.basic.trackingType", orderCreate.getTrackingType());

        if(isCreateForm)
        {
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
        }

        DistributionPoint distributionPoint = shipper.getDistributionPoints();
        clickToggleButton("ctrl.data.basic.allowCod", convertBooleanToString(orderCreate.getAllowCodService(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.allowCp", convertBooleanToString(orderCreate.getAllowCpService(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.isPrePaid", convertBooleanToString(orderCreate.getIsPrePaid(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.allowStaging", convertBooleanToString(orderCreate.getAllowStagedOrders(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.isMultiParcel", convertBooleanToString(orderCreate.getIsMultiParcelShipper(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.disableReschedule", convertBooleanToString(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt(), "Yes", "No"));

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

        if(isCreateForm)
        {
            selectValueFromNvAutocomplete("ctrl.view.salesPerson.searchText", shipper.getSalesPerson());
        }
    }

    public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/"+shipper.getLegacyId());

        String actualShipperStatus = getToggleButtonValue("ctrl.data.basic.status");
        String actualShipperType = getMdSelectValueTrimmed("ctrl.data.basic.shipperType");

        Assert.assertEquals("Shipper Status", convertBooleanToString(shipper.getActive(), "Active", "Disabled"), actualShipperStatus);
        Assert.assertEquals("Shipper Type", shipper.getType(), actualShipperType);

        // Shipper Details
        String actualShipperName = getValue("//input[@id='Shipper Name']");
        String actualShipperShortName = getValue("//input[@id='Short Name']");
        String actualShipperContact = getValue("//input[@id='Shipper Contact']");
        String actualShipperEmail = getValue("//input[@id='Shipper Email']");

        Assert.assertEquals("Shipper Name", shipper.getName(), actualShipperName);
        Assert.assertEquals("Shipper Short Name", shipper.getShortName(), actualShipperShortName);
        Assert.assertEquals("Shipper Contact", shipper.getContact(), actualShipperContact);
        Assert.assertEquals("Shipper Email", shipper.getEmail(), actualShipperEmail);

        // Liaison Details
        String actualLiaisonName = getValue("//input[@id='Liaison Name']");
        String actualLiaisonContact = getValue("//input[@id='Liaison Contact']");
        String actualLiaisonEmail = getValue("//input[@id='Liaison Email']");
        String actualLiaisonAddress = getValue("//input[@id='Liaison Address']");
        String actualLiaisonPostcode = getValue("//input[@id='Liaison Postcode']");

        Assert.assertEquals("Liaison Name", shipper.getLiaisonName(), actualLiaisonName);
        Assert.assertEquals("Liaison Contact", shipper.getLiaisonContact(), actualLiaisonContact);
        Assert.assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        Assert.assertEquals("Liaison Address", shipper.getLiaisonAddress(), actualLiaisonAddress);
        Assert.assertEquals("Liaison Postcode", shipper.getLiaisonPostcode(), actualLiaisonPostcode);

        // Services
        String actualOcVersion = getMdSelectValueTrimmed("ctrl.data.basic.ocVersion");
        String availableService = getAttribute("//md-select[@ng-model='ctrl.data.basic.selectedOcServices']", "aria-label");
        String actualTrackingType = getMdSelectValue("ctrl.data.basic.trackingType");
        String actualPrefix = getValue("//input[@id='Prefix']");

        List<String> listOfActualServices;

        if(availableService==null || availableService.equals("oc-services"))
        {
            listOfActualServices = new ArrayList<>();
        }
        else
        {
            String[] temp = availableService.split("oc-services:")[1].split(",");
            listOfActualServices = Stream.of(temp).map(String::trim).collect(Collectors.toList());
        }

        OrderCreate orderCreate = shipper.getOrderCreate();
        Assert.assertEquals("OC Version", orderCreate.getVersion(), actualOcVersion);
        Assert.assertThat("Services Available", listOfActualServices, Matchers.hasItems(orderCreate.getServicesAvailable().toArray(new String[]{})));
        Assert.assertEquals("Tracking Type", orderCreate.getTrackingType(), actualTrackingType);
        Assert.assertEquals("Prefix", orderCreate.getPrefix(), actualPrefix);

        String actualAllowCodService = getToggleButtonValue("ctrl.data.basic.allowCod");
        String actualAllowCpService = getToggleButtonValue("ctrl.data.basic.allowCp");
        String actualIsPrePaid = getToggleButtonValue("ctrl.data.basic.isPrePaid");
        String actualAllowStagedOrders = getToggleButtonValue("ctrl.data.basic.allowStaging");
        String actualIsMultiParcelShipper = getToggleButtonValue("ctrl.data.basic.isMultiParcel");
        String actualShipperLiteAllowRescheduleFirstAttempt = getToggleButtonValue("ctrl.data.basic.disableReschedule");

        DistributionPoint distributionPoint = shipper.getDistributionPoints();

        Assert.assertEquals("Allow COD Service", convertBooleanToString(orderCreate.getAllowCodService(), "Yes", "No"), actualAllowCodService);
        Assert.assertEquals("Allow CP Service", convertBooleanToString(orderCreate.getAllowCpService(), "Yes", "No"), actualAllowCpService);
        Assert.assertEquals("Is Prepaid Account", convertBooleanToString(orderCreate.getIsPrePaid(), "Yes", "No"), actualIsPrePaid);
        Assert.assertEquals("Allow Staged Orders", convertBooleanToString(orderCreate.getAllowStagedOrders(), "Yes", "No"), actualAllowStagedOrders);
        Assert.assertEquals("Is Multi Parcel Shipper", convertBooleanToString(orderCreate.getIsMultiParcelShipper(), "Yes", "No"), actualIsMultiParcelShipper);
        Assert.assertEquals("Disable Driver App Reschedule", convertBooleanToString(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt(), "Yes", "No"), actualShipperLiteAllowRescheduleFirstAttempt);

        // Pricing
        Pricing pricing = shipper.getPricing();
        String actualPricingScript = getNvAutocompleteValue("ctrl.view.pricingScripts.searchText");
        Assert.assertThat("Pricing Script", actualPricingScript, Matchers.endsWith(pricing.getScriptName()));

        // Billing
        String actualBillingName = getValue("//input[@id='Billing Name']");
        String actualBillingContact = getValue("//input[@id='Billing Contact']");
        String actualBillingAddress = getValue("//input[@id='Billing Address']");
        String actualBillingPostcode = getValue("//input[@id='Billing Postcode']");

        Assert.assertEquals("Billing Name", shipper.getBillingName(), actualBillingName);
        Assert.assertEquals("Billing Contact", shipper.getBillingContact(), actualBillingContact);
        Assert.assertEquals("Billing Address", shipper.getBillingAddress(), actualBillingAddress);
        Assert.assertEquals("Billing Postcode", shipper.getBillingPostcode(), actualBillingPostcode);

        // Industry & Sales
        String actualIndustry = getNvAutocompleteValue("ctrl.view.industry.searchText");
        String actualSalesPerson = getNvAutocompleteValue("ctrl.view.salesPerson.searchText");

        Assert.assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        Assert.assertEquals("Sales Person", shipper.getSalesPerson(), actualSalesPerson);

        backToShipperList();
    }

    public void backToShipperList()
    {
        clickNvIconTextButtonByName("container.shippers.back-to-shipper-list");

        if(isElementExistFast("//md-dialog//button[@aria-label='Leave']"))
        {
            clickButtonOnMdDialogByAriaLabel("Leave");
        }

        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading shippers...']");
    }
}
