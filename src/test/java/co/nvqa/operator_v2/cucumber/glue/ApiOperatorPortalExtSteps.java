package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.driver.client.DriverManagementClient;
import co.nvqa.common.driver.cucumber.DriverKeyStorage;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.CodInbound;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.GetDriverResponse;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.filter_preset.ShipperPickupFilterTemplate;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.driver.DriverFilter;
import co.nvqa.operator_v2.model.ContactType;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.ThirdPartyShipper;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import javax.inject.Inject;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager> {

  private static final Logger LOGGER = LoggerFactory.getLogger(ApiOperatorPortalExtSteps.class);

  @Inject
  @Getter
  private DriverManagementClient driverManagementClient;

  public ApiOperatorPortalExtSteps() {
  }

  @Override
  public void init() {
  }



  //  TODO move to common-lighthouse
  @After("@DeleteShipperPickupFilterTemplate or @DeleteFilterTemplate")
  public void deleteShipperPickupFilterTemplate() {
    try {
      ShipperPickupFilterTemplate shipperPickupFilterTemplate = get(
          KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE);
      if (shipperPickupFilterTemplate != null && shipperPickupFilterTemplate.getId() != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteShipperPickupsFilerTemplate(shipperPickupFilterTemplate.getId());
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
    try {
      Long presetId = get(KEY_ALL_ORDERS_FILTERS_PRESET_ID);
      if (presetId != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteOrdersFilterTemplate(presetId);
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
    try {
      Long presetId = get(KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID);
      if (presetId != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteShipperPickupsFilerTemplate(presetId);
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
    try {
      Long presetId = get(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID);
      if (presetId != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteRouteGroupsFilerTemplate(presetId);
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
    try {
      Long presetId = get(KEY_SHIPMENTS_FILTERS_PRESET_ID);
      if (presetId != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteShipmentsFilerTemplate(presetId);
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
    try {
      Long presetId = get(CoreScenarioStorageKeys.KEY_CORE_FILTERS_PRESET_ID);
      if (presetId != null) {
        getShipperPickupFilterTemplatesClient()
            .deleteRoutesFilterTemplate(presetId);
      }
    } catch (Throwable ex) {
      LOGGER.warn("Could not delete Filter Preset", ex);
    }
  }

  //  TODO move to common-driver
  @After("@DeleteContactTypes")
  public void deleteContactTypes() {
    ContactType contactType = get(KEY_CONTACT_TYPE);
    if (contactType != null) {
      if (contactType.getId() != null) {
        try {
          getContactTypeClient().delete(contactType.getId());
        } catch (Throwable ex) {
          LOGGER.warn(f("Could not delete Driver Contact Type [%s]", ex.getMessage()));
        }
      } else {
        LOGGER.warn(f("Could not delete Driver Contact Type [%s] - id was not defined",
            contactType.getName()));
      }
    }
  }

  //  TODO move to common-dp
  @Given("API DP gets DP Partner Details for Partner ID {string}")
  public void apiDpGetsDpPartnerDetailsForPartnerId(String partnerIdAsString) {
    long partnerId = Long.parseLong(partnerIdAsString);
    co.nvqa.commons.model.dp.DpPartner allDpPartners = getDpClient().getPartner();

    for (Partner p : allDpPartners.getPartners()) {
      if (p.getId() == partnerId) {
        put(KEY_DP_PARTNER, p);
        break;
      }
    }
  }

  //  TODO move to common-driver
  @When("API Operator create {int} new Driver using data below:")
  public void apiOperatorCreateMultiNewDriverUsingDataBelow(Integer numberOdDrivers,
      Map<String, String> mapOfData) {
    for (int i = 0; i < numberOdDrivers; i++) {
      apiOperatorCreateNewDriverUsingDataBelow(mapOfData);
    }
  }

  //  TODO move to common-driver
  @When("API Operator create new Driver using data below:")
  public void apiOperatorCreateNewDriverUsingDataBelow(Map<String, String> mapOfData) {
    String country = StandardTestConstants.NV_SYSTEM_ID.toUpperCase();
    Map<String, String> mapOfDynamicVariable = new HashMap<>() {{
      put("RANDOM_FIRST_NAME", "Driver");
      put("RANDOM_LAST_NAME", "Automation");
      put("TIMESTAMP", TestUtils.generateDateUniqueString());
      put("RANDOM_LATITUDE", String.valueOf(StandardTestUtils.generateLatitude()));
      put("RANDOM_LONGITUDE", String.valueOf(StandardTestUtils.generateLongitude()));
      put("CURRENT_DATE", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
    }};
    setPhoneNumber(mapOfDynamicVariable, country);

    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String driverCreateRequestJson = replaceTokens(resolvedMapOfData.get("driverCreateRequest"),
        mapOfDynamicVariable);
    CreateDriverV2Request createDriverV2Request = fromJsonSnakeCase(driverCreateRequestJson,
        CreateDriverV2Request.class);

    doWithRetry(() -> getDriverClient().createDriver(createDriverV2Request), " Create Driver");

    DriverInfo driverInfo = new DriverInfo();
    driverInfo.fromDriver(createDriverV2Request.getDriver());
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    put(KEY_CREATED_DRIVER, createDriverV2Request.getDriver());
    putInList(KEY_LIST_OF_CREATED_DRIVERS, createDriverV2Request.getDriver());
    put(KEY_CREATED_DRIVER_USERNAME, driverInfo.getUsername());
    put(KEY_CREATED_DRIVER_ID, driverInfo.getId());
    put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
  }


  //  TODO move to common-driver
  @And("API Operator refresh drivers data")
  public void refreshDriversData() {
    getDriverClient().getAllDriver();
  }


  //  TODO move to common-driver
  @And("API Operator verifies coordinates of created driver were updated")
  public void verifyChangedCoordinates() {
    Driver oldDriver = get(KEY_CREATED_DRIVER);
    DriverFilter driverFilter = new DriverFilter();
    driverFilter.setAll(true);
    driverFilter.setRefresh(true);
    GetDriverResponse drivers = getDriverClient().getAllDriver(driverFilter);
    Driver newDriver = drivers.getData().getDrivers().stream()
        .filter(drv -> Objects.equals(drv.getId(), oldDriver.getId()))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException(
            "Could not find driver with id=" + oldDriver.getId()));

    assertFalse("Driver latitude was not changed", Objects.equals(
        oldDriver.getZonePreferences().get(0).getLatitude(),
        newDriver.getZonePreferences().get(0).getLatitude()));
    assertFalse("Driver longitude was not changed", Objects.equals(
        oldDriver.getZonePreferences().get(0).getLongitude(),
        newDriver.getZonePreferences().get(0).getLongitude()));
  }


  //  TODO move to common-core
  @And("API Operator get created Reservation Group params")
  public void apiOperatorGetCreatedReservationGroupParams() {
    ReservationGroup reservationGroup = get(
        ReservationPresetManagementSteps.KEY_CREATED_RESERVATION_GROUP);
    List<MilkrunGroup> milkrunGroups = getRouteClient().getMilkrunGroups(new Date());
    MilkrunGroup group = milkrunGroups.stream()
        .filter(
            milkrunGroup -> StringUtils.equals(milkrunGroup.getName(), reservationGroup.getName()))
        .findFirst()
        .orElseThrow(() -> new RuntimeException(
            "Could not find milkrun group with name [" + reservationGroup.getName() + "]"));
    reservationGroup.setId(group.getId());
    put(KEY_CREATED_RESERVATION_GROUP_ID, reservationGroup.getId());
  }

  // TODO move to common-lighthouse
  @Given("API Operator creates new Shipper Pickup Filter Template using data below:")
  public void apiOperatorCreatesShipperPickupFilterTemplate(Map<String, String> data) {
    data = resolveKeyValues(data);
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
    shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
        .createShipperPickupFilerTemplate(shipperPickupFilterTemplate);
    put(KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE, shipperPickupFilterTemplate);
    put(KEY_SHIPPER_PICKUPS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
    put(KEY_SHIPPER_PICKUPS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
  }

  // TODO move to common-lighthouse
  @Given("API Operator creates new Orders Filter Template using data below:")
  public void apiOperatorCreatesOrdersFilterTemplate(Map<String, String> data) {
    data = resolveKeyValues(data);
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
    shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
        .createOrdersFilerTemplate(shipperPickupFilterTemplate);
    put(KEY_ALL_ORDERS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
    put(KEY_ALL_ORDERS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
  }

  // TODO move to common-lighthouse
  @Given("API Operator creates new Route Groups Filter Template using data below:")
  public void apiOperatorCreatesRouteGroupsFilterTemplate(Map<String, String> data) {
    data = resolveKeyValues(data);
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
    shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
        .createRouteGroupsFilerTemplate(shipperPickupFilterTemplate);
    put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
    put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
  }

  // TODO move to common-lighthouse
  @Given("API Operator creates new Shipments Filter Template using data below:")
  public void apiOperatorCreatesShipmentsFilterTemplate(Map<String, String> data) {
    data = resolveKeyValues(data);
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
    shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
        .createShipmentsFilerTemplate(shipperPickupFilterTemplate);
    put(KEY_SHIPMENTS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
    put(KEY_SHIPMENTS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
  }

  // TODO to deprecate, already in common-core
  @When("API Operator create new COD for created order")
  public void operatorCreateNewCod() {
    Order order = get(KEY_CREATED_ORDER);
    Long routeId = get(KEY_CREATED_ROUTE_ID);

    Cod cod = order.getCod();
    Assertions.assertThat(cod).as("COD should not be null.").isNotNull();
    Double codGoodsAmount = cod.getGoodsAmount();
    Assertions.assertThat(codGoodsAmount).as("COD Goods Amount should not be null.").isNotNull();

    Double amountCollected = codGoodsAmount - (codGoodsAmount.intValue() / 2);
    String receiptNumber = "#" + routeId + "-" + generateDateUniqueString();

    RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();
    routeCashInboundCod.setRouteId(routeId);
    routeCashInboundCod.setTotalCollected(amountCollected);
    routeCashInboundCod.setAmountCollected(amountCollected);
    routeCashInboundCod.setReceiptNumber(receiptNumber);

    CodInbound codInbound = new CodInbound();
    codInbound.setRouteId(routeId);
    codInbound.setAmountCollected(amountCollected);
    codInbound.setReceiptNo(receiptNumber);

    getCodInboundsClient().codInbound(codInbound);

    put(KEY_ROUTE_CASH_INBOUND_COD, routeCashInboundCod);
    put(KEY_COD_GOODS_AMOUNT, codGoodsAmount);
    put(KEY_CASH_ON_DELIVERY_AMOUNT, codGoodsAmount);
  }


  //TODO move to common-driver
  @Given("API Driver - Operator create new Driver using data below:")
  public void operatorCreateNewDriver(Map<String, String> mapOfData) {
    String country = StandardTestConstants.NV_SYSTEM_ID.toUpperCase();
    Map<String, String> mapOfDynamicVariable = new HashMap<>() {{
      put("RANDOM_FIRST_NAME", "Driver");
      put("RANDOM_LAST_NAME", "Automation");
      put("TIMESTAMP", TestUtils.generateDateUniqueString());
      put("RANDOM_LATITUDE", String.valueOf(StandardTestUtils.generateLatitude()));
      put("RANDOM_LONGITUDE", String.valueOf(StandardTestUtils.generateLongitude()));
      put("CURRENT_DATE", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
    }};
    setPhoneNumber(mapOfDynamicVariable, country);

    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String driverCreateRequestJson = replaceTokens(resolvedMapOfData.get("driverCreateRequest"),
        mapOfDynamicVariable);
    co.nvqa.common.driver.model.Driver createDriverRequest = fromJsonSnakeCase(
        driverCreateRequestJson,
        co.nvqa.common.driver.model.Driver.class);

    doWithRetry(() -> {
          co.nvqa.common.driver.model.Driver result = getDriverManagementClient().
              createDriver(createDriverRequest, "1.0").getData();
          putInList(DriverKeyStorage.KEY_DRIVER_LIST_OF_DRIVERS, result);
        },
        " Create Driver");
  }

  private void setPhoneNumber(Map<String, String> mapOfDynamicVariable, String country) {
    switch (country) {
      case "SG":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6531594329");
        break;
      case "ID":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6282188881593");
        break;
      case "MY":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6066567878");
        break;
      case "PH":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+639285554697");
        break;
      case "TH":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+66955573510");
        break;
      case "VN":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+0812345678");
        break;
      default:
        break;
    }
  }
}
