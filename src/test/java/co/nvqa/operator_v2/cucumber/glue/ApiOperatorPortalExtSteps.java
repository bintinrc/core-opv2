package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.BatchOrderInfo;
import co.nvqa.commons.model.core.BulkOrderInfo;
import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.CodInbound;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.GetDriverResponse;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.SalesPerson;
import co.nvqa.commons.model.core.filter_preset.ShipperPickupFilterTemplate;
import co.nvqa.commons.model.core.ThirdPartyShippers;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.core.setaside.SetAsideRequest;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.driver.DriverFilter;
import co.nvqa.commons.model.sort.nodes.Node;
import co.nvqa.commons.model.sort.nodes.Node.NodeType;
import co.nvqa.commons.util.JsonUtils;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.model.ContactType;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.ThirdPartyShipper;
import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.After;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager> {

  private static final String HUB_CD_CD = "CD->CD";
  private static final String HUB_CD_ITS_ST = "CD->its ST";
  private static final String HUB_CD_ST_DIFF_CD = "CD->ST under another CD";
  private static final String HUB_ST_ST_SAME_CD = "ST->ST under same CD";
  private static final String HUB_ST_ST_DIFF_CD = "ST->ST under diff CD";
  private static final String HUB_ST_ITS_CD = "ST->its CD";
  private static final String HUB_ST_CD_DIFF_CD = "ST->another CD";

  public ApiOperatorPortalExtSteps() {
  }

  @Override
  public void init() {
  }

  @Given("^API Operator create new DP Partner with the following attributes:$")
  public void apiOperatorCreateNewDpPartnerWithTheFollowingAttributes(Map<String, String> data) {
    DpPartner dpPartner = new DpPartner(data);
    Map<String, Object> responseBody = getDpClient().createPartner(toJsonSnakeCase(dpPartner));
    dpPartner.setId(Long.parseLong(responseBody.get("id").toString()));
    dpPartner.setDpmsPartnerId(Long.parseLong(responseBody.get("dpms_partner_id").toString()));
    put(KEY_DP_PARTNER, dpPartner);
  }

  @When("^API Operator add new DP for the created DP Partner with the following attributes:$")
  public void operatorAddNewDpForTheDpPartnerWithTheFollowingAttributes(Map<String, String> data) {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    Map<String, String> mapOfDynamicVariable = new HashMap<>();
    mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
    mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
    String json = replaceTokens(data.get("requestBody"), mapOfDynamicVariable);
    Dp dp = new Dp();
    dp.fromJson(JsonUtils.getDefaultSnakeCaseMapper(), json);
    Map<String, Object> responseBody = getDpClient().createDp(dpPartner.getId(), json);
    dp.setId(Long.parseLong(responseBody.get("id").toString()));
    dp.setDpmsId(Long.parseLong(responseBody.get("dpms_id").toString()));
    put(KEY_DISTRIBUTION_POINT, dp);
  }

  @When("^API Operator add new DP User for the created DP with the following attributes:$")
  public void operatorAddDpUserForTheCreatedDpWithTheFollowingAttributes(Map<String, String> data) {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    Dp dp = get(KEY_DISTRIBUTION_POINT);
    Map<String, String> mapOfDynamicVariable = new HashMap<>();
    mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
    mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
    String json = replaceTokens(data.get("requestBody"), mapOfDynamicVariable);
    DpUser dpUser = new DpUser();
    dpUser.fromJson(JsonUtils.getDefaultCamelCaseMapper(), json);
    Map<String, Object> responseBody = getDpmsClient()
        .createUser(dpPartner.getDpmsPartnerId(), dp.getDpmsId(), json);
    dpUser.setId(Long.parseLong(responseBody.get("id").toString()));
    put(KEY_DP_USER, dpUser);
  }

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

  @When("^API Operator create new Driver using data below:$")
  public void apiOperatorCreateNewDriverUsingDataBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String dateUniqueString = TestUtils.generateDateUniqueString();

    Map<String, String> mapOfDynamicVariable = new HashMap<>();
    mapOfDynamicVariable.put("RANDOM_FIRST_NAME", "Driver-" + dateUniqueString);
    mapOfDynamicVariable.put("RANDOM_LAST_NAME", "Rider-" + dateUniqueString);
    mapOfDynamicVariable.put("TIMESTAMP", dateUniqueString);
    mapOfDynamicVariable
        .put("RANDOM_LATITUDE", String.valueOf(HubFactory.getRandomHub().getLatitude()));
    mapOfDynamicVariable
        .put("RANDOM_LONGITUDE", String.valueOf(HubFactory.getRandomHub().getLongitude()));

    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String driverCreateRequestTemplate = resolvedMapOfData.get("driverCreateRequest");
    String driverCreateRequestJson = replaceTokens(driverCreateRequestTemplate,
        mapOfDynamicVariable);

    CreateDriverV2Request driverCreateRequest = fromJsonCamelCase(driverCreateRequestJson,
        CreateDriverV2Request.class);
    driverCreateRequest = getDriverClient().createDriver(driverCreateRequest);
    put(KEY_CREATED_DRIVER, driverCreateRequest.getDriver());
    putInList(KEY_LIST_OF_CREATED_DRIVERS, driverCreateRequest.getDriver());

    DriverInfo driverInfo = new DriverInfo();
    driverInfo.fromDriver(driverCreateRequest.getDriver());
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    put(KEY_CREATED_DRIVER_USERNAME, driverInfo.getUsername());
    put(KEY_CREATED_DRIVER_ID, driverInfo.getId());
    put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
  }

  @And("API Operator refresh drivers data")
  public void refreshDriversData() {
    getDriverClient().getAllDriver();
  }

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

  @After("@DeleteFilersPreset")
  public void deleteFiltersPreset() {
    Long presetId = get(ShipmentManagementSteps.KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID);
    if (presetId != null) {
      getTemplatesClient().deleteTemplate(presetId);
    }
  }

  @And("^API Operator get created Reservation Group params$")
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

  @Given("^API Operator gets data of created Third Party shipper$")
  public void apiOperatorGetsDataOfCreatedThirdPartyShipper() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    List<ThirdPartyShippers> thirdPartyShippers = getThirdPartyShippersClient().getAll();
    ThirdPartyShippers apiData = thirdPartyShippers.stream()
        .filter(shipper -> StringUtils.equals(shipper.getName(), thirdPartyShipper.getName()))
        .findFirst()
        .orElseThrow(() -> new RuntimeException(
            f("Third Party Shipper with name [%s] was not found", thirdPartyShipper.getName())));
    thirdPartyShipper.setId(apiData.getId());
  }

  @After("@DeleteThirdPartyShippers")
  public void deleteThirdPartyShippers() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    if (thirdPartyShipper != null) {
      if (thirdPartyShipper.getId() != null) {
        try {
          getThirdPartyShippersClient().delete(thirdPartyShipper.getId());
        } catch (Throwable ex) {
          NvLogger.warn(f("Could not delete Third Party Shipper [%s]", ex.getMessage()));
        }
      } else {
        NvLogger.warn(f("Could not delete Third Party Shipper [%s] - id was not defined",
            thirdPartyShipper.getName()));
      }
    }
  }

  @After("@DeleteContactTypes")
  public void deleteContactTypes() {
    ContactType contactType = get(KEY_CONTACT_TYPE);
    if (contactType != null) {
      if (contactType.getId() != null) {
        try {
          getContactTypeClient().delete(contactType.getId());
        } catch (Throwable ex) {
          NvLogger.warn(f("Could not delete Driver Contact Type [%s]", ex.getMessage()));
        }
      } else {
        NvLogger.warn(f("Could not delete Driver Contact Type [%s] - id was not defined",
            contactType.getName()));
      }
    }
  }

  @Given("^API Operator gets data of created Vehicle Type$")
  public void apiOperatorGetsDataOfCreatedVehicleType() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    List<co.nvqa.commons.model.core.VehicleType> vehicleTypes = getVehicleTypeClient()
        .getAllVehicleType().getData().getVehicleTypes();
    co.nvqa.commons.model.core.VehicleType apiData = vehicleTypes.stream()
        .filter(type -> StringUtils.equals(type.getName(), vehicleType.getName()))
        .findFirst()
        .orElseThrow(() -> new RuntimeException(
            f("Vehicle Type with name [%s] was not found", vehicleType.getName())));
    vehicleType.setId(apiData.getId());
  }

  @After("@DeleteVehicleTypes")
  public void deleteVehicleTypes() {
    VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
    if (vehicleType != null) {
      if (vehicleType.getId() != null) {
        try {
          getVehicleTypeClient().delete(vehicleType.getId());
        } catch (Throwable ex) {
          NvLogger.warn(f("Could not delete Vehicle Type [%s]", ex.getMessage()));
        }
      } else {
        NvLogger.warn(
            f("Could not delete Vehicle Type [%s] - id was not defined", vehicleType.getName()));
      }
    }
  }

  @Given("^API Operator retrieve information about Bulk Order with ID \"(.+)\"$")
  public void apiOperatorRetrieveBulkOrderIdInfo(long bulkId) {
    BulkOrderInfo bulkOrderInfo = getOrderClient().retrieveBulkOrderInfo(bulkId);
    put(KEY_CREATED_BULK_ORDER_INFO, bulkOrderInfo);
  }

  @Given("^API Operator enable Set Aside using data below:$")
  public void apiOperatorEnableSetAside(Map<String, String> data) {
    data = resolveKeyValues(data);
    SetAsideRequest request = new SetAsideRequest();
    request.fromMap(data);
    getSetAsideClient().enable(request);
  }

  @Given("^API Operator retrieve information about Bulk Order$")
  public void apiOperatorRetrieveBatchOrderIdInfo() {
    BatchOrderInfo batchOrderInfo = getOrderClient()
        .retrieveBatchOrderInfo(Long.parseLong(get(KEY_CREATED_BATCH_ORDER_ID)));
    put(KEY_CREATED_BATCH_ORDER_INFO, batchOrderInfo);
  }

  @After("@DeleteAddress")
  public void deleteAddress() {
    Addressing addressing = get(KEY_CREATED_ADDRESSING);

    if (addressing != null) {
      try {
        List<co.nvqa.commons.model.addressing.Address> addresses = getAddressingClient()
            .searchAddresses(StandardTestConstants.COUNTRY_CODE, addressing.getBuildingNo());
        if (CollectionUtils.isNotEmpty(addresses)) {
          getAddressingClient().deleteAddress(addresses.get(0).getId());
        }
      } catch (Throwable ex) {
        NvLogger.warn("Could not delete created address");
      }
    }
  }

  @Given("^API Operator creates new Shipper Pickup Filter Template using data below:$")
  public void apiOperatorCreatesShipperPickupFilterTemplate(Map<String, String> data) {
    data = resolveKeyValues(data);
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
    shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
        .createFilerTemplate(shipperPickupFilterTemplate);
    put(KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE, shipperPickupFilterTemplate);
  }

  @After("@DeleteShipperPickupFilterTemplate")
  public void deleteShipperPickupFilterTemplate() {
    ShipperPickupFilterTemplate shipperPickupFilterTemplate = get(
        KEY_CREATED_SHIPPER_PICKUP_FILTER_TEMPLATE);
    if (shipperPickupFilterTemplate != null && shipperPickupFilterTemplate.getId() != null) {
      getShipperPickupFilterTemplatesClient()
          .deleteFilerTemplate(shipperPickupFilterTemplate.getId());
    }
  }

  @When("^API Operator create new COD for created order$")
  public void operatorCreateNewCod() {
    Order order = get(KEY_CREATED_ORDER);
    Long routeId = get(KEY_CREATED_ROUTE_ID);

    Cod cod = order.getCod();
    assertNotNull("COD should not be null.", cod);
    Double codGoodsAmount = cod.getGoodsAmount();
    assertNotNull("COD Goods Amount should not be null.", codGoodsAmount);

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

  @Given("^API Operator create Middle Tier sort node:$")
  public void apiOperatorCreateSortNode(Map<String, String> data) {
    Node node = new Node(resolveKeyValues(data));
    node.setType(new NodeType(10));
    node = getNodesClient().createMiddleTierNode(node);
    put(KEY_CREATED_MIDDLE_TIER_NAME, node.getName());
    put(KEY_CREATED_MIDDLE_TIER_NODE, node);
  }

  @Given("API Operator create sales person:")
  public void apiOperatorCreateSalesPerson(Map<String, String> data) {
    SalesPerson salesPerson = new SalesPerson(resolveKeyValues(data));
    String uniqueString = generateDateUniqueString();
    if (StringUtils.endsWithIgnoreCase(salesPerson.getName(), "{uniqueString}")) {
      salesPerson.setName(salesPerson.getName().replace("{uniqueString}", uniqueString));
    }
    if (StringUtils.endsWithIgnoreCase(salesPerson.getCode(), "{uniqueString}")) {
      salesPerson.setCode(salesPerson.getCode().replace("{uniqueString}", uniqueString));
    }
    salesPerson = getSalesClient().createSalesPerson(salesPerson);
    putInList(KEY_LIST_OF_SALES_PERSON, salesPerson);
  }
}
