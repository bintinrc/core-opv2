package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.MilkrunSettings;
import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.LabelPrinter;
import co.nvqa.commons.model.shipper.v2.Magento;
import co.nvqa.commons.model.shipper.v2.MarketplaceBilling;
import co.nvqa.commons.model.shipper.v2.MarketplaceDefault;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pickup;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Qoo10;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Return;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.shipper.v2.Shopify;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersCreateEditPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT_TABLE_ADDRESS = "address in getTableData()";

    public static final String ACTION_BUTTON_SET_AS_DEFAULT = "Set as Default";
    public static final String LOCATOR_FIELD_OC_VERSION = "ctrl.data.basic.ocVersion";
    public static final String LOCATOR_FIELD_PRICING_SCRIPT = "commons.pricing-script";
    public static final String LOCATOR_FIELD_INDUSTRY = "ctrl.data.basic.industry";
    public static final String LOCATOR_FIELD_SALES_PERSON = "container.shippers.oc-sales-person";
    public static final String LOCATOR_FIELD_CHANNEL = "ctrl.data.basic.shipperClassification";
    public static final String LOCATOR_FIELD_ACCOUNT_TYPE = "ctrl.data.basic.accountType";

    public AllShippersCreateEditPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createNewShipper(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/create");
        fillBasicSettingsForm(shipper);
        fillMoreSettingsForm(shipper);
        if (shipper.getMarketplaceDefault() != null)
        {
            fillMarketplaceSettingsForm(shipper);
        }
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
        pause3s();
    }

    public void updateShipper(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        fillBasicSettingsForm(shipper);
        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    private void fillBasicSettingsForm(Shipper shipper)
    {
        boolean isCreateForm = getCurrentUrl().endsWith("shippers/create");
        String shipperStatusAriaLabel = convertBooleanToString(shipper.getActive(), "Active", "Disabled");

        clickToggleButton("ctrl.data.basic.status", shipperStatusAriaLabel);
        selectValueFromMdSelect("ctrl.data.basic.shipperType", shipper.getType());

        // Shipper Details
        sendKeysById("shipper-name", shipper.getName());
        sendKeysById("Short Name", shipper.getShortName());
        sendKeysById("shipper-phone-number", shipper.getContact());

        if (isCreateForm)
        {
            sendKeysById("shipper-email", shipper.getEmail());
            sendKeysById("shipper-dashboard-password", shipper.getShipperDashboardPassword());
        }

        // Liaison Details
        sendKeysById("Liaison Name", shipper.getLiaisonName());
        sendKeysById("Liaison Contact", shipper.getLiaisonContact());
        sendKeysById("Liaison Email", shipper.getLiaisonEmail());
        sendKeysById("liaison-address", shipper.getLiaisonAddress());
        sendKeysById("Liaison Postcode", shipper.getLiaisonPostcode());

        // Services
        OrderCreate orderCreate = shipper.getOrderCreate();
        selectValueFromMdSelectOrCheckCurrentIfDisabled("OC Version", LOCATOR_FIELD_OC_VERSION, orderCreate.getVersion());

        if (isCreateForm)
        {
            selectMultipleValuesFromMdSelect("ctrl.data.basic.selectedOcServices", orderCreate.getServicesAvailable());
        }

        selectValueFromMdSelect("ctrl.data.basic.trackingType", orderCreate.getTrackingType());

        if (isCreateForm)
        {
            TestUtils.retryIfRuntimeExceptionOccurred(() ->
            {
                String generatedPrefix = generateUpperCaseAlphaNumericString(5);
                orderCreate.setPrefix(generatedPrefix);
                sendKeysById("shipper-prefix", generatedPrefix);
                click("//label[@for='shipper-prefix']");
                pause500ms();
                boolean isPrefixAlreadyUsed = isElementExistWait3Seconds("//div[text()='Prefix already used']");

                if (isPrefixAlreadyUsed)
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
        if (pricing != null && StringUtils.isNotBlank(pricing.getScriptName()))
        {
            selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_PRICING_SCRIPT, pricing.getScriptName());
        }

        // Billing
        sendKeysById("Billing Name", shipper.getBillingName());
        sendKeysById("Billing Contact", shipper.getBillingContact());
        sendKeysById("Billing Address", shipper.getBillingAddress());
        sendKeysById("Billing Postcode", shipper.getBillingPostcode());

        // Account Type
        selectValueFromMdSelect(LOCATOR_FIELD_CHANNEL, "B2C Marketplace");
        selectValueFromMdSelect(LOCATOR_FIELD_INDUSTRY, shipper.getIndustryName());
        String accountTypeId = shipper.getAccountTypeId() != null ? String.valueOf(shipper.getAccountTypeId()) : "0";
        selectValueFromMdSelect(LOCATOR_FIELD_ACCOUNT_TYPE, accountTypeId);

        if (isCreateForm)
        {
            selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_SALES_PERSON, shipper.getSalesPerson());
        }
    }

    private void fillMoreSettingsForm(Shipper shipper)
    {
        Pickup pickupSettings = shipper.getPickup();
        if (pickupSettings != null)
        {
            clickTabItem("More Settings");

            if (CollectionUtils.isNotEmpty(pickupSettings.getReservationPickupAddresses()))
            {
                pickupSettings.getReservationPickupAddresses().forEach(address -> {
                    addAddress(address);
                    verifyPickupAddress(address);
                });
            }

            String startTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(pickupSettings.getDefaultStartTime());
            String endTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(pickupSettings.getDefaultEndTime());
            String defaultPickupTimeSelector = startTimeFormatted + " - " + endTimeFormatted;
            selectValueFromMdSelectByIdContains("commons.select", defaultPickupTimeSelector);
        }
    }

    private void addAddress(Address address)
    {
        scrollIntoView("//*[@name='container.shippers.more-reservation-add-pickup-address']", false);
        clickNvIconTextButtonByName("container.shippers.more-reservation-add-pickup-address");
        fillAddAddressForm(address);
    }

    private void fillAddAddressForm(Address address)
    {
        waitUntilVisibilityOfMdDialogByTitle("Add Address");

        String value = address.getName();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Contact Name", value);
        }

        value = address.getContact();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Contact Mobile Number", value);
        }

        value = address.getEmail();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Contact Email", value);
        }

        value = address.getAddress1();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Pickup Address 1", value);
        }

        value = address.getAddress2();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Pickup Address 2 / Unit Number", value);
        }

        value = address.getCountry();
        if (StringUtils.isNotBlank(value))
        {
            selectValueFromMdSelectById("commons.country", value);
        }

        value = address.getPostcode();
        if (StringUtils.isNotBlank(value))
        {
            sendKeysById("Pickup Postcode", value);
        }

        Double val = address.getLatitude();
        if (val != null)
        {
            sendKeysById("Latitude", String.valueOf(val));
        }

        val = address.getLongitude();
        if (val != null)
        {
            sendKeysById("Longitude", String.valueOf(val));
        }

        if (BooleanUtils.isTrue(address.getMilkRun()))
        {
            fillMilkrunReservationSettings(address);
        }

        clickNvApiTextButtonByName("commons.save-changes");
        waitUntilInvisibilityOfMdDialogByTitle("Add Address");
    }

    private void fillMilkrunReservationSettings(Address address)
    {
        click("//span[.='Milkrun Reservations']");
        if (CollectionUtils.isNotEmpty(address.getMilkrunSettings()))
        {
            List<MilkrunSettings> milkrunSettingsList = address.getMilkrunSettings();
            for (int i = 0; i < milkrunSettingsList.size(); i++)
            {
                MilkrunSettings milkrunSettings = milkrunSettingsList.get(i);
                clickNvIconTextButtonByName("container.shippers.add-new-reservation");
                fillMilkrunReservationForm(milkrunSettings, i + 1);
            }
        }
    }

    private void fillMilkrunReservationForm(MilkrunSettings milkrunSettings, int index)
    {
        String itemXpath = "//*[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings'][" + index + "]";
        executeInContext(itemXpath, () -> {
            if (CollectionUtils.isNotEmpty(milkrunSettings.getDays()))
            {
                selectMultipleValuesFromMdSelectById("container.shippers.more-reservation-days",
                        milkrunSettings.getDays().stream().map(String::valueOf).collect(Collectors.toList()));
            }

            if (StringUtils.isNoneBlank(milkrunSettings.getStartTime(), milkrunSettings.getEndTime()))
            {
                selectValueFromMdSelectById("container.shippers.timeslot-selected",
                        milkrunSettings.getStartTime().toUpperCase() + " - " + milkrunSettings.getEndTime().toUpperCase());
            }

            if (milkrunSettings.getNoOfReservation() != null)
            {
                selectValueFromMdSelectById("container.shippers.number-of-reservations",
                        String.valueOf(milkrunSettings.getNoOfReservation()));
            }
        });
    }

    private void fillMarketplaceSettingsForm(Shipper shipper)
    {
        clickTabItem("Marketplace");

        MarketplaceDefault md = shipper.getMarketplaceDefault();
        if (md != null)
        {
            // Services
            selectValueFromMdSelect("ctrl.data.marketplace.ocVersion", md.getOrderCreateVersion());
            selectMultipleValuesFromMdSelect("ctrl.data.marketplace.selectedOcServices", md.getOrderCreateServicesAvailable());
            selectValueFromMdSelect("ctrl.data.marketplace.trackingType", md.getOrderCreateTrackingType());

            clickToggleButton("ctrl.data.marketplace.allowCod", convertBooleanToString(md.getOrderCreateAllowCodService(), "Yes", "No"));
            clickToggleButton("ctrl.data.marketplace.allowCp", convertBooleanToString(md.getOrderCreateAllowCpService(), "Yes", "No"));
            clickToggleButton("ctrl.data.marketplace.isPrePaid", convertBooleanToString(md.getOrderCreateIsPrePaid(), "Yes", "No"));
            clickToggleButton("ctrl.data.marketplace.allowStaging", convertBooleanToString(md.getOrderCreateAllowStagedOrders(), "Yes", "No"));
            clickToggleButton("ctrl.data.marketplace.isMultiParcel", convertBooleanToString(md.getOrderCreateIsMultiParcelShipper(), "Yes", "No"));
            sendKeys("//md-input-container[@model='ctrl.data.marketplace.premiumPickupDailyLimit']//input", String.valueOf(md.getPickupPremiumPickupDailyLimit()));
        }

        // Billing
        MarketplaceBilling mb = shipper.getMarketplaceBilling();
        if (mb != null)
        {
            sendKeys("//md-input-container[@model='ctrl.data.marketplace.billingName']//input", mb.getBillingName());
            sendKeys("//md-input-container[@model='ctrl.data.marketplace.billingContact']//input", mb.getBillingContact());
            sendKeys("//md-input-container[@model='ctrl.data.marketplace.billingAddress']//input", mb.getBillingAddress());
            sendKeys("//md-input-container[@model='ctrl.data.marketplace.billingPostcode']//input", mb.getBillingPostcode());
        }
    }

    public void removeMilkrunReservarion(Shipper shipper, int addressIndex, int milkrunReservationIndex)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");
        if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses()))
        {
            Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
            int reservationsCount = CollectionUtils.size(address.getMilkrunSettings());
            searchTableCustom1("contact", address.getContact());
            clickNvIconButtonByName("container.shippers.more-reservation-edit-pickup-address");
            waitUntilVisibilityOfMdDialogByTitle("Edit Address");
            click("//span[.='Milkrun Reservations']");
            String xpath = String.format("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings'][%d]//nv-icon-button[@name='commons.delete']/button", milkrunReservationIndex);
            waitUntilVisibilityOfElementLocated(xpath);
            click(xpath);
            pause500ms();
            Assert.assertEquals("Number of Milkrun Reservations", reservationsCount - 1, getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"));
            clickNvApiTextButtonByName("commons.save-changes");
            waitUntilInvisibilityOfMdDialogByTitle("Edit Address");
        }
        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void removeAllMilkrunReservations(Shipper shipper, int addressIndex)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");
        if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses()))
        {
            Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
            searchTableCustom1("contact", address.getContact());
            clickNvIconTextButtonByName("container.shippers.milkrun");
            waitUntilVisibilityOfMdDialogByTitle("Unset as Milkrun");
            executeInContext("//md-dialog", () -> clickButtonByAriaLabelAndWaitUntilDone("Delete"));
            waitUntilInvisibilityOfMdDialogByTitle("Unset as Milkrun");
        }
        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void setPickupAddressesAsMilkrun(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");
        if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses()))
        {
            shipper.getPickup().getReservationPickupAddresses().stream().filter(Address::getMilkRun).forEach(address -> {
                searchTableCustom1("contact", address.getContact());
                clickNvIconTextButtonByName("container.shippers.set-as-milkrun");
                waitUntilVisibilityOfMdDialogByTitle("Edit Address");
                fillMilkrunReservationSettings(address);
                clickNvApiTextButtonByName("commons.save-changes");
                waitUntilInvisibilityOfMdDialogByTitle("Edit Address");

                verifyPickupAddress(address);
            });
        }
        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());

        String actualShipperStatus = getToggleButtonValue("ctrl.data.basic.status");

        String actualShipperType;
        if (StringUtils.equalsIgnoreCase(shipper.getType(), "Marketplace"))
        {
            actualShipperType = getInputValueById("Shipper Type");
        } else
        {
            actualShipperType = getMdSelectValueTrimmed("ctrl.data.basic.shipperType");
        }

        Assert.assertEquals("Shipper Status", convertBooleanToString(shipper.getActive(), "Active", "Disabled"), actualShipperStatus);
        Assert.assertEquals("Shipper Type", shipper.getType(), actualShipperType);

        // Shipper Details
        String actualShipperName = getInputValueById("shipper-name");
        String actualShipperShortName = getInputValueById("Short Name");
        String actualShipperContact = getInputValueById("shipper-phone-number");
        String actualShipperEmail = getInputValueById("shipper-email", XpathTextMode.STARTS_WITH);

        Assert.assertEquals("Shipper Name", shipper.getName(), actualShipperName);
        Assert.assertEquals("Shipper Short Name", shipper.getShortName(), actualShipperShortName);
        Assert.assertEquals("Shipper Contact", shipper.getContact(), actualShipperContact);
        Assert.assertEquals("Shipper Email", shipper.getEmail(), actualShipperEmail);

        // Liaison Details
        String actualLiaisonName = getInputValueById("Liaison Name");
        String actualLiaisonContact = getInputValueById("Liaison Contact");
        String actualLiaisonEmail = getInputValueById("Liaison Email");
        String actualLiaisonAddress = getInputValueById("liaison-address");
        String actualLiaisonPostcode = getInputValueById("Liaison Postcode");

        Assert.assertEquals("Liaison Name", shipper.getLiaisonName(), actualLiaisonName);
        Assert.assertEquals("Liaison Contact", shipper.getLiaisonContact(), actualLiaisonContact);
        Assert.assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        Assert.assertEquals("Liaison Address", shipper.getLiaisonAddress(), actualLiaisonAddress);
        Assert.assertEquals("Liaison Postcode", shipper.getLiaisonPostcode(), actualLiaisonPostcode);

        // Services
        String actualOcVersion = getMdSelectValueTrimmed("ctrl.data.basic.ocVersion");
        String availableService = getAttribute("//md-select[@ng-model='ctrl.data.basic.selectedOcServices']", "aria-label");
        String actualTrackingType = getMdSelectValue("ctrl.data.basic.trackingType");
        String actualPrefix = getInputValueById("shipper-prefix");

        List<String> listOfActualServices;

        if (availableService == null || availableService.equals("oc-services"))
        {
            listOfActualServices = new ArrayList<>();
        } else
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
        String actualPricingScript = getMdSelectValueById(LOCATOR_FIELD_PRICING_SCRIPT);
        Assert.assertThat("Pricing Script", actualPricingScript, Matchers.endsWith(pricing.getScriptName()));

        // Billing
        String actualBillingName = getInputValueById("Billing Name");
        String actualBillingContact = getInputValueById("Billing Contact");
        String actualBillingAddress = getInputValueById("Billing Address");
        String actualBillingPostcode = getInputValueById("Billing Postcode");

        Assert.assertEquals("Billing Name", shipper.getBillingName(), actualBillingName);
        Assert.assertEquals("Billing Contact", shipper.getBillingContact(), actualBillingContact);
        Assert.assertEquals("Billing Address", shipper.getBillingAddress(), actualBillingAddress);
        Assert.assertEquals("Billing Postcode", shipper.getBillingPostcode(), actualBillingPostcode);

        // Industry & Sales
        String actualIndustry = getMdSelectValue(LOCATOR_FIELD_INDUSTRY); //getNvAutocompleteValue("ctrl.view.industry.searchText");
        String actualSalesPerson = getMdSelectValueById(LOCATOR_FIELD_SALES_PERSON); //getNvAutocompleteValue("ctrl.view.salesPerson.searchText");

        Assert.assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        Assert.assertEquals("Sales Person", shipper.getSalesPerson(), actualSalesPerson);

        verifyMoreSettingsTab(shipper);

        backToShipperList();
    }

    public void verifyMoreSettingsTab(Shipper shipper)
    {
        Pickup pickupSettings = shipper.getPickup();
        if (pickupSettings != null)
        {
            clickTabItem("More Settings");

            if (CollectionUtils.isNotEmpty(pickupSettings.getReservationPickupAddresses()))
            {
                pickupSettings.getReservationPickupAddresses().forEach(this::verifyPickupAddress);
            }
        }
    }

    public void verifyPickupAddress(Address address)
    {
        boolean isEditForm = isElementExistFast("//div[@class='action-toolbar']//div[contains(text(),'Edit Shippers')]");
        searchTableCustom1("contact", address.getContact());
        Assert.assertTrue("Pickup Addresses with contact [" + address.getContact() + "] exists", !isTableEmpty());
        String actualAddress = isEditForm ?
                getTextOnTableWithMdVirtualRepeat(1, "address", "address in getTableData()") :
                getTextOnTableWithNgRepeat(1, "address", "address in getTableData()");

        Assert.assertEquals("Address", address.to1LineAddressWithPostcode(), actualAddress);
        if (BooleanUtils.isTrue(address.getMilkRun()))
        {
            Assert.assertTrue("Milkrun action button is not displayed for address", isElementVisible("//nv-icon-text-button[@name='container.shippers.milkrun']"));
            verifyMilkrunSettings(address);
            scrollIntoView("//*[@name='container.shippers.more-reservation-add-pickup-address']", false);
        } else {
            Assert.assertTrue("Set As Milkrun action button is not displayed for address", isElementVisible("//nv-icon-text-button[@name='container.shippers.set-as-milkrun']"));
        }
    }

    public void verifyMilkrunSettings(Address address)
    {
        int reservationsCount = CollectionUtils.size(address.getMilkrunSettings());
        clickNvIconButtonByName("container.shippers.more-reservation-edit-pickup-address");
        waitUntilVisibilityOfMdDialogByTitle("Edit Address");
        click("//span[.='Milkrun Reservations']");
        waitUntilVisibilityOfElementLocated("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']");
        Assert.assertEquals("Number of Milkrun Reservations", reservationsCount, getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"));
        clickNvIconButtonByName("Cancel");
        waitUntilInvisibilityOfMdDialogByTitle("Edit Address");
    }

    public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper, Address address, Reservation reservation)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");
        addAddress(address);
        setAsDefaultAddress(address);
        setAutoReservation(reservation);
        backToShipperList();
    }

    public void setAsDefaultAddress(Address address)
    {
        searchTableAddressByAddress(address.getAddress2());
        clickActionButtonOnTableAddress(1, ACTION_BUTTON_SET_AS_DEFAULT);
        try
        {
            long addressId = Long.parseLong(getInputValueById("Address ID"));
            address.setId(addressId);
        } catch (NumberFormatException ex)
        {
            throw new RuntimeException("Failed to get address ID.");
        }
    }

    public void setAutoReservation(Reservation reservation)
    {
        List<String> listOfDaysAsString = reservation.getDays().stream().map(String::valueOf).collect(Collectors.toList());
        clickToggleButton("ctrl.data.more.isAutoReservation", convertBooleanToString(reservation.getAutoReservationEnabled(), "Yes", "No"));
        selectMultipleValuesFromMdSelect("ctrl.data.more.reservationDays", XpathTextMode.EXACT, listOfDaysAsString);

        String[] readyTime = reservation.getAutoReservationReadyTime().split(":");
        String readyTimeHour = readyTime[0];
        String readyTimeMinute = readyTime[1];

        String[] latestTime = reservation.getAutoReservationLatestTime().split(":");
        String latestTimeHour = latestTime[0];
        String latestTimeMinute = latestTime[1];

        String[] cutoffTime = reservation.getAutoReservationCutoffTime().split(":");
        String cutoffTimeHour = cutoffTime[0];
        String cutoffTimeMinute = cutoffTime[1];

        selectValueFromMdSelect("ctrl.data.more.readyTime.hour", readyTimeHour);
        selectValueFromMdSelect("ctrl.data.more.readyTime.minute", readyTimeMinute);
        selectValueFromMdSelect("ctrl.data.more.latestTime.hour", latestTimeHour);
        selectValueFromMdSelect("ctrl.data.more.latestTime.minute", latestTimeMinute);
        selectValueFromMdSelect("ctrl.data.more.cutoffTime.hour", cutoffTimeHour);
        selectValueFromMdSelect("ctrl.data.more.cutoffTime.minute", cutoffTimeMinute);

        selectValueFromMdSelect("ctrl.data.more.approxVolume", reservation.getAutoReservationApproxVolume());
        selectMultipleValuesFromMdSelect("ctrl.data.more.allowedTypes", reservation.getAllowedTypes());

        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void updateShipperLabelPrinterSettings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Basic Settings");

        LabelPrinter labelPrinter = shipper.getLabelPrinter();
        sendKeysById("Printer IP", labelPrinter.getPrinterIp());
        clickToggleButton("ctrl.data.basic.isPrinterAvailable", convertBooleanToString(labelPrinter.getShowShipperDetails(), "Yes", "No"));
        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Basic Settings");

        LabelPrinter labelPrinter = shipper.getLabelPrinter();

        String actualPrinterIp = getInputValueById("Printer IP");
        String actualShowShipperDetails = getToggleButtonValue("ctrl.data.basic.isPrinterAvailable");

        Assert.assertEquals("Label Printer - Printer IP", labelPrinter.getPrinterIp(), actualPrinterIp);
        Assert.assertEquals("Label Printer - Show Shipper Details", convertBooleanToString(labelPrinter.getShowShipperDetails(), "Yes", "No"), actualShowShipperDetails);

        backToShipperList();
    }

    public void updateShipperDistributionPointSettings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");

        DistributionPoint distributionPoint = shipper.getDistributionPoints();

        clickToggleButton("ctrl.data.more.isIntegratedVault", convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"));
        clickToggleButton("ctrl.data.more.isCollectCustomerNricCode", convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"));

        clickToggleButton("ctrl.data.more.isReturnsOnDpms", convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"));
        sendKeysById("DPMS Logo URL", distributionPoint.getDpmsLogoUrl());

        clickToggleButton("ctrl.data.more.isReturnsOnVault", convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"));
        sendKeysById("Vault Logo URL", distributionPoint.getVaultLogoUrl());

        clickToggleButton("ctrl.data.more.isReturnsOnShipperLite", convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"));
        sendKeysById("Shipper Lite Logo URL", distributionPoint.getShipperLiteLogoUrl());

        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");

        DistributionPoint distributionPoint = shipper.getDistributionPoints();

        String actualIsIntegratedVault = getToggleButtonValue("ctrl.data.more.isIntegratedVault");
        String actualIsCollectCustomerNricCode = getToggleButtonValue("ctrl.data.more.isCollectCustomerNricCode");

        String actualIsReturnsOnDpms = getToggleButtonValue("ctrl.data.more.isReturnsOnDpms");
        String actualDpmsLogoUrl = getInputValueById("DPMS Logo URL");

        String actualIsReturnsOnVault = getToggleButtonValue("ctrl.data.more.isReturnsOnVault");
        String actualVaultLogoUrl = getInputValueById("Vault Logo URL");

        String actualIsReturnsOnShipperLite = getToggleButtonValue("ctrl.data.more.isReturnsOnShipperLite");
        String actualShipperLiteLogoUrl = getInputValueById("Shipper Lite Logo URL");

        Assert.assertEquals("Distribution Point - Is Integrated Vault", convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"), actualIsIntegratedVault);
        Assert.assertEquals("Distribution Point - Is Collect Customer NRIC Code", convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"), actualIsCollectCustomerNricCode);

        Assert.assertEquals("Distribution Point - Is Return On DPMS", convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"), actualIsReturnsOnDpms);
        Assert.assertEquals("Distribution Point - DPMS Logo URL", distributionPoint.getDpmsLogoUrl(), actualDpmsLogoUrl);

        Assert.assertEquals("Distribution Point - Is Return On Vault", convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"), actualIsReturnsOnVault);
        Assert.assertEquals("Distribution Point - Vault Logo URL", distributionPoint.getVaultLogoUrl(), actualVaultLogoUrl);

        Assert.assertEquals("Distribution Point - Is Return On Shipper Lite", convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"), actualIsReturnsOnShipperLite);
        Assert.assertEquals("Distribution Point - Shipper Lite Logo URL", distributionPoint.getShipperLiteLogoUrl(), actualShipperLiteLogoUrl);

        backToShipperList();
    }

    public void updateShipperReturnsSettings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");

        Return returnSettings = shipper.getReturns();

        sendKeysById("Returns Name", returnSettings.getName());
        sendKeysById("Returns Contact", returnSettings.getContact());
        sendKeysById("Returns Email", returnSettings.getEmail());
        sendKeysById("Returns Address 1", returnSettings.getAddress1());
        sendKeysById("Returns Address 2 / Unit Number", returnSettings.getAddress2());
        sendKeysById("Returns City", returnSettings.getCity());
        sendKeysById("Returns Postcode", returnSettings.getPostcode());
        sendKeysById("Last Returns Number", returnSettings.getLastReturnNumber());
        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperReturnsSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("More Settings");

        Return returnSettings = shipper.getReturns();

        String actualReturnsName = getInputValueById("Returns Name");
        String actualReturnsContact = getInputValueById("Returns Contact");
        String actualReturnsEmail = getInputValueById("Returns Email");
        String actualReturnsAddress1 = getInputValueById("Returns Address 1");
        String actualReturnsAddress2 = getInputValueById("Returns Address 2 / Unit Number");
        String actualReturnsCity = getInputValueById("Returns City");
        String actualReturnsPostcode = getInputValueById("Returns Postcode");
        String actualLastReturnsNumber = getInputValueById("Last Returns Number");

        Assert.assertEquals("Returns Name", returnSettings.getName(), actualReturnsName);
        Assert.assertEquals("Returns Contact", returnSettings.getContact(), actualReturnsContact);
        Assert.assertEquals("Returns Email", returnSettings.getEmail(), actualReturnsEmail);
        Assert.assertEquals("Returns Address1 1", returnSettings.getAddress1(), actualReturnsAddress1);
        Assert.assertEquals("Returns Address1 2", returnSettings.getAddress2(), actualReturnsAddress2);
        Assert.assertEquals("Returns City", returnSettings.getCity(), actualReturnsCity);
        Assert.assertEquals("Returns Postcode", returnSettings.getPostcode(), actualReturnsPostcode);
        Assert.assertEquals("Last Returns Number", returnSettings.getLastReturnNumber(), actualLastReturnsNumber);

        backToShipperList();
    }

    public void updateShipperQoo10Settings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Qoo10 qoo10 = shipper.getQoo10();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.qooUsername']/input", qoo10.getUsername());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.qooPassword']/input", qoo10.getPassword());
        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperQoo10SettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Qoo10 qoo10 = shipper.getQoo10();

        String actualQoo10Username = getValue("//md-input-container[@model='ctrl.data.integrations.qooUsername']/input");
        String actualQoo10Password = getValue("//md-input-container[@model='ctrl.data.integrations.qooPassword']/input");

        Assert.assertEquals("Qoo10 - Username", qoo10.getUsername(), actualQoo10Username);
        Assert.assertEquals("Qoo10 - Password", qoo10.getPassword(), actualQoo10Password);

        backToShipperList();
    }

    public void updateShipperShopifySettings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Shopify shopify = shipper.getShopify();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyMaxDelivery']/input", String.valueOf(shopify.getMaxDeliveryDays()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyDdOffset']/input", String.valueOf(shopify.getDdOffset()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyTimewindowId']/input", String.valueOf(shopify.getDdTimewindowId()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyBaseUrl']/input", shopify.getBaseUri());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyApiKey']/input", shopify.getApiKey());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyPassword']/input", shopify.getPassword());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyCode']/input", shopify.getShippingCodes().get(0));
        clickToggleButton("ctrl.data.integrations.shopifyCodeFilter", convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"));
        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperShopifySettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Shopify shopify = shipper.getShopify();

        String actualMaxDeliveryDays = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyMaxDelivery']/input");
        String actualDdOffset = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyDdOffset']/input");
        String actualDDTimeWindowId = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyTimewindowId']/input");
        String actualBaseUrl = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyBaseUrl']/input");
        String actualApiKey = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyApiKey']/input");
        String actualPassword = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyPassword']/input");
        String actualShippingCodes = getValue("//md-input-container[@model='ctrl.data.integrations.shopifyCode']/input");
        String actualShoppingCodeFilter = getToggleButtonValue("ctrl.data.integrations.shopifyCodeFilter");

        Assert.assertEquals("Shopify - Max Delivery Days", String.valueOf(shopify.getMaxDeliveryDays()), actualMaxDeliveryDays);
        Assert.assertEquals("Shopify - DD Offset", String.valueOf(shopify.getDdOffset()), actualDdOffset);
        Assert.assertEquals("Shopify - DD Time-window ID", String.valueOf(shopify.getDdTimewindowId()), actualDDTimeWindowId);
        Assert.assertEquals("Shopify - Base URL", shopify.getBaseUri(), actualBaseUrl);
        Assert.assertEquals("Shopify - API Key", shopify.getApiKey(), actualApiKey);
        Assert.assertEquals("Shopify - Password", shopify.getPassword(), actualPassword);
        Assert.assertEquals("Shopify - Shipping Codes", shopify.getShippingCodes().get(0), actualShippingCodes);
        Assert.assertEquals("Shopify - Shopping Code Filter", convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"), actualShoppingCodeFilter);

        backToShipperList();
    }

    public void updateShipperMagentoSettings(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Magento magento = shipper.getMagento();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input", magento.getUsername());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input", magento.getPassword());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input", magento.getSoapApiUrl());
        clickNvIconTextButtonByName("Save Changes");

        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void verifyShipperMagentoSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilPageLoaded("shippers/" + shipper.getLegacyId());
        clickTabItem("Integrations");

        Magento magento = shipper.getMagento();

        String actualMagentoUsername = getValue("//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input");
        String actualMagentoPassword = getValue("//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input");
        String actualMagentoApiUrl = getValue("//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input");

        Assert.assertEquals("Magento - Username", magento.getUsername(), actualMagentoUsername);
        Assert.assertEquals("Magento - Password", magento.getPassword(), actualMagentoPassword);
        Assert.assertEquals("Magento - SOAP API URL", magento.getSoapApiUrl(), actualMagentoApiUrl);

        backToShipperList();
    }

    public void backToShipperList()
    {
        clickNvIconTextButtonByName("container.shippers.back-to-shipper-list");

        if (isElementExistFast("//md-dialog//button[@aria-label='Leave']"))
        {
            clickButtonOnMdDialogByAriaLabel("Leave");
        }

        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading shippers...']");
    }

    public void searchTableAddressByAddress(String address)
    {
        searchTableCustom1("address", address);
    }

    public void clickActionButtonOnTableAddress(int rowNumber, String actionButtonNameOrText)
    {
        try
        {
            String xpath1 = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-text-button[@text='%s']", NG_REPEAT_TABLE_ADDRESS, rowNumber, actionButtonNameOrText);
            String xpath2 = String.format("//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-button[@name='%s']", NG_REPEAT_TABLE_ADDRESS, rowNumber, actionButtonNameOrText);
            String xpath = xpath1 + " | " + xpath2;
            WebElement we = findElementByXpath(xpath);
            moveAndClick(we);
        } catch (NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void waitUntilPageLoaded(String expectedUrlEndsWith)
    {
        super.waitUntilPageLoaded();

        waitUntil(() ->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("AllShippersCreateEditPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
            return currentUrl.endsWith(expectedUrlEndsWith);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, String.format("Current URL does not contain '%s'.", expectedUrlEndsWith));

        waitUntilInvisibilityOfElementLocated("//tab-content[@aria-hidden='false']//md-content[@ng-if='ctrl.state.loading === true']//md-progress-circular");
    }
}
