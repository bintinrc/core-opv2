package co.nvqa.operator_v2.selenium.page.all_shippers;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdBooleanSwitch;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.md.TabWrapper;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;


import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class ShipperCreatePageV2 extends OperatorV2SimplePage {

  static Logger LOGGER = getLogger(ShipperCreatePageV2.class);

  public ShipperCreatePageV2(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "form[name='ctrl.marketplaceForm'] input[name='premium-pickup-daily-limit']")
  public TextBox premiumPickupDailyLimitMarketplace;

  @FindBy(css = "tabs-wrapper")
  public TabWrapper tabs;
  @FindBy(name = "ctrl.basicForm")
  public BasicSettingsForm basicSettingsForm;

  @FindBy(css = "md-dialog")
  public AddAddressDialog addAddressDialog;
  @FindBy(name = "container.shippers.create-shipper")
  public NvIconTextButton createShipper;

  @FindBy(name = "Save Changes")
  public NvIconTextButton saveChanges;

  @FindBy(css = "md-dialog")
  public NewPricingProfileDialog newPricingProfileDialog;
  @FindBy(xpath = "//md-content[./form[@name='ctrl.moreForm']]")
  public MoreSettingsForm moreSettingsForm;

  @FindBy(xpath = "//md-content[./form[@name='ctrl.billingForm']]")
  public PricingAndBillingForm pricingAndBillingForm;


  public static class BasicSettingsForm extends PageElement {

    public OperationalSettings operationalSettings;

    public ShipperInformation shipperInformation;
    public ContactDetails contactDetails;

    public ServiceOfferings serviceOfferings;

    public FailedDeliveryManagement failedDeliveryManagement;

    public BasicSettingsForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      operationalSettings = new OperationalSettings(webDriver, webElement);
      shipperInformation = new ShipperInformation(webDriver, webElement);
      contactDetails = new ContactDetails(webDriver, webElement);
      serviceOfferings = new ServiceOfferings(webDriver, webElement);
      failedDeliveryManagement = new FailedDeliveryManagement(webDriver, webElement);
    }

    public static String inputErrorMessageXpath = "//md-input-container[@name='%s']//div[contains(@class,'md-input-messages-animation')]//div";

    public static class ShipperInformation extends PageElement {

      public ShipperInformation(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

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


    }

    public static class ContactDetails extends PageElement {

      public ContactDetails(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

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

    }

    public static class ServiceOfferings extends PageElement {

      public ServiceOfferings(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

      @FindBy(css = "md-select[ng-model='ctrl.data.basic.ocVersion']")
      public MdSelect ocVersion;
      @FindBy(xpath = ".//md-input-container[./label[.='Bulky']]/div")
      public MdBooleanSwitch bulky;


      @FindBy(xpath = ".//md-input-container[./label[.='Return']]/div")
      public MdBooleanSwitch Return;
      @FindBy(xpath = ".//md-input-container[./label[.='Parcel Delivery']]/div")
      public MdBooleanSwitch parcelDelivery;
      @FindBy(xpath = ".//md-input-container[./label[.='Marketplace']]/div")
      public MdBooleanSwitch marketplace;
      @FindBy(xpath = ".//md-input-container[./label[.='International']]/div")
      public MdBooleanSwitch international;
      @FindBy(xpath = ".//md-input-container[./label[.='Marketplace International']]/div")
      public MdBooleanSwitch marketplaceInternational;
      @FindBy(xpath = ".//md-input-container[./label[.='Document']]/div")
      public MdBooleanSwitch document;
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

    }


    public static class OperationalSettings extends PageElement {

      public OperationalSettings(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

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

      @FindBy(css = "[model='ctrl.data.basic.isDeliveryAddressValidationEnabled']")
      public MdBooleanSwitch isDeliveryAddressValidationEnabled;

      @FindBy(css = "[model='ctrl.data.basic.showShipperDetails']")
      public MdBooleanSwitch showShipperDetails;
      @FindBy(css = "[model='ctrl.data.basic.showCod']")
      public MdBooleanSwitch showCod;
      @FindBy(css = "[model='ctrl.data.basic.showParcelDescription']")
      public MdBooleanSwitch showParcelDescription;

      @FindBy(id = "Printer IP")
      public TextBox printerIp;
      @FindBy(name = "trackingType")
      public MdSelect trackingType;
      @FindBy(id = "shipper-prefix")
      public TextBox shipperPrefix;
      @FindBy(xpath = ".//label[@for='shipper-prefix']")
      public PageElement labelForShipperPrefix;
      @FindBy(xpath = ".//div[text()='Prefix already used']")
      public PageElement prefixAlreadyUsed;
      @FindBy(name = "deliveryOtpLength")
      public MdSelect deliveryOtpLength;

      @FindBy(name = "deliveryOtpValidationLimit")
      public MdSelect deliveryOtpValidationLimit;

      public String getShipperPrefixError() {
        return getWebDriver().findElement(
            By.xpath(f(inputErrorMessageXpath, "shipper-prefix"))).getText();
      }

      public String getShipperPrefixError(String index) {
        return getWebDriver().findElement(
            By.xpath(f(inputErrorMessageXpath, f("shipper-prefix-%s", index)))).getText();
      }

      public TextBox getShipperPrefix(String index) {
        WebElement shipperPrefixWebElement = getWebDriver().findElement(
            By.id(f("shipper-prefix-%s", index)));
        return new TextBox(webDriver, shipperPrefixWebElement);
      }
    }

    public static class FailedDeliveryManagement extends PageElement {

      public FailedDeliveryManagement(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

      @FindBy(css = "[model='ctrl.data.basic.fulfillmentService']")
      public MdBooleanSwitch fulfillmentService;

      @FindBy(name = "container.shippers.shipper-bucket")
      public MdSelect shipperBucket;

      @FindBy(id = "free-storage-days")
      public TextBox freeStorageDays;
      @FindBy(id = "maximum-storage-days")
      public TextBox maximumStorageDays;

    }


  }


  public static class MoreSettingsForm extends PageElement {

    public MoreSettingsForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(name = "container.shippers.more-reservation-add-pickup-address")
    public NvIconTextButton addAddress;

    @FindBy(css = "form[name='ctrl.moreForm'] md-select[ng-model='ctrl.data.more.allowedTypes']")
    public MdSelect allowedTypes;

    @FindBy(css = "form[name='ctrl.moreForm'] [name='container.shippers.add-new-service']")
    public NvIconTextButton moreSettingsAddNewService;

    @FindBy(name = "container.shippers.milkrun")
    public NvIconTextButton milkrun;

    @FindBy(name = "container.shippers.more-reservation-edit-pickup-address")
    public NvIconButton editAddress;


    @FindBy(css = "[model='ctrl.data.more.allowPremiumPickupOnSunday']")
    public MdBooleanSwitch allowPremiumPickupOnSunday;

    @FindBy(css = "[model='ctrl.data.more.customerReservation']")
    public MdBooleanSwitch customerReservation;

    @FindBy(id = "premium-pickup-daily-limit")
    public TextBox premiumPickupDailyLimit;


    @FindBy(name = "more-settings-service-type0")
    public MdSelect serviceType;

    @FindBy(id = "more-settings-service-level0")
    public MdSelect serviceLevel;

    @FindBy(name = "commons.select-1")
    public MdSelect defaultPickupTimeSelector;

    @FindBy(css = "[model='ctrl.data.more.isReturnsEnabled']")
    public MdBooleanSwitch isReturnsEnabled;
    @FindBy(name = "Replace with Liaison Details")
    public NvIconTextButton replaceWithLiaisonDetails;

    @FindBy(id = "Returns Address 2 / Unit Number")
    public TextBox returnAddress2;
    @FindBy(id = "Returns Postcode")
    public TextBox returnPostcode;
    @FindBy(id = "Returns City")
    public TextBox returnCity;
    @FindBy(id = "Last Returns Number")
    public TextBox lastReturnNumber;


    @FindBy(css = "[model='ctrl.data.more.isIntegratedVault']")
    public MdBooleanSwitch isIntegratedVault;

    @FindBy(css = "[model='ctrl.data.more.isReturnsOnDpms']")
    public MdBooleanSwitch isReturnsOnDpms;
    @FindBy(css = "[model='ctrl.data.more.isReturnsOnVault']")
    public MdBooleanSwitch isReturnsOnVault;
    @FindBy(css = "[model='ctrl.data.more.isReturnsOnShipperLite']")
    public MdBooleanSwitch isReturnsOnShipperLite;
    @FindBy(css = "[model='ctrl.data.more.allowNinjaCollect']")
    public MdBooleanSwitch allowNinjaCollect;


    @FindBy(css = "[model='ctrl.data.more.allowNoCapDoorStepDelivery']")
    public MdBooleanSwitch allowNoCapDoorStepDelivery;
    @FindBy(css = "[model='ctrl.data.more.isCollectCustomerNricCode']")
    public MdBooleanSwitch isCollectCustomerNricCode;
    @FindBy(id = "DPMS Logo URL")
    public TextBox DPMSLogoURL;
    @FindBy(id = "Vault Logo URL")
    public TextBox VaultLogoURL;
    @FindBy(id = "Shipper Lite Logo URL")
    public TextBox ShipperLiteLogoURL;
    @FindBy(css = "md-select[ng-model='ctrl.data.more.eligibleServiceLevels']")
    public MdSelect eligibleServiceLevels;
    @FindBy(css = "md-select[ng-model='ctrl.data.more.deadlineFallbackAction']")
    public MdSelect deadlineFallbackAction;


    @FindBy(css = "[model='ctrl.data.more.transitShipper']")
    public MdBooleanSwitch transitShipper;

    @FindBy(css = "[model='ctrl.data.more.completedShipper']")
    public MdBooleanSwitch completedShipper;
    @FindBy(css = "[model='ctrl.data.more.pickupFailShipper']")
    public MdBooleanSwitch pickupFailShipper;
    @FindBy(css = "[model='ctrl.data.more.deliveryFailShipper']")
    public MdBooleanSwitch deliveryFailShipper;
    @FindBy(css = "[model='ctrl.data.more.transitCustomer']")
    public MdBooleanSwitch transitCustomer;
    @FindBy(css = "[model='ctrl.data.more.completedCustomer']")
    public MdBooleanSwitch completedCustomer;
    @FindBy(css = "[model='ctrl.data.more.pickupFailCustomer']")
    public MdBooleanSwitch pickupFailCustomer;

    @FindBy(css = "[model='ctrl.data.more.deliveryFailCustomer']")
    public MdBooleanSwitch deliveryFailCustomer;


  }

  public static class AddAddressDialog extends PageElement {

    public AddAddressDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
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


    public PricingAndBillingForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
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

}
