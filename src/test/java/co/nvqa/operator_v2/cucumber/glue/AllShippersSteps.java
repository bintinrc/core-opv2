package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.MilkrunSettings;
import co.nvqa.commons.model.other.LatLong;
import co.nvqa.commons.model.pricing.PricingLevers;
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
import co.nvqa.commons.model.shipper.v2.ServiceTypeLevel;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.shipper.v2.Shopify;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;

import static co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.XPATH_PRICING_PROFILE_CONTACT_END_DATE;
import static co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.XPATH_PRICING_PROFILE_EFFECTIVE_DATE;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.NAME_COLUMN_LOCATOR_KEY;
import static co.nvqa.operator_v2.util.KeyConstants.KEY_SHIPPER_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllShippersSteps extends AbstractSteps {

  private static final String KEY_CURRENT_COUNTRY = "KEY_CURRENT_COUNTRY";
  private AllShippersPage allShippersPage;
  private ProfilePage profilePage;

  private static final DecimalFormat NO_TRAILING_ZERO_DF = new DecimalFormat("###.##");

  public AllShippersSteps() {
  }

  @Override
  public void init() {
    allShippersPage = new AllShippersPage(getWebDriver());
    profilePage = new ProfilePage(getWebDriver());
  }

  @Before("@ResetCountry")
  public void saveCurrentCountry() {
    profilePage.clickProfileButton();
    put(KEY_CURRENT_COUNTRY, profilePage.getCurrentCountry());
    profilePage.closeProfile();
  }

  @After("@ResetCountry")
  public void restoreCurrentCountry() {
    String country = get(KEY_CURRENT_COUNTRY);
    if (StringUtils.isNotBlank(country)) {
      profilePage.clickProfileButton();
      profilePage.changeCountry(country);
      profilePage.closeProfile();
    }
  }

  @When("Operator clear browser cache and reload All Shipper page")
  public void operatorClearBrowserCacheAndReloadAllShipperPage() {
    allShippersPage.clearBrowserCacheAndReloadPage();
  }

  @When("^Operator create new Shipper with basic settings using data below:$")
  public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(
      Map<String, String> mapOfData) {
    Shipper shipper = prepareShipperData(mapOfData);

    allShippersPage.createNewShipper(shipper);
    put(KEY_LEGACY_SHIPPER_ID, String.valueOf(shipper.getLegacyId()));
    put(KEY_CREATED_SHIPPER, shipper);
    putInList(KEY_LIST_OF_CREATED_SHIPPERS, shipper);
  }

  @When("Operator fail create new Shipper with basic settings using data below:")
  public void operatorCreateNewShipperWithBasicSettingsFail(
      Map<String, String> mapOfData) {
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    Shipper shipper = prepareShipperData(mapOfData);
    allShippersPage.createNewShipperFail(shipper);
  }

  private Shipper prepareShipperData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String dateUniqueString = generateDateUniqueString();

    Shipper shipper = new Shipper();
    setShipperDetails(shipper, dateUniqueString, mapOfData);
    setLiaisonDetails(dateUniqueString, shipper);
    setServices(shipper, mapOfData);
    setIndustryAndSales(shipper, mapOfData);
    setPricing(shipper, mapOfData);
    setBilling(shipper, dateUniqueString);
    fillMarketplaceProperties(shipper, mapOfData);
    generatePickupAddresses(shipper, mapOfData);
    return shipper;
  }

  private void generatePickupAddresses(Shipper shipper, Map<String, String> mapOfData) {
    String pickupAddressCount = mapOfData.get("pickupAddressCount");

    if (StringUtils.isNotBlank(pickupAddressCount)) {
      int count = Integer.parseInt(pickupAddressCount);
      List<Address> pickupAddresses = new ArrayList<>();

      for (int i = 0; i < count; i++) {
        Address address = generateRandomAddress();
        address.setName("DA-" + generateDateUniqueString());
        LatLong latLong = generateRandomLatLong();
        address.setLongitude(latLong.getLongitude());
        address.setLatitude(latLong.getLatitude());
        fillMilkrunReservationsProperties(address, i + 1, mapOfData);
        pickupAddresses.add(address);
      }

      shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
    }
  }

  private <T> Map<String, T> extractSubmap(Map<String, T> map, String prefix) {
    return map.entrySet().stream()
        .filter(entry -> entry.getKey().startsWith(prefix))
        .collect(Collectors.toMap(
            entry -> StringUtils.removeStart(entry.getKey(), prefix + ".").trim(),
            Map.Entry::getValue
        ));
  }

  private void fillMarketplaceProperties(Shipper shipper, Map<String, String> mapOfData) {
    if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith("marketplace."))) {
      MarketplaceDefault md = new MarketplaceDefault();
      md.setOrderCreateVersion(mapOfData.get("marketplace.ocVersion"));
      String value = mapOfData.get("marketplace.selectedOcServices");

      if (StringUtils.isNotBlank(value)) {
        List<String> selectedOcServices = Arrays.asList(value.split(","));
        md.setOrderCreateServicesAvailable(selectedOcServices);
      }

      md.setOrderCreateTrackingType(mapOfData.get("marketplace.trackingType"));
      md.setOrderCreateAllowCodService(Boolean.valueOf(mapOfData.get("marketplace.allowCod")));
      md.setOrderCreateAllowCpService(Boolean.valueOf(mapOfData.get("marketplace.allowCp")));
      md.setOrderCreateIsPrePaid(Boolean.valueOf(mapOfData.get("marketplace.isPrePaid")));
      md.setOrderCreateAllowStagedOrders(
          Boolean.valueOf(mapOfData.get("marketplace.allowStaging")));
      md.setOrderCreateIsMultiParcelShipper(
          Boolean.valueOf(mapOfData.get("marketplace.isMultiParcel")));

      value = mapOfData.get("marketplace.premiumPickupDailyLimit");
      if (StringUtils.isNotBlank(value)) {
        md.setPickupPremiumPickupDailyLimit(Integer.valueOf(value));
      }
      value = mapOfData.get("marketplace.orderCreateAvailableServiceLevels");
      if (StringUtils.isNotBlank(value)) {
        List<String> serviceLevels = Arrays.stream(value.split(",")).map(StringUtils::trim)
            .collect(Collectors.toList());
        md.setOrderCreateAvailableServiceLevels(serviceLevels);
      }

      // Billing
      MarketplaceBilling mb = new MarketplaceBilling();
      Address billingAddress = generateRandomAddress();
      String dateUniqueString = generateDateUniqueString();

      value = mapOfData.get("marketplace.billingName");
      mb.setBillingName(StringUtils.isNotBlank(value) ? value : "Billing #" + dateUniqueString);

      value = mapOfData.get("marketplace.billingContact");
      mb.setBillingContact(
          StringUtils.isNotBlank(value) ? value : generatePhoneNumber(dateUniqueString + "2"));

      value = mapOfData.get("marketplace.billingAddress");
      mb.setBillingAddress(StringUtils.isNotBlank(value) ? value
          : billingAddress.to1LineAddress() + " #" + dateUniqueString);

      value = mapOfData.get("marketplace.billingPostcode");
      mb.setBillingPostcode(StringUtils.isNotBlank(value) ? value : billingAddress.getPostcode());

      shipper.setMarketplaceBilling(mb);
      shipper.setMarketplaceDefault(md);
    }
  }

  private void fillMilkrunReservationsProperties(Address address, int addressIndex,
      Map<String, String> mapOfData) {
    String milkrunPrefix = "address." + addressIndex + ".milkrun";

    if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith(milkrunPrefix))) {
      Map<String, String> milkrunData = extractSubmap(mapOfData, milkrunPrefix);
      int reservationsCount = milkrunData.containsKey("reservationCount") ? Integer
          .parseInt(milkrunData.get("reservationCount")) : 1;

      for (int j = 1; j <= reservationsCount; j++) {
        Map<String, String> reservationData = extractSubmap(milkrunData, String.valueOf(j));
        fillMilkrunReservationProperties(address, reservationData);
      }
    }
  }

  private void fillMilkrunReservationProperties(Address address, Map<String, String> mapOfData) {
    MilkrunSettings ms = new MilkrunSettings();
    String value = mapOfData.get("startTime");

    if (StringUtils.isNotBlank(value)) {
      ms.setStartTime(value);
    }

    value = mapOfData.get("endTime");

    if (StringUtils.isNotBlank(value)) {
      ms.setEndTime(value);
    }

    value = mapOfData.get("days");

    if (StringUtils.isNotBlank(value)) {
      List<Integer> days = Arrays.stream(value.split(","))
          .map(d -> Integer.parseInt(d.trim()))
          .collect(Collectors.toList());
      ms.setDays(days);
    }

    value = mapOfData.get("noOfReservation");

    if (StringUtils.isNotBlank(value)) {
      ms.setNoOfReservation(Integer.valueOf(value));
    }

    List<MilkrunSettings> milkrunSettings = new LinkedList<>();
    milkrunSettings.add(ms);

    address.setMilkRun(true);

    if (address.getMilkrunSettings() == null) {
      address.setMilkrunSettings(milkrunSettings);
    } else {
      address.getMilkrunSettings().addAll(milkrunSettings);
    }
  }

  @Then("^Operator verify the new Shipper is created successfully$")
  public void operatorVerifyTheNewShipperIsCreatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyNewShipperIsCreatedSuccessfully(shipper);
  }

  @Then("^Operator open Edit Shipper Page of shipper \"(.+)\"$")
  public void operatorOpenEditShipperPageOfShipper(String shipperName) {
    shipperName = resolveValue(shipperName);
    allShippersPage.searchShipper(shipperName);
    allShippersPage.openEditShipperPage();
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.allShippersCreateEditPage.shipperInformation.waitUntilClickable();
    pause2s();
  }

  @And("Operator open Edit Shipper Page of created shipper")
  public void operatorOpenEditShipperOfCreatedShipper() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    openSpecificShipperEditPage(String.valueOf(shipper.getLegacyId()));
  }

  @Then("^Operator open Edit Pricing Profile dialog on Edit Shipper Page$")
  public void operatorOpenEditPricingProfileDialogOnEditShipperPage() {
    allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
    allShippersPage.allShippersCreateEditPage.editPendingProfile.click();
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilVisible();
  }

  @Then("^Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:$")
  public void operatorVerifyEditPricingProfileDialogOnEditShipperPage(Map<String, String> data) {
    data = resolveKeyValues(data);

    String value = data.get("shipperId");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Shipper ID", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperId.getText());
    }
    value = data.get("shipperName");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Shipper Name", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperName.getText());
    }
    value = data.get("startDate");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Start Date", value,
          getWebDriver().findElement(By.xpath(XPATH_PRICING_PROFILE_EFFECTIVE_DATE)).getText());
    }
    value = data.get("endDate");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("End Date", value,
          getWebDriver().findElement(By.xpath(XPATH_PRICING_PROFILE_CONTACT_END_DATE)).getText());
    }
    value = data.get("pricingScriptName");
    if (StringUtils.isNotBlank(value)) {
      assertThat("Pricing Script",
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript
              .getValue(), Matchers.containsString(value));
    }
    value = data.get("type");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Salesperson Discount Type", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingSalespersonDicountType
              .getText());
    }
    value = data.get("discount");
    if (StringUtils.equalsIgnoreCase("none", value)) {
      assertThat("Discount Value",
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue
              .getValue(), Matchers.is(Matchers.emptyOrNullString()));
    } else if (StringUtils.isNotBlank(value)) {
      assertEquals("Discount Value", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue
              .getValue());
    }
    value = data.get("comments");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Comments", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.getValue());
    }
    value = data.get("insuranceMinFee");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Insurance Min Fee", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin
              .getValue());
    }
    value = data.get("insurancePercentage");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Insurance Percentage", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent
              .getValue());
    }
    value = data.get("insuranceThreshold");
    if (StringUtils.isNotBlank(value)) {
      assertEquals("Insurance Threshold", value,
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold
              .getValue());
    }
    value = data.get("isDefaultIns");
    if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
      assertTrue("Default Insurance",
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceCountryDefaultCheckbox
              .getAttribute("aria-checked").equalsIgnoreCase("true"));
    }
    value = data.get("isDefaultCod");
    if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
      assertTrue("Default Cod",
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codCountryDefaultCheckbox
              .getAttribute("aria-checked").equalsIgnoreCase("true"));
    }
  }

  @Then("^Operator add New Pricing Profile on Edit Shipper Page using data below:$")
  public void operatorAddNewPricingProfileOnEditShipperPage(Map<String, String> data) {
    Shipper shipper = setShipperPricingProfile(data);
    allShippersPage.addNewPricingProfileWithoutSaving(shipper);
    put(KEY_PRICING_PROFILE, shipper.getPricing());
  }

  @Then("^Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:$")
  public void operatorFillNewPricingProfileOnEditShipperPage(Map<String, String> data) {
    try {
      data = resolveKeyValues(data);
      Pricing pricing = get(KEY_PRICING_PROFILE);

      String value = data.get("startDate");
      if (StringUtils.isNotBlank(value)) {
        NvLogger.infof("Set Start date : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingStartDate
            .simpleSetValue(value);
        pricing.setEffectiveDate(YYYY_MM_DD_SDF.parse(value));
      }
      value = data.get("endDate");
      if (StringUtils.isNotBlank(value)) {
        NvLogger.infof("Set End date : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingEndDate
            .simpleSetValue(value);
        pricing.setContractEndDate(YYYY_MM_DD_SDF.parse(value));
      }
      value = data.get("pricingScriptName");
      if (StringUtils.isNotBlank(value)) {
        NvLogger.infof("Set Pricing Script value : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript
            .searchAndSelectValue(value);
      }
      value = data.get("discount");
      if (StringUtils.equalsIgnoreCase("none", value)) {
        NvLogger.infof("Set Discount value : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.clear();
        pricing.setDiscount(null);
      } else if (StringUtils.isNotBlank(value)) {
        NvLogger.infof("Set Discount value : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue
            .setValue(value);
        pricing.setDiscount(value);
      }
      value = data.get("comments");
      if (StringUtils.isNotBlank(value)) {
        NvLogger.infof("Set comments : %s", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.setValue(value);
        pricing.setComments(value);
      }
      value = data.get("insuranceMinFee");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin
              .sendKeys(Keys.TAB);
          pricing.setInsMin(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin
              .setValue(value);
          pricing.setInsMin(value);
        }
      }
      value = data.get("insurancePercentage");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent
              .clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent
              .sendKeys(Keys.TAB);
          pricing.setInsPercentage(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent
              .setValue(value);
          pricing.setInsPercentage(value);
        }
      }
      value = data.get("insuranceThreshold");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold
              .clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold
              .sendKeys(Keys.TAB);
          pricing.setInsThreshold(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold
              .setValue(value);
          pricing.setInsThreshold(value);
        }
      }
      value = data.get("codMinFee");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin
              .sendKeys(Keys.TAB);
          pricing.setCodMin(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin
              .setValue(value);
          pricing.setCodMin(value);
        }
      }
      value = data.get("codPercentage");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent
              .sendKeys(Keys.TAB);
          pricing.setCodPercentage(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent
              .setValue(value);
          pricing.setCodPercentage(value);
        }
      }
      value = data.get("isDefaultIns");
      if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceCountryDefaultCheckbox
            .check();
      }
      value = data.get("isDefaultCod");
      if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codCountryDefaultCheckbox
            .check();
      }
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }

  @Then("^Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page$")
  public void operatorSaveChangesPricingProfileOnEditShipperPage() {
    takesScreenshot();
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.saveChanges
        .clickAndWaitUntilDone();
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilInvisible();
  }

  @Then("^Operator save changes on Edit Shipper Page$")
  public void operatorSaveChangesOnEditShipperPage() {
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
    allShippersPage.allShippersCreateEditPage
        .waitUntilInvisibilityOfToast("All changes saved successfully");
    allShippersPage.allShippersCreateEditPage.backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("^Operator save changes on Edit Shipper Page and gets saved pricing profile values$")
  public void operatorSaveChangesOnEditShipperPageAndGetsPPDiscountValue() {
    try {
      allShippersPage.allShippersCreateEditPage.saveChanges.click();
      allShippersPage.allShippersCreateEditPage
          .waitUntilInvisibilityOfToast("All changes saved successfully");

      Shipper shipper = get(KEY_CREATED_SHIPPER);
      getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
      openSpecificShipperEditPage(shipper.getLegacyId().toString());

      allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
      Pricing createdPricingProfile = allShippersPage.getCreatedPricingProfile();
      put(KEY_CREATED_PRICING_PROFILE_OPV2, createdPricingProfile);
      put(KEY_PRICING_PROFILE_ID, createdPricingProfile.getTemplateId().toString());
      allShippersPage.allShippersCreateEditPage.backToShipperList();
      pause3s();
      getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }


  @And("Operator gets pricing profile values")
  public void operatorGetsPricingProfileValues() {
    try {
      allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
      Pricing createdPricingProfile = allShippersPage.getCreatedPricingProfile();
      put(KEY_CREATED_PRICING_PROFILE_OPV2, createdPricingProfile);
      put(KEY_PRICING_PROFILE_ID, createdPricingProfile.getTemplateId().toString());
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }


  @Then("^Operator go back to Shipper List page")
  public void operatorGoBackToShipperListPage() {
    allShippersPage.allShippersCreateEditPage.backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("^Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:$")
  public void operatorVerifyErrorMessagesNewPricingProfileOnEditShipperPage(
      Map<String, String> data) {
    pause1s();
    data = resolveKeyValues(data);
    String expectedErrorMsg = data.get("errorMessage");
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog
        .verifyErrorMsgEditPricingScript(expectedErrorMsg);
  }

  @Then("^Operator verify the new Shipper is updated successfully$")
  public void operatorVerifyTheNewShipperIsUpdatedSuccessfully() {
    operatorVerifyTheNewShipperIsCreatedSuccessfully();
  }

  @When("^Operator update Shipper's basic settings$")
  public void operatorUpdateShipperBasicSettings() {
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Shipper oldShipper = SerializationUtils.clone(shipper);
    String dateUniqueString = generateDateUniqueString();

    // Shipper Details
    shipper.setActive(!shipper.getActive());
    shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
    shipper.setContact(generatePhoneNumber(dateUniqueString));

    // Liaison Details
    Address liaisonAddress = generateRandomAddress();

    shipper.setLiaisonName("Liaison #" + dateUniqueString);
    shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString + "1"));
    shipper.setLiaisonEmail("ln." + dateUniqueString + "@ninjavan.co");
    shipper.setLiaisonAddress(liaisonAddress.to1LineAddress() + " #" + dateUniqueString);
    shipper.setLiaisonPostcode(liaisonAddress.getPostcode());

    // Services
    OrderCreate orderCreate = shipper.getOrderCreate();
    orderCreate.setAllowCodService(!orderCreate.getAllowCodService());
    orderCreate.setAllowCpService(!orderCreate.getAllowCpService());
    orderCreate.setIsPrePaid(!orderCreate.getIsPrePaid());
    orderCreate.setAllowStagedOrders(!orderCreate.getAllowStagedOrders());
    orderCreate.setIsMultiParcelShipper(!orderCreate.getIsMultiParcelShipper());

    DistributionPoint distributionPoint = shipper.getDistributionPoints();
    distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(
        !distributionPoint.getShipperLiteAllowRescheduleFirstAttempt());

    // Billing
//        Address billingAddress = generateRandomAddress();
//
//        shipper.setBillingName("Billing #" + dateUniqueString);
//        shipper.setBillingContact(generatePhoneNumber(dateUniqueString + "2"));
//        shipper.setBillingAddress(billingAddress.to1LineAddress() + " #" + dateUniqueString);
//        shipper.setBillingPostcode(billingAddress.getPostcode());

    allShippersPage.updateShipperBasicSettings(oldShipper, shipper);
    put(KEY_UPDATED_SHIPPER, oldShipper);
  }

  @Then("^Operator verify Shipper's basic settings is updated successfully$")
  public void operatorVerifyShipperBasicSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Shipper oldShipper = get(KEY_UPDATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyShipperIsUpdatedSuccessfully(oldShipper, shipper);
  }

  @When("^Operator update Shipper's Label Printer settings$")
  public void operatorUpdateShipperLabelPrinterSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    LabelPrinter labelPrinter = new LabelPrinter();
    labelPrinter.setPrinterIp("127.0.0.1");
    labelPrinter.setShowShipperDetails(true);
    shipper.setLabelPrinter(labelPrinter);

    allShippersPage.updateShipperLabelPrinterSettings(shipper);
  }

  @Then("^Operator verify Shipper's Label Printer settings is updated successfully$")
  public void operatorVerifyShipperLabelPrinterSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("^Operator update Shipper's Returns settings$")
  public void operatorUpdateShipperReturnsSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();
    Address returnAddress = generateRandomAddress();

    Return returnSettings = new Return();
    returnSettings.setName("Return #" + dateUniqueString);
    returnSettings.setContact(generatePhoneNumber(dateUniqueString));
    returnSettings.setEmail("return." + dateUniqueString + "@ninjavan.co");
    returnSettings.setAddress1(returnAddress.getAddress1());
    returnSettings.setAddress2(returnAddress.getAddress2());
    returnSettings.setCity(returnAddress.getCity());
    returnSettings.setPostcode(returnAddress.getPostcode());
    returnSettings.setLastReturnNumber(System.currentTimeMillis());
    shipper.setReturns(returnSettings);

    allShippersPage.updateShipperReturnsSettings(shipper);
  }

  @Then("^Operator verify Shipper's Returns settings is updated successfully$")
  public void operatorVerifyShipperReturnsSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperReturnsSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("^Operator update Shipper's Distribution Point settings$")
  public void operatorUpdateShipperDistributionPointSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    DistributionPoint distributionPoint = new DistributionPoint();
    distributionPoint.setVaultIsIntegrated(true);
    distributionPoint.setVaultCollectCustomerNricCode(true);
    distributionPoint.setAllowReturnsOnDpms(true);
    distributionPoint.setDpmsLogoUrl("https://dpmslogo" + dateUniqueString + ".com");
    distributionPoint.setAllowReturnsOnVault(true);
    distributionPoint.setVaultLogoUrl("https://vaultlogo" + dateUniqueString + ".com");
    distributionPoint.setAllowReturnsOnShipperLite(true);
    distributionPoint.setShipperLiteLogoUrl("https://shipperlitelogo" + dateUniqueString + ".com");
    shipper.setDistributionPoints(distributionPoint);

    allShippersPage.updateShipperDistributionPointSettings(shipper);
  }

  @Then("^Operator verify Shipper's Distribution Point settings is updated successfully$")
  public void operatorVerifyShipperDistributionPointSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("^Operator update Shipper's Qoo10 settings$")
  public void operatorUpdateShipperQoo10Settings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    Qoo10 qoo10 = new Qoo10();
    qoo10.setUsername("qoo10" + dateUniqueString);
    qoo10.setPassword(dateUniqueString);
    shipper.setQoo10(qoo10);

    allShippersPage.updateShipperQoo10Settings(shipper);
  }

  @Then("^Operator verify Shipper's Qoo10 settings is updated successfully$")
  public void operatorVerifyShipperQoo10SettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperQoo10SettingsIsUpdatedSuccessfully(shipper);
  }

  @When("^Operator update Shipper's Shopify settings$")
  public void operatorUpdateShipperShopifySettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    Shopify shopify = new Shopify();
    shopify.setMaxDeliveryDays(randomLong(0, 3));
    shopify.setDdOffset(1L);
    shopify.setDdTimewindowId(2L);
    shopify.setBaseUri(f("https://www.shopify%s.com", dateUniqueString));
    shopify.setApiKey(dateUniqueString + "1");
    shopify.setPassword(dateUniqueString + "2");
    shopify.setShippingCodes(Collections.singletonList(dateUniqueString + "3"));
    shopify.setShippingCodeFilterEnabled(true);
    shipper.setShopify(shopify);

    allShippersPage.updateShipperShopifySettings(shipper);
  }

  @Then("^Operator verify Shipper's Shopify settings is updated successfully$")
  public void operatorVerifyShipperShopifySettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperShopifySettingsIsUpdatedSuccessfuly(shipper);
  }

  @When("^Operator update Shipper's Magento settings$")
  public void operatorUpdateShipperMagentoSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    Magento magento = new Magento();
    magento.setUsername("magento" + dateUniqueString);
    magento.setPassword(dateUniqueString);
    magento.setSoapApiUrl(f("https://www.magento%s.com", dateUniqueString));
    shipper.setMagento(magento);

    allShippersPage.updateShipperMagentoSettings(shipper);
  }

  @Then("^Operator verify Shipper's Magento settings is updated successfully$")
  public void operatorVerifyShipperMagentoSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperMagentoSettingsIsUpdatedSuccessfuly(shipper);
  }

  @When("^Operator enable Auto Reservation for Shipper and change Shipper default Address to the new Address using data below:$")
  public void operatorEnableAutoReservationForShipperAndChangeShipperDefaultAddressToTheNewAddressUsingDataBelow(
      Map<String, String> mapOfData) {
    String reservationDays = mapOfData.get("reservationDays");
    String autoReservationReadyTime = mapOfData.get("autoReservationReadyTime");
    String autoReservationLatestTime = mapOfData.get("autoReservationLatestTime");
    String autoReservationCutoffTime = mapOfData.get("autoReservationCutoffTime");
    String autoReservationApproxVolume = mapOfData.get("autoReservationApproxVolume");
    String allowedTypes = mapOfData.get("allowedTypes");

    List<Long> listOfReservationDays;

    if (reservationDays == null || reservationDays.isEmpty()) {
      listOfReservationDays = new ArrayList<>();
    } else {
      listOfReservationDays = Stream.of(reservationDays.split(","))
          .map(s -> Long.parseLong(s.trim())).collect(Collectors.toList());
    }

    List<String> listOfAllowedTypes;

    if (allowedTypes == null || allowedTypes.isEmpty()) {
      listOfAllowedTypes = new ArrayList<>();
    } else {
      listOfAllowedTypes = Stream.of(allowedTypes.split(",")).map(String::trim)
          .collect(Collectors.toList());
    }

    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Address createdAddress = AddressFactory.getRandomAddress();
    String unique = generateDateUniqueString();
    createdAddress.setName(f("Dummy Address #%s", unique));
    createdAddress.setEmail(f("dummy.address.%s@gmail.com", unique));
    createdAddress.setAddress2(createdAddress.getAddress2() + " #" + unique);

    Reservation reservation = new Reservation();
    reservation.setAutoReservationEnabled(true);
    reservation.setDays(listOfReservationDays);
    reservation.setAutoReservationReadyTime(autoReservationReadyTime);
    reservation.setAutoReservationLatestTime(autoReservationLatestTime);
    reservation.setAutoReservationCutoffTime(autoReservationCutoffTime);
    reservation.setAutoReservationApproxVolume(autoReservationApproxVolume);
    reservation.setAllowedTypes(listOfAllowedTypes);

    allShippersPage
        .enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper, createdAddress,
            reservation);
    put(KEY_CREATED_ADDRESS, createdAddress);
  }

  @Then("^Operator verify the shipper is deleted successfully$")
  public void operatorVerifyTheShipperIsDeletedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperIsDeletedSuccessfully(shipper);
  }

  @When("^Operator login to created Shipper's Dashboard from All Shipper page$")
  public void operatorLoginAsCreatedShipperFromAllShipperPage() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    allShippersPage.loginToShipperDashboard(shipper);
  }

  @When("^Operator set pickup addresses of the created shipper using data below:$")
  public void operatorSetPickupAddressesOfTheCreatedShipperUsingDataBelow(
      Map<String, String> mapOfData) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    List<Address> addresses = shipper.getPickup().getReservationPickupAddresses();
    if (CollectionUtils.isNotEmpty(addresses)) {
      for (int i = 0; i < addresses.size(); i++) {
        fillMilkrunReservationsProperties(addresses.get(i), i + 1, mapOfData);
      }
    }
    allShippersPage.setPickupAddressesAsMilkrun(shipper);
  }

  @And("^Operator unset milkrun reservation \"(\\d+)\" form pickup address \"(\\d+)\" for created shipper$")
  public void operatorUnsetMilkrunReservationFormPickupAddressForCreatedShipper(
      int milkrunReservationIndex, int addressIndex) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.removeMilkrunReservarion(shipper, addressIndex, milkrunReservationIndex);
    Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
    address.getMilkrunSettings().remove(milkrunReservationIndex - 1);
    if (CollectionUtils.isEmpty(address.getMilkrunSettings())) {
      address.setMilkRun(false);
    }
  }

  @And("^Operator unset all milkrun reservations form pickup address \"(\\d+)\" for created shipper$")
  public void operatorUnsetAllMilkrunReservationsFormPickupAddressForCreatedShipper(
      int addressIndex) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.removeAllMilkrunReservarions(shipper, addressIndex);
    Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
    address.getMilkrunSettings().clear();
    address.setMilkRun(false);
  }

  @Then("^Operator verifies All Shippers Page is displayed$")
  public void operatorVerifiesAllOrdersPageIsDispalyed() {
    allShippersPage.waitUntilPageLoaded();
  }

  @When("Operator clears all filters on All Shippers page")
  public void operatorClearsAllFiltersOnAllShippersPage() {
    allShippersPage.clearAllSelections();
  }

  @And("Operator chooses {string} filter")
  public void operatorChoosesFilter(String filter) {
    allShippersPage.chooseFilter(filter);
  }

  @Then("Operator searches the {string} field with {string} keyword")
  public void OperatorSearchesTheFieldWithKeyword(String filter, String keyword) {
    allShippersPage.searchByFilterWithKeyword(filter, keyword);
  }

  @Then("Operator verifies that the results have keyword {string} in {string} column")
  public void operatorVerifiesThatTheResultsHaveKeywordInColumn(String keyword, String column) {
    allShippersPage.verifiesResultsOfColumn(keyword, column);
  }

  @Then("Operator searches for Shippers with Active filter")
  public void operatorSearchesForShippersWithActiveFilter() {
    allShippersPage.searchActiveFilter();
  }

  @And("Operator searches for keyword {string} in quick search filter")
  public void operatorSearchesForShippersInQuickSearchFilter(String keyword) {
    allShippersPage.quickSearchShipper(keyword);
  }

  @And("Operator edits the created shipper")
  public void operatorEditsTheCreatedShipper() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.editShipper(shipper);
  }

  @And("Operator edits shipper {string}")
  public void operatorEditsShipper(String shipperLegacyId) {
    Shipper shipper = new Shipper();
    shipper.setLegacyId(Long.valueOf(shipperLegacyId));
    put(KEY_CREATED_SHIPPER, shipper);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    openSpecificShipperEditPage(shipperLegacyId);
  }

  private void openSpecificShipperEditPage(String shipperLegacyId) {
    for (String handle : getWebDriver().getWindowHandles()) {
      if (!handle.equals(get(KEY_MAIN_WINDOW_HANDLE))) {
        getWebDriver().switchTo().window(handle);
        getWebDriver().close();
      }
    }

    String editSpecificShipperPageURL = (f("%s/%s/shippers/%s",
        TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.COUNTRY_CODE, shipperLegacyId));

    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    ((JavascriptExecutor) getWebDriver()).executeScript("window.open()");
    ArrayList<String> tabs = new ArrayList<>(getWebDriver().getWindowHandles());
    getWebDriver().switchTo().window(tabs.get(1));
    getWebDriver().get(editSpecificShipperPageURL);
    allShippersPage.allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  @And("Operator edits shipper with ID and Name {string}")
  public void operatorEditsShipperWithIdAndName(String shipperIdAndName) {
    Shipper shipper = new Shipper();
    shipper.setLegacyId(Long.valueOf(shipperIdAndName.split("-", 2)[0]));
    shipper.setName(shipperIdAndName.split("-", 2)[1]);
    put(KEY_CREATED_SHIPPER, shipper);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.editShipper(shipper);
  }

  @Then("Operator adds new Shipper's Pricing Profile")
  public void OperatorAddsNewShippersPricingProfile(Map<String, String> mapOfData) {
    Shipper shipper = setShipperPricingProfile(mapOfData);
    String pricingProfileId = allShippersPage.addNewPricingProfile(shipper);
    put(KEY_PRICING_PROFILE, shipper.getPricing());
    put(KEY_PRICING_PROFILE_ID, pricingProfileId);
  }

  @Then("Operator adds pricing profile with below details and verifies save button is disabled")
  public void operatorAddsPricingProfileWithBelowDetailsAndVerifiesSaveButtonIsDisabled(
      Map<String, String> mapOfData) {
    Shipper shipper = setShipperPricingProfile(mapOfData);
    allShippersPage.addPricingProfileAndVerifySaveButtonIsDisabled(shipper);
  }

  private Shipper setShipperPricingProfile(Map<String, String> mapOfData) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Pricing pricing = new Pricing();
    try {
      String pricingScriptName = mapOfData.get("pricingScriptName");
      String discount = mapOfData.get("discount");
      String comments = mapOfData.get("comments");
      String type = mapOfData.get("type");
      String codMinFee = mapOfData.get("codMinFee");
      String codPercentage = mapOfData.get("codPercentage");
      String insuranceMinFee = mapOfData.get("insuranceMinFee");
      String insurancePercentage = mapOfData.get("insurancePercentage");
      String insuranceThreshold = mapOfData.get("insuranceThreshold");
      String startDate = mapOfData.get("startDate");
      String endDate = mapOfData.get("endDate");

      pricing.setComments(comments);
      pricing.setScriptName(pricingScriptName);
      pricing.setDiscount(discount);
      pricing.setType(type);
      pricing.setCodMin(codMinFee);
      pricing.setCodPercentage(codPercentage);
      pricing.setInsThreshold(insuranceThreshold);
      pricing.setInsPercentage(insurancePercentage);
      pricing.setInsMin(insuranceMinFee);
      pricing.setEffectiveDate(
          Objects.nonNull(startDate) ? YYYY_MM_DD_SDF.parse(startDate) : null);
      pricing.setContractEndDate(
          Objects.nonNull(endDate) ? YYYY_MM_DD_SDF.parse(endDate) : null);
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
    shipper.setPricing(pricing);
    return shipper;
  }

  @Deprecated
  @Then("Operator edits the Pending Pricing Script")
  public void operatorEditsThePendingPricingScript(Map<String, String> mapOfData) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    String discount = mapOfData.get("discount");
    String comments = mapOfData.get("comments");

    Pricing pricing = new Pricing();
    pricing.setDiscount(discount);
    pricing.setComments(comments);

    shipper.setPricing(pricing);

    allShippersPage.editPricingScript(shipper);
  }

  @Then("Operator verifies that Pricing Script is {string} and {string}")
  public void operatorVerifiesThatPricingScriptIsActiveAnd(String status, String status1) {
    allShippersPage.verifyPricingScriptIsActive(status, status1);
  }

  @When("Operator create new Shipper with basic settings and updates pricing script using data below:")
  public void operatorCreateNewShipperWithBasicSettingsAndUpdatesPricingScriptUsingDataBelow(
      Map<String, String> mapOfData) {
    String dateUniqueString = generateDateUniqueString();

    Shipper shipper = new Shipper();
    setShipperDetails(shipper, dateUniqueString, mapOfData);
    setLiaisonDetails(dateUniqueString, shipper);
    setServices(shipper, mapOfData);
    setIndustryAndSales(shipper, mapOfData);
    setPricing(shipper, mapOfData);
    setBilling(shipper, dateUniqueString);
    fillMarketplaceProperties(shipper, mapOfData);
    generatePickupAddresses(shipper, mapOfData);

    allShippersPage.createNewShipperWithUpdatedPricingScript(shipper);
    put(KEY_CREATED_SHIPPER, shipper);
  }

  private void setBilling(Shipper shipper, String dateUniqueString) {
    Address billingAddress = generateRandomAddress();

    shipper.setBillingName("Billing #" + dateUniqueString);
    shipper.setBillingContact(generatePhoneNumber(dateUniqueString + "2"));
    shipper.setBillingAddress(billingAddress.to1LineAddress() + " #" + dateUniqueString);
    shipper.setBillingPostcode(billingAddress.getPostcode());
  }

  private void setPricing(Shipper shipper, Map<String, String> mapOfData) {
    Pricing pricing = new Pricing();
    pricing.setScriptName(mapOfData.get("pricingScriptName"));
    shipper.setPricing(pricing);
  }

  private void setIndustryAndSales(Shipper shipper, Map<String, String> mapOfData) {
    shipper.setIndustryName(mapOfData.get("industryName"));
    shipper.setSalesPerson(mapOfData.get("salesPerson"));
    shipper.setAccountTypeId(6L);

    Pickup pickupSettings = new Pickup();
    pickupSettings.setDefaultStartTime("09:00");
    pickupSettings.setDefaultEndTime("22:00");
    if (mapOfData.containsKey("premiumPickupDailyLimit")) {
      pickupSettings
          .setPremiumPickupDailyLimit(Integer.valueOf(mapOfData.get("premiumPickupDailyLimit")));
    }
    if (mapOfData.containsKey("pickupServiceTypeLevels")) {
      List<ServiceTypeLevel> serviceTypeLevels = Arrays
          .stream(mapOfData.get("pickupServiceTypeLevels").split(","))
          .map(val ->
          {
            ServiceTypeLevel serviceTypeLevel = new ServiceTypeLevel();
            String[] values = val.split(":");
            serviceTypeLevel.setType(values[0].trim());
            serviceTypeLevel.setLevel(values[1].trim());
            return serviceTypeLevel;
          })
          .collect(Collectors.toList());
      pickupSettings.setServiceTypeLevel(serviceTypeLevels);
    }
    shipper.setPickup(pickupSettings);
  }

  private void setServices(Shipper shipper, Map<String, String> mapOfData) {
    Boolean isAllowCod = Boolean.parseBoolean(mapOfData.get("isAllowCod"));
    Boolean isAllowCashPickup = Boolean.parseBoolean(mapOfData.get("isAllowCashPickup"));
    Boolean isPrepaid = Boolean.parseBoolean(mapOfData.get("isPrepaid"));
    Boolean isAllowStagedOrders = Boolean.parseBoolean(mapOfData.get("isAllowStagedOrders"));
    Boolean isMultiParcelShipper = Boolean.parseBoolean(mapOfData.get("isMultiParcelShipper"));
    Boolean isDisableDriverAppReschedule = Boolean
        .parseBoolean(mapOfData.get("isDisableDriverAppReschedule"));
    Boolean isCorporateReturn = Boolean.parseBoolean(mapOfData.get("isCorporateReturn"));
    String ocVersion = mapOfData.get("ocVersion");
    String servicesTemp = mapOfData.get("services");
    String trackingType = mapOfData.get("trackingType");

    List<String> listOfAvailableService;
    if (servicesTemp == null || servicesTemp.isEmpty()) {
      listOfAvailableService = new ArrayList<>();
    } else {
      listOfAvailableService = Stream.of(servicesTemp.split(",")).map(String::trim)
          .collect(Collectors.toList());
    }

    OrderCreate orderCreate = new OrderCreate();
    orderCreate.setVersion(ocVersion);
    orderCreate.setServicesAvailable(listOfAvailableService);
    orderCreate.setTrackingType(trackingType);
    orderCreate.setAllowCodService(isAllowCod);
    orderCreate.setAllowCpService(isAllowCashPickup);
    orderCreate.setIsPrePaid(isPrepaid);
    orderCreate.setAllowStagedOrders(isAllowStagedOrders);
    orderCreate.setIsMultiParcelShipper(isMultiParcelShipper);
    orderCreate.setIsCorporateReturn(isCorporateReturn);
    shipper.setOrderCreate(orderCreate);

    DistributionPoint distributionPoint = new DistributionPoint();
    distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(isDisableDriverAppReschedule);
    shipper.setDistributionPoints(distributionPoint);

    Map<String, String> labelPrintingSettings = extractSubmap(mapOfData, "labelPrinting");
    if (MapUtils.isNotEmpty(labelPrintingSettings)) {
      LabelPrinter labelPrinter = new LabelPrinter();
      String value = labelPrintingSettings.get("showShipperDetails");
      if (StringUtils.isNotBlank(value)) {
        labelPrinter.setShowShipperDetails(Boolean.parseBoolean(value));
      }
      value = labelPrintingSettings.get("showCod");
      if (StringUtils.isNotBlank(value)) {
        labelPrinter.setShowCod(Boolean.parseBoolean(value));
      }
      value = labelPrintingSettings.get("showParcelDescription");
      if (StringUtils.isNotBlank(value)) {
        labelPrinter.setShowParcelDescription(Boolean.parseBoolean(value));
      }
      value = labelPrintingSettings.get("printerIp");
      if (StringUtils.isNotBlank(value)) {
        labelPrinter.setPrinterIp(value);
      }
      shipper.setLabelPrinter(labelPrinter);
    }
  }

  private void setLiaisonDetails(String dateUniqueString, Shipper shipper) {
    Address liaisonAddress = generateRandomAddress();

    shipper.setLiaisonName("Liaison #" + dateUniqueString);
    shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString + "1"));
    shipper.setLiaisonEmail("ln." + dateUniqueString + "@automation.co");
    shipper.setLiaisonAddress(liaisonAddress.to1LineAddress() + " #" + dateUniqueString);
    shipper.setLiaisonPostcode(liaisonAddress.getPostcode());
  }

  private Shipper setShipperDetails(Shipper shipper, String dateUniqueString,
      Map<String, String> mapOfData) {
    shipper.setActive(Boolean.parseBoolean(mapOfData.get("isShipperActive")));
    shipper.setType(mapOfData.get("shipperType"));
    shipper.setName("Dummy Shipper #" + dateUniqueString);
    shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
    shipper.setContact(generatePhoneNumber(dateUniqueString));
    shipper.setEmail("ds." + dateUniqueString + "@automation.co");
    shipper.setShipperDashboardPassword("Ninjitsu89");
    return shipper;
  }

  @When("Operator create new Shipper with basic settings and without Pricing profile using data below:")
  public void operatorCreateNewShipperWithBasicSettingsAndWithoutPricingProfileUsingDataBelow(
      Map<String, String> mapOfData) {
    String dateUniqueString = generateDateUniqueString();

    Shipper shipper = new Shipper();
    setShipperDetails(shipper, dateUniqueString, mapOfData);
    setLiaisonDetails(dateUniqueString, shipper);
    setServices(shipper, mapOfData);
    setIndustryAndSales(shipper, mapOfData);
    setBilling(shipper, dateUniqueString);
    fillMarketplaceProperties(shipper, mapOfData);
    generatePickupAddresses(shipper, mapOfData);

    allShippersPage.createNewShipperWithoutPricingScript(shipper);
    put(KEY_CREATED_SHIPPER, shipper);
  }

  @When("Operator set service type {string} to {string} on edit shipper page")
  public void setServiceTypeOnShipperEditOrCreatePage(
      String serviceType, String value) {
    allShippersPage.allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
    allShippersPage.allShippersCreateEditPage.clickToggleButtonByLabel(serviceType, value);
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
  }

  @When("Operator verifies toast {string} displayed on edit shipper page")
  public void verifiesToast(String msg) {
    String actualMsg = allShippersPage.allShippersCreateEditPage.errorSaveDialog.message.getText();
    assertTrue(actualMsg.contains(msg));
  }

  @And("Operator verifies the pricing profile and shipper discount details are correct")
  public void OperatorVerifiesThePricingProfileAndShipperDiscountDetailsAreCorrect() {
    Pricing pricingProfile = get(KEY_PRICING_PROFILE);
    Pricing pricingProfileFromDb = get(KEY_PRICING_PROFILE_DETAILS);
    Pricing pricingProfileFromOPV2 = get(KEY_CREATED_PRICING_PROFILE_OPV2);
    allShippersPage
        .verifyPricingScriptAndShipperDiscountDetails(pricingProfile, pricingProfileFromDb,
            pricingProfileFromOPV2);
  }

  @Given("Operator changes the country to {string}")
  public void operatorChangesTheCountryTo(String country) {
    profilePage.clickProfileButton();
    profilePage.changeCountry(country);
    profilePage.closeProfile();
  }

  @And("Operator verifies that Edit Pending Profile is displayed")
  public void operatorVerifiesThatEditPendingProfileIsDisplayed() {
    allShippersPage.verifyEditPendingProfileIsDisplayed();
  }

  @Then("Operator adds pricing script with invalid discount/pricing_lever and verifies the error message")
  public void operatorAddsPricingScriptWithInvalidDiscountAndVerifiesTheErrorMessage(
      Map<String, String> mapOfData) {
    String errorMessage = mapOfData.get("errorMessage");
    Shipper shipper = setShipperPricingProfile(mapOfData);
    allShippersPage.addNewPricingScriptAndVerifyErrorMessage(shipper, errorMessage);
  }

  @When("Operator adds new pricing Profile")
  public void operatorAddsNewPricingProfile() {
    allShippersPage.allShippersCreateEditPage.addNewPricingProfile();
  }

  @When("Operator go to tab corporate sub shipper")
  public void operatorGoToTabCorporateSubShipper() {
    allShippersPage.allShippersCreateEditPage.goToTabCorporateSubShipper();
  }

  @When("Operator go to {string} tab on Edit Shipper page")
  public void goToTab(String tabName) {
    tabName = resolveValue(tabName);
    allShippersPage.allShippersCreateEditPage.tabs.selectTab(tabName);
    if (StringUtils.equalsIgnoreCase(tabName, "Corporate sub shippers")) {
      pause7s();
    }
  }

  @Then("hint {string} is displayed on Edit Shipper page")
  public void verifyHint(String expected) {
    assertTrue("Hint is displayed",
        allShippersPage.allShippersCreateEditPage.tabHint.isDisplayed());
    assertEquals("Hint text", resolveValue(expected),
        allShippersPage.allShippersCreateEditPage.tabHint.getText());
  }

  @When("Operator verifies corporate sub shipper is correct")
  public void operatorVerifiesCorporateSubShipper() {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page -> {
      List<Shipper> subShipper = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();

      for (Shipper shipper : actualSubShipper) {
        assertTrue(f("Check shipper with id %d on API", shipper.getId()), subShipper.stream()
            .anyMatch(s -> s.getExternalRef().equals(shipper.getExternalRef())));
      }
    });
  }

  @When("Operator search corporate sub shipper by name with {string}")
  public void operatorFillNameSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page ->
        page.subShipperTable.filterByColumn("name", resolveValue(searchValue))
    );
    pause1s();
  }

  @Then("Operator verifies corporate sub shippers with name contains {string} is displayed")
  public void qaVerifySubShippersWithNameContainsIsDisplayedOnBBManagementPage(String shipperName) {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page -> {
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();
      boolean isExist = actualSubShipper.stream().allMatch(s -> s.getName().contains(shipperName));
      assertTrue(f("Check shippers name contain %s", shipperName), isExist);
    });
  }

  @When("Operator search corporate sub shipper by email with {string}")
  public void operatorFillEmailSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page -> page.subShipperTable
        .filterByColumn("email", resolveValue(searchValue))
    );
    pause1s();
  }

  @Then("Operator verifies corporate sub shippers with email contains {string} is displayed")
  public void qaVerifySubShippersWithEmailContainsIsDisplayedOnBBManagementPage(
      String shipperEmail) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();
      boolean isExist = actualSubShipper.stream()
          .allMatch(s -> s.getEmail().contains(shipperEmail));
      assertTrue(f("Check shippers email contain %s", shipperEmail), isExist);
    });
  }

  @When("Operator create corporate sub shipper with data below:")
  public void createCorporateSubShipper(Map<String, String> mapOfData) {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page -> {
          pause2s();
          page.addSubShipper.click();
          fillNewSubShipperData(0, resolveKeyValues(mapOfData));
          page.createSubShipperAccount.click();
          pause1s();
        }
    );
  }

  private void fillNewSubShipperData(int index, Map<String, String> data) {
    String random = String.valueOf(System.currentTimeMillis()).substring(5, 11);
    String id = data.get("branchId");

    if ("generated".equalsIgnoreCase(id)) {
      id = random;
    }
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.branchId.get(index).setValue(id);
    putInList(KEY_LIST_SUB_SHIPPER_SELLER_ID, id);
    put(KEY_SUB_SHIPPER_SELLER_ID, id);

    String fixedName = data.get("name");
    if ("generated".equalsIgnoreCase(fixedName)) {
      fixedName = f("sub shipper %s", random);
    }
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.name.get(index).setValue(fixedName);
    putInList(KEY_LIST_SUB_SHIPPER_SELLER_NAME, fixedName);
    put(KEY_SHIPPER_NAME, fixedName);

    String fixedEmail = data.get("email");
    if ("generated".equalsIgnoreCase(fixedEmail)) {
      fixedEmail = f("sub.shipper+%s@ninja.tes", random);
    }
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.email.get(index).setValue(fixedEmail);
  }

  @When("Operator create corporate sub shippers with data below:")
  public void createCorporateSubShipper(List<Map<String, String>> data) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      pause2s();
      page.addSubShipper.click();
      for (int i = 0; i < data.size(); i++) {
        Map<String, String> entry = resolveKeyValues(data.get(i));
        fillNewSubShipperData(i, entry);
        if (i < data.size() - 1) {
          page.addAnotherAccount.click();
        }
      }
      page.createSubShipperAccount.click();
    });
  }

  @Then("Operator verifies corporate sub shipper is created")
  @When("Operator verifies corporate sub shippers are created")
  public void qaVerifySubShipperWithSellerIdIsDisplayedOnBBManagementPage() {
    List<String> expectedSellerIds = get(KEY_LIST_SUB_SHIPPER_SELLER_ID);

    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page ->
        expectedSellerIds.forEach(expectedSellerId ->
        {
          boolean isSubShipperExist;
          boolean isNextPageDisabled = false;
          List<Shipper> actualSubShipper;
          NvLogger.infof("Check seller id %s", expectedSellerId);

          page.goToFirstPage();

          do {
            actualSubShipper = page.subShipperTable.readAllEntities();
            isSubShipperExist = actualSubShipper.stream()
                .anyMatch(subShipper -> subShipper.getExternalRef().equals(expectedSellerId));
            if (!isSubShipperExist) {
              isNextPageDisabled = page.isNextPageButtonDisable();
              if (!isNextPageDisabled) {
                page.nextPage.click();
              }
            }
          }
          while (!isSubShipperExist && !isNextPageDisabled);

          assertTrue(isSubShipperExist);
        })
    );
  }

  @When("Operator click edit action button for newly created corporate sub shipper")
  public void operatorClickEditActionButtonForNewSubShipperOnBBManagementPage() {
    List<String> expectedSellerIds = get(KEY_LIST_SUB_SHIPPER_SELLER_ID);
    String branchId = expectedSellerIds.get(0);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<String> branchIds = page.subShipperTable.readColumn("id");
      for (int i = 0; i < branchIds.size(); i++) {
        if (branchId.equals(branchIds.get(i))) {
          page.subShipperTable.clickActionButton(i + 1, "Edit");
          break;
        }
      }
      throw new AssertionError("Subshipper with brack id [" + branchId + "] was not found");
    });
  }

  @When("Operator set shipper on this page as newly created shipper")
  public void setShipperAsNewlyCreatedShipper() {
    allShippersPage.allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
    String url = getCurrentUrl();
    Shipper shipper = new Shipper();
    shipper.setLegacyId(Long.valueOf(url.substring(url.lastIndexOf("/") + 1)));
    put(KEY_CREATED_SHIPPER, shipper);
  }

  @When("Operator click edit action button for first corporate sub shipper")
  public void operatorClickEditActionButtonForSubShipperOnBBManagementPage() {
    allShippersPage.allShippersCreateEditPage
        .b2bManagementPage.inFrame(page -> {
      String name = page.subShipperTable.getColumnText(1, NAME_COLUMN_LOCATOR_KEY);
      put(KEY_SHIPPER_NAME, name);
      page.subShipperTable.clickActionButton(1, "Edit");
    });
  }

  @Then("Operator verifies corporate sub shipper details page is displayed")
  public void qaVerifyShipperDetailsPageWithIdIsDisplayed() {
    String shipperName = get(KEY_SHIPPER_NAME);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage
        .shipperDetailsDisplayed(shipperName);
  }

  @Then("Operator verifies error message {string} is displayed on b2b management page")
  public void qaVerifyErrorMessageIsDisplayedOnBBManagementPage(String errorMsg) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      String actualErrorMsg = page.errorMessage.get(0).getText();
      assertEquals(f("Check error message : %s", errorMsg), errorMsg, actualErrorMsg);
    });
  }

  @Then("Operator verifies that Start Date is populated as today's date and is not editable")
  public void operatorVerifiesThatStartDateIsPopulatedAsTodaySDateAndIsNotEditable() {
    allShippersPage.allShippersCreateEditPage.verifyStartDateInNewPricingScript();
  }

  @And("Operator verifies the pricing lever details in the database")
  public void operatorVerifiesThePricingLeverDetails() {
    Pricing pricingProfile = get(KEY_PRICING_PROFILE);
    PricingLevers pricingLeversFromDb = get(KEY_PRICING_LEVER_DETAILS);

    if (Objects.nonNull(pricingProfile.getCodMin())) {
      assertEquals("COD min fee is not the same: ", pricingProfile.getCodMin(),
          NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getCodMinFee()));
    }
    if (Objects.nonNull(pricingProfile.getCodPercentage())) {
      assertEquals("COD percentage is not the same: ", pricingProfile.getCodPercentage(),
          NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getCodPercentage()));
    }
    if (Objects.nonNull(pricingProfile.getInsMin())) {
      assertEquals("INS min fee is not the same: ", pricingProfile.getInsMin(),
          NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsuranceMinFee()));
    }
    if (Objects.nonNull(pricingProfile.getInsPercentage())) {
      assertEquals("INS percentage fee is not the same: ", pricingProfile.getInsPercentage(),
          NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsurancePercentage()));
    }
    if (Objects.nonNull(pricingProfile.getInsThreshold())) {
      assertEquals("INS threshold is not the same: ", pricingProfile.getInsThreshold(),
          NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsuranceThreshold()));
    }
  }

  @And("Operator verifies the pricing profile details are like below:")
  public void operatorVerifiesThePricingProfileDetailsAreLikeBelow(Map<String, String> data) {
    Pricing pricingProfile = setShipperPricingProfile(data).getPricing();
    Pricing pricingProfileFromOPV2 = get(KEY_CREATED_PRICING_PROFILE_OPV2);
    allShippersPage
        .verifyPricingProfileDetails(pricingProfile,
            pricingProfileFromOPV2);
  }

  @And("Operator verifies shipper type is {string} on Edit Shipper page")
  public void verifyShipperType(String expected) {
    assertEquals("Shipper type", resolveValue(expected),
        allShippersPage.allShippersCreateEditPage.shipperTypeReadOnly.getValue());
  }
}
