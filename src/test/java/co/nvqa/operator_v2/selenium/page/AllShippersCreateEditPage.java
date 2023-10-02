package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.model.address.MilkrunSettings;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.LabelPrinter;
import co.nvqa.commons.model.shipper.v2.Magento;
import co.nvqa.commons.model.shipper.v2.MarketplaceBilling;
import co.nvqa.commons.model.shipper.v2.MarketplaceDefault;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pickup;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Pricing.BillingWeightEnum;
import co.nvqa.commons.model.shipper.v2.PricingAndBillingSettings;
import co.nvqa.commons.model.shipper.v2.Qoo10;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Return;
import co.nvqa.commons.model.shipper.v2.ServiceTypeLevel;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.shipper.v2.ShipperBasicSettings;
import co.nvqa.commons.model.shipper.v2.Shopify;
import co.nvqa.commons.model.shipper.v2.SubShipperDefaultSettings;
import co.nvqa.commons.support.DateUtil;
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
import co.nvqa.operator_v2.util.TestUtils;
import java.text.ParseException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.Condition;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.utils.StandardTestConstants.NV_SYSTEM_ID;
import static co.nvqa.common.utils.StandardTestUtils.convertToDate;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersCreateEditPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersCreateEditPage.class);

  @FindBy(name = "ctrl.basicForm")
  public BasicSettingsForm basicSettingsForm;

  @FindBy(name = "ctrl.marketplaceForm")
  public SubShippersDefaultSettingsForm subShippersDefaultSettingsForm;

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

  @FindBy(css = "form[name='ctrl.moreForm'] md-select[ng-model='ctrl.data.more.allowedTypes']")
  public MdSelect allowedTypes;

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
  @FindBy(name = "container.shippers.add-new-service")
  public NvIconTextButton addNewService;
  @FindBy(name = "commons.delete")
  public NvIconButton deleteService;
  @FindBy(xpath = "//*[@class='nv-text-center' and descendant::*[contains(text(),'No Results Found')]]")
  public PageElement noResultText;
  //endregion

  //endregion

  @FindBy(css = "md-dialog")
  public NewPricingProfileDialog newPricingProfileDialog;
  @FindBy(css = "md-dialog")
  public EditPendingProfileDialog editPendingProfileDialog;
  @FindBy(css = "md-dialog")
  public DiscardChangesDialog discardChangesDialog;
  @FindBy(css = "md-dialog")
  public ErrorSaveDialog errorSaveDialog;
  @FindBy(css = "md-dialog")
  public WarningDialog warningDialog;
  @FindBy(css = "md-dialog")
  public UnsetAsMilkrunDialog unsetAsMilkrunDialog;

  @FindBy(css = "md-dialog")
  public AddAddressDialog addAddressDialog;
  @FindBy(xpath = "//md-dialog/md-toolbar")
  public PageElement dialogHeader;

  private static final String NG_REPEAT_TABLE_ADDRESS = "address in getTableData()";

  public static final String ACTION_BUTTON_SET_AS_DEFAULT = "Set as Default";
  public static final String LOCATOR_FIELD_OC_VERSION = "ctrl.data.basic.ocVersion";
  public static final String LOCATOR_FIELD_INDUSTRY = "ctrl.data.basic.industry";
  public static final String LOCATOR_FIELD_SALES_PERSON = "salesperson";
  public static final String XPATH_SAVE_CHANGES_PRICING_SCRIPT = "//form//button[@aria-label='Save Changes']";
  public static final String XPATH_DISCOUNT_VALUE = "//input[@id='discount-value']";
  public static final String ARIA_LABEL_COMMENTS = "Comments";
  public static final String XPATH_PRICING_PROFILE_STATUS = "//table[@class='table-body']//td[contains(@class,'status') and text()='%s']";
  public static final String LOCATOR_END_DATE = "container.shippers.pricing-billing-end-date";
  public static final String LOCATOR_START_DATE = "container.shippers.pricing-billing-start-date";
  public static final String XPATH_VALIDATION_ERROR = "//md-dialog[contains(@class, 'nv-container-shipper-errors-dialog')] ";
  public static final String XPATH_SHIPPER_INFORMATION = "//div[text()='Shipper Information']";
  public static final String XPATH_PRICING_PROFILE_ID = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='id']";
  public static final String XPATH_PRICING_PROFILE_EFFECTIVE_DATE = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='effective-date']";
  public static final String XPATH_PRICING_PROFILE_DISCOUNT = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='discount']";
  public static final String XPATH_PRICING_PROFILE_SCRIPT_NAME = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='pricing-script-name']";
  public static final String XPATH_PRICING_PROFILE_COMMENTS = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='comments']";
  public static final String XPATH_PRICING_PROFILE_CONTACT_END_DATE = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='contract-end-date']";
  public static final String XPATH_PRICING_PROFILE_COD_MIN = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='cod-min']";
  public static final String XPATH_PRICING_PROFILE_COD_PERCENTAGE = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='cod-percent']";
  public static final String XPATH_PRICING_PROFILE_INS_THRESHOLD = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='insurance-threshold']";
  public static final String XPATH_PRICING_PROFILE_INS_MIN = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='insurance-min']";
  public static final String XPATH_PRICING_PROFILE_INS_PERCENTAGE = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='insurance-percent']";
  public static final String XPATH_PRICING_PROFILE_RTS_CHARGE = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='rts-charge']";
  public static final String XPATH_PRICING_PROFILE_BILLING_WEIGHT_LOGIC = "//div[@id='pricing-profile-table']//table[@class='table-body']//tr[1]//td[@class='billing-weight-logic']";
  public static final String XPATH_EDIT_PENDING_PROFILE = "//button[@aria-label='Edit Pending Profile']";
  public static final String XPATH_ADD_NEW_PRICING_PROFILE = "//button[@aria-label='Add New Profile']";
  public static final String XPATH_DISCOUNT_ERROR_MESSAGE = "//md-input-container[contains(@class,'md-input-invalid')]//div[@ng-repeat='e in errorMsgs' or @ng-message='required']";
  public static final String XPATH_SEARCH_MARKETPLACE_SUB_SHIPPER_TAB = "//th[@nv-table-filter='%s']//input";
  public static final String XPATH_SEARCH_MARKETPLACE_SUB_SHIPPER_TAB_LEGACY_ID = "//td[contains(text(),'%s')]//preceding-sibling::td[@nv-table-highlight='filter.id']";

  public final B2bManagementPage b2bManagementPage;

  public AllShippersCreateEditPage(WebDriver webDriver) {
    super(webDriver);
    b2bManagementPage = new B2bManagementPage(webDriver);
  }

  public void waitUntilShipperCreateEditPageIsLoaded() {
    shipperInformation.waitUntilClickable(120);
  }

  public void waitUntilShipperCreateEditPageIsLoaded(int timeoutInSeconds) {
    shipperInformation.waitUntilClickable(timeoutInSeconds);
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

  public void createNewShipperWithUpdatedPricingScript(Shipper shipper) {
    String currentWindowHandle = switchToNewWindow();

    waitUntilShipperCreateEditPageIsLoaded();
    pause2s();
    fillBasicSettingsForm(shipper);
    fillMoreSettingsForm(shipper);

    if (shipper.getMarketplaceDefault() != null) {
      fillMarketplaceSettingsForm(shipper);
    }

    fillPricingAndBillingForm(shipper);
    updatePricingScript();

    clickNvIconTextButtonByName("container.shippers.create-shipper");
    waitUntilInvisibilityOfToast("All changes saved successfully");
    String url = getWebDriver().getCurrentUrl();
    shipper.setLegacyId(Long.valueOf(url.substring(url.lastIndexOf("/") + 1)));
    backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(currentWindowHandle);

  }

  public void createNewShipperWithoutPricingScript(Shipper shipper) {
    String currentWindowHandle = switchToNewWindow();

    waitUntilShipperCreateEditPageIsLoaded();
    pause2s();
    fillBasicSettingsForm(shipper);
    fillMoreSettingsForm(shipper);
    fillBillingInformation(shipper);

    if (shipper.getMarketplaceDefault() != null) {
      fillMarketplaceSettingsForm(shipper);
    }

    clickNvIconTextButtonByName("container.shippers.create-shipper");
    String errorText = getText(XPATH_VALIDATION_ERROR);
    Assertions.assertThat(errorText.contains("Pricing Profile (Pricing and Billing)"))
        .as("Error message is not displayed!").isTrue();
    backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(currentWindowHandle);
  }

  public void updatePricingScript() {
    click(XPATH_EDIT_PENDING_PROFILE);
    pause2s();
    moveToElementWithXpath(XPATH_DISCOUNT_VALUE);
    sendKeys(XPATH_DISCOUNT_VALUE, "20");
    sendKeysByAriaLabel(ARIA_LABEL_COMMENTS, "This is edited comment");
    click(XPATH_SAVE_CHANGES_PRICING_SCRIPT);
    pause1s();
  }

  public void updateShipper(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    fillBasicSettingsForm(shipper);
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void updateShipperBasicSettings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    fillBasicSettingsForm(shipper);
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
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
      retryIfRuntimeExceptionOccurred(() ->
      {
        String generatedPrefix = generateUpperCaseAlphaNumericString(5);
        orderCreate.setPrefix(generatedPrefix);
        basicSettingsForm.shipperPrefix.setValue(generatedPrefix + Keys.ENTER);
        basicSettingsForm.labelForShipperPrefix.click();
        if (basicSettingsForm.prefixAlreadyUsed.waitUntilVisible(2)) {
          throw new NvTestRuntimeException("Prefix already used. Regenerate new prefix.");
        }
      });
    }

    // Label Printing:
    LabelPrinter labelPrinter = shipper.getLabelPrinter();
    if (labelPrinter != null) {
      basicSettingsForm.showShipperDetails.selectValue(labelPrinter.getShowShipperDetails());
      basicSettingsForm.showCod.selectValue(labelPrinter.getShowCod());
      basicSettingsForm.showParcelDescription.selectValue(labelPrinter.getShowParcelDescription());
    }
  }

  public void fillBasicSettingsForm(ShipperBasicSettings settings) {
    boolean isCreateForm = getCurrentUrl().endsWith("shippers/create");

    // ===== SHIPPER INFORMATION =====

    basicSettingsForm.shipperName.setValue(settings.getShipperName());
    basicSettingsForm.shortName.setValue(settings.getShortName());
    basicSettingsForm.shipperPhoneNumber.setValue(settings.getShipperPhoneNumber());

    basicSettingsForm.shipperEmail.setValue(settings.getShipperEmail());

    if (isCreateForm) {
      basicSettingsForm.shipperDashboardPassword.setValue(settings.getShipperDashboardPassword());
    } else {
      basicSettingsForm.dashUsername.setValue(settings.getDashUsername());
    }
  }

  public void fillSubShippersDefaults(Shipper shipper) {
    tabs.selectTab("Sub shippers Default Setting");
    SubShipperDefaultSettings subShipperDefaults = shipper.getSubShippersDefaults();
    if (StringUtils.isNotBlank(subShipperDefaults.getVersion())) {
      subShippersDefaultSettingsForm.ocVersion.selectValue(subShipperDefaults.getVersion());
    }
    if (CollectionUtils.isNotEmpty(subShipperDefaults.getAvailableServiceTypes())) {
      subShippersDefaultSettingsForm.services
          .selectValues(subShipperDefaults.getAvailableServiceTypes());
    }
    subShippersDefaultSettingsForm.bulky.selectValue(subShipperDefaults.getBulky());
    subShippersDefaultSettingsForm.corporate.selectValue(subShipperDefaults.getCorporate());
    subShippersDefaultSettingsForm.corporateReturn
        .selectValue(subShipperDefaults.getCorporateReturn());
    subShippersDefaultSettingsForm.corporateManualAWB
        .selectValue(subShipperDefaults.getCorporateManualAWB());
    if (CollectionUtils.isNotEmpty(subShipperDefaults.getAvailableServiceLevels())) {
      subShippersDefaultSettingsForm.serviceLevel
          .selectValues(subShipperDefaults.getAvailableServiceLevels());
    }
    if (StringUtils.isNotBlank(subShipperDefaults.getBillingName())) {
      subShippersDefaultSettingsForm.billingName.setValue(subShipperDefaults.getBillingName());
    }
    if (StringUtils.isNotBlank(subShipperDefaults.getBillingContact())) {
      subShippersDefaultSettingsForm.billingContact
          .setValue(subShipperDefaults.getBillingContact());
    }
    if (StringUtils.isNotBlank(subShipperDefaults.getBillingAddress())) {
      subShippersDefaultSettingsForm.billingAddress
          .setValue(subShipperDefaults.getBillingAddress());
    }
    if (StringUtils.isNotBlank(subShipperDefaults.getBillingPostcode())) {
      subShippersDefaultSettingsForm.billingPostcode
          .setValue(subShipperDefaults.getBillingPostcode());
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

  public void removeMilkrunReservarion(Shipper shipper, int addressIndex,
      int milkrunReservationIndex) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");

    if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses())) {
      Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
      int reservationsCount = CollectionUtils.size(address.getMilkrunSettings());
      searchTableCustom1("contact", address.getContact());
      clickNvIconButtonByName("container.shippers.more-reservation-edit-pickup-address");
      waitUntilVisibilityOfMdDialogByTitle("Edit Address");
      click("//span[.='Milkrun Reservations']");
      String xpath = String.format(
          "//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings'][%d]//nv-icon-button[@name='commons.delete']/button",
          milkrunReservationIndex);
      waitUntilVisibilityOfElementLocated(xpath);
      click(xpath);
      pause500ms();
      Assertions.assertThat(
              getElementsCount("//div[@ng-repeat='milkrunSetting in ctrl.data.milkrunSettings']"))
          .as("Number of Milkrun Reservations").isEqualTo(reservationsCount - 1);
      clickNvApiTextButtonByName("commons.save-changes");
      waitUntilInvisibilityOfMdDialogByTitle("Edit Address");
    }

    clickNvIconTextButtonByName("Save Changes");
    waitUntilInvisibilityOfToast("All changes saved successfully");
    backToShipperList();
  }

  public void removeAllMilkrunReservations(Shipper shipper, int addressIndex) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");
    if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses())) {
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

  public void deleteAllPickupServices() {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");
    int looping = 0;
    while (!noResultText.isDisplayedFast()
        && looping < DEFAULT_MAX_RETRY_FOR_STALE_ELEMENT_REFERENCE) {
      deleteService.click();
      looping++;
    }
  }

  public ShipperBasicSettings getBasicSettings() {
    ShipperBasicSettings settings = new ShipperBasicSettings();
    settings.setShipperPhoneNumber(basicSettingsForm.shipperPhoneNumber.getValue());
    settings.setShipperEmail(basicSettingsForm.shipperEmail.getValue());
    settings.setVersion(basicSettingsForm.ocVersion.getValue());
    settings.setCorporate(basicSettingsForm.corporate.isOn());
    settings.setCorporateReturn(basicSettingsForm.corporateReturn.isOn());
    settings.setCorporateManualAWB(basicSettingsForm.corporateManualAWB.isOn());
    settings.setCorporateDocument(basicSettingsForm.corporateDocument.isOn());
    settings.setAvailableServiceLevels(basicSettingsForm.serviceLevel.getValue());
    return settings;
  }

  public PricingAndBillingSettings getPricingAndBillingSettings() {
    PricingAndBillingSettings settings = new PricingAndBillingSettings();
    settings.setBillingName(pricingAndBillingForm.billingName.getValue());
    settings.setBillingContact(pricingAndBillingForm.billingContact.getValue());
    settings.setBillingAddress(pricingAndBillingForm.billingAddress.getValue());
    settings.setBillingPostcode(pricingAndBillingForm.billingPostcode.getValue());
    return settings;
  }

  public void setPickupAddressesAsMilkrun(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");
    if (CollectionUtils.isNotEmpty(shipper.getPickup().getReservationPickupAddresses())) {
      shipper.getPickup().getReservationPickupAddresses().stream().filter(Address::getMilkRun)
          .forEach(address ->
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

  public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    String actualShipperStatus = basicSettingsForm.shipperStatus.getValue();
    String actualShipperType;

    if (StringUtils.equalsAnyIgnoreCase(shipper.getType(), "Marketplace", "Corporate HQ")) {
      actualShipperType = basicSettingsForm.shipperTypeReadOnly.getValue();
    } else {
      actualShipperType = getMdSelectValueTrimmed("ctrl.data.basic.shipperType");
    }

    Assertions.assertThat(actualShipperStatus).as("Shipper Status")
        .isEqualTo(convertBooleanToString(shipper.getActive(), "Active", "Disabled"));
    Assertions.assertThat(actualShipperType).as("Shipper Type").isEqualTo(shipper.getType());

    // Shipper Details
    String actualShipperName = getInputValueById("shipper-name");
    String actualShipperShortName = getInputValueById("Short Name");
    String actualShipperContact = getInputValueById("shipper-phone-number");
    String actualShipperEmail = getInputValueById("shipper-email", XpathTextMode.STARTS_WITH);

    Assertions.assertThat(actualShipperName).as("Shipper Name").isEqualTo(shipper.getName());
    Assertions.assertThat(actualShipperShortName).as("Shipper Short Name")
        .isEqualTo(shipper.getShortName());
    Assertions.assertThat(actualShipperContact).as("Shipper Contact")
        .isEqualTo(shipper.getContact());
    Assertions.assertThat(actualShipperEmail).as("Shipper Email").isEqualTo(shipper.getEmail());

    // Liaison Details
    String actualLiaisonName = getInputValueById("Liaison Name");
    String actualLiaisonContact = getInputValueById("Liaison Contact");
    String actualLiaisonEmail = getInputValueById("Liaison Email");
    String actualLiaisonAddress = getInputValueById("liaison-address");
    String actualLiaisonPostcode = getInputValueById("Liaison Postcode");

    Assertions.assertThat(actualLiaisonName).as("Liaison Name").isEqualTo(shipper.getLiaisonName());
    Assertions.assertThat(actualLiaisonContact).as("Liaison Contact")
        .isEqualTo(shipper.getLiaisonContact());
    Assertions.assertThat(actualLiaisonEmail).as("Liaison Email")
        .isEqualTo(shipper.getLiaisonEmail());
    Assertions.assertThat(actualLiaisonAddress).as("Liaison Address")
        .isEqualTo(shipper.getLiaisonAddress());
    Assertions.assertThat(actualLiaisonPostcode).as("Liaison Postcode")
        .isEqualTo(shipper.getLiaisonPostcode());

    // Services
    String actualOcVersion = getMdSelectValueTrimmed("ctrl.data.basic.ocVersion");
    String availableService = getAttribute("//*[@id='container.shippers.service-level']",
        "aria-label");
    String actualTrackingType = getMdSelectValue("ctrl.data.basic.trackingType");
    String actualPrefix = getInputValueById("shipper-prefix");

    List<String> listOfActualServices;

    if (availableService == null || availableService.equals("oc-services")) {
      listOfActualServices = new ArrayList<>();
    } else {
      String[] temp = availableService.replace("Service Level:", "").split(",");
      listOfActualServices = Stream.of(temp).map(val -> val.replace(" ", "").toUpperCase())
          .collect(Collectors.toList());
    }

    OrderCreate orderCreate = shipper.getOrderCreate();
    Assertions.assertThat(actualOcVersion).as("OC Version").isEqualTo(orderCreate.getVersion());
    Assertions.assertThat(listOfActualServices).as("Services Available")
        .is(new Condition<>(m -> m.containsAll(orderCreate.getServicesAvailable()),
            "Available services"));
    Assertions.assertThat(actualTrackingType).as("Tracking Type")
        .isEqualTo(orderCreate.getTrackingType());
    Assertions.assertThat(actualPrefix).as("Prefix").isEqualTo(orderCreate.getPrefix());

    String actualAllowCodService = getToggleButtonValue("ctrl.data.basic.allowCod");
    String actualAllowCpService = getToggleButtonValue("ctrl.data.basic.allowCp");
    String actualIsPrePaid = getToggleButtonValue("ctrl.data.basic.isPrePaid");
    String actualAllowStagedOrders = getToggleButtonValue("ctrl.data.basic.allowStaging");
    String actualIsMultiParcelShipper = getToggleButtonValue("ctrl.data.basic.isMultiParcel");
    String actualShipperLiteAllowRescheduleFirstAttempt = getToggleButtonValue(
        "ctrl.data.basic.disableReschedule");

    DistributionPoint distributionPoint = shipper.getDistributionPoints();

    Assertions.assertThat(actualAllowCodService).as("Allow COD Service")
        .isEqualTo(convertBooleanToString(orderCreate.getAllowCodService(), "Yes", "No"));
    Assertions.assertThat(actualAllowCpService).as("Allow CP Service")
        .isEqualTo(convertBooleanToString(orderCreate.getAllowCpService(), "Yes", "No"));
    Assertions.assertThat(actualIsPrePaid).as("Is Prepaid Account")
        .isEqualTo(convertBooleanToString(orderCreate.getIsPrePaid(), "Yes", "No"));
    Assertions.assertThat(actualAllowStagedOrders).as("Allow Staged Orders")
        .isEqualTo(convertBooleanToString(orderCreate.getAllowStagedOrders(), "Yes", "No"));
    Assertions.assertThat(actualIsMultiParcelShipper).as("Is Multi Parcel Shipper")
        .isEqualTo(convertBooleanToString(orderCreate.getIsMultiParcelShipper(), "Yes", "No"));
    Assertions.assertThat(
            convertBooleanToString(distributionPoint.getShipperLiteAllowRescheduleFirstAttempt(), "Yes",
                "No")).
        as("Disable Driver App Reschedule").isEqualTo(actualShipperLiteAllowRescheduleFirstAttempt);

    // Industry & Sales
    String actualIndustry = getMdSelectValue(
        LOCATOR_FIELD_INDUSTRY); //getNvAutocompleteValue("ctrl.view.industry.searchText");
    String actualSalesPerson = getMdSelectValueById(
        LOCATOR_FIELD_SALES_PERSON); //getNvAutocompleteValue("ctrl.view.salesPerson.searchText");

    Assertions.assertThat(actualIndustry).as("Industry").isEqualTo(shipper.getIndustryName());
    Assertions.assertThat(actualSalesPerson).as("Sales Person").isEqualTo(shipper.getSalesPerson());

    verifyMoreSettingsTab(shipper);

    // Pricing
    tabs.selectTab("Pricing and Billing");

    // Billing
    String actualBillingName = pricingAndBillingForm.billingName.getValue();
    String actualBillingContact = pricingAndBillingForm.billingContact.getValue();
    String actualBillingAddress = pricingAndBillingForm.billingAddress.getValue();
    String actualBillingPostcode = pricingAndBillingForm.billingPostcode.getValue();

    Assertions.assertThat(actualBillingName).as("Billing Name").isEqualTo(shipper.getBillingName());
    Assertions.assertThat(actualBillingContact).as("Billing Contact")
        .isEqualTo(shipper.getBillingContact());
    Assertions.assertThat(actualBillingAddress).as("Billing Address")
        .isEqualTo(shipper.getBillingAddress());
    Assertions.assertThat(actualBillingPostcode).as("Billing Postcode")
        .isEqualTo(shipper.getBillingPostcode());
  }

  public void verifyMoreSettingsTab(Shipper shipper) {
    Pickup pickupSettings = shipper.getPickup();
    if (pickupSettings != null) {
      clickTabItem("More Settings");

      if (CollectionUtils.isNotEmpty(pickupSettings.getReservationPickupAddresses())) {
        pickupSettings.getReservationPickupAddresses().forEach(this::verifyPickupAddress);
      }
    }
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

  public void verifyPickupServicesIsEmpty() {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");
    Assertions.assertThat(noResultText.isDisplayed()).as("Check pickup service is empty").isTrue();
  }

  public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper,
      Address address, Reservation reservation) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");
    addAddress(address);
    setAsDefaultAddress(address);
    setAutoReservation(reservation);
    backToShipperList();
  }

  public void setAsDefaultAddress(Address address) {
    searchTableAddressByAddress(address.getAddress2());
    clickActionButtonOnTableAddress(1, ACTION_BUTTON_SET_AS_DEFAULT);
    try {
      long addressId = Long.parseLong(getInputValueById("Address ID"));
      address.setId(addressId);
    } catch (NumberFormatException ex) {
      throw new RuntimeException("Failed to get address ID.");
    }
  }

  public void setAutoReservation(Reservation reservation) {
    List<String> listOfDaysAsString = reservation.getDays().stream().map(String::valueOf)
        .collect(Collectors.toList());
    clickToggleButton("ctrl.data.more.isAutoReservation",
        convertBooleanToString(reservation.getAutoReservationEnabled(), "Yes", "No"));
    selectMultipleValuesFromMdSelect("ctrl.data.more.reservationDays", XpathTextMode.EXACT,
        listOfDaysAsString);

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

    selectValueFromMdSelect("ctrl.data.more.approxVolume",
        reservation.getAutoReservationApproxVolume());
    selectMultipleValuesFromMdSelect("ctrl.data.more.allowedTypes", reservation.getAllowedTypes());

    clickNvIconTextButtonByName("Save Changes");
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void updateShipperLabelPrinterSettings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("Basic Settings");

    LabelPrinter labelPrinter = shipper.getLabelPrinter();
    sendKeysById("Printer IP", labelPrinter.getPrinterIp());
    basicSettingsForm.showShipperDetails.selectValue(labelPrinter.getShowShipperDetails());
    basicSettingsForm.showCod.selectValue(labelPrinter.getShowCod());
    basicSettingsForm.showParcelDescription.selectValue(labelPrinter.getShowParcelDescription());
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("Basic Settings");

    LabelPrinter labelPrinter = shipper.getLabelPrinter();

    String actualPrinterIp = getInputValueById("Printer IP");
    String actualShowShipperDetails = getToggleButtonValue("ctrl.data.basic.isPrinterAvailable");

    Assertions.assertThat(actualPrinterIp).as("Label Printer - Printer IP")
        .isEqualTo(labelPrinter.getPrinterIp());
    Assertions.assertThat(actualShowShipperDetails).as("Label Printer - Show Shipper Details")
        .isEqualTo(convertBooleanToString(labelPrinter.getShowShipperDetails(), "Yes", "No"));

    backToShipperList();
  }

  public void updateShipperDistributionPointSettings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("More Settings");

    DistributionPoint distributionPoint = shipper.getDistributionPoints();

    clickToggleButton("ctrl.data.more.isIntegratedVault",
        convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"));
    clickToggleButton("ctrl.data.more.isCollectCustomerNricCode",
        convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"));

    clickToggleButton("ctrl.data.more.isReturnsOnDpms",
        convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"));
    sendKeysById("DPMS Logo URL", distributionPoint.getDpmsLogoUrl());

    clickToggleButton("ctrl.data.more.isReturnsOnVault",
        convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"));
    sendKeysById("Vault Logo URL", distributionPoint.getVaultLogoUrl());

    clickToggleButton("ctrl.data.more.isReturnsOnShipperLite",
        convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"));
    sendKeysById("Shipper Lite Logo URL", distributionPoint.getShipperLiteLogoUrl());

    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("More Settings");

    DistributionPoint distributionPoint = shipper.getDistributionPoints();

    String actualIsIntegratedVault = getToggleButtonValue("ctrl.data.more.isIntegratedVault");
    String actualIsCollectCustomerNricCode = getToggleButtonValue(
        "ctrl.data.more.isCollectCustomerNricCode");

    String actualIsReturnsOnDpms = getToggleButtonValue("ctrl.data.more.isReturnsOnDpms");
    String actualDpmsLogoUrl = getInputValueById("DPMS Logo URL");

    String actualIsReturnsOnVault = getToggleButtonValue("ctrl.data.more.isReturnsOnVault");
    String actualVaultLogoUrl = getInputValueById("Vault Logo URL");

    String actualIsReturnsOnShipperLite = getToggleButtonValue(
        "ctrl.data.more.isReturnsOnShipperLite");
    String actualShipperLiteLogoUrl = getInputValueById("Shipper Lite Logo URL");

    Assertions.assertThat(actualIsIntegratedVault).as("Distribution Point - Is Integrated Vault")
        .isEqualTo(convertBooleanToString(distributionPoint.getVaultIsIntegrated(), "Yes", "No"));
    Assertions.assertThat(actualIsCollectCustomerNricCode)
        .as("Distribution Point - Is Collect Customer NRIC Code").isEqualTo(
            convertBooleanToString(distributionPoint.getVaultCollectCustomerNricCode(), "Yes", "No"));

    Assertions.assertThat(actualIsReturnsOnDpms).as("Distribution Point - Is Return On DPMS")
        .isEqualTo(convertBooleanToString(distributionPoint.getAllowReturnsOnDpms(), "Yes", "No"));
    Assertions.assertThat(actualDpmsLogoUrl).as("Distribution Point - DPMS Logo URL")
        .isEqualTo(distributionPoint.getDpmsLogoUrl());

    Assertions.assertThat(actualIsReturnsOnVault).as("Distribution Point - Is Return On Vault")
        .isEqualTo(convertBooleanToString(distributionPoint.getAllowReturnsOnVault(), "Yes", "No"));
    Assertions.assertThat(actualVaultLogoUrl).as("Distribution Point - Vault Logo URL")
        .isEqualTo(distributionPoint.getVaultLogoUrl());

    Assertions.assertThat(actualIsReturnsOnShipperLite)
        .as("Distribution Point - Is Return On Shipper Lite").isEqualTo(
            convertBooleanToString(distributionPoint.getAllowReturnsOnShipperLite(), "Yes", "No"));
    Assertions.assertThat(actualShipperLiteLogoUrl).as("Distribution Point - Shipper Lite Logo URL")
        .isEqualTo(distributionPoint.getShipperLiteLogoUrl());

    backToShipperList();
  }

  public void updateShipperReturnsSettings(Shipper shipper) {
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

  public void verifyShipperReturnsSettingsIsUpdatedSuccessfully(Shipper shipper) {
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

    Assertions.assertThat(actualReturnsName).as("Returns Name").isEqualTo(returnSettings.getName());
    Assertions.assertThat(actualReturnsContact).as("Returns Contact")
        .isEqualTo(returnSettings.getContact());
    Assertions.assertThat(actualReturnsEmail).as("Returns Email")
        .isEqualTo(returnSettings.getEmail());
    Assertions.assertThat(actualReturnsAddress1).as("Returns Address1 1")
        .isEqualTo(returnSettings.getAddress1());
    Assertions.assertThat(actualReturnsAddress2).as("Returns Address1 2")
        .isEqualTo(returnSettings.getAddress2());
    Assertions.assertThat(actualReturnsCity).as("Returns City").isEqualTo(returnSettings.getCity());
    Assertions.assertThat(actualReturnsPostcode).as("Returns Postcode")
        .isEqualTo(returnSettings.getPostcode());
    Assertions.assertThat(actualLastReturnsNumber).as("Last Returns Number")
        .isEqualTo(String.valueOf(returnSettings.getLastReturnNumber()));

    backToShipperList();
  }

  public void updateShipperQoo10Settings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("Integrations");

    Qoo10 qoo10 = shipper.getQoo10();

    sendKeys("//md-input-container[@model='ctrl.data.integrations.qooUsername']/input",
        qoo10.getUsername());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.qooPassword']/input",
        qoo10.getPassword());
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void verifyShipperQoo10SettingsIsUpdatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("Integrations");

    Qoo10 qoo10 = shipper.getQoo10();

    String actualQoo10Username = getValue(
        "//md-input-container[@model='ctrl.data.integrations.qooUsername']/input");
    String actualQoo10Password = getValue(
        "//md-input-container[@model='ctrl.data.integrations.qooPassword']/input");

    Assertions.assertThat(actualQoo10Username).as("Qoo10 - Username")
        .isEqualTo(qoo10.getUsername());
    Assertions.assertThat(actualQoo10Password).as("Qoo10 - Password")
        .isEqualTo(qoo10.getPassword());

    backToShipperList();
  }

  public void updateShipperShopifySettings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("Integrations");

    Shopify shopify = shipper.getShopify();

    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyMaxDelivery']/input",
        String.valueOf(shopify.getMaxDeliveryDays()));
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyDdOffset']/input",
        String.valueOf(shopify.getDdOffset()));
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyTimewindowId']/input",
        String.valueOf(shopify.getDdTimewindowId()));
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyBaseUrl']/input",
        shopify.getBaseUri());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyApiKey']/input",
        shopify.getApiKey());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyPassword']/input",
        shopify.getPassword());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.shopifyCode']/input",
        shopify.getShippingCodes().get(0));
    clickToggleButton("ctrl.data.integrations.shopifyCodeFilter",
        convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"));
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void verifyShipperShopifySettingsIsUpdatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("Integrations");

    Shopify shopify = shipper.getShopify();

    String actualMaxDeliveryDays = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyMaxDelivery']/input");
    String actualDdOffset = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyDdOffset']/input");
    String actualDDTimeWindowId = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyTimewindowId']/input");
    String actualBaseUrl = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyBaseUrl']/input");
    String actualApiKey = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyApiKey']/input");
    String actualPassword = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyPassword']/input");
    String actualShippingCodes = getValue(
        "//md-input-container[@model='ctrl.data.integrations.shopifyCode']/input");
    String actualShoppingCodeFilter = getToggleButtonValue(
        "ctrl.data.integrations.shopifyCodeFilter");

    Assertions.assertThat(actualMaxDeliveryDays).as("Shopify - Max Delivery Days")
        .isEqualTo(String.valueOf(shopify.getMaxDeliveryDays()));
    Assertions.assertThat(actualDdOffset).as("Shopify - DD Offset")
        .isEqualTo(String.valueOf(shopify.getDdOffset()));
    Assertions.assertThat(actualDDTimeWindowId).as("Shopify - DD Time-window ID")
        .isEqualTo(String.valueOf(shopify.getDdTimewindowId()));
    Assertions.assertThat(actualBaseUrl).as("Shopify - Base URL").isEqualTo(shopify.getBaseUri());
    Assertions.assertThat(actualApiKey).as("Shopify - API Key").isEqualTo(shopify.getApiKey());
    Assertions.assertThat(actualPassword).as("Shopify - Password").isEqualTo(shopify.getPassword());
    Assertions.assertThat(actualShippingCodes).as("Shopify - Shipping Codes")
        .isEqualTo(shopify.getShippingCodes().get(0));
    Assertions.assertThat(actualShoppingCodeFilter).as("Shopify - Shopping Code Filter")
        .isEqualTo(convertBooleanToString(shopify.getShippingCodeFilterEnabled(), "Yes", "No"));

    backToShipperList();
  }

  public void updateShipperMagentoSettings(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("Integrations");

    Magento magento = shipper.getMagento();

    sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input",
        magento.getUsername());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input",
        magento.getPassword());
    sendKeys("//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input",
        magento.getSoapApiUrl());
    saveChanges.click();
    waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  public void verifyShipperMagentoSettingsIsUpdatedSuccessfully(Shipper shipper) {
    waitUntilShipperCreateEditPageIsLoaded();
    clickTabItem("Integrations");

    Magento magento = shipper.getMagento();

    String actualMagentoUsername = getValue(
        "//md-input-container[@model='ctrl.data.integrations.magentoUsername']/input");
    String actualMagentoPassword = getValue(
        "//md-input-container[@model='ctrl.data.integrations.magentoPassword']/input");
    String actualMagentoApiUrl = getValue(
        "//md-input-container[@model='ctrl.data.integrations.magentoApiUrl']/input");

    Assertions.assertThat(actualMagentoUsername).as("Magento - Username")
        .isEqualTo(magento.getUsername());
    Assertions.assertThat(actualMagentoPassword).as("Magento - Password")
        .isEqualTo(magento.getPassword());
    Assertions.assertThat(actualMagentoApiUrl).as("Magento - SOAP API URL")
        .isEqualTo(magento.getSoapApiUrl());

    backToShipperList();
  }

  public void backToShipperList() {
    discardChanges.click();
    pause2s();
    if (discardChangesDialog.leave.isDisplayedFast()) {
      discardChangesDialog.leave.click();
    }
    webDriver.switchTo().window(webDriver.getWindowHandles().iterator().next());
  }

  public void searchTableAddressByAddress(String address) {
    searchTableCustom1("address", address);
  }

  public void clickActionButtonOnTableAddress(int rowNumber, String actionButtonNameOrText) {
    try {
      String xpath1 = String.format(
          "//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-text-button[@text='%s']",
          NG_REPEAT_TABLE_ADDRESS, rowNumber, actionButtonNameOrText);
      String xpath2 = String.format(
          "//tr[@ng-repeat='%s'][%d]/td[starts-with(@class, 'actions')]//nv-icon-button[@name='%s']",
          NG_REPEAT_TABLE_ADDRESS, rowNumber, actionButtonNameOrText);
      String xpath = xpath1 + " | " + xpath2;
      WebElement we = findElementByXpath(xpath);
      moveAndClick(we);
    } catch (NoSuchElementException ex) {
      throw new NvTestRuntimeException("Cannot find action button on table.", ex);
    }
  }

  public void goToTabCorporateSubShipper() {
    tabs.selectTab("Corporate sub shippers");
    waitUntilPageLoaded();
    b2bManagementPage.iframe.isDisplayedFast();
    b2bManagementPage.backToSubShipperTable();
  }

  public void addNewPricingProfileWithoutSave(Shipper shipper) {
    addNewPricingProfile(shipper);
  }

  public String addNewPricingProfileAndSave(Shipper shipper) {
    addNewPricingProfile(shipper);

    String status = getText(f(XPATH_PRICING_PROFILE_STATUS, "Pending"));
    Assertions.assertThat("Pending").as("Status is not Pending ").isEqualTo(status);
    saveChanges.click();

    return retryIfAssertionErrorOccurred(() ->
    {
      String pricingProfileId = getText(XPATH_PRICING_PROFILE_ID);
      assertNotNull(pricingProfileId);
      assertFalse(pricingProfileId.equals(""));
      return pricingProfileId;
    }, "Getting Pricing Profile ID");
  }

  private void addNewPricingProfile(Shipper shipper) {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION, 120);
    tabs.selectTab("Pricing and Billing");
    pricingAndBillingForm.addNewProfile.click();
    dialogHeader.waitUntilVisible();

    if (dialogHeader.getAttribute("title").equalsIgnoreCase("Warning")) {
      warningDialog.proceed.waitUntilVisible();
      warningDialog.proceed.click();
      newPricingProfileDialog.waitUntilClickable();
    }

    Pricing pricing = shipper.getPricing();
    if (pricing != null) {
      clickTabItem(" Pricing and Billing");
      fillPricingProfileDetails(pricing);
      newPricingProfileDialog.saveChanges.click();
      newPricingProfileDialog.waitUntilInvisible();
    }
  }

  private void fillPricingProfileDetails(Pricing pricing) {
    Date effectiveDate = pricing.getEffectiveDate();
    if (Objects.nonNull(effectiveDate)) {
      try {
        setMdDatepickerById(LOCATOR_START_DATE,
            ZonedDateTime.ofInstant(effectiveDate.toInstant(), ZoneId.systemDefault()));
      } catch (InvalidElementStateException ex) {
        LOGGER.info("Start Date is already filled");
      }
    }
    Date endDate = pricing.getContractEndDate();
    if (Objects.nonNull(endDate)) {
      setMdDatepickerById(LOCATOR_END_DATE,
          ZonedDateTime.ofInstant(endDate.toInstant(), ZoneId.systemDefault()));
    }
    String pricingScriptName = pricing.getScriptName();
    if (Objects.nonNull(pricingScriptName)) {
      newPricingProfileDialog.pricingScript.searchAndSelectValue(pricingScriptName);
    }
    String comments = pricing.getComments();
    if (Objects.nonNull(comments)) {
      newPricingProfileDialog.comments.setValue(comments);
    }
    String discount = pricing.getDiscount();
    if (Objects.nonNull(discount)) {
      if (discount.equalsIgnoreCase("empty")) {
        newPricingProfileDialog.discountValue.sendKeys("");
      } else {
        newPricingProfileDialog.discountValue.sendKeys(pricing.getDiscount());
      }
    }
    String shipperInsMin = pricing.getInsMin();
    String shipperInsPercentage = pricing.getInsPercentage();
    String shipperInsThreshold = pricing.getInsThreshold();
    if (Objects.isNull(shipperInsMin) && Objects.isNull(shipperInsPercentage) && Objects
        .isNull(shipperInsThreshold)) {
      newPricingProfileDialog.insuranceCountryDefaultCheckbox.scrollIntoView();
      newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
    } else {
      if (Objects.nonNull(shipperInsMin) && shipperInsMin.equalsIgnoreCase("none")) {
        newPricingProfileDialog.insuranceMin.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperInsMin)) {
        newPricingProfileDialog.insuranceMin.sendKeys(shipperInsMin);
      }
      if (Objects.nonNull(shipperInsPercentage) && shipperInsPercentage
          .equalsIgnoreCase("none")) {
        newPricingProfileDialog.insurancePercent.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperInsPercentage)) {
        newPricingProfileDialog.insurancePercent.sendKeys(shipperInsPercentage);
      }
      if (Objects.nonNull(shipperInsThreshold) && shipperInsThreshold
          .equalsIgnoreCase("none")) {
        newPricingProfileDialog.insuranceThreshold.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperInsThreshold)) {
        newPricingProfileDialog.insuranceThreshold.sendKeys(shipperInsThreshold);
      }
    }
    String shipperCodMin = pricing.getCodMin();
    String shipperCodPercentage = pricing.getCodPercentage();
    if (Objects.isNull(shipperCodMin) && Objects.isNull(shipperCodPercentage)) {
      newPricingProfileDialog.codCountryDefaultCheckbox.check();
    } else {
      if (Objects.nonNull(shipperCodMin) && shipperCodMin.equalsIgnoreCase("none")) {
        newPricingProfileDialog.codMin.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperCodMin)) {
        newPricingProfileDialog.codMin.sendKeys(shipperCodMin);
      }
      if (Objects.nonNull(shipperCodPercentage) && shipperCodPercentage
          .equalsIgnoreCase("none")) {
        newPricingProfileDialog.codPercent.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperCodPercentage)) {
        newPricingProfileDialog.codPercent.sendKeys(shipperCodPercentage);
      }
    }
    String shipperRtsType = pricing.getRtsChargeType();
    String shipperRtsValue = pricing.getRtsChargeValue();
    if (Objects.isNull(shipperRtsType) && Objects.isNull(shipperRtsValue)) {
      newPricingProfileDialog.rtsCountryDefaultCheckbox.check();
    } else {
      if (Objects.nonNull(shipperRtsType)) {
        if (shipperRtsType.equalsIgnoreCase("Discount")) {
          newPricingProfileDialog.rtsDiscount.click();
        } else if (shipperRtsType.equalsIgnoreCase("Surcharge")) {
          newPricingProfileDialog.rtsSurcharge.click();
        }
      }
      if (Objects.nonNull(shipperRtsValue) && shipperRtsValue.equalsIgnoreCase("none")) {
        newPricingProfileDialog.rtsValue.sendKeys(Keys.TAB);
      } else if (Objects.nonNull(shipperRtsValue)) {
        newPricingProfileDialog.rtsValue.sendKeys(shipperRtsValue);
      }
    }
    String country = NV_SYSTEM_ID;
    if (!(country.equalsIgnoreCase("SG") || country.equalsIgnoreCase("VN"))) {
      String billingWeight = pricing.getBillingWeight().getCode();
      if (Objects.isNull(billingWeight)) {
        newPricingProfileDialog.billingWeight.selectValue("Standard");
      } else if (!billingWeight.equalsIgnoreCase("empty")) {
        newPricingProfileDialog.billingWeight.selectValue(billingWeight);
      }
    }
  }

  public Pricing getAddedPricingProfileDetails() throws ParseException {
    Pricing addedPricingProfileOPV2 = new Pricing();
    waitUntilVisibilityOfElementLocated(XPATH_PRICING_PROFILE_ID);
    addedPricingProfileOPV2.setTemplateId(Long.valueOf(getText(XPATH_PRICING_PROFILE_ID)));
    addedPricingProfileOPV2.setDiscount(getText(XPATH_PRICING_PROFILE_DISCOUNT));
    addedPricingProfileOPV2.setScriptName(getText(XPATH_PRICING_PROFILE_SCRIPT_NAME));
    addedPricingProfileOPV2.setComments(getText(XPATH_PRICING_PROFILE_COMMENTS));
    addedPricingProfileOPV2.setCodMin(getText(XPATH_PRICING_PROFILE_COD_MIN));
    addedPricingProfileOPV2.setCodPercentage(getText(XPATH_PRICING_PROFILE_COD_PERCENTAGE));
    addedPricingProfileOPV2.setInsThreshold(getText(XPATH_PRICING_PROFILE_INS_THRESHOLD));
    addedPricingProfileOPV2.setInsMin(getText(XPATH_PRICING_PROFILE_INS_MIN));
    addedPricingProfileOPV2.setInsPercentage(getText(XPATH_PRICING_PROFILE_INS_PERCENTAGE));
    addedPricingProfileOPV2.setBillingWeight(BillingWeightEnum.getBillingWeightEnum(
        getText(XPATH_PRICING_PROFILE_BILLING_WEIGHT_LOGIC)));
    String value = getText(XPATH_PRICING_PROFILE_RTS_CHARGE);
    if (value.startsWith("-")) {
      addedPricingProfileOPV2.setRtsChargeType("Discount");
      addedPricingProfileOPV2.setRtsChargeValue(value.replaceAll("[-%]", ""));
    } else {
      addedPricingProfileOPV2.setRtsChargeType("Surcharge");
      addedPricingProfileOPV2.setRtsChargeValue(value.replaceAll("[%]", ""));
    }
    String endDate = getText(XPATH_PRICING_PROFILE_CONTACT_END_DATE);
    if (!endDate.equals("-")) {
      addedPricingProfileOPV2.setContractEndDate(
          convertToDate(endDate, DTF_NORMAL_DATE));
    }
    String startDate = getText(XPATH_PRICING_PROFILE_EFFECTIVE_DATE);
    if (!startDate.equals("-")) {
      addedPricingProfileOPV2.setEffectiveDate(
          convertToDate(startDate, DTF_NORMAL_DATE));
    }
    return addedPricingProfileOPV2;
  }


  public void editPricingScript(Shipper shipper) {
    String currentWindowHandle = switchToNewWindow();

    Pricing pricing = shipper.getPricing();

    if (pricing != null) {
      clickTabItem(" Pricing and Billing");

      if (StringUtils.isNotBlank(pricing.getScriptName())) {
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
    Assertions.assertThat("Pending").as("Status is not Pending ").isEqualTo(status);

    backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(currentWindowHandle);
  }

  public void verifyPricingScriptIsActive(String status, String status1) {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION, 120);
    clickTabItem(" Pricing and Billing");

    String statusText = getText(f(XPATH_PRICING_PROFILE_STATUS, status));
    Assertions.assertThat(statusText).as("Status is not correct").isEqualTo(status);

    if (!status1.equalsIgnoreCase("")) {
      String statusText1 = getText(f(XPATH_PRICING_PROFILE_STATUS, status1));
      Assertions.assertThat(statusText1).as("Status is not correct").isEqualTo(status1);
    }

    backToShipperList();
    pause3s();
  }

  public void verifyAddNewPricingProfileButtonIsDisplayed() {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION);
    clickTabItem(" Pricing and Billing");

    Assertions.assertThat(isElementVisible(XPATH_ADD_NEW_PRICING_PROFILE))
        .as("Add New Pricing Profile Button is not displayed").isTrue();

    backToShipperList();
    pause3s();
  }

  public void verifyEditPendingProfileIsDisplayed() {
    waitUntilVisibilityOfElementLocated(XPATH_SHIPPER_INFORMATION, 120);
    clickTabItem(" Pricing and Billing");

    Assertions.assertThat(isElementVisible(XPATH_EDIT_PENDING_PROFILE))
        .as("Edit Pending Profile is not displayed").isTrue();

    backToShipperList();
    pause3s();
  }

  public void addNewPricingScriptAndVerifyErrorMessage(Shipper shipper,
      String expectedErrorMessage) {
    Pricing pricing = shipper.getPricing();
    if (pricing != null) {
//      tabs.selectTab("Pricing and Billing");
//      pricingAndBillingForm.addNewProfile.click();
//      newPricingProfileDialog.waitUntilVisible();
      fillPricingProfileDetails(pricing);
      Assertions.assertThat(isElementEnabled(XPATH_SAVE_CHANGES_PRICING_SCRIPT))
          .as("Save Button is enabled").isFalse();
      pause3s();
      waitUntilVisibilityOfElementLocated(XPATH_DISCOUNT_ERROR_MESSAGE);
      String actualErrorMessageText = getText(XPATH_DISCOUNT_ERROR_MESSAGE);
      Assertions.assertThat(actualErrorMessageText).as("Error Message is not expected ")
          .isEqualTo(expectedErrorMessage);

      clickButtonByAriaLabel("Cancel");
    }
  }

  public void addPricingProfileAndVerifySaveButtonIsDisabled(Shipper shipper) {
    Pricing pricing = shipper.getPricing();
    if (pricing != null) {
      clickTabItem(" Pricing and Billing");
      pricingAndBillingForm.addNewProfile.click();
      newPricingProfileDialog.waitUntilVisible();
      if (StringUtils.isNotBlank(pricing.getScriptName())) {
        fillPricingProfileDetails(pricing);
        Assertions.assertThat(isElementEnabled(XPATH_SAVE_CHANGES_PRICING_SCRIPT))
            .as("Save Button is enabled").isFalse();
        clickButtonByAriaLabel("Cancel");
      }
    }
  }

  public static class NewPricingProfileDialog extends MdDialog {

    public NewPricingProfileDialog(WebDriver webDriver, WebElement webElement) {
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
    public PageElement pricingBillingSalespersonDiscountType;

    @FindBy(id = "discount-value")
    public TextBox discountValue;

    @FindBy(css = "md-input-container[label$='COD Value'] div.md-container")
    public CheckBox codCountryDefaultCheckbox;

    @FindBy(id = "cod-min")
    public TextBox codMin;

    @FindBy(id = "cod-percent")
    public TextBox codPercent;

    @FindBy(css = "md-input-container[label$='Insured Value'] div.md-container")
    public CheckBox insuranceCountryDefaultCheckbox;

    @FindBy(id = "insurance-min")
    public TextBox insuranceMin;

    @FindBy(id = "insurance-percent")
    public TextBox insurancePercent;

    @FindBy(id = "insurance-threshold")
    public TextBox insuranceThreshold;

    @FindBy(css = "button[aria-label='Surcharge']")
    public Button rtsSurcharge;

    @FindBy(css = "button[aria-label='Discount']")
    public Button rtsDiscount;

    @FindBy(id = "rts-charge")
    public TextBox rtsValue;

    @FindBy(css = "md-input-container[label$='RTS Fee'] div.md-container")
    public CheckBox rtsCountryDefaultCheckbox;

    @FindBy(css = "md-input-container[label$='RTS Fee'] div.md-label")
    public PageElement rtsCountryDefaultText;

    @FindBy(css = "[id^='container.shippers.pricing-billing-comments']")
    public TextBox comments;

    @FindBy(css = "md-select[placeholder$='Select billing weight logic']")
    public MdSelect billingWeight;

    @FindBy(name = "Save Changes")
    public NvApiTextButton saveChanges;
  }

  public static class EditPendingProfileDialog extends MdDialog {

    public EditPendingProfileDialog(WebDriver webDriver, WebElement webElement) {
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

    @FindBy(id = "insurance-min")
    public TextBox insuranceMin;

    @FindBy(id = "insurance-percent")
    public TextBox insurancePercent;

    @FindBy(id = "insurance-threshold")
    public TextBox insuranceThreshold;

    @FindBy(id = "cod-min")
    public TextBox codMin;

    @FindBy(id = "cod-percent")
    public TextBox codPercent;

    @FindBy(css = "button[aria-label='Surcharge']")
    public Button rtsSurcharge;

    @FindBy(css = "button[aria-label='Discount']")
    public Button rtsDiscount;

    @FindBy(id = "rts-charge")
    public TextBox rtsValue;

    @FindBy(xpath = "//md-input-container[contains(@label,'COD Value')]/md-checkbox")
    public MdCheckbox codCountryDefaultCheckbox;

    @FindBy(xpath = "//md-input-container[contains(@label,'Insured Value')]/md-checkbox")
    public MdCheckbox insuranceCountryDefaultCheckbox;

    @FindBy(xpath = "//md-input-container[contains(@label,'RTS Fee')]/md-checkbox")
    public MdCheckbox rtsCountryDefaultCheckbox;

    @FindBy(xpath = "//md-select[contains(@aria-label,'Select billing weight logic')]")
    public MdSelect billingWeight;

    @FindBy(name = "Save Changes")
    public NvApiTextButton saveChanges;


    public void verifyErrorMsgEditPricingScript(String expectedErrorMessage) {
      try {
        waitUntilVisibilityOfElementLocated(XPATH_DISCOUNT_ERROR_MESSAGE);
        String actualErrorMessageText = getText(XPATH_DISCOUNT_ERROR_MESSAGE);
        Assertions.assertThat(actualErrorMessageText).as("Error Message is not expected ")
            .isEqualTo(expectedErrorMessage);
      } catch (TimeoutException e) {
        fail("Error Message is not available");
      }
    }
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

  public static class WarningDialog extends MdDialog {

    @FindBy(css = ".md-dialog-content")
    public PageElement message;

    @FindBy(css = "[aria-label='Proceed']")
    public Button proceed;

    @FindBy(css = "[aria-label='Abort']")
    public Button abort;

    public WarningDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public void addNewPricingProfile() {
    waitUntilPageLoaded();
    createShipper.click();
    switchToNewWindow();
    waitUntilShipperCreateEditPageIsLoaded();
    tabs.selectTab("Pricing and Billing");
    pricingAndBillingForm.addNewProfile.click();
    newPricingProfileDialog.waitUntilVisible();
  }

  public void verifyStartDateInNewPricingScript() {
    Assertions.assertThat(getValueMdDatepickerById(LOCATOR_START_DATE))
        .as("Expected Start Date is not today ").isEqualTo(DateUtil.getTodayDate_YYYY_MM_DD());
    assertFalse(isEnabledMdDatepickerById(LOCATOR_START_DATE));
  }

  public static class SubShippersDefaultSettingsForm extends PageElement {

    @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.ocVersion']")
    public MdSelect ocVersion;
    @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.selectedOcServices']")
    public MdSelect services;
    @FindBy(css = "md-select[ng-model='ctrl.data.marketplace.trackingType']")
    public MdSelect trackingType;
    @FindBy(xpath = ".//md-input-container[./label[.='Bulky']]/div")
    public MdBooleanSwitch bulky;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate']]/div")
    public MdBooleanSwitch corporate;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate Return']]/div")
    public MdBooleanSwitch corporateReturn;
    @FindBy(xpath = ".//md-input-container[./label[.='Corporate Manual AWB']]/div")
    public MdBooleanSwitch corporateManualAWB;
    @FindBy(id = "container.shippers.service-level")
    public MdSelect serviceLevel;
    @FindBy(id = "Billing Name")
    public TextBox billingName;
    @FindBy(id = "Billing Contact")
    public TextBox billingContact;
    @FindBy(id = "Billing Address")
    public TextBox billingAddress;
    @FindBy(id = "Billing Postcode")
    public TextBox billingPostcode;

    public SubShippersDefaultSettingsForm(WebDriver webDriver, WebElement webElement) {
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
    @FindBy(id = "Shipper Type")
    public TextBox shipperTypeReadOnly;
    @FindBy(id = "shipper-name")
    public TextBox shipperName;
    @FindBy(id = "Short Name")
    public TextBox shortName;
    @FindBy(id = "shipper-phone-number")
    public TextBox shipperPhoneNumber;
    @FindBy(id = "shipper-email")
    public TextBox shipperEmail;
    @FindBy(css = "button[aria-label='Create dash account']")
    public Button createDashAccount;
    @FindBy(id = "dashUsername")
    public TextBox dashUsername;
    @FindBy(css = "[id*='shipper-dashboard-password']")
    public TextBox shipperDashboardPassword;
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
    @FindBy(css = "md-select[ng-model='ctrl.data.basic.ocVersion']")
    public MdSelect ocVersion;
    @FindBy(xpath = ".//md-input-container[./label[.='Bulky']]/div")
    public MdBooleanSwitch bulky;
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
    @FindBy(css = "[model='ctrl.data.basic.enforceParcelPickupTracking']")
    public MdBooleanSwitch enforceParcelPickupTracking;
    @FindBy(css = "[model='ctrl.data.basic.allowEnforceDeliveryVerification']")
    public MdBooleanSwitch allowEnforceDeliveryVerification;

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
    @FindBy(name = "container.shippers.pricing-billing-edit-pending-profile")
    public NvIconTextButton editPendingProfile;
    @FindBy(id = "Billing Name")
    public TextBox billingName;
    @FindBy(id = "Billing Contact")
    public TextBox billingContact;
    @FindBy(id = "Billing Address")
    public TextBox billingAddress;
    @FindBy(id = "Billing Postcode")
    public TextBox billingPostcode;

    @FindBy(css = "[model='ctrl.data.more.are_rates_displayed']")
    public MdBooleanSwitch showPricingEstimate;

    public PricingAndBillingForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public String searchMarketplaceSubshipperAndGetLegacyId(String searchKey, String searchValue) {
    sendKeysAndEnter(f(XPATH_SEARCH_MARKETPLACE_SUB_SHIPPER_TAB, searchKey), searchValue);
    return getText(f(XPATH_SEARCH_MARKETPLACE_SUB_SHIPPER_TAB_LEGACY_ID, searchValue));
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

    @FindBy(name = "Address Finder")
    public NvIconTextButton addressFinder;

    @FindBy(name = "commons.save-changes")
    public NvApiTextButton saveChanges;

    @FindBy(xpath = ".//md-tab-item[.='Address']")
    public PageElement addressTab;

    @FindBy(xpath = ".//md-tab-item[.='Milkrun Reservations']")
    public PageElement milkrunReservationsTab;

    @FindBy(name = "container.shippers.add-new-reservation")
    public NvIconTextButton addNewReservation;
  }
}
