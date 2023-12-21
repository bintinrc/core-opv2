package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.model.address.MilkrunSettings;
import co.nvqa.common.shipper.model.ServiceTypeLevel;
import co.nvqa.common.shipper.model.Shipper;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.shipper.model.settings.DistributionPoint;
import co.nvqa.common.shipper.model.settings.LabelPrinter;
import co.nvqa.common.shipper.model.settings.MarketplaceBilling;
import co.nvqa.common.shipper.model.settings.MarketplaceDefault;
import co.nvqa.common.shipper.model.settings.OrderCreate;
import co.nvqa.common.shipper.model.settings.Pickup;
import co.nvqa.common.shipper.model.settings.Pricing;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdBooleanSwitch;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.md.TabWrapper;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.utils.StandardTestConstants.NV_SYSTEM_ID;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersCreateEditPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersCreateEditPage.class);

  @FindBy(name = "ctrl.basicForm")
  public BasicSettingsForm basicSettingsForm;
  @FindBy(xpath = "//md-content[./form[@name='ctrl.billingForm']]")
  public PricingAndBillingForm pricingAndBillingForm;

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

  //region MORE SETTINGS

  @FindBy(css = "form[name='ctrl.moreForm'] [name='container.shippers.add-new-service']")
  public NvIconTextButton moreSettingsAddNewService;

  @FindBy(name = "container.shippers.milkrun")
  public NvIconTextButton milkrun;

  @FindBy(name = "container.shippers.more-reservation-add-pickup-address")
  public NvIconTextButton addAddress;

  @FindBy(name = "container.shippers.more-reservation-edit-pickup-address")
  public NvIconButton editAddress;

  //endregion

  //region MARKETPLACE

  //region Services
  @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.ocVersion']")
  public MdSelect ocVersion;
  @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.selectedOcServices']")
  public MdSelect ocServices;
  @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.trackingType']")
  public MdSelect marketplaceTrackingType;
  //endregion

  //region Billing
  @FindBy(css = "form[name='ctrl.marketplaceForm'] [id='Billing Name']")
  public TextBox marketplaceBillingName;
  @FindBy(css = "form[name='ctrl.marketplaceForm'] [id='Billing Contact']")
  public TextBox marketplaceBillingContact;
  @FindBy(css = "form[name='ctrl.marketplaceForm'] [id='Billing Address']")
  public TextBox marketplaceBillingAddress;
  @FindBy(css = "form[name='ctrl.marketplaceForm'] [id='Billing Postcode']")
  public TextBox marketplaceBillingPostcode;
  //endregion

  //region Pickup Service
  @FindBy(css = "form[name='ctrl.marketplaceForm'] [id='premium-pickup-daily-limit']")
  public TextBox premiumPickupDailyLimit;
  @FindBy(css = "md-dialog")
  public NewPricingProfileDialog newPricingProfileDialog;
  @FindBy(css = "md-dialog")
  public DiscardChangesDialog discardChangesDialog;
  @FindBy(css = "md-dialog")
  public ErrorSaveDialog errorSaveDialog;
  @FindBy(css = "md-dialog")
  public UnsetAsMilkrunDialog unsetAsMilkrunDialog;

  @FindBy(css = "md-dialog")
  public AddAddressDialog addAddressDialog;
  public static final String LOCATOR_FIELD_OC_VERSION = "ctrl.data.basic.ocVersion";

  public AllShippersCreateEditPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void waitUntilShipperCreateEditPageIsLoaded() {
    shipperInformation.waitUntilClickable(120);
  }

  public void openPage(String legacyId) {
    openPage(Long.parseLong(legacyId));
  }

  public void openPage(long legacyId) {
    getWebDriver().get(f("%s/%s/shippers/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
        NV_SYSTEM_ID.toLowerCase(), legacyId));
    pause1s();
    closeDialogIfVisible();
    waitWhilePageIsLoading(120);
  }

  public void createNewShipper(Shipper shipper) {
    String currentWindowHandle = switchToNewWindow();

    createNewShipperSteps(shipper);
    if (errorSaveDialog.isDisplayed()) {
      String errorMessage = errorSaveDialog.message.getText();
      LOGGER.info(f("Error dialog is displayed : %s ", errorMessage));
      if ((errorMessage.contains("devsupport@ninjavan.co")) || errorMessage
          .contains("DB constraints")) {
        errorSaveDialog.forceClose();
        if (Objects.nonNull(getToast())) {
          LOGGER.info(f("Toast msg is displayed :  %s ", getToast().getText()));
          closeToast();
        }
        createShipper.click();
      }
    }
    waitUntilInvisibilityOfToast("All changes saved successfully");
    String url = getWebDriver().getCurrentUrl();
    shipper.setLegacyId(Long.valueOf(url.substring(url.lastIndexOf("/") + 1)));
    if (!shipper.getActive()) {
      waitWhilePageIsLoading();
      basicSettingsForm.shipperStatus.selectValue("Disabled");
      saveChanges.click();
      waitUntilInvisibilityOfToast("All changes saved successfully");
    }
    waitUntilShipperCreateEditPageIsLoaded();
    backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(currentWindowHandle);
  }

  public void createNewShipperSteps(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    pause2s();
    fillBasicSettingsForm(shipper);
    fillMoreSettingsForm(shipper);

    if (shipper.getMarketplaceDefault() != null) {
      fillMarketplaceSettingsForm(shipper);
    }

    fillPricingAndBillingForm(shipper);

    createShipper.click();
  }

  private void fillBasicSettingsForm(Shipper shipper) {
    boolean isCreateForm = getCurrentUrl().endsWith("shippers/create");

    String shipperStatusAriaLabel = convertBooleanToString(shipper.getActive(), "Active",
        "Disabled");
    basicSettingsForm.shipperStatus.selectValue(shipperStatusAriaLabel);
    basicSettingsForm.shipperType.selectValue(shipper.getType());

    // ===== SHIPPER INFORMATION =====

    basicSettingsForm.shipperName.setValue(shipper.getName());
    basicSettingsForm.shortName.setValue(shipper.getShortName());
    basicSettingsForm.shipperPhoneNumber.setValue(shipper.getContact());

    if (isCreateForm) {
      basicSettingsForm.shipperEmail.setValue(shipper.getEmail());

    }

    basicSettingsForm.channel.selectValue("B2C Marketplace");
    basicSettingsForm.industry.selectValue(shipper.getIndustryName());
    String accountTypeId =
        shipper.getAccountTypeId() != null ? String.valueOf(shipper.getAccountTypeId()) : "0";
    basicSettingsForm.accountType.selectByValue(accountTypeId);
    if (isCreateForm) {
      basicSettingsForm.salesperson.searchAndSelectValue(shipper.getSalesPerson());
    }

    // ===== CONTACT DETAILS =====

    basicSettingsForm.liaisonName.setValue(shipper.getLiaisonName());
    basicSettingsForm.liaisonContact.setValue(shipper.getLiaisonContact());
    basicSettingsForm.liaisonEmail.setValue(shipper.getLiaisonEmail());
    basicSettingsForm.liaisonAddress.setValue(shipper.getLiaisonAddress());
    basicSettingsForm.liaisonPostcode.setValue(shipper.getLiaisonPostcode());

    // ===== SERVICE OFFERINGS =====

    OrderCreate orderCreate = shipper.getOrderCreate();

    selectValueFromMdSelectOrCheckCurrentIfDisabled("OC Version", LOCATOR_FIELD_OC_VERSION,
        orderCreate.getVersion());

    if (StringUtils.equalsAnyIgnoreCase(shipper.getType(), "Normal", "Corporate HQ")) {
      basicSettingsForm.marketplace.selectValue("No");
      basicSettingsForm.marketplaceInternational.selectValue("No");
    }
    if (StringUtils.equalsAnyIgnoreCase(shipper.getType(), "Normal", "Marketplace")) {
      basicSettingsForm.corporate.selectValue("No");
      basicSettingsForm.corporateReturn.selectValue("No");
      basicSettingsForm.corporateManualAWB.selectValue("No");
      basicSettingsForm.corporateDocument.selectValue("No");
    }
    basicSettingsForm.corporate.selectValue(orderCreate.getIsCorporate());
    basicSettingsForm.corporateReturn.selectValue(orderCreate.getIsCorporateReturn());
    basicSettingsForm.corporateManualAWB.selectValue(orderCreate.getIsCorporateManualAWB());
    basicSettingsForm.corporateDocument.selectValue(orderCreate.getIsCorporateDocument());

    if (isCreateForm) {
      selectMultipleValuesFromMdSelectById("container.shippers.service-level",
          orderCreate.getServicesAvailable());
    }

    //===== OPERATIONAL SETTINGS =====

    basicSettingsForm.allowCod.selectValue(orderCreate.getAllowCodService());
    basicSettingsForm.allowCp.selectValue(orderCreate.getAllowCpService());
    basicSettingsForm.isPrePaid.selectValue(orderCreate.getIsPrePaid());
    basicSettingsForm.allowStaging.selectValue(orderCreate.getAllowStagedOrders());
    basicSettingsForm.isMultiParcel.selectValue(orderCreate.getIsMultiParcelShipper());

    DistributionPoint distributionPoint = shipper.getDistributionPoints();
    basicSettingsForm.disableReschedule
        .selectValue(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt());

    basicSettingsForm.trackingType.selectValue(orderCreate.getTrackingType());

    if (isCreateForm) {
      doWithRetry(() ->
      {
        String generatedPrefix = generateUpperCaseAlphaNumericString(5);
        orderCreate.setPrefix(generatedPrefix);
        basicSettingsForm.shipperPrefix.setValue(generatedPrefix + Keys.ENTER);
        basicSettingsForm.labelForShipperPrefix.click();
        if (basicSettingsForm.prefixAlreadyUsed.waitUntilVisible(2)) {
          throw new NvTestRuntimeException("Prefix already used. Regenerate new prefix.");
        }
      }, "");
    }

    // Label Printing:
    LabelPrinter labelPrinter = shipper.getLabelPrinter();
    if (labelPrinter != null) {
      basicSettingsForm.showShipperDetails.selectValue(labelPrinter.getShowShipperDetails());
      basicSettingsForm.showCod.selectValue(labelPrinter.getShowCod());
      basicSettingsForm.showParcelDescription.selectValue(labelPrinter.getShowParcelDescription());
    }
  }

  private void fillMoreSettingsForm(Shipper shipper) {
    Pickup pickupSettings = shipper.getPickup();

    if (pickupSettings != null) {
      clickTabItem("More Settings");

      if (CollectionUtils.isNotEmpty(pickupSettings.getReservationPickupAddresses())) {
        pickupSettings.getReservationPickupAddresses().forEach(address ->
        {
          addAddress(address);
          verifyPickupAddress(address);
        });
      }

      if (pickupSettings.getPremiumPickupDailyLimit() != null) {
        sendKeysById("premium-pickup-daily-limit",
            String.valueOf(pickupSettings.getPremiumPickupDailyLimit()));
      }

      String startTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(
          pickupSettings.getDefaultStartTime());
      String endTimeFormatted = convertTimeFrom24sHourTo12HoursAmPm(
          pickupSettings.getDefaultEndTime());
      String defaultPickupTimeSelector = startTimeFormatted + " - " + endTimeFormatted;
      scrollIntoView("//md-select[contains(@id, 'commons.select')]", false);
      selectValueFromMdSelectByIdContains("commons.select", defaultPickupTimeSelector);
      if (CollectionUtils.isNotEmpty(pickupSettings.getServiceTypeLevel())) {
        List<ServiceTypeLevel> serviceTypeLevels = pickupSettings.getServiceTypeLevel();
        for (int i = 0; i < serviceTypeLevels.size(); i++) {
          ServiceTypeLevel serviceTypeLevel = serviceTypeLevels.get(i);
          new MdSelect(getWebDriver(), f("//*[@id='more-settings-service-type%d']", i))
              .selectValue(serviceTypeLevel.getType());
          new MdSelect(getWebDriver(), f("//*[@id='more-settings-service-level%d']", i))
              .selectValue(serviceTypeLevel.getLevel());
          if (i < serviceTypeLevels.size() - 1) {
            moreSettingsAddNewService.click();
          }
        }
      }
    }
  }

  private void fillPricingAndBillingForm(Shipper shipper) {
    fillPricingProfile(shipper);
    fillBillingInformation(shipper);
  }

  private void fillBillingInformation(Shipper shipper) {
    tabs.selectTab("Pricing and Billing");
    pricingAndBillingForm.billingName.setValue(shipper.getBillingName());
    pricingAndBillingForm.billingContact.setValue(shipper.getBillingContact());
    pricingAndBillingForm.billingAddress.setValue(shipper.getBillingAddress());
    pricingAndBillingForm.billingPostcode.setValue(shipper.getBillingPostcode());
  }

  private void fillPricingProfile(Shipper shipper) {
    Pricing pricing = shipper.getPricing();
    tabs.selectTab("Pricing and Billing");
    if (Objects.nonNull(pricing) && StringUtils.isNotBlank(pricing.getScriptName())) {
      pricingAndBillingForm.addNewProfile.click();
      newPricingProfileDialog.waitUntilVisible();
      newPricingProfileDialog.pricingScript.searchAndSelectValue(pricing.getScriptName());
      newPricingProfileDialog.codCountryDefaultCheckbox.check();
      newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
      newPricingProfileDialog.rtsCountryDefaultCheckbox.check();

      newPricingProfileDialog.saveChanges.clickAndWaitUntilDone();
      newPricingProfileDialog.waitUntilInvisible();
    }

  }

  private void addAddress(Address address) {
    addAddress.click();
    fillAddAddressForm(address);
  }

  private void fillAddAddressForm(Address address) {
    addAddressDialog.waitUntilVisible();

    String value = address.getName();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.contactName.setValue(value);
    }

    value = address.getContact();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.contactMobileNumber.setValue(value);
    }

    value = address.getEmail();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.contactEmail.setValue(value);
    }

    value = address.getAddress1();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.pickupAddress1.setValue(value);
    }

    value = address.getAddress2();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.pickupAddress2.setValue(value);
    }

    value = address.getCountry();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.country.selectByValue(value);
    }

    value = address.getPostcode();
    if (StringUtils.isNotBlank(value)) {
      addAddressDialog.pickupPostcode.setValue(value);
    }

    Double val = address.getLatitude();
    if (val != null) {
      addAddressDialog.latitude.setValue(val);
    }

    val = address.getLongitude();
    if (val != null) {
      addAddressDialog.longitude.setValue(val);
    }

    if (BooleanUtils.isTrue(address.getMilkRun())) {
      fillMilkrunReservationSettings(address);
    }

    addAddressDialog.saveChanges.click();
    addAddressDialog.waitUntilInvisible();
  }

  private void fillMilkrunReservationSettings(Address address) {
    addAddressDialog.milkrunReservationsTab.click();
    pause500ms();
    if (CollectionUtils.isNotEmpty(address.getMilkrunSettings())) {
      List<MilkrunSettings> milkrunSettingsList = address.getMilkrunSettings();
      for (int i = 0; i < milkrunSettingsList.size(); i++) {
        MilkrunSettings milkrunSettings = milkrunSettingsList.get(i);
        addAddressDialog.addNewReservation.click();
        fillMilkrunReservationForm(milkrunSettings, i + 1);
      }
    }
  }

  private void fillMilkrunReservationForm(MilkrunSettings milkrunSettings, int index) {
    String itemXpath =
        "//*[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings'][" + index + "]";
    executeInContext(itemXpath, () ->
    {
      if (CollectionUtils.isNotEmpty(milkrunSettings.getDays())) {
        selectMultipleValuesFromMdSelectById("container.shippers.more-reservation-days",
            milkrunSettings.getDays().stream().map(String::valueOf).collect(Collectors.toList()));
      }

      if (StringUtils.isNoneBlank(milkrunSettings.getStartTime(), milkrunSettings.getEndTime())) {
        selectValueFromMdSelectById("container.shippers.timeslot-selected",
            milkrunSettings.getStartTime().toUpperCase() + " - " + milkrunSettings.getEndTime()
                .toUpperCase());
      }

      if (milkrunSettings.getNoOfReservation() != null) {
        selectValueFromMdSelectById("container.shippers.number-of-reservations",
            String.valueOf(milkrunSettings.getNoOfReservation()));
      }
    });
  }

  private void fillMarketplaceSettingsForm(Shipper shipper) {
    clickTabItem("Marketplace");
    MarketplaceDefault md = shipper.getMarketplaceDefault();

    if (md != null) {
      // Services
      ocVersion.selectValue(md.getOrderCreateVersion());
      ocServices.selectValues(md.getOrderCreateServicesAvailable());
      marketplaceTrackingType.selectValue(md.getOrderCreateTrackingType());

      clickToggleButton("ctrl.data.marketplace.allowCod",
          convertBooleanToString(md.getOrderCreateAllowCodService(), "Yes", "No"));
      clickToggleButton("ctrl.data.marketplace.allowCp",
          convertBooleanToString(md.getOrderCreateAllowCpService(), "Yes", "No"));
      clickToggleButton("ctrl.data.marketplace.isPrePaid",
          convertBooleanToString(md.getOrderCreateIsPrePaid(), "Yes", "No"));
      clickToggleButton("ctrl.data.marketplace.allowStaging",
          convertBooleanToString(md.getOrderCreateAllowStagedOrders(), "Yes", "No"));
      clickToggleButton("ctrl.data.marketplace.isMultiParcel",
          convertBooleanToString(md.getOrderCreateIsMultiParcelShipper(), "Yes", "No"));
      premiumPickupDailyLimit.setValue(md.getPickupPremiumPickupDailyLimit());
    }

    // Billing
    MarketplaceBilling mb = shipper.getMarketplaceBilling();

    if (mb != null) {
      marketplaceBillingName.setValue(mb.getBillingName());
      marketplaceBillingContact.setValue(mb.getBillingContact());
      marketplaceBillingAddress.setValue(mb.getBillingAddress());
      marketplaceBillingPostcode.setValue(mb.getBillingPostcode());
    }
  }

  public void unsetPickupAddressesAsMilkrun(Address shipperPickupAddress) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");

    searchTableCustom1("contact", shipperPickupAddress.getContact());
    milkrun.click();
    unsetAsMilkrunDialog.waitUntilVisible();
    unsetAsMilkrunDialog.delete.click();
    unsetAsMilkrunDialog.waitUntilInvisible();
    pause1s();

    clickNvIconTextButtonByName("Save Changes");
    waitUntilInvisibilityOfToast("All changes saved successfully");
    backToShipperList();
  }

  public void verifyPickupAddress(Address address) {
    boolean isEditForm = isElementExistFast(
        "//div[@class='action-toolbar']//div[contains(text(),'Edit Shippers')]");
    searchTableCustom1("contact", address.getContact());
    Assertions.assertThat(!isTableEmpty())
        .as("Pickup Addresses with contact [" + address.getContact() + "] exists").isTrue();
    String actualAddress = isEditForm ?
        getTextOnTableWithMdVirtualRepeat(1, "address", "address in getTableData()") :
        getTextOnTableWithNgRepeat(1, "address", "address in getTableData()");

    Assertions.assertThat(actualAddress).as("Address")
        .isEqualTo(address.to1LineAddressWithPostcode());

    if (BooleanUtils.isTrue(address.getMilkRun())) {
      Assertions.assertThat(
          isElementVisible("//nv-icon-text-button[@name='container.shippers.milkrun']"))
          .as("Milkrun action button is not displayed for address").isTrue();
      verifyMilkrunSettings(address);
      scrollIntoView("//*[@name='container.shippers.more-reservation-add-pickup-address']", false);
    } else {
      Assertions.assertThat(
          isElementVisible("//nv-icon-text-button[@name='container.shippers.set-as-milkrun']"))
          .as("Set As Milkrun action button is not displayed for address").isTrue();
    }
  }

  public void verifyMilkrunSettings(Address address) {
    int reservationsCount = CollectionUtils.size(address.getMilkrunSettings());
    editAddress.click();
    addAddressDialog.waitUntilVisible();
    pause1s();
    addAddressDialog.milkrunReservationsTab.click();
    waitUntilVisibilityOfElementLocated(
        "//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']");
    Assertions.assertThat(
        getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"))
        .as("Number of Milkrun Reservations").isEqualTo(reservationsCount);
    addAddressDialog.saveChanges.click();
    addAddressDialog.waitUntilInvisible();
  }

  public void backToShipperList() {
    discardChanges.click();
    pause2s();
    if (discardChangesDialog.leave.isDisplayedFast()) {
      discardChangesDialog.leave.click();
    }
    webDriver.switchTo().window(webDriver.getWindowHandles().iterator().next());
  }

  public static class NewPricingProfileDialog extends MdDialog {

    public NewPricingProfileDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-id'] div.readonly")
    public PageElement shipperId;

    @FindBy(css = "md-input-container[label='container.shippers.pricing-billing-shipper-name'] div.readonly")
    public PageElement shipperName;

    @FindBy(id = "container.shippers.pricing-billing-pricing-scripts")
    public MdSelect pricingScript;

    @FindBy(css = "md-input-container[label$='COD Value'] div.md-container")
    public CheckBox codCountryDefaultCheckbox;

    @FindBy(css = "md-input-container[label$='Insured Value'] div.md-container")
    public CheckBox insuranceCountryDefaultCheckbox;

    @FindBy(css = "md-input-container[label$='RTS Fee'] div.md-container")
    public CheckBox rtsCountryDefaultCheckbox;

    @FindBy(css = "[id^='container.shippers.pricing-billing-comments']")
    public TextBox comments;

    @FindBy(name = "Save Changes")
    public NvApiTextButton saveChanges;
  }


  public static class DiscardChangesDialog extends MdDialog {

    public DiscardChangesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "button[aria-label='Leave']")
    public Button leave;
  }

  public static class ErrorSaveDialog extends MdDialog {

    @FindBy(css = ".md-dialog-content")
    public PageElement message;

    @FindBy(css = "[aria-label='Close']")
    public Button close;

    @FindBy(css = "div[ng-repeat*='ctrl.payload.errors']")
    public List<PageElement> errors;

    public ErrorSaveDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class BasicSettingsForm extends PageElement {

    @FindBy(css = "tab-content[aria-hidden='false'] .nv-hint p")
    public PageElement tabHint;

    //region Shipper Information
    @FindBy(css = "div[model='ctrl.data.basic.status']")
    public MdBooleanSwitch shipperStatus;
    @FindBy(css = "md-select[ng-model='ctrl.data.basic.shipperType']")
    public MdSelect shipperType;
    @FindBy(id = "shipper-name")
    public TextBox shipperName;
    @FindBy(id = "Short Name")
    public TextBox shortName;
    @FindBy(id = "shipper-phone-number")
    public TextBox shipperPhoneNumber;
    @FindBy(id = "shipper-email")
    public TextBox shipperEmail;
    @FindBy(name = "shipper-classification")
    public MdSelect channel;
    @FindBy(name = "industry")
    public MdSelect industry;
    @FindBy(name = "account-type")
    public MdSelect accountType;
    @FindBy(id = "salesperson")
    public MdSelect salesperson;
    //endregion

    //region Contact Details
    @FindBy(id = "Liaison Name")
    public TextBox liaisonName;
    @FindBy(id = "Liaison Contact")
    public TextBox liaisonContact;
    @FindBy(id = "Liaison Email")
    public TextBox liaisonEmail;
    @FindBy(id = "liaison-address")
    public TextBox liaisonAddress;
    @FindBy(id = "Liaison Postcode")
    public TextBox liaisonPostcode;
    //endregion

    //region Service Offerings
    @FindBy(xpath = ".//md-input-container[./label[.='Marketplace']]/div")
    public MdBooleanSwitch marketplace;
    @FindBy(xpath = ".//md-input-container[./label[.='Marketplace International']]/div")
    public MdBooleanSwitch marketplaceInternational;
    @FindBy(xpath = ".//md-input-container[./label[.='Marketplace Sort']]/div")
    public MdBooleanSwitch marketplaceSort;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate']]/div")
    public MdBooleanSwitch corporate;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate Return']]/div")
    public MdBooleanSwitch corporateReturn;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate Manual AWB']]/div")
    public MdBooleanSwitch corporateManualAWB;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate Document']]/div")
    public MdBooleanSwitch corporateDocument;
    @FindBy(id = "container.shippers.service-level")
    public MdSelect serviceLevel;

    //endregion

    //region Operational Settings
    @FindBy(css = "[model='ctrl.data.basic.allowCod']")
    public MdBooleanSwitch allowCod;
    @FindBy(css = "[model='ctrl.data.basic.allowCp']")
    public MdBooleanSwitch allowCp;
    @FindBy(css = "[model='ctrl.data.basic.isPrePaid']")
    public MdBooleanSwitch isPrePaid;
    @FindBy(css = "[model='ctrl.data.basic.allowStaging']")
    public MdBooleanSwitch allowStaging;
    @FindBy(css = "[model='ctrl.data.basic.isMultiParcel']")
    public MdBooleanSwitch isMultiParcel;
    @FindBy(css = "[model='ctrl.data.basic.disableReschedule']")
    public MdBooleanSwitch disableReschedule;

    @FindBy(css = "[model='ctrl.data.basic.showShipperDetails']")
    public MdBooleanSwitch showShipperDetails;
    @FindBy(css = "[model='ctrl.data.basic.showCod']")
    public MdBooleanSwitch showCod;
    @FindBy(css = "[model='ctrl.data.basic.showParcelDescription']")
    public MdBooleanSwitch showParcelDescription;
    @FindBy(name = "trackingType")
    public MdSelect trackingType;
    @FindBy(id = "shipper-prefix")
    public TextBox shipperPrefix;
    @FindBy(xpath = ".//label[@for='shipper-prefix']")
    public PageElement labelForShipperPrefix;
    @FindBy(xpath = ".//div[text()='Prefix already used']")
    public PageElement prefixAlreadyUsed;
    //endregion

    public BasicSettingsForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class PricingAndBillingForm extends PageElement {

    @FindBy(name = "container.shippers.pricing-billing-add-new-profile")
    public NvIconTextButton addNewProfile;
    @FindBy(id = "Billing Name")
    public TextBox billingName;
    @FindBy(id = "Billing Contact")
    public TextBox billingContact;
    @FindBy(id = "Billing Address")
    public TextBox billingAddress;
    @FindBy(id = "Billing Postcode")
    public TextBox billingPostcode;

    public PricingAndBillingForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class UnsetAsMilkrunDialog extends MdDialog {

    @FindBy(css = "[aria-label='Delete']")
    public Button delete;

    public UnsetAsMilkrunDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AddAddressDialog extends MdDialog {

    public AddAddressDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "Contact Name")
    public TextBox contactName;

    @FindBy(id = "Contact Mobile Number")
    public TextBox contactMobileNumber;

    @FindBy(id = "Contact Email")
    public TextBox contactEmail;

    @FindBy(id = "Pickup Address 1")
    public TextBox pickupAddress1;

    @FindBy(id = "Pickup Address 2 / Unit Number")
    public TextBox pickupAddress2;

    @FindBy(id = "commons.country")
    public MdSelect country;

    @FindBy(id = "Pickup Postcode")
    public TextBox pickupPostcode;

    @FindBy(id = "Latitude")
    public TextBox latitude;

    @FindBy(id = "Longitude")
    public TextBox longitude;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    @FindBy(xpath = ".//md-tab-item[.='Milkrun Reservations']")
    public PageElement milkrunReservationsTab;

    @FindBy(name = "container.shippers.add-new-reservation")
    public NvIconTextButton addNewReservation;
  }
}

