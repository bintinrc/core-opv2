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
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.ContainerSwitch;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.md.TabWrapper;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

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
    @FindBy(xpath = "//div[text()='Shipper Information']")
    public PageElement shipperInformation;

    @FindBy(name = "commons.discard-changes")
    public NvIconTextButton discardChanges;

    @FindBy(css = "tabs-wrapper")
    public TabWrapper tabs;
    @FindBy(name = "container.shippers.create-shipper")
    public NvIconTextButton createShipper;
    @FindBy(name = "Save Changes")
    public NvIconTextButton saveChanges;

    @FindBy(css = "div[model='ctrl.data.basic.status']")
    public ContainerSwitch shipperStatus;
    @FindBy(css = "md-select[ng-model='ctrl.data.basic.shipperType']")
    public MdSelect sipperType;

    @FindBy(name = "container.shippers.pricing-billing-add-new-profile")
    public NvIconTextButton addNewProfile;
    @FindBy(name = "container.shippers.pricing-billing-edit-pending-profile")
    public NvIconTextButton editPendingProfile;
    @FindBy(css = "form[name='ctrl.billingForm'] [id='Billing Name']")
    public TextBox billingName;
    @FindBy(css = "form[name='ctrl.billingForm'] [id='Billing Contact']")
    public TextBox billingContact;
    @FindBy(css = "form[name='ctrl.billingForm'] [id='Billing Address']")
    public TextBox billingAddress;
    @FindBy(css = "form[name='ctrl.billingForm'] [id='Billing Postcode']")
    public TextBox billingPostcode;

    @FindBy(css = "md-dialog")
    public NewPricingProfileDialog newPricingProfileDialog;
    @FindBy(css = "md-dialog")
    public EditPendingProfileDialog editPendingProfileDialog;
    @FindBy(css = "md-dialog")
    public DiscardChangesDialog discardChangesDialog;

    private static final String NG_REPEAT_TABLE_ADDRESS = "address in getTableData()";

    public static final String ACTION_BUTTON_SET_AS_DEFAULT = "Set as Default";
    public static final String LOCATOR_FIELD_OC_VERSION = "ctrl.data.basic.ocVersion";
    public static final String LOCATOR_FIELD_PRICING_SCRIPT = "container.shippers.pricing-billing-pricing-scripts";
    public static final String LOCATOR_FIELD_INDUSTRY = "ctrl.data.basic.industry";
    public static final String LOCATOR_FIELD_SALES_PERSON = "salesperson";
    public static final String LOCATOR_FIELD_CHANNEL = "ctrl.data.basic.shipperClassification";
    public static final String LOCATOR_FIELD_ACCOUNT_TYPE = "ctrl.data.basic.accountType";
    public static final String XPATH_SAVE_CHANGES_PRICING_SCRIPT = "//form//button[@aria-label='Save Changes']";
    public static final String XPATH_DISCOUNT_VALUE = "//input[@id='discount-value']";
    public static final String ARIA_LABEL_COMMENTS = "Comments";
    public static final String XPATH_PRICING_PROFILE_STATUS = "//table[@class='table-body']//td[contains(@class,'status') and text()='%s']";
    public static final String LOCATOR_END_DATE = "container.shippers.pricing-billing-end-date";
    public static final String LOCATOR_START_DATE = "container.shippers.pricing-billing-start-date";
    public static final String XPATH_VALIDATION_ERROR = "//md-dialog[contains(@class, 'nv-container-shipper-errors-dialog')] ";
    public static final String XPATH_SHIPPER_INFORMATION = "//div[text()='Shipper Information']";
    public static final String XPATH_ADD_NEW_PROFILE = "//button[@aria-label='Add New Profile']";
    public static final String XPATH_PRICING_PROFILE_ID = "//table[@class='table-body']//td[contains(@class,'status') and text()='Pending']/preceding-sibling::td[@class='id']";
    public static final String XPATH_EDIT_PENDING_PROFILE = "//button[@aria-label='Edit Pending Profile']";
    public static final String XPATH_DISCOUNT_ERROR_MESSAGE = "//div[contains(@ng-messages,'error') and contains(@class,'ng-active')]/div[@ng-repeat='e in errorMsgs']";
    public static final String XPATH_UPDATE_ERROR_MESSAGE = "//div[@class='error-box']//div[@class='title']";

    public AllShippersCreateEditPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilShipperCreateEditPageIsLoaded()
    {
        shipperInformation.waitUntilClickable(5);
    }

    public void createNewShipper(Shipper shipper)
    {
        String currentWindowHandle = switchToNewWindow();

        waitUntilShipperCreateEditPageIsLoaded();
        pause2s();
        fillBasicSettingsForm(shipper);
        fillMoreSettingsForm(shipper);

        if (shipper.getMarketplaceDefault() != null)
        {
            fillMarketplaceSettingsForm(shipper);
        }

        fillPricingAndBillingForm(shipper);

        createShipper.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(currentWindowHandle);
    }

    public void createNewShipperWithUpdatedPricingScript(Shipper shipper)
    {
        String currentWindowHandle = switchToNewWindow();

        waitUntilShipperCreateEditPageIsLoaded();
        pause2s();
        fillBasicSettingsForm(shipper);
        fillMoreSettingsForm(shipper);

        if (shipper.getMarketplaceDefault() != null)
        {
            fillMarketplaceSettingsForm(shipper);
        }

        fillPricingAndBillingForm(shipper);
        updatePricingScript();

        clickNvIconTextButtonByName("container.shippers.create-shipper");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(currentWindowHandle);

    }

    public void createNewShipperWithoutPricingScript(Shipper shipper)
    {
        String currentWindowHandle = switchToNewWindow();

        waitUntilShipperCreateEditPageIsLoaded();
        pause2s();
        fillBasicSettingsForm(shipper);
        fillMoreSettingsForm(shipper);

        if (shipper.getMarketplaceDefault() != null)
        {
            fillMarketplaceSettingsForm(shipper);
        }

        clickNvIconTextButtonByName("container.shippers.create-shipper");
        String errorText = getText(XPATH_VALIDATION_ERROR);
        assertTrue("Error message is not displayed!", errorText.contains("Pricing and Billing"));
        backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(currentWindowHandle);
    }

    public void updatePricingScript()
    {
        click(XPATH_EDIT_PENDING_PROFILE);
        pause2s();
        moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
        sendKeys(XPATH_DISCOUNT_VALUE, "20");
        sendKeysByAriaLabel(ARIA_LABEL_COMMENTS, "This is edited comment");
        click(XPATH_SAVE_CHANGES_PRICING_SCRIPT);
        pause1s();
    }

    public void updateShipper(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        fillBasicSettingsForm(shipper);
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void updateShipperBasicSettings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        fillBasicSettingsForm(shipper);
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    private void fillBasicSettingsForm(Shipper shipper)
    {
        boolean isCreateForm = getCurrentUrl().endsWith("shippers/create");

        String shipperStatusAriaLabel = convertBooleanToString(shipper.getActive(), "Active", "Disabled");
        shipperStatus.selectValue(shipperStatusAriaLabel);
        sipperType.selectValue(shipper.getType());

        /*
          ===== SHIPPER INFORMATION =====
         */
        sendKeysById("shipper-name", shipper.getName());
        sendKeysById("Short Name", shipper.getShortName());
        sendKeysById("shipper-phone-number", shipper.getContact());

        if (isCreateForm)
        {
            sendKeysById("shipper-email", shipper.getEmail());
            sendKeysById("shipper-dashboard-password", shipper.getShipperDashboardPassword());
        }

        selectValueFromMdSelect(LOCATOR_FIELD_CHANNEL, "B2C Marketplace");
        selectValueFromMdSelect(LOCATOR_FIELD_INDUSTRY, shipper.getIndustryName());
        String accountTypeId = shipper.getAccountTypeId() != null ? String.valueOf(shipper.getAccountTypeId()) : "0";
        selectValueFromMdSelect(LOCATOR_FIELD_ACCOUNT_TYPE, accountTypeId);

        if (isCreateForm)
        {
            selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_SALES_PERSON, shipper.getSalesPerson());
        }

        /*
          ===== CONTACT DETAILS =====
         */
        sendKeysById("Liaison Name", shipper.getLiaisonName());
        sendKeysById("Liaison Contact", shipper.getLiaisonContact());
        sendKeysById("Liaison Email", shipper.getLiaisonEmail());
        sendKeysById("liaison-address", shipper.getLiaisonAddress());
        sendKeysById("Liaison Postcode", shipper.getLiaisonPostcode());

        /*
          ===== SERVICE OFFERINGS =====
         */
        OrderCreate orderCreate = shipper.getOrderCreate();

        selectValueFromMdSelectOrCheckCurrentIfDisabled("OC Version", LOCATOR_FIELD_OC_VERSION, orderCreate.getVersion());

        //Service Type
        // TO-DO: Add 'Parcel Delivery', 'Return', 'Marketplace', 'Ninja Pack', 'Bulky', 'International' and 'Marketplace International'.
        if ("Normal".equals(shipper.getType()))
        {
            clickToggleButtonByLabel("Marketplace", "No");
            clickToggleButtonByLabel("Marketplace International", "No");
            clickToggleButtonByLabel("Corporate", "No");
        }

        if (isCreateForm)
        {
            selectMultipleValuesFromMdSelectById("container.shippers.service-level", orderCreate.getServicesAvailable());
        }

        /*
          ===== OPERATIONAL SETTINGS =====
         */
        clickToggleButton("ctrl.data.basic.allowCod", convertBooleanToString(orderCreate.getAllowCodService(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.allowCp", convertBooleanToString(orderCreate.getAllowCpService(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.isPrePaid", convertBooleanToString(orderCreate.getIsPrePaid(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.allowStaging", convertBooleanToString(orderCreate.getAllowStagedOrders(), "Yes", "No"));
        clickToggleButton("ctrl.data.basic.isMultiParcel", convertBooleanToString(orderCreate.getIsMultiParcelShipper(), "Yes", "No"));

        DistributionPoint distributionPoint = shipper.getDistributionPoints();
        clickToggleButton("ctrl.data.basic.disableReschedule", convertBooleanToString(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt(), "Yes", "No"));
        //To-Do: Add Enforce Pickup Scanning

        //Driver Delivery One-Time Pin
        // To-Do: Add 'No. of Digits in Delivery OTP' and 'No. of Validation Attempts'.

        // Tracking ID
        selectValueFromMdSelect("ctrl.data.basic.trackingType", orderCreate.getTrackingType());

        if (isCreateForm)
        {
            retryIfRuntimeExceptionOccurred(() ->
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

        // Label Printing: Skipped on fill Basic Settings.

        /*
          ===== PRICING & BILLING =====
         */
     /*   Pricing pricing = shipper.getPricing();

        if(pricing!=null && StringUtils.isNotBlank(pricing.getScriptName()))
        {
            selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_PRICING_SCRIPT, pricing.getScriptName());
        }

        // Billing
        sendKeysById("Billing Name", shipper.getBillingName());
        sendKeysById("Billing Contact", shipper.getBillingContact());
        sendKeysById("Billing Address", shipper.getBillingAddress());
        sendKeysById("Billing Postcode", shipper.getBillingPostcode());

      */
    }

    private void fillMoreSettingsForm(Shipper shipper)
    {
        Pickup pickupSettings = shipper.getPickup();

        if (pickupSettings != null)
        {
            clickTabItem("More Settings");

            if (CollectionUtils.isNotEmpty(pickupSettings.getReservationPickupAddresses()))
            {
                pickupSettings.getReservationPickupAddresses().forEach(address ->
                {
                    addAddress(address);
                    verifyPickupAddress(address);
                });
            }

            if (pickupSettings.getPremiumPickupDailyLimit() != null)
            {
                sendKeysById("premium-pickup-daily-limit", String.valueOf(pickupSettings.getPremiumPickupDailyLimit()));
            }

            String startTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(pickupSettings.getDefaultStartTime());
            String endTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(pickupSettings.getDefaultEndTime());
            String defaultPickupTimeSelector = startTimeFormatted + " - " + endTimeFormatted;
            scrollIntoView("//md-select[contains(@id, 'commons.select')]", false);
            selectValueFromMdSelectByIdContains("commons.select", defaultPickupTimeSelector);
        }
    }

    private void fillPricingAndBillingForm(Shipper shipper)
    {
        // ===== PRICING & BILLING =====
        Pricing pricing = shipper.getPricing();

        if (pricing != null)
        {
            tabs.selectTab("Pricing and Billing");

            if (StringUtils.isNotBlank(pricing.getScriptName()))
            {
                addNewProfile.click();
                newPricingProfileDialog.waitUntilVisible();
                newPricingProfileDialog.pricingScript.searchAndSelectValue(pricing.getScriptName());
                newPricingProfileDialog.codCountryDefaultCheckbox.check();
                newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();

                newPricingProfileDialog.saveChanges.clickAndWaitUntilDone();
                newPricingProfileDialog.waitUntilInvisible();
            }
        }
        // Billing
        billingName.setValue(shipper.getBillingName());
        billingContact.setValue(shipper.getBillingContact());
        billingAddress.setValue(shipper.getBillingAddress());
        billingPostcode.setValue(shipper.getBillingPostcode());
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
        executeInContext(itemXpath, () ->
        {
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
        waitUntilShipperCreateEditPageIsLoaded();
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
            assertEquals("Number of Milkrun Reservations", reservationsCount - 1, getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"));
            clickNvApiTextButtonByName("commons.save-changes");
            waitUntilInvisibilityOfMdDialogByTitle("Edit Address");
        }

        clickNvIconTextButtonByName("Save Changes");
        waitUntilInvisibilityOfToast("All changes saved successfully");
        backToShipperList();
    }

    public void removeAllMilkrunReservations(Shipper shipper, int addressIndex)
    {
        waitUntilShipperCreateEditPageIsLoaded();
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
        waitUntilShipperCreateEditPageIsLoaded();
        clickTabItem("More Settings");
        if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses()))
        {
            shipper.getPickup().getReservationPickupAddresses().stream().filter(Address::getMilkRun).forEach(address ->
            {
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
        waitUntilShipperCreateEditPageIsLoaded();
        String actualShipperStatus = getToggleButtonValue("ctrl.data.basic.status");
        String actualShipperType;

        if (StringUtils.equalsIgnoreCase(shipper.getType(), "Marketplace"))
        {
            actualShipperType = getInputValueById("Shipper Type");
        } else
        {
            actualShipperType = getMdSelectValueTrimmed("ctrl.data.basic.shipperType");
        }

        assertEquals("Shipper Status", convertBooleanToString(shipper.getActive(), "Active", "Disabled"), actualShipperStatus);
        assertEquals("Shipper Type", shipper.getType(), actualShipperType);

        // Shipper Details
        String actualShipperName = getInputValueById("shipper-name");
        String actualShipperShortName = getInputValueById("Short Name");
        String actualShipperContact = getInputValueById("shipper-phone-number");
        String actualShipperEmail = getInputValueById("shipper-email", XpathTextMode.STARTS_WITH);

        assertEquals("Shipper Name", shipper.getName(), actualShipperName);
        assertEquals("Shipper Short Name", shipper.getShortName(), actualShipperShortName);
        assertEquals("Shipper Contact", shipper.getContact(), actualShipperContact);
        assertEquals("Shipper Email", shipper.getEmail(), actualShipperEmail);

        // Liaison Details
        String actualLiaisonName = getInputValueById("Liaison Name");
        String actualLiaisonContact = getInputValueById("Liaison Contact");
        String actualLiaisonEmail = getInputValueById("Liaison Email");
        String actualLiaisonAddress = getInputValueById("liaison-address");
        String actualLiaisonPostcode = getInputValueById("Liaison Postcode");

        assertEquals("Liaison Name", shipper.getLiaisonName(), actualLiaisonName);
        assertEquals("Liaison Contact", shipper.getLiaisonContact(), actualLiaisonContact);
        assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        assertEquals("Liaison Address", shipper.getLiaisonAddress(), actualLiaisonAddress);
        assertEquals("Liaison Postcode", shipper.getLiaisonPostcode(), actualLiaisonPostcode);

        // Services
        String actualOcVersion = getMdSelectValueTrimmed("ctrl.data.basic.ocVersion");
        String availableService = getAttribute("//*[@id='container.shippers.service-level']", "aria-label");
        String actualTrackingType = getMdSelectValue("ctrl.data.basic.trackingType");
        String actualPrefix = getInputValueById("shipper-prefix");

        List<String> listOfActualServices;

        if (availableService == null || availableService.equals("oc-services"))
        {
            listOfActualServices = new ArrayList<>();
        } else
        {
            String[] temp = availableService.replace("Service Level:", "").split(",");
            listOfActualServices = Stream.of(temp).map(val -> val.replace(" ", "").toUpperCase()).collect(Collectors.toList());
        }

        OrderCreate orderCreate = shipper.getOrderCreate();
        assertEquals("OC Version", orderCreate.getVersion(), actualOcVersion);
        assertThat("Services Available", listOfActualServices, hasItems(orderCreate.getServicesAvailable().toArray(new String[]{})));
        assertEquals("Tracking Type", orderCreate.getTrackingType(), actualTrackingType);
        assertEquals("Prefix", orderCreate.getPrefix(), actualPrefix);

        String actualAllowCodService = getToggleButtonValue("ctrl.data.basic.allowCod");
        String actualAllowCpService = getToggleButtonValue("ctrl.data.basic.allowCp");
        String actualIsPrePaid = getToggleButtonValue("ctrl.data.basic.isPrePaid");
        String actualAllowStagedOrders = getToggleButtonValue("ctrl.data.basic.allowStaging");
        String actualIsMultiParcelShipper = getToggleButtonValue("ctrl.data.basic.isMultiParcel");
        String actualShipperLiteAllowRescheduleFirstAttempt = getToggleButtonValue("ctrl.data.basic.disableReschedule");

        DistributionPoint distributionPoint = shipper.getDistributionPoints();

        assertEquals("Allow COD Service", convertBooleanToString(orderCreate.getAllowCodService(), "Yes", "No"), actualAllowCodService);
        assertEquals("Allow CP Service", convertBooleanToString(orderCreate.getAllowCpService(), "Yes", "No"), actualAllowCpService);
        assertEquals("Is Prepaid Account", convertBooleanToString(orderCreate.getIsPrePaid(), "Yes", "No"), actualIsPrePaid);
        assertEquals("Allow Staged Orders", convertBooleanToString(orderCreate.getAllowStagedOrders(), "Yes", "No"), actualAllowStagedOrders);
        assertEquals("Is Multi Parcel Shipper", convertBooleanToString(orderCreate.getIsMultiParcelShipper(), "Yes", "No"), actualIsMultiParcelShipper);
        assertEquals("Disable Driver App Reschedule", convertBooleanToString(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt(), "Yes", "No"), actualShipperLiteAllowRescheduleFirstAttempt);

        // Industry & Sales
        String actualIndustry = getMdSelectValue(LOCATOR_FIELD_INDUSTRY); //getNvAutocompleteValue("ctrl.view.industry.searchText");
        String actualSalesPerson = getMdSelectValueById(LOCATOR_FIELD_SALES_PERSON); //getNvAutocompleteValue("ctrl.view.salesPerson.searchText");

        assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        assertEquals("Sales Person", shipper.getSalesPerson(), actualSalesPerson);

        verifyMoreSettingsTab(shipper);

        // Pricing
        tabs.selectTab("Pricing and Billing");
//        Pricing pricing = shipper.getPricing();
//        String actualPricingScript = getMdSelectValueById(LOCATOR_FIELD_PRICING_SCRIPT);
//        assertThat("Pricing Script", actualPricingScript, endsWith(pricing.getScriptName()));

        // Billing
        String actualBillingName = billingName.getValue();
        String actualBillingContact = billingContact.getValue();
        String actualBillingAddress = billingAddress.getValue();
        String actualBillingPostcode = billingPostcode.getValue();

        assertEquals("Billing Name", shipper.getBillingName(), actualBillingName);
        assertEquals("Billing Contact", shipper.getBillingContact(), actualBillingContact);
        assertEquals("Billing Address", shipper.getBillingAddress(), actualBillingAddress);
        assertEquals("Billing Postcode", shipper.getBillingPostcode(), actualBillingPostcode);
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
        assertTrue("Pickup Addresses with contact [" + address.getContact() + "] exists", !isTableEmpty());
        String actualAddress = isEditForm ?
                getTextOnTableWithMdVirtualRepeat(1, "address", "address in getTableData()") :
                getTextOnTableWithNgRepeat(1, "address", "address in getTableData()");

        assertEquals("Address", address.to1LineAddressWithPostcode(), actualAddress);

        if (BooleanUtils.isTrue(address.getMilkRun()))
        {
            assertTrue("Milkrun action button is not displayed for address", isElementVisible("//nv-icon-text-button[@name='container.shippers.milkrun']"));
            verifyMilkrunSettings(address);
            scrollIntoView("//*[@name='container.shippers.more-reservation-add-pickup-address']", false);
        } else
        {
            assertTrue("Set As Milkrun action button is not displayed for address", isElementVisible("//nv-icon-text-button[@name='container.shippers.set-as-milkrun']"));
        }
    }

    public void verifyMilkrunSettings(Address address)
    {
        int reservationsCount = CollectionUtils.size(address.getMilkrunSettings());
        clickNvIconButtonByName("container.shippers.more-reservation-edit-pickup-address");
        waitUntilVisibilityOfMdDialogByTitle("Edit Address");
        click("//span[.='Milkrun Reservations']");
        waitUntilVisibilityOfElementLocated("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']");
        assertEquals("Number of Milkrun Reservations", reservationsCount, getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"));
        clickNvIconButtonByName("Cancel");
        waitUntilInvisibilityOfMdDialogByTitle("Edit Address");
    }

    public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper, Address address, Reservation reservation)
    {
        waitUntilShipperCreateEditPageIsLoaded();
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
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("Basic Settings");

        LabelPrinter labelPrinter = shipper.getLabelPrinter();
        sendKeysById("Printer IP", labelPrinter.getPrinterIp());
        clickToggleButton("ctrl.data.basic.isPrinterAvailable", convertBooleanToString(labelPrinter.getShowShipperDetails(), "Yes", "No"));
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        clickTabItem("Basic Settings");

        LabelPrinter labelPrinter = shipper.getLabelPrinter();

        String actualPrinterIp = getInputValueById("Printer IP");
        String actualShowShipperDetails = getToggleButtonValue("ctrl.data.basic.isPrinterAvailable");

        assertEquals("Label Printer - Printer IP", labelPrinter.getPrinterIp(), actualPrinterIp);
        assertEquals("Label Printer - Show Shipper Details", convertBooleanToString(labelPrinter.getShowShipperDetails(), "Yes", "No"), actualShowShipperDetails);

        backToShipperList();
    }

    public void updateShipperDistributionPointSettings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("More Settings");

        DistributionPoint distributionPoint = shipper.getDistributionPoints();

        clickToggleButton("ctrl.data.more.isIntegratedVault", convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"));
        clickToggleButton("ctrl.data.more.isCollectCustomerNricCode", convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"));

        clickToggleButton("ctrl.data.more.isReturnsOnDpms", convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"));
        sendKeysById("DPMS Logo URL", distributionPoint.getDpmsLogoUrl());

        clickToggleButton("ctrl.data.more.isReturnsOnVault", convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"));
        sendKeysById("Vault Logo URL", distributionPoint.getVaultLogoUrl());

        clickToggleButton("ctrl.data.more.isReturnsOnShipperLite", convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"));
        sendKeysById("Shipper Lite Logo URL", distributionPoint.getShipperLiteLogoUrl());

        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
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

        assertEquals("Distribution Point - Is Integrated Vault", convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"), actualIsIntegratedVault);
        assertEquals("Distribution Point - Is Collect Customer NRIC Code", convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"), actualIsCollectCustomerNricCode);

        assertEquals("Distribution Point - Is Return On DPMS", convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"), actualIsReturnsOnDpms);
        assertEquals("Distribution Point - DPMS Logo URL", distributionPoint.getDpmsLogoUrl(), actualDpmsLogoUrl);

        assertEquals("Distribution Point - Is Return On Vault", convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"), actualIsReturnsOnVault);
        assertEquals("Distribution Point - Vault Logo URL", distributionPoint.getVaultLogoUrl(), actualVaultLogoUrl);

        assertEquals("Distribution Point - Is Return On Shipper Lite", convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"), actualIsReturnsOnShipperLite);
        assertEquals("Distribution Point - Shipper Lite Logo URL", distributionPoint.getShipperLiteLogoUrl(), actualShipperLiteLogoUrl);

        backToShipperList();
    }

    public void updateShipperReturnsSettings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("More Settings");

        Return returnSettings = shipper.getReturns();

        sendKeysById("Returns Name", returnSettings.getName());
        sendKeysById("Returns Contact", returnSettings.getContact());
        sendKeysById("Returns Email", returnSettings.getEmail());
        sendKeysById("Returns Address 1", returnSettings.getAddress1());
        sendKeysById("Returns Address 2 / Unit Number", returnSettings.getAddress2());
        sendKeysById("Returns City", returnSettings.getCity());
        sendKeysById("Returns Postcode", returnSettings.getPostcode());
        sendKeysById("Last Returns Number", String.valueOf(returnSettings.getLastReturnNumber()));
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperReturnsSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
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

        assertEquals("Returns Name", returnSettings.getName(), actualReturnsName);
        assertEquals("Returns Contact", returnSettings.getContact(), actualReturnsContact);
        assertEquals("Returns Email", returnSettings.getEmail(), actualReturnsEmail);
        assertEquals("Returns Address1 1", returnSettings.getAddress1(), actualReturnsAddress1);
        assertEquals("Returns Address1 2", returnSettings.getAddress2(), actualReturnsAddress2);
        assertEquals("Returns City", returnSettings.getCity(), actualReturnsCity);
        assertEquals("Returns Postcode", returnSettings.getPostcode(), actualReturnsPostcode);
        assertEquals("Last Returns Number", String.valueOf(returnSettings.getLastReturnNumber()), actualLastReturnsNumber);

        backToShipperList();
    }

    public void updateShipperQoo10Settings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("Integrations");

        Qoo10 qoo10 = shipper.getQoo10();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.qooUsername']/input", qoo10.getUsername());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.qooPassword']/input", qoo10.getPassword());
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperQoo10SettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        clickTabItem("Integrations");

        Qoo10 qoo10 = shipper.getQoo10();

        String actualQoo10Username = getValue("//md-input-container[@model='ctrl.data.integrations.qooUsername']/input");
        String actualQoo10Password = getValue("//md-input-container[@model='ctrl.data.integrations.qooPassword']/input");

        assertEquals("Qoo10 - Username", qoo10.getUsername(), actualQoo10Username);
        assertEquals("Qoo10 - Password", qoo10.getPassword(), actualQoo10Password);

        backToShipperList();
    }

    public void updateShipperShopifySettings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("Integrations");

        Shopify shopify = shipper.getShopify();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyMaxDelivery']/input", String.valueOf(shopify.getMaxDeliveryDays()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyDdOffset']/input", String.valueOf(shopify.getDdOffset()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyTimewindowId']/input", String.valueOf(shopify.getDdTimewindowId()));
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyBaseUrl']/input", shopify.getBaseUri());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyApiKey']/input", shopify.getApiKey());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyPassword']/input", shopify.getPassword());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyCode']/input", shopify.getShippingCodes().get(0));
        clickToggleButton("ctrl.data.integrations.shopifyCodeFilter", convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"));
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperShopifySettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
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

        assertEquals("Shopify - Max Delivery Days", String.valueOf(shopify.getMaxDeliveryDays()), actualMaxDeliveryDays);
        assertEquals("Shopify - DD Offset", String.valueOf(shopify.getDdOffset()), actualDdOffset);
        assertEquals("Shopify - DD Time-window ID", String.valueOf(shopify.getDdTimewindowId()), actualDDTimeWindowId);
        assertEquals("Shopify - Base URL", shopify.getBaseUri(), actualBaseUrl);
        assertEquals("Shopify - API Key", shopify.getApiKey(), actualApiKey);
        assertEquals("Shopify - Password", shopify.getPassword(), actualPassword);
        assertEquals("Shopify - Shipping Codes", shopify.getShippingCodes().get(0), actualShippingCodes);
        assertEquals("Shopify - Shopping Code Filter", convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"), actualShoppingCodeFilter);

        backToShipperList();
    }

    public void updateShipperMagentoSettings(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        tabs.selectTab("Integrations");

        Magento magento = shipper.getMagento();

        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input", magento.getUsername());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input", magento.getPassword());
        sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input", magento.getSoapApiUrl());
        saveChanges.click();
        waitUntilInvisibilityOfToast("All changes saved successfully");
    }

    public void verifyShipperMagentoSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        waitUntilShipperCreateEditPageIsLoaded();
        clickTabItem("Integrations");

        Magento magento = shipper.getMagento();

        String actualMagentoUsername = getValue("//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input");
        String actualMagentoPassword = getValue("//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input");
        String actualMagentoApiUrl = getValue("//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input");

        assertEquals("Magento - Username", magento.getUsername(), actualMagentoUsername);
        assertEquals("Magento - Password", magento.getPassword(), actualMagentoPassword);
        assertEquals("Magento - SOAP API URL", magento.getSoapApiUrl(), actualMagentoApiUrl);

        backToShipperList();
    }

    public void backToShipperList()
    {
        discardChanges.click();
        pause2s();
        if (discardChangesDialog.leave.isDisplayedFast())
        {
            discardChangesDialog.leave.click();
        }
        webDriver.switchTo().window(webDriver.getWindowHandles().iterator().next());
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
            throw new NvTestRuntimeException("Cannot find action button on table.", ex);
        }
    }

    /*  public void waitUntilPageLoaded(String expectedUrlEndsWith)
      {
          super.waitUntilPageLoaded();

          waitUntil(() ->
          {
              String currentUrl = getCurrentUrl();
              NvLogger.infof("AllShippersCreateEditPage.waitUntilPageLoaded: Current URL = [%s] - Expected URL contains = [%s]", currentUrl, expectedUrlEndsWith);
              return currentUrl.endsWith(expectedUrlEndsWith);
          }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS, f("Current URL does not contain '%s'.", expectedUrlEndsWith));

          waitUntilInvisibilityOfElementLocated("//tab-content[@aria-hidden='false']//md-content[@ng-if='ctrl.state.loading === true']//md-progress-circular");
      }
  */

    public String addNewPricingScript(Shipper shipper)
    {
        waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION);
        Pricing pricing = shipper.getPricing();
        if (pricing != null)
        {
            clickTabItem(" Pricing and Billing");

            if (StringUtils.isNotBlank(pricing.getScriptName()))
            {
                click(XPATH_ADD_NEW_PROFILE);
                pause2s();
                selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_PRICING_SCRIPT, pricing.getScriptName());
                setMdDatepickerById(LOCATOR_START_DATE, TestUtils.getNextDate(1));
                setMdDatepickerById(LOCATOR_END_DATE, TestUtils.getNextDate(10));
                if (pricing.getDiscount() != null)
                {
                    moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
                    sendKeys(XPATH_DISCOUNT_VALUE, pricing.getDiscount());
                }
                newPricingProfileDialog.codCountryDefaultCheckbox.check();
                newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
                if (pricing.getComments() != null)
                {
                    sendKeysByAriaLabel(ARIA_LABEL_COMMENTS, pricing.getComments());
                }
                click(XPATH_SAVE_CHANGES_PRICING_SCRIPT);
            }
        }

        String status = getText(f(XPATH_PRICING_PROFILE_STATUS, "Pending"));
        assertEquals("Status is not Pending ", status, "Pending");
        saveChanges.click();
        waitUntilInvisibilityOfElementLocated(XPATH_DISCOUNT_VALUE);

        return retryIfAssertionErrorOccurred(() ->
        {
            String pricingProfileId = getText(XPATH_PRICING_PROFILE_ID);
            assertNotNull(pricingProfileId);
            assertFalse(pricingProfileId.equals(""));
            return pricingProfileId;
        }, "Getting Pricing Profile ID");
    }

    public void editPricingScript(Shipper shipper)
    {
        String currentWindowHandle = switchToNewWindow();

        Pricing pricing = shipper.getPricing();

        if (pricing != null)
        {
            clickTabItem(" Pricing and Billing");

            if (pricing != null && StringUtils.isNotBlank(pricing.getScriptName()))
            {
                click("//button[@aria-label='Edit Pending Profile']");
                pause2s();
                setMdDatepickerById(LOCATOR_END_DATE, TestUtils.getNextDate(15));
                setMdDatepickerById(LOCATOR_START_DATE, TestUtils.getNextWorkingDay());
                moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
                sendKeys(XPATH_DISCOUNT_VALUE, pricing.getDiscount());
                sendKeysByAriaLabel(ARIA_LABEL_COMMENTS, pricing.getComments());
                click(XPATH_SAVE_CHANGES_PRICING_SCRIPT);
                pause1s();
            }
        }

        String status = getText(f(XPATH_PRICING_PROFILE_STATUS, "Pending"));
        assertEquals("Status is not Pending ", status, "Pending");

        backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(currentWindowHandle);
    }

    public void verifyPricingScriptIsActive(String status, String status1)
    {
        waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION);
        clickTabItem(" Pricing and Billing");

        String statusText = getText(f(XPATH_PRICING_PROFILE_STATUS, status));
        assertEquals("Status is not correct", status, statusText);

        if (!status1.equalsIgnoreCase(""))
        {
            String statusText1 = getText(f(XPATH_PRICING_PROFILE_STATUS, status1));
            assertEquals("Status is not correct", status1, statusText1);
        }

        backToShipperList();
        pause3s();
    }

    public void verifyEditPendingProfileIsDisplayed()
    {
        waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION);
        clickTabItem(" Pricing and Billing");

        assertTrue("Edit Pending Profile is not displayed", isElementVisible(XPATH_EDIT_PENDING_PROFILE));

        backToShipperList();
        pause3s();
    }

    public void addNewPricingScriptAndVerifyErrorMessage(Shipper shipper, String errorMessage)
    {
        Pricing pricing = shipper.getPricing();
        if (pricing != null)
        {
            tabs.selectTab("Pricing and Billing");
            if (StringUtils.isNotBlank(pricing.getScriptName()))
            {
                addNewProfile.click();
                pause2s();
                selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_PRICING_SCRIPT, pricing.getScriptName());
                moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
                sendKeys(XPATH_DISCOUNT_VALUE, pricing.getDiscount());
                String errorMessageText = getText(XPATH_DISCOUNT_ERROR_MESSAGE);
                assertTrue("Error Message is displayed: ", errorMessage.equalsIgnoreCase(errorMessageText));
                clickButtonByAriaLabel("Cancel");
            }
        }
    }

    public void addNewPricingScriptWithDiscountOver6DigitsAndVerifyErrorMessage(Shipper shipper, String errorMessage)
    {
        Pricing pricing = shipper.getPricing();
        if (pricing != null)
        {
            tabs.selectTab("Pricing and Billing");
            if (StringUtils.isNotBlank(pricing.getScriptName()))
            {
                addNewProfile.click();
                pause2s();
                selectValueFromMdSelectWithSearchById(LOCATOR_FIELD_PRICING_SCRIPT, pricing.getScriptName());
                moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
                sendKeys(XPATH_DISCOUNT_VALUE, pricing.getDiscount());
                sendKeysByAriaLabel(ARIA_LABEL_COMMENTS, pricing.getComments());
                newPricingProfileDialog.codCountryDefaultCheckbox.check();
                newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
                click(XPATH_SAVE_CHANGES_PRICING_SCRIPT);
                pause1s();
            }
        }
        clickNvIconTextButtonByName("Save Changes");
        waitUntilVisibilityOfToast("Some changes may not saved successfully");

        String errorMessageText = getText(XPATH_UPDATE_ERROR_MESSAGE);
        assertTrue("Error message is not displayed: ", errorMessageText.contains(errorMessage));

        clickNvIconTextButtonByName("Close");
    }

    public static class NewPricingProfileDialog extends MdDialog
    {
        public NewPricingProfileDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-id'] div.readonly")
        public PageElement shipperId;

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-name'] div.readonly")
        public PageElement shipperName;

        @FindBy(id = "container.shippers.pricing-billing-start-date")
        public MdDatepicker pricingBillingStartDate;

        @FindBy(id = "container.shippers.pricing-billing-end-date")
        public MdDatepicker pricingBillingEndDate;

        @FindBy(id = "container.shippers.pricing-billing-pricing-scripts")
        public MdSelect pricingScript;

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-salesperson-discount-type'] div.readonly")
        public PageElement pricingBillingSalespersonDicountType;

        @FindBy(id = "discount-value")
        public TextBox discountValue;

        @FindBy(css = "md-input-container[label='Use Country Default - Higher of: S$ 1 OR 3% of COD Value'] div.md-container")
        public CheckBox codCountryDefaultCheckbox;

        @FindBy(css = "md-input-container[label='Use Country Default - Higher of: S$ 0 OR 1.2% of Insured Value'] div.md-container")
        public CheckBox insuranceCountryDefaultCheckbox;

        @FindBy(css = "[id^='container.shippers.pricing-billing-comments']")
        public TextBox comments;

        @FindBy(name = "Save Changes")
        public NvApiTextButton saveChanges;
    }

    public static class EditPendingProfileDialog extends MdDialog
    {
        public EditPendingProfileDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-id'] div.readonly")
        public PageElement shipperId;

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-name'] div.readonly")
        public PageElement shipperName;

        @FindBy(id = "container.shippers.pricing-billing-start-date")
        public MdDatepicker pricingBillingStartDate;

        @FindBy(id = "container.shippers.pricing-billing-end-date")
        public MdDatepicker pricingBillingEndDate;

        @FindBy(id = "container.shippers.pricing-billing-pricing-scripts")
        public MdSelect pricingScript;

        @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-salesperson-discount-type'] div.readonly")
        public PageElement pricingBillingSalespersonDicountType;

        @FindBy(id = "discount-value")
        public TextBox discountValue;

        @FindBy(css = "[name='discount-value'] div[ng-repeat]")
        public PageElement discountValueError;

        @FindBy(css = "[id^='container.shippers.pricing-billing-comments']")
        public TextBox comments;

        @FindBy(name = "Save Changes")
        public NvApiTextButton saveChanges;
    }

    public static class DiscardChangesDialog extends MdDialog
    {
        public DiscardChangesDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "button[aria-label='Leave']")
        public Button leave;
    }
}
