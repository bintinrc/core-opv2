package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.model.address.MilkrunSettings;
import co.nvqa.common.model.others.LatLong;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.common.utils.factory.address.AddressFactory;
import co.nvqa.commons.model.order_create.v4.Marketplace;
import co.nvqa.commons.model.pricing.PricingLevers;
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
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.ErrorSaveDialog;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.utils.StandardTestConstants.NV_SYSTEM_ID;
import static co.nvqa.common.utils.StandardTestUtils.generateDateUniqueString;
import static co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.XPATH_PRICING_PROFILE_CONTACT_END_DATE;
import static co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.XPATH_PRICING_PROFILE_EFFECTIVE_DATE;
import static co.nvqa.operator_v2.selenium.page.AllShippersPage.ShippersTable.ACTION_DASH_LOGIN;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.B2bShipperTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.B2bShipperTable.ACTION_NINJA_DASH_LOGIN;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.B2bShipperTable.CULUMN_BRANCH_ID;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.NAME_COLUMN_LOCATOR_KEY;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllShippersSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersSteps.class);

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

  @When("Operator create new Shipper with basic settings using data below:")
  public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(
      Map<String, String> mapOfData) {
    Shipper shipper = prepareShipperData(mapOfData);

    allShippersPage.createNewShipper(shipper);

    put(KEY_LEGACY_SHIPPER_ID, String.valueOf(shipper.getLegacyId()));
    put(KEY_CREATED_SHIPPER, shipper);
    putInList(KEY_LIST_OF_CREATED_SHIPPERS, shipper);
  }

  @When("Operator verify pickup address on Edit Shipper page:")
  public void verifyPickupAddress(Map<String, String> data) {
    data = resolveKeyValues(data);
    List<Address> shipperPickupAddresses = fromJsonToList(data.get("shipperPickupAddresses"),
        Address.class);
    allShippersPage.allShippersCreateEditPage.clickTabItem("More Settings");
    if (CollectionUtils.isNotEmpty(shipperPickupAddresses)) {
      for (int i = 0; i < shipperPickupAddresses.size(); i++) {
        fillMilkrunReservationsProperties(shipperPickupAddresses.get(i), i + 1,
            resolveKeyValues(data));
        allShippersPage.allShippersCreateEditPage.verifyPickupAddress(
            shipperPickupAddresses.get(i));
      }
    }
  }

  @When("Operator fail create new Shipper with basic settings using data below:")
  public void operatorCreateNewShipperWithBasicSettingsFail(Map<String, String> mapOfData) {
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
        Address address = AddressFactory.getRandomAddress();
        address.setName("DA-" + generateDateUniqueString());
        LatLong latLong = StandardTestUtils.generateRandomLatLong();
        address.setLongitude(latLong.getLongitude());
        address.setLatitude(latLong.getLatitude());
        fillMilkrunReservationsProperties(address, i + 1, mapOfData);
        pickupAddresses.add(address);
      }

      shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
    } else if (mapOfData.containsKey("useCreatedAddress")) {
      List<Address> pickupAddresses = new ArrayList<>();
      int i = Integer.parseInt(mapOfData.get("useCreatedAddress"));
      List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
      Address address = addresses.get(i - 1);
      fillMilkrunReservationsProperties(address, i, mapOfData);
      pickupAddresses.add(address);
      shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
    }
  }

  private <T> Map<String, T> extractSubmap(Map<String, T> map, String prefix) {
    return map.entrySet().stream().filter(entry -> entry.getKey().startsWith(prefix)).collect(
        Collectors.toMap(entry -> StringUtils.removeStart(entry.getKey(), prefix + ".").trim(),
            Map.Entry::getValue));
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
      Address billingAddress = StandardTestUtils.generateRandomAddress();
      String dateUniqueString = generateDateUniqueString();

      value = mapOfData.get("marketplace.billingName");
      mb.setBillingName(StringUtils.isNotBlank(value) ? value : "Billing #" + dateUniqueString);

      value = mapOfData.get("marketplace.billingContact");
      mb.setBillingContact(
          StringUtils.isNotBlank(value) ? value
              : StandardTestUtils.generatePhoneNumber(dateUniqueString + "2"));

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
      String isMilkrun = milkrunData.get("isMilkrun");
      if (StringUtils.equalsIgnoreCase(isMilkrun, "false")) {
        address.setMilkRun(false);
        return;
      }
      int reservationsCount = milkrunData.containsKey("reservationCount") ? Integer.parseInt(
          milkrunData.get("reservationCount")) : 1;

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
      List<Integer> days = Arrays.stream(value.split(",")).map(d -> Integer.parseInt(d.trim()))
          .collect(Collectors.toList());
      ms.setDays(days);
    }

    value = mapOfData.get("noOfReservation");

    if (StringUtils.isNotBlank(value)) {
      ms.setNoOfReservation(Integer.valueOf(value));
    }
    address.setMilkRun(true);

    List<MilkrunSettings> milkrunSettings = Collections.singletonList(ms);
    address.setMilkrunSettings(milkrunSettings);
  }

  @Then("Operator verify the new Shipper is created successfully")
  public void operatorVerifyTheNewShipperIsCreatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyNewShipperIsCreatedSuccessfully(shipper);
  }

  @Then("Operator open Edit Shipper Page of shipper {string}")
  public void operatorOpenEditShipperPageOfShipper(String shipperName) {
    shipperName = resolveValue(shipperName);
    allShippersPage.searchShipper(shipperName);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.openEditShipperPage();
    allShippersPage.allShippersCreateEditPage.shipperInformation.waitUntilClickable();
    pause2s();
  }

  @Then("Operator opens Edit Shipper Page of shipper {value}")
  public void operatorOpenEditsShipperPageOfShipper(String legacyId) {
    allShippersPage.allShippersCreateEditPage.openPage(legacyId);
  }

  @Then("Operator login to Ninja Dash as shipper \"(.+)\" from All Shippers page")
  public void loginToDash(String shipperName) {
    shipperName = resolveValue(shipperName);
    allShippersPage.quickSearchShipper(shipperName);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    int i = 0;
    boolean enabled = allShippersPage.shippersTable.getActionButton("Ninja Dashboard Login (NEW)",
        1).isEnabled();
    while (i < 3 && !enabled) {
      allShippersPage.refreshPage();
      enabled = allShippersPage.shippersTable.getActionButton("Ninja Dashboard Login (NEW)", 1)
          .isEnabled();
      i++;
    }
    Assertions.assertThat(enabled).as("Ninja Dashboard Login (NEW) in row 1 is enabled").isTrue();
    allShippersPage.shippersTable.clickActionButton(1, ACTION_DASH_LOGIN);
    allShippersPage.waitUntilNewWindowOrTabOpened();
    allShippersPage.switchToOtherWindowAndWaitWhileLoading(
        TestConstants.DASH_PORTAL_BASE_URL + "/home");
  }

  @And("Operator open Edit Shipper Page of created shipper")
  public void operatorOpenEditShipperOfCreatedShipper() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    openSpecificShipperEditPage(String.valueOf(shipper.getLegacyId()));
  }

  @Then("Operator open Edit Pricing Profile dialog on Edit Shipper Page")
  public void operatorOpenEditPricingProfileDialogOnEditShipperPage() {
    allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
    allShippersPage.allShippersCreateEditPage.pricingAndBillingForm.editPendingProfile.click();
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilVisible();
  }

  @Then("Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:")
  public void operatorVerifyEditPricingProfileDialogOnEditShipperPage(Map<String, String> data) {
    data = resolveKeyValues(data);

    String value = data.get("shipperId");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperId.getText())
          .as("Shipper ID").isEqualTo(value);
    }
    value = data.get("shipperName");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperName.getText())
          .as("Shipper Name").isEqualTo(value);
    }
    value = data.get("startDate");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(XPATH_PRICING_PROFILE_EFFECTIVE_DATE)).getText())
          .as("Start Date").isEqualTo(value);
    }
    value = data.get("endDate");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              getWebDriver().findElement(By.xpath(XPATH_PRICING_PROFILE_CONTACT_END_DATE)).getText())
          .as("End Date").isEqualTo(value);
    }
    value = data.get("pricingScriptName");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript.getValue())
          .as("Pricing Script").contains(value);
    }
    value = data.get("type");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingSalespersonDicountType.getText())
          .as("Salesperson Discount Type").isEqualTo(value);
    }
    value = data.get("discount");
    if (StringUtils.equalsIgnoreCase("none", value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.getValue())
          .as("Discount Value").isNullOrEmpty();
    } else if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.getValue())
          .as("Discount Value").isEqualTo(value);
    }
    value = data.get("comments");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.getValue())
          .as("Comments").isEqualTo(value);
    }
    value = data.get("insuranceMinFee");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin.getValue())
          .as("Insurance Min Fee").isEqualTo(value);
    }
    value = data.get("insurancePercentage");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent.getValue())
          .as("Insurance Percentage").isEqualTo(value);
    }
    value = data.get("insuranceThreshold");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold.getValue())
          .as("Insurance Threshold").isEqualTo(value);
    }
    value = data.get("isDefaultIns");
    if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
      Assertions.assertThat(
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceCountryDefaultCheckbox.getAttribute(
              "aria-checked")).as("Default Insurance").isEqualToIgnoringCase("true");
    }
    value = data.get("isDefaultCod");
    if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
      Assertions.assertThat(
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codCountryDefaultCheckbox.getAttribute(
              "aria-checked")).as("Default Cod").isEqualToIgnoringCase("true");
    }
    value = data.get("isDefaultRts");
    if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
      Assertions.assertThat(
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsCountryDefaultCheckbox.getAttribute(
              "aria-checked")).as("Default Rts").isEqualToIgnoringCase("true");
    }
    value = data.get("rtsChargeType");
    if (StringUtils.isNotBlank(value)) {
      if (value.equalsIgnoreCase("Surcharge")) {
        String attributeValue = allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsSurcharge.getAttribute(
            "class");
        Assertions.assertThat(attributeValue).as("RTS Surcharge").contains("raised");
      }
      if (value.equalsIgnoreCase("Discount")) {
        String attributeValue = allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsDiscount.getAttribute(
            "class");
        Assertions.assertThat(attributeValue).as("RTS Discount").contains("raised");
      }
    }
    value = data.get("rtsChargeValue");
    if (StringUtils.isNotBlank(value)) {
      Assertions.assertThat(
              allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsValue.getValue())
          .as("Rts Value").isEqualTo(value);
    }
  }

  @Then("Operator add New Pricing Profile on Edit Shipper Page using data below:")
  public void operatorAddNewPricingProfileOnEditShipperPage(Map<String, String> data) {
    Shipper shipper = setShipperPricingProfile(data);
    allShippersPage.addNewPricingProfileWithoutSaving(shipper);
    put(KEY_PRICING_PROFILE, shipper.getPricing());
  }

  @Then("Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:")
  public void operatorFillNewPricingProfileOnEditShipperPage(Map<String, String> data) {
    try {
      data = resolveKeyValues(data);
      Pricing pricing =
          Objects.isNull(get(KEY_PRICING_PROFILE)) ? new Pricing() : get(KEY_PRICING_PROFILE);

      String value = data.get("startDate");
      if (StringUtils.isNotBlank(value)) {
        LOGGER.info("Set Start date : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingStartDate.simpleSetValue(
            value);
        LocalDate date = LocalDate.parse(value, DTF_NORMAL_DATE);
        ZonedDateTime zdtEffectiveDate = date.atStartOfDay(ZoneId.systemDefault());
        pricing.setEffectiveDate(Date.from(zdtEffectiveDate.toInstant()));
      }
      value = data.get("endDate");
      if (StringUtils.isNotBlank(value)) {
        LOGGER.info("Set End date : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingEndDate.simpleSetValue(
            value);
        LocalDate date = LocalDate.parse(value, DTF_NORMAL_DATE);
        ZonedDateTime zdtContractEndDate = date.atStartOfDay(ZoneId.systemDefault());
        pricing.setContractEndDate(Date.from(zdtContractEndDate.toInstant()));
      }
      value = data.get("pricingScriptName");
      if (StringUtils.isNotBlank(value)) {
        LOGGER.info("Set Pricing Script value : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript.searchAndSelectValue(
            value);
      }
      value = data.get("discount");
      if (StringUtils.equalsIgnoreCase("none", value)) {
        LOGGER.info("Set Discount value : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.clear();
        pricing.setDiscount(null);
      } else if (StringUtils.isNotBlank(value)) {
        LOGGER.info("Set Discount value : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.setValue(
            value);
        pricing.setDiscount(value);
      }
      value = data.get("comments");
      if (StringUtils.isNotBlank(value)) {
        LOGGER.info("Set comments : {}", value);
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.setValue(value);
        pricing.setComments(value);
      }
      value = data.get("isDefaultIns");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("true")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceCountryDefaultCheckbox.check();
        } else if (value.equalsIgnoreCase("false")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceCountryDefaultCheckbox.uncheck();

        }
      }
      value = data.get("insuranceMinFee");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin.sendKeys(
              Keys.TAB);
          pricing.setInsMin(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceMin.setValue(
              value);
          pricing.setInsMin(value);
        }
      }
      value = data.get("insurancePercentage");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent.sendKeys(
              Keys.TAB);
          pricing.setInsPercentage(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insurancePercent.setValue(
              value);
          pricing.setInsPercentage(value);
        }
      }
      value = data.get("insuranceThreshold");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold.sendKeys(
              Keys.TAB);
          pricing.setInsThreshold(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.insuranceThreshold.setValue(
              value);
          pricing.setInsThreshold(value);
        }
      }
      value = data.get("isDefaultCod");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("true")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codCountryDefaultCheckbox.check();
        } else if (value.equalsIgnoreCase("false")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codCountryDefaultCheckbox.uncheck();
        }
      }
      value = data.get("codMinFee");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin.sendKeys(
              Keys.TAB);
          pricing.setCodMin(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codMin.setValue(value);
          pricing.setCodMin(value);
        }
      }
      value = data.get("codPercentage");
      if (StringUtils.isNotBlank(value)) {
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent.clear();
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent.sendKeys(
              Keys.TAB);
          pricing.setCodPercentage(null);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.codPercent.setValue(
              value);
          pricing.setCodPercentage(value);
        }
      }
      value = data.get("isDefaultRts");
      if (StringUtils.isNotBlank(value) && value.equalsIgnoreCase("true")) {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsCountryDefaultCheckbox.check();
      }
      value = data.get("rtsChargeType");
      if (StringUtils.isNotBlank(value)) {
        // need to uncheck Country Default Checkbox before changing RTS charge
        if (!allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsDiscount.isDisplayed()) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsCountryDefaultCheckbox.uncheck();
        }
        if (value.equalsIgnoreCase("Surcharge")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsSurcharge.click();
        }
        if (value.equalsIgnoreCase("Discount")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsDiscount.click();
        }
      }
      value = data.get("rtsChargeValue");
      if (StringUtils.isNotBlank(value)) {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsValue.clear();
        if (value.equalsIgnoreCase("none")) {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsValue.sendKeys(
              Keys.TAB);
        } else {
          allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.rtsValue.sendKeys(
              value);
        }
      }
      value = data.get("billingWeightLogic");
      if (StringUtils.isNotBlank(value)) {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.billingWeight.selectValue(
            value);
      }
    } catch (DateTimeParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }

  @And("Operator verifies that Billing Weight Logic is not available in the Edit Pricing Profile dialog")
  public void operatorVerifiesThatBillingWeightLogicIsNotAvailable() {
    Assertions.assertThat(
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.billingWeight.isDisplayed())
        .as("Billing Weight Logic is not available in the Edit Pricing Profile Dialog").isFalse();
  }

  @Then("Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page")
  public void operatorSaveChangesPricingProfileOnEditShipperPage() {
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.saveChanges.clickAndWaitUntilDone();
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilInvisible();
  }

  @Then("Operator save changes on Edit Shipper Page")
  public void operatorSaveChangesOnEditShipperPage() {
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
    allShippersPage.allShippersCreateEditPage.waitUntilInvisibilityOfToast(
        "All changes saved successfully");
    allShippersPage.allShippersCreateEditPage.backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("Operator save changes on Edit Shipper Page and gets saved pricing profile values")
  public void operatorSaveChangesOnEditShipperPageAndGetsPPDiscountValue() {
    try {
      retryIfRuntimeExceptionOccurred(() -> {
        allShippersPage.allShippersCreateEditPage.saveChanges.click();
        closeErrorToastIfDisplayedAndSaveShipper();
        allShippersPage.allShippersCreateEditPage.waitUntilInvisibilityOfToast(
            "All changes saved successfully");
      }, "Save Shipper", 100, 3);

      takesScreenshot();
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

  private void closeErrorToastIfDisplayedAndSaveShipper() {
    if (allShippersPage.allShippersCreateEditPage.errorSaveDialog.isDisplayed()) {
      takesScreenshot();
      ErrorSaveDialog errorSaveDialog = allShippersPage.allShippersCreateEditPage.errorSaveDialog;
      String errorMessage = errorSaveDialog.message.getText();
      LOGGER.info(f("Error dialog is displayed : %s ", errorMessage));

      if ((errorMessage.contains("devsupport@ninjavan.co")) || errorMessage.contains(
          "DB constraints")) {
        errorSaveDialog.forceClose();
        takesScreenshot();
        if (Objects.nonNull(allShippersPage.allShippersCreateEditPage.getToast())) {
          LOGGER.info(f("Toast msg is displayed :  %s ",
              allShippersPage.allShippersCreateEditPage.getToast().getText()));
          allShippersPage.allShippersCreateEditPage.closeToast();
        }
        takesScreenshot();
        allShippersPage.allShippersCreateEditPage.saveChanges.click();
        takesScreenshot();
      }
    }
  }

  @And("Operator gets pricing profile values")
  public void operatorGetsPricingProfileValues() {
    try {
      allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
      Pricing createdPricingProfile = allShippersPage.getCreatedPricingProfile();
      put(KEY_CREATED_PRICING_PROFILE_OPV2, createdPricingProfile);
      put(KEY_PRICING_PROFILE, createdPricingProfile);
      put(KEY_PRICING_PROFILE_ID, createdPricingProfile.getTemplateId().toString());
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }

  @Then("Operator go back to Shipper List page")
  public void operatorGoBackToShipperListPage() {
    allShippersPage.allShippersCreateEditPage.backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:")
  public void operatorVerifyErrorMessagesNewPricingProfileOnEditShipperPage(
      Map<String, String> data) {
    pause1s();
    data = resolveKeyValues(data);
    String expectedErrorMsg = data.get("errorMessage");
    allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.verifyErrorMsgEditPricingScript(
        expectedErrorMsg);
  }

  @Then("Operator verify the new Shipper is updated successfully")
  public void operatorVerifyTheNewShipperIsUpdatedSuccessfully() {
    operatorVerifyTheNewShipperIsCreatedSuccessfully();
  }

  @When("Operator update Shipper's basic settings")
  public void operatorUpdateShipperBasicSettings() {
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Shipper oldShipper = SerializationUtils.clone(shipper);
    String dateUniqueString = generateDateUniqueString();

    // Shipper Details
    shipper.setActive(!shipper.getActive());
    shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
    shipper.setContact(StandardTestUtils.generatePhoneNumber(dateUniqueString));

    // Liaison Details
    Address liaisonAddress = StandardTestUtils.generateRandomAddress();

    shipper.setLiaisonName("Liaison #" + dateUniqueString);
    shipper.setLiaisonContact(StandardTestUtils.generatePhoneNumber(dateUniqueString + "1"));
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

  @When("Operator update basic settings of shipper {string}:")
  public void operatorUpdateShipperBasicSettings(String shipperName, Map<String, String> data) {
    if(!allShippersPage.allShippersCreateEditPage.basicSettingsForm.shipperType.isDisplayed())
      operatorOpenEditShipperPageOfShipper(shipperName);
    ShipperBasicSettings settings = new ShipperBasicSettings(resolveKeyValues(data));
    allShippersPage.allShippersCreateEditPage.fillBasicSettingsForm(settings);
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
    allShippersPage.allShippersCreateEditPage.waitUntilInvisibilityOfToast(
        "All changes saved successfully");
    allShippersPage.allShippersCreateEditPage.backToShipperList();
    pause3s();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @When("Operator fill shipper basic settings:")
  public void operatorFillShipperBasicSettings(Map<String, String> data) {
    ShipperBasicSettings settings = new ShipperBasicSettings(resolveKeyValues(data));
    allShippersPage.allShippersCreateEditPage.fillBasicSettingsForm(settings);
  }

  @Then("Operator verify Shipper's basic settings is updated successfully")
  public void operatorVerifyShipperBasicSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    Shipper oldShipper = get(KEY_UPDATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyShipperIsUpdatedSuccessfully(oldShipper, shipper);
  }

  @When("Operator update Shipper's Label Printer settings")
  public void operatorUpdateShipperLabelPrinterSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    LabelPrinter labelPrinter = new LabelPrinter();
    labelPrinter.setPrinterIp("127.0.0.1");
    labelPrinter.setShowShipperDetails(true);
    shipper.setLabelPrinter(labelPrinter);

    allShippersPage.updateShipperLabelPrinterSettings(shipper);
  }

  @Then("Operator verify Shipper's Label Printer settings is updated successfully")
  public void operatorVerifyShipperLabelPrinterSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    allShippersPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("Operator update Shipper's Returns settings")
  public void operatorUpdateShipperReturnsSettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();
    Address returnAddress = StandardTestUtils.generateRandomAddress();

    Return returnSettings = new Return();
    returnSettings.setName("Return #" + dateUniqueString);
    returnSettings.setContact(StandardTestUtils.generatePhoneNumber(dateUniqueString));
    returnSettings.setEmail("return." + dateUniqueString + "@ninjavan.co");
    returnSettings.setAddress1(returnAddress.getAddress1());
    returnSettings.setAddress2(returnAddress.getAddress2());
    returnSettings.setCity(returnAddress.getCity());
    returnSettings.setPostcode(returnAddress.getPostcode());
    returnSettings.setLastReturnNumber(System.currentTimeMillis());
    shipper.setReturns(returnSettings);

    allShippersPage.updateShipperReturnsSettings(shipper);
  }

  @When("Operator update Sub Shippers Default settings:")
  public void operatorUpdateSubShippersDefaultSettings(Map<String, String> data) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    setSubShipperDefaults(shipper, resolveKeyValues(data));
    allShippersPage.allShippersCreateEditPage.fillSubShippersDefaults(shipper);
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
    allShippersPage.allShippersCreateEditPage.waitUntilInvisibilityOfToast(
        "All changes saved successfully", true);
  }

  @When("Operator verifies Basic Settings on Edit Shipper page:")
  public void operatorVerifyBasicSettings(Map<String, String> data) {
    allShippersPage.allShippersCreateEditPage.tabs.selectTab("Basic Settings");
    ShipperBasicSettings expected = new ShipperBasicSettings(resolveKeyValues(data));
    ShipperBasicSettings actual = allShippersPage.allShippersCreateEditPage.getBasicSettings();
    expected.compareWithActual(actual);
  }

  @When("Operator verifies Pricing And Billing Settings on Edit Shipper page:")
  public void operatorVerifyPricingAndBillingSettings(Map<String, String> data) {
    allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
    PricingAndBillingSettings expected = new PricingAndBillingSettings(resolveKeyValues(data));
    PricingAndBillingSettings actual = allShippersPage.allShippersCreateEditPage.getPricingAndBillingSettings();
    expected.compareWithActual(actual);
  }

  @Then("Operator verify Shipper's Returns settings is updated successfully")
  public void operatorVerifyShipperReturnsSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperReturnsSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("Operator update Shipper's Distribution Point settings")
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

  @Then("Operator verify Shipper's Distribution Point settings is updated successfully")
  public void operatorVerifyShipperDistributionPointSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(shipper);
  }

  @When("Operator update Shipper's Qoo10 settings")
  public void operatorUpdateShipperQoo10Settings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    Qoo10 qoo10 = new Qoo10();
    qoo10.setUsername("qoo10" + dateUniqueString);
    qoo10.setPassword(dateUniqueString);
    shipper.setQoo10(qoo10);

    allShippersPage.updateShipperQoo10Settings(shipper);
  }

  @Then("Operator verify Shipper's Qoo10 settings is updated successfully")
  public void operatorVerifyShipperQoo10SettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperQoo10SettingsIsUpdatedSuccessfully(shipper);
  }

  @When("Operator update Shipper's Shopify settings")
  public void operatorUpdateShipperShopifySettings() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);

    String dateUniqueString = generateDateUniqueString();

    Shopify shopify = new Shopify();
    shopify.setMaxDeliveryDays(StandardTestUtils.randomLong(0, 3));
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

  @Then("Operator verify Shipper's Shopify settings is updated successfully")
  public void operatorVerifyShipperShopifySettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperShopifySettingsIsUpdatedSuccessfuly(shipper);
  }

  @When("Operator update Shipper's Magento settings")
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

  @Then("Operator verify Shipper's Magento settings is updated successfully")
  public void operatorVerifyShipperMagentoSettingsIsUpdatedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperMagentoSettingsIsUpdatedSuccessfuly(shipper);
  }

  @When("Operator enable Auto Reservation for Shipper and change Shipper default Address to the new Address using data below:")
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

    allShippersPage.enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper,
        createdAddress, reservation);
    put(KEY_CREATED_ADDRESS, createdAddress);
  }

  @Then("Operator verify the shipper is deleted successfully")
  public void operatorVerifyTheShipperIsDeletedSuccessfully() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.verifyShipperIsDeletedSuccessfully(shipper);
  }

  @When("Operator login to created Shipper's Dashboard from All Shipper page")
  public void operatorLoginAsCreatedShipperFromAllShipperPage() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    String mainWindowHandle = getWebDriver().getWindowHandle();
    put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
    allShippersPage.loginToShipperDashboard(shipper);
  }

  @When("Operator set pickup addresses of the created shipper using data below:")
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

  @When("Operator unset pickup addresses of the created shipper:")
  public void operatorUnsetPickupAddressesOfTheCreatedShipper(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    String shipperName = resolvedData.get("shipperName");
    Address shipperPickupAddress = fromJson(resolvedData.get("shipperPickupAddress"),
        Address.class);
    allShippersPage.unsetPickupAddressesAsMilkrun(shipperName, shipperPickupAddress);
  }

  @And("Operator unset milkrun reservation \"(\\d+)\" form pickup address \"(\\d+)\" for created shipper")
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

  @And("Operator unset all milkrun reservations form pickup address \"(\\d+)\" for created shipper")
  public void operatorUnsetAllMilkrunReservationsFormPickupAddressForCreatedShipper(
      int addressIndex) {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    allShippersPage.removeAllMilkrunReservarions(shipper, addressIndex);
    Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
    address.getMilkrunSettings().clear();
    address.setMilkRun(false);
  }

  @Then("Operator verifies All Shippers Page is displayed")
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

  @When("Operator edits the created corporate sub-shipper")
  public void editCreatedCorporateSubshipper() {
    String corporateSubShipperName = get(KEY_SHIPPER_NAME);
    allShippersPage.searchShipperByNameOnShipperListPage(corporateSubShipperName);
    allShippersPage.editShipperOnShipperListPage();
  }

  @When("Operator edits the created marketplace sub-shipper")
  public void operatorEditsCreatedMarketplaceSubshipper() {
    Marketplace marketplaceSubShipper = get(KEY_MARKETPLACE_SUB_SHIPPER);
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    pause1s();
    allShippersPage.editShipper(marketplaceSubShipper);
  }

  @And("Operator edits shipper {string}")
  public void operatorEditsShipper(String shipperLegacyId) {
    shipperLegacyId = resolveValue(shipperLegacyId);
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    if (shipper == null) {
      shipper = new Shipper();
    }
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
        TestConstants.OPERATOR_PORTAL_BASE_URL, TestConstants.NV_SYSTEM_ID, shipperLegacyId));
    pause10ms();
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    ((JavascriptExecutor) getWebDriver()).executeScript("window.open()");
    takesScreenshot();
    ArrayList<String> tabs = new ArrayList<>(getWebDriver().getWindowHandles());
    getWebDriver().switchTo().window(tabs.get(1));
    getWebDriver().navigate().to(editSpecificShipperPageURL);
    allShippersPage.allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded(180);
    takesScreenshot();
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
    Shipper shipper =
        Objects.nonNull(get(KEY_CREATED_SHIPPER)) ? get(KEY_CREATED_SHIPPER) : new Shipper();
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
      String rtsChargeType = mapOfData.get("rtsChargeType");
      String rtsChargeValue = mapOfData.get("rtsChargeValue");
      String billingWeightLogic = mapOfData.get("billingWeightLogic");

      pricing.setComments(comments);
      pricing.setScriptName(pricingScriptName);
      pricing.setDiscount(discount);
      pricing.setType(type);
      pricing.setCodMin(codMinFee);
      pricing.setCodPercentage(codPercentage);
      pricing.setInsThreshold(insuranceThreshold);
      pricing.setInsPercentage(insurancePercentage);
      pricing.setInsMin(insuranceMinFee);
      pricing.setRtsChargeType(rtsChargeType);
      pricing.setRtsChargeValue(rtsChargeValue);
      pricing.setEffectiveDate(
          Objects.nonNull(startDate) ? StandardTestUtils.convertToDate(startDate, DTF_NORMAL_DATE)
              : null);
      pricing.setContractEndDate(
          Objects.nonNull(endDate) ? StandardTestUtils.convertToDate(endDate, DTF_NORMAL_DATE)
              : null);
      String country = NV_SYSTEM_ID;
      if (!country.equalsIgnoreCase("SG")) {
        if (Objects.isNull(billingWeightLogic)) {
          pricing.setBillingWeight(BillingWeightEnum.STANDARD);
        } else {
          pricing.setBillingWeight(BillingWeightEnum.getBillingWeightEnum(billingWeightLogic));
        }
      } else {
        pricing.setBillingWeight(BillingWeightEnum.LEGACY);
      }

    } catch (DateTimeParseException e) {
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
    put(KEY_LEGACY_SHIPPER_ID, String.valueOf(shipper.getLegacyId()));
    put(KEY_CREATED_SHIPPER, shipper);
    putInList(KEY_LIST_OF_CREATED_SHIPPERS, shipper);
  }

  private void setBilling(Shipper shipper, String dateUniqueString) {
    Address billingAddress = StandardTestUtils.generateRandomAddress();

    shipper.setBillingName("Billing #" + dateUniqueString);
    shipper.setBillingContact(StandardTestUtils.generatePhoneNumber(dateUniqueString + "2"));
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
      pickupSettings.setPremiumPickupDailyLimit(
          Integer.valueOf(mapOfData.get("premiumPickupDailyLimit")));
    }
    if (mapOfData.containsKey("pickupServiceTypeLevels")) {
      List<ServiceTypeLevel> serviceTypeLevels = Arrays.stream(
          mapOfData.get("pickupServiceTypeLevels").split(",")).map(val -> {
        ServiceTypeLevel serviceTypeLevel = new ServiceTypeLevel();
        String[] values = val.split(":");
        serviceTypeLevel.setType(values[0].trim());
        serviceTypeLevel.setLevel(values[1].trim());
        return serviceTypeLevel;
      }).collect(Collectors.toList());
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
    Boolean isDisableDriverAppReschedule = Boolean.parseBoolean(
        mapOfData.get("isDisableDriverAppReschedule"));
    String ocVersion = mapOfData.get("ocVersion");
    String servicesTemp = mapOfData.get("services");
    String trackingType = mapOfData.get("trackingType");

    List<String> listOfAvailableService;
    if (servicesTemp == null || servicesTemp.isEmpty()) {
      listOfAvailableService = new ArrayList<>();
    } else {
      listOfAvailableService = splitAndNormalize(servicesTemp);
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
    orderCreate.setIsCorporate(Boolean.parseBoolean(mapOfData.get("isCorporate")));
    orderCreate.setIsCorporateManualAWB(
        Boolean.parseBoolean(mapOfData.get("isCorporateManualAWB")));
    orderCreate.setIsCorporateReturn(Boolean.parseBoolean(mapOfData.get("isCorporateReturn")));
    orderCreate.setIsCorporateDocument(Boolean.parseBoolean(mapOfData.get("isCorporateDocument")));
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

  private void setSubShipperDefaults(Shipper shipper, Map<String, String> mapOfData) {
    SubShipperDefaultSettings subShipperDefaults = new SubShipperDefaultSettings(mapOfData);
    shipper.setSubShippersDefaults(subShipperDefaults);
  }

  private void setLiaisonDetails(String dateUniqueString, Shipper shipper) {
    Address liaisonAddress = StandardTestUtils.generateRandomAddress();

    shipper.setLiaisonName("Liaison #" + dateUniqueString);
    shipper.setLiaisonContact(StandardTestUtils.generatePhoneNumber(dateUniqueString + "1"));
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
    shipper.setContact(StandardTestUtils.generatePhoneNumber(dateUniqueString));
    if (mapOfData.containsKey("email")) {
      shipper.setEmail(mapOfData.get("email"));
    } else {
      shipper.setEmail("ds." + dateUniqueString + "@automation.co");
    }
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
  public void setServiceTypeOnShipperEditOrCreatePage(String serviceType, String value) {
    allShippersPage.allShippersCreateEditPage.clickToggleButtonByLabel(serviceType, value);
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
    allShippersPage.waitUntilInvisibilityOfToast("All changes saved successfully");
  }

  @Then("Operator verify that the toggle: {string} is set as {string} under 'Pricing and Billing' tab")
  public void operatorVerifyThatTheToggleIsSetAsUnderTab(String toggle, String expectedValue) {
    if (toggle.equalsIgnoreCase("Show Pricing Estimate")) {
      String selectedValue = allShippersPage.allShippersCreateEditPage.pricingAndBillingForm.showPricingEstimate.getValue()
          .trim();
      Assertions.assertThat(selectedValue).as(f("Assert that Show Pricing Estimate has a toggle value: %s", expectedValue))
          .isEqualTo(expectedValue);
      return;
    }
    Assertions.fail("No matches for the given toggle name");
  }

  @When("Operator set service type {string} to {string} on Sub shippers Default Setting tab edit shipper page")
  public void setServiceTypeOnSubShippersDefaultSettingTab(String serviceType, String value) {
    String model = "ctrl.data.marketplace.serviceType[key]";
    allShippersPage.allShippersCreateEditPage.clickToggleButtonByLabelAndModel(serviceType, model,
        value);
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
  }

  @When("Operator click Save Changes on edit shipper page")
  public void clickSaveChanges() {
    allShippersPage.allShippersCreateEditPage.saveChanges.click();
  }

  @When("Operator verifies toast {string} displayed on edit shipper page")
  public void verifiesToast(String msg) {
    String actualMsg = allShippersPage.allShippersCreateEditPage.errorSaveDialog.message.getText();
    String resolveValue = resolveValue(msg);
    Assertions.assertThat(actualMsg).as("Error message").contains(resolveValue);
  }

  @And("Operator verifies the pricing profile and shipper discount details are correct")
  public void OperatorVerifiesThePricingProfileAndShipperDiscountDetailsAreCorrect() {
    Pricing pricingProfile = get(KEY_PRICING_PROFILE);
    Pricing pricingProfileFromDb = get(KEY_PRICING_PROFILE_DETAILS);
    Pricing pricingProfileFromOPV2 = get(KEY_CREATED_PRICING_PROFILE_OPV2);
    allShippersPage.verifyPricingScriptAndShipperDiscountDetails(pricingProfile,
        pricingProfileFromDb, pricingProfileFromOPV2);
  }

  @Given("Operator changes the country to {string}")
  public void operatorChangesTheCountryTo(String country) {
    getWebDriver().switchTo().defaultContent();
    profilePage.clickProfileButton();
    profilePage.changeCountry(country);
    profilePage.closeProfile();
  }

  @Then("Operator verifies that Add New Pricing Profile Button is displayed")
  public void operatorVerifiesThatAddNewPricingProfileButtonIsDisplayed() {
    allShippersPage.verifyAddNewPricingProfileButtonIsDisplayed();
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
    Assertions.assertThat(
            allShippersPage.allShippersCreateEditPage.basicSettingsForm.tabHint.isDisplayed())
        .as("Hint is displayed").isTrue();
    Assertions.assertThat(
            allShippersPage.allShippersCreateEditPage.basicSettingsForm.tabHint.getText())
        .as("Hint text").isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies corporate sub shipper is correct")
  public void operatorVerifiesCorporateSubShipper() {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<Shipper> subShipper = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();

      for (Shipper shipper : actualSubShipper) {
        Assertions.assertThat(
                subShipper.stream().anyMatch(s -> s.getExternalRef().equals(shipper.getExternalRef())))
            .as(f("Check shipper with id %d on API", shipper.getId())).isTrue();
      }
    });
  }

  @When("Operator search corporate sub shipper by name with {string}")
  public void operatorFillNameSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.subShipperTable.filterByColumn("name", resolveValue(searchValue)));
    pause1s();
  }

  @Then("Operator verifies corporate sub shippers with name contains {string} is displayed")
  public void qaVerifySubShippersWithNameContainsIsDisplayedOnBBManagementPage(String shipperName) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();
      boolean isExist = actualSubShipper.stream().allMatch(s -> s.getName().contains(shipperName));
      Assertions.assertThat(isExist).as(f("Check shippers name contain %s", shipperName)).isTrue();
    });
  }

  @When("Operator search corporate sub shipper by email with {string}")
  public void operatorFillEmailSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.subShipperTable.filterByColumn("email", resolveValue(searchValue)));
    pause1s();
  }

  @Then("Operator verifies corporate sub shippers with email contains {string} is displayed")
  public void qaVerifySubShippersWithEmailContainsIsDisplayedOnBBManagementPage(
      String shipperEmail) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<Shipper> actualSubShipper = page.subShipperTable.readAllEntities();
      boolean isExist = actualSubShipper.stream()
          .allMatch(s -> s.getEmail().contains(shipperEmail));
      Assertions.assertThat(isExist).as(f("Check shippers email contain %s", shipperEmail))
          .isTrue();
    });
  }

  @When("Operator create corporate sub shipper with data below:")
  public void createCorporateSubShipper(Map<String, String> mapOfData) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      pause2s();
      page.addSubShipper.click();
      fillNewSubShipperData(0, resolveKeyValues(mapOfData));
      page.createSubShipperAccount.click();
      pause1s();
    });
  }

  @When("Operator verifies success notification {string} is displayed on Corporate sub shippers tab")
  public void checkSuccessNotification(String expected) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.waitUntilInvisibilityOfNotification(resolveValue(expected), true));
  }

  private void fillNewSubShipperData(int index, Map<String, String> data) {
    data = resolveKeyValues(data);
    generateBranchData(data);

    String id = data.get("branchId");
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.branchId.get(index).setValue(id);
    putInList(KEY_LIST_SUB_SHIPPER_SELLER_ID, id);
    put(KEY_SUB_SHIPPER_SELLER_ID, id);

    String fixedName = data.get("name");
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.name.get(index).setValue(fixedName);
    putInList(KEY_LIST_SUB_SHIPPER_SELLER_NAME, fixedName);
    put(KEY_SHIPPER_NAME, fixedName);

    String fixedEmail = data.get("email");
    putInList(KEY_LIST_SUB_SHIPPER_SELLER_EMAIL, fixedEmail);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.email.get(index)
        .setValue(fixedEmail);
  }

  private void generateBranchData(Map<String, String> data) {
    String random = String.valueOf(System.currentTimeMillis()).substring(5, 11);
    String id = data.get("branchId");
    if ("generated".equalsIgnoreCase(id)) {
      data.put("branchId", random);
    }
    String fixedName = data.get("name");
    if ("generated".equalsIgnoreCase(fixedName)) {
      data.put("name", "Dummy Shipper branch " + random);
    }
    String fixedEmail = data.get("email");
    if ("generated".equalsIgnoreCase(fixedEmail)) {
      data.put("email", f("sub.shipper+%s@ninja.tes", random));
    }
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

  @When("Operator bulk create corporate sub shippers with data below:")
  public void bulkCreateCorporateSubShipper(List<Map<String, String>> data) throws IOException {
    uploadFileBulkCreateCorporateSubShipper(data);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.createSubShipperAccount.click());
  }

  @When("Operator upload bulk create corporate sub shippers file with data below:")
  public void uploadFileBulkCreateCorporateSubShipper(List<Map<String, String>> data)
      throws IOException {
    List<String> rows = data.stream().map(row -> {
      row = resolveKeyValues(row);
      pause100ms();
      generateBranchData(row);
      putInList(KEY_LIST_SUB_SHIPPER_SELLER_ID, row.get("branchId"));
      put(KEY_SUB_SHIPPER_SELLER_ID, row.get("branchId"));
      putInList(KEY_LIST_SUB_SHIPPER_SELLER_NAME, row.get("name"));
      put(KEY_SHIPPER_NAME, row.get("name"));
      putInList(KEY_LIST_SUB_SHIPPER_SELLER_EMAIL, row.get("email"));
      return row.get("branchId") + "," + row.get("name") + "," + row.get("email");
    }).collect(Collectors.toList());
    rows.add(0, "Branch ID (External Ref),Name,Email");
    File file = TestUtils.createFileOnTempFolder(
        String.format("create-order-update_%s.csv", generateDateUniqueString()));
    FileUtils.writeLines(file, rows);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      page.addSubShipper.click();
      page.switchToFileUpload.click();
      page.uploadCsvFile.setValue(file);
    });
  }

  @When("Operator upload incorrect bulk create corporate sub shippers file")
  public void bulkCreateCorporateSubShipper() throws IOException {
    List<String> rows = new ArrayList<>();
    rows.add("Branch ID (External Ref),Name,Email, Some other data");
    File file = TestUtils.createFileOnTempFolder(
        String.format("create-order-update_%s.csv", generateDateUniqueString()));
    FileUtils.writeLines(file, rows);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      page.addSubShipper.click();
      page.switchToFileUpload.click();
      page.uploadCsvFile.setValue(file);
    });
  }

  @Then("Operator verifies corporate sub shipper is created")
  @When("Operator verifies corporate sub shippers are created")
  public void qaVerifySubShipperWithSellerIdIsDisplayedOnBBManagementPage() {
    List<String> expectedSellerIds = get(KEY_LIST_SUB_SHIPPER_SELLER_ID);

    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> expectedSellerIds.forEach(expectedSellerId -> {
          boolean isSubShipperExist;
          boolean isNextPageDisabled = false;
          List<Shipper> actualSubShipper;
          LOGGER.info("Check seller id {}", expectedSellerId);

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
          } while (!isSubShipperExist && !isNextPageDisabled);

          Assertions.assertThat(isSubShipperExist)
              .as("Sub shipper exist with id: " + expectedSellerId).isTrue();
        }));
  }

  @When("Operator click edit action button for newly created corporate sub shipper")
  public void operatorClickEditActionButtonForNewSubShipperOnBBManagementPage() {
    List<String> expectedSellerIds = get(KEY_LIST_SUB_SHIPPER_SELLER_ID);
    String branchId = expectedSellerIds.get(0);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<String> branchIds = page.subShipperTable.readColumn(CULUMN_BRANCH_ID);
      for (int i = 0; i < branchIds.size(); i++) {
        if (branchId.equals(branchIds.get(i))) {
          page.subShipperTable.clickActionButton(i + 1, ACTION_EDIT);
          return;
        }
      }
      throw new AssertionError("Subshipper with branch id [" + branchId + "] was not found");
    });
  }

  @When("Operator click Ninja Dash Login button for {string} corporate sub shipper")
  public void operatorClickNinjaDashLogin(String value) {
    String branchId = resolveValue(value);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<String> branchIds = page.subShipperTable.readColumn(CULUMN_BRANCH_ID);
      for (int i = 0; i < branchIds.size(); i++) {
        if (branchId.equals(branchIds.get(i))) {
          page.subShipperTable.clickActionButton(i + 1, ACTION_NINJA_DASH_LOGIN);
          return;
        }
      }
      throw new AssertionError("Subshipper with branch id [" + branchId + "] was not found");
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
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      String name = page.subShipperTable.getColumnText(1, NAME_COLUMN_LOCATOR_KEY);
      put(KEY_SHIPPER_NAME, name);
      page.subShipperTable.clickActionButton(1, "Edit");
    });
  }

  @Then("Operator verifies corporate sub shipper details page is displayed")
  public void qaVerifyShipperDetailsPageWithIdIsDisplayed() {
    String shipperName = get(KEY_SHIPPER_NAME);
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.shipperDetailsDisplayed(
        shipperName);
  }

  @Then("Operator verifies error message {string} is displayed on b2b management page")
  public void qaVerifyErrorMessageIsDisplayedOnBBManagementPage(String errorMsg) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      String actualErrorMsg = page.errorMessage.get(0).getText();
      Assertions.assertThat(actualErrorMsg).as(f("Check error message : %s", errorMsg))
          .isEqualTo(errorMsg);
    });
  }

  @Then("Operator verifies file upload error messages are displayed on b2b management page:")
  public void qaVerifyFileUploadErrorMessageIsDisplayedOnBBManagementPage(
      List<String> errorMessages) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<String> actualErrorMsg = page.bulkCreationErrorMessage.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(actualErrorMsg).as("List of bulk create error messages")
          .containsAll(errorMessages);
    });
  }

  @Then("Operator verifies file upload warning messages are displayed on b2b management page:")
  public void qaVerifyFileUploadWarningMessageIsDisplayedOnBBManagementPage(
      List<String> errorMessages) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      List<String> actualErrorMsg = page.bulkCreationWarningMessage.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(actualErrorMsg).as("List of bulk create warning messages")
          .containsAll(errorMessages);
    });
  }

  @Then("Operator clicks Go Back button on b2b management page")
  public void clickGoBack() {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.goBack.click());
  }

  @Then("Before You Go modal is displayed with {string} message on b2b management page")
  public void checkBeforeYouGoModal(String message) {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      page.beforeYouGoModal.waitUntilVisible();
      Assertions.assertThat(page.beforeYouGoModal.message.getNormalizedText()).as("Modal message")
          .isEqualTo(resolveValue(message));
    });
  }

  @Then("Operator clicks Cancel button on Before You Go modal on b2b management page")
  public void cancelBeforeYouGoModal() {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      page.beforeYouGoModal.cancel.click();
      page.beforeYouGoModal.waitUntilInvisible();
    });
  }

  @Then("Operator downloads error log on b2b management page")
  public void downloadErrorLog() {
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(
        page -> page.downloadErrorLog.click());
  }

  @Then("bulk shipper creation error log file contains data:")
  public void checkErrorLogFile(List<Map<String, String>> data) {
    List<String> rows = data.stream().map(row -> {
      row = resolveKeyValues(row);
      return row.get("branchId") + "," + row.get("name") + "," + row.get("email");
    }).collect(Collectors.toList());
    rows.add(0, "Branch ID (External Ref),Name,Email");
    allShippersPage.allShippersCreateEditPage.b2bManagementPage.inFrame(page -> {
      File file = Paths.get(StandardTestConstants.TEMP_DIR, "template.csv").toFile();
      try {
        page.verifyFileDownloadedSuccessfully("template.csv", StringUtils.join(rows, "\n"));
      } finally {
        FileUtils.deleteQuietly(file);
      }
    });
  }

  @Then("Operator verifies that Start Date is populated as today's date and is not editable")
  public void operatorVerifiesThatStartDateIsPopulatedAsTodaySDateAndIsNotEditable() {
    allShippersPage.allShippersCreateEditPage.verifyStartDateInNewPricingScript();
  }

  @And("Operator verifies the pricing lever details in the database")
  public void operatorVerifiesThePricingLeverDetails() {
    Pricing pricingProfile =
        Objects.isNull(get(KEY_CREATED_PRICING_PROFILE_OPV2)) ? get(KEY_PRICING_PROFILE_DETAILS)
            : get(KEY_CREATED_PRICING_PROFILE_OPV2);

    PricingLevers pricingLeversFromDb = get(KEY_PRICING_LEVER_DETAILS);
    if (Objects.isNull(pricingProfile) || Objects.isNull(pricingLeversFromDb)) {
      throw new NvTestRuntimeException("Actual and expected pricing lever details are missing");
    }

    SoftAssertions softAssertions = new SoftAssertions();
    String codMin = pricingProfile.getCodMin();
    if (Objects.nonNull(codMin) && !codMin.equalsIgnoreCase("-")) {
      if (codMin.equalsIgnoreCase("[country default]")) {
        softAssertions.assertThat(pricingLeversFromDb.getCodMinFee()).as("COD min fee is null")
            .isNull();
      } else {
        softAssertions.assertThat(NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getCodMinFee()))
            .as("COD min fee is correct").isEqualTo(codMin);
      }
    }
    String codPercentage = pricingProfile.getCodPercentage();
    if (Objects.nonNull(codPercentage) && !codPercentage.equalsIgnoreCase("-")) {
      if (codPercentage.equalsIgnoreCase("[country default]")) {
        softAssertions.assertThat(pricingLeversFromDb.getCodPercentage())
            .as("COD min percentage is null").isNull();
      } else {
        softAssertions.assertThat(
                NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getCodPercentage()))
            .as("COD percentage fee is correct").isEqualTo(codPercentage);
      }
    }
    String insMin = pricingProfile.getInsMin();
    if (Objects.nonNull(insMin) && !insMin.equalsIgnoreCase("-")) {
      if (insMin.equalsIgnoreCase("[country default]")) {
        softAssertions.assertThat(pricingLeversFromDb.getInsuranceMinFee())
            .as("Insurance min is null").isNull();
      } else {
        softAssertions.assertThat(
                NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsuranceMinFee()))
            .as("Insurance min fee is correct").isEqualTo(insMin);
      }
    }
    String insPercentage = pricingProfile.getInsPercentage();
    if (Objects.nonNull(insPercentage) && !insPercentage.equalsIgnoreCase("-")) {
      if (insPercentage.equalsIgnoreCase("[country default]")) {
        softAssertions.assertThat(pricingLeversFromDb.getInsurancePercentage())
            .as("Insurance Percentage is null").isNull();
      } else {
        softAssertions.assertThat(
                NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsurancePercentage()))
            .as("Insurance Percentage is correct").isEqualTo(insPercentage);
      }
    }
    String insThreshold = pricingProfile.getInsPercentage();
    if (Objects.nonNull(insThreshold) && !insThreshold.equalsIgnoreCase("-")) {
      if (insThreshold.equalsIgnoreCase("[country default]")) {
        softAssertions.assertThat(pricingLeversFromDb.getInsuranceThreshold())
            .as("Threshold is null").isNull();
      } else {
        softAssertions.assertThat(
                NO_TRAILING_ZERO_DF.format(pricingLeversFromDb.getInsuranceThreshold()))
            .as("Insurance Threshold fee is correct").isEqualTo(insThreshold);
      }
    }
    String rtsChargeType = pricingProfile.getRtsChargeType();
    if (Objects.nonNull(rtsChargeType)) {
      Double rtsChargeDb = pricingLeversFromDb.getRtsCharge();
      if (rtsChargeType.equalsIgnoreCase("Discount")) {
        softAssertions.assertThat(rtsChargeDb).as("RTS charge is a negative value").isNegative();
      }
      if (rtsChargeType.equalsIgnoreCase("Surcharge")) {
        softAssertions.assertThat(rtsChargeDb).as("RTS charge is a positive value").isPositive();
      }
    }
    BillingWeightEnum billingWeight = pricingProfile.getBillingWeight();
    if (Objects.nonNull(billingWeight)) {
      if (billingWeight.getCode().equalsIgnoreCase("Legacy")) {
        softAssertions.assertThat(pricingLeversFromDb.getBillingWeightLogic())
            .as("Billing Weight Logic is null").isNull();
      } else {
        softAssertions.assertThat(pricingLeversFromDb.getBillingWeightLogic())
            .as("Billing Weight Logic is correct").isEqualTo(pricingProfile.getBillingWeight());
      }
    }
  }

  @And("Operator verifies the pricing profile details are like below:")
  public void operatorVerifiesThePricingProfileDetailsAreLikeBelow(Map<String, String> data) {
    Pricing pricingProfile = setShipperPricingProfile(data).getPricing();
    Pricing pricingProfileFromOPV2 = get(KEY_CREATED_PRICING_PROFILE_OPV2);
    allShippersPage.verifyPricingProfileDetails(pricingProfile, pricingProfileFromOPV2);
  }

  @Then("Operator verifies shipper discount details is null")
  public void operatorVerifiesShipperDiscountDetails() {
    Pricing pricing = get(KEY_PRICING_PROFILE_DETAILS);
    Assertions.assertThat(pricing.getShipperDiscountId()).as("Shipper Discount Id is null")
        .isNull();
  }


  @And("Operator verifies shipper type is {string} on Edit Shipper page")
  public void verifyShipperType(String expected) {
    Assertions.assertThat(
            allShippersPage.allShippersCreateEditPage.basicSettingsForm.shipperTypeReadOnly.getValue())
        .as("Shipper type").isEqualTo(resolveValue(expected));
  }

  @And("Operator verifies the pricing profile is referred to parent shipper {string}")
  public void operatorVerifiesThePricingProfileIsReferredToParentShipper(
      String parentShipperLegacyId) {
    takesScreenshot();
    allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
    Assertions.assertThat(allShippersPage.getReferParentsProfileText()).isEqualTo(
        "This is a Marketplace Seller / Corporate Branch that refers to its parent's profile(s). To see cascaded profiles,");

    String parentShipperPageURL = (f("%s/%s/shippers/%s", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.NV_SYSTEM_ID, parentShipperLegacyId));
    Assertions.assertThat(allShippersPage.getReferParentsProfileLink())
        .as("Parent Shipper link mismatch").isEqualTo(parentShipperPageURL);
  }

  @Then("Operator search for marketplace sub shipper by shipper name and get sub shipper id")
  public void operatorSearchForMarketplaceSubShipperByShipperNameAndGetSubShipperId() {
    try {
      Marketplace marketplaceSubShipper = get(KEY_MARKETPLACE_SUB_SHIPPER);
      String legacyId = allShippersPage.allShippersCreateEditPage.searchMarketplaceSubshipperAndGetLegacyId(
          "name", marketplaceSubShipper.getSellerCompanyName());
      Long.parseLong(legacyId);
      put(KEY_SUBSHIPPER_LEGACY_ID, legacyId);
    } catch (NumberFormatException e) {
      throw new NvTestRuntimeException("Legacy Id could not be parsed", e);
    }
  }

  @Then("Operator verifies country default text is displayed like below")
  public void operatorVerifiesCountryDefaultTextIsDisplayedLikeBelow(
      Map<String, String> dataTableAsMap) {
    String actualText;
    if (dataTableAsMap.containsKey("rtsCharge")) {
      actualText = allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.rtsCountryDefaultText.getText();
      Assertions.assertThat(actualText).as("Rts Charge country default text ")
          .isEqualTo(dataTableAsMap.get("rtsCharge"));
    }
  }

  @And("Operator Edit Shipper Page of created b2b sub shipper")
  public void operatorGetDataOfCreatedBBSubShipper() {
    String externalRefCreatedShipper = get(KEY_SUB_SHIPPER_SELLER_ID);
    List<Shipper> exsistingCorporateSubShipper = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
    Optional<Shipper> createdSubShipper = exsistingCorporateSubShipper.stream()
        .filter(subShipper -> subShipper.getExternalRef().equals(externalRefCreatedShipper))
        .findFirst();
    Assertions.assertThat(createdSubShipper.isPresent()).as("Created sub shipper is exist")
        .isTrue();
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    openSpecificShipperEditPage(String.valueOf(createdSubShipper.get().getLegacyId()));
  }

  @When("Operator delete all shipper pickup services on Edit Shipper page")
  public void operatorDeleteAllShipperPickupServices() {
    allShippersPage.allShippersCreateEditPage.deleteAllPickupServices();
  }

  @Then("Operator verifies all shipper pickup services are deleted on Edit Shipper page")
  public void allShipperPickupServicesdeleted() {
    allShippersPage.allShippersCreateEditPage.verifyPickupServicesIsEmpty();
  }

  @Given("Operator verifies that the following error appears on creating new shipper:")
  public void operatorVerifiesThatTheFollowingErrorAppearsOnCreatingNewShipper(List<String> data) {
    data = resolveValues(data);
    allShippersPage.allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
    pause2s();
    ErrorSaveDialog errorDialog = allShippersPage.allShippersCreateEditPage.errorSaveDialog;
    List<String> actual = errorDialog.errors.stream().map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual).as("Assert that all errors appear as expected")
        .containsAll(data);
  }

  @Given("Operator verifies that following shipper personal details are correct in db:")
  public void operatorVerifiesThatFollowingShipperPersonalDetailsAreCorrect(Map<String, String> personalInfo) {
    Shipper shipperPersonalDetails = get(KEY_SHIPPER_SHIPPER_DB_DATA);
    personalInfo.forEach((fieldName, fieldValue) -> {
      if(fieldName.equalsIgnoreCase("email")){
        Assertions.assertThat(fieldValue).isEqualToIgnoringCase(shipperPersonalDetails.getEmail());
      }
      if(fieldName.equalsIgnoreCase("contact")){
        Assertions.assertThat(fieldValue).isEqualToIgnoringCase(shipperPersonalDetails.getContact());
      }
    });
  }

  @Then("Operator creates dash account with 'Create Dash Account'")
  public void operatorCreatesDashAccountWith() {
    pause3s();
    allShippersPage.allShippersCreateEditPage.basicSettingsForm.createDashAccount.click();
  }

}
