package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.client.core.HubClient;
import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.BatchOrderInfo;
import co.nvqa.commons.model.core.BulkOrderInfo;
import co.nvqa.commons.model.core.Cod;
import co.nvqa.commons.model.core.CodInbound;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.SalesPerson;
import co.nvqa.commons.model.core.ShipperPickupFilterTemplate;
import co.nvqa.commons.model.core.ThirdPartyShippers;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.core.setaside.SetAsideRequest;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.sort.hub.CrossDockStationRelation;
import co.nvqa.commons.model.sort.nodes.Node;
import co.nvqa.commons.model.sort.nodes.Node.NodeType;
import co.nvqa.commons.support.DateUtil;
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
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import static co.nvqa.commons.model.core.Order.GRANULAR_STATUS_VAN_ENROUTE_TO_PICKUP;
import static co.nvqa.commons.model.core.Order.STATUS_TRANSIT;

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

  @After("@DeleteCorporateSubShipper")
  public void deleteShipper() {
    List<Shipper> subShippers = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
    if (subShippers != null) {
      for (Shipper subShipper : subShippers) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(
            () -> getShipperClient().deleteShipperByShipperId(subShipper.getId()),
            f("Deleting newly created shipper with ID : %d", subShipper.getId()));
      }
    }
  }

  @Given("^API Operator retrieve routes using data below:$")
  public void apiOperatorRetrieveRoutesUsingDataBelow(Map<String, String> mapOfData) {
    String value = mapOfData.getOrDefault("from", "TODAY");
    Date fromDate = null;

    if ("TODAY".equalsIgnoreCase(value)) {
      Calendar fromCal = Calendar.getInstance();
      fromCal.setTime(getNextDate(-1));
      fromCal.set(Calendar.HOUR_OF_DAY, 16);
      fromCal.set(Calendar.MINUTE, 0);
      fromCal.set(Calendar.SECOND, 0);
      fromDate = fromCal.getTime();
    } else if ("TOMORROW".equalsIgnoreCase(value)) {
      Calendar fromCal = Calendar.getInstance();
      fromCal.setTime(getNextDate(1));
      fromCal.set(Calendar.HOUR_OF_DAY, 16);
      fromCal.set(Calendar.MINUTE, 0);
      fromCal.set(Calendar.SECOND, 0);
      fromDate = fromCal.getTime();
    } else if (StringUtils.isNotBlank(value)) {
      fromDate = Date.from(DateUtil.getDate(value).toInstant());
    }

    value = mapOfData.getOrDefault("to", "TODAY");
    Date toDate = null;

    if ("TODAY".equalsIgnoreCase(value)) {
      Calendar toCal = Calendar.getInstance();
      toCal.setTime(new Date());
      toCal.set(Calendar.HOUR_OF_DAY, 15);
      toCal.set(Calendar.MINUTE, 59);
      toCal.set(Calendar.SECOND, 59);
      toDate = toCal.getTime();
    } else if ("TOMORROW".equalsIgnoreCase(value)) {
      Calendar toCal = Calendar.getInstance();
      toCal.setTime(getNextDate(1));
      toCal.set(Calendar.HOUR_OF_DAY, 15);
      toCal.set(Calendar.MINUTE, 59);
      toCal.set(Calendar.SECOND, 59);
      toDate = toCal.getTime();
    } else if (StringUtils.isNotBlank(value)) {
      toDate = Date.from(DateUtil.getDate(value).toInstant());
    }

    List<Integer> tags = null;
    value = mapOfData.get("tagIds");

    if (StringUtils.isNotBlank(value)) {
      tags = Arrays.stream(value.split(",")).map(tag -> Integer.parseInt(tag.trim()))
          .collect(Collectors.toList());
    }

    Route[] routes = getRouteClient().findPendingRoutesByTagsAndDates(fromDate, toDate, tags);
    put(KEY_LIST_OF_FOUND_ROUTES, Arrays.asList(routes));
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

  @When("^API Operator create new Driver using data below:$")
  public void apiOperatorCreateNewDriverUsingDataBelow(Map<String, String> mapOfData) {
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

  @Given("^API Operator verify order info after Return PP transaction added to route$")
  public void apiOperatorVerifyOrderInfoAfterReturnPpTransactionAddedToRoute() {
    Order order = get(KEY_CREATED_ORDER);
    Long orderId = order.getId();
    pause2s();
    String methodInfo = f("%s - [Order ID = %d]", getCurrentMethodName(), orderId);
    Order latestOrderInfo = retryIfAssertionErrorOrRuntimeExceptionOccurred(
        () -> getOrderClient().getOrder(orderId), methodInfo);
    assertEquals(f("Granular Status - [Tracking ID = %s]", latestOrderInfo.getTrackingId()),
        GRANULAR_STATUS_VAN_ENROUTE_TO_PICKUP, latestOrderInfo.getGranularStatus());
    assertEquals(f("Status - [Tracking ID = %s]", latestOrderInfo.getTrackingId()), STATUS_TRANSIT,
        latestOrderInfo.getStatus());
  }

  @Given("^API Operator creates new Hub using data below:$")
  public void apiOperatorCreatesNewHubUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);

    String name = data.get("name");
    String displayName = data.get("displayName");
    String facilityType = data.get("facilityType");
    String city = data.get("city");
    String country = data.get("country");
    String latitude = data.get("latitude");
    String longitude = data.get("longitude");
    String region = "JKB";

    String uniqueCode = generateDateUniqueString();
    Address address = AddressFactory.getRandomAddress();

    if ("GENERATED".equals(name)) {
      name = "HUB DO NOT USE " + uniqueCode;
    }

    if ("GENERATED".equals(displayName)) {
      displayName = "Hub DNS " + uniqueCode;
    }

    if ("GENERATED".equals(city)) {
      city = address.getCity();
    }

    if ("GENERATED".equals(country)) {
      country = address.getCountry();
    }

    Hub randomHub = HubFactory.getRandomHub();

    if ("GENERATED".equals(latitude)) {
      latitude = String.valueOf(randomHub.getLatitude());
    }

    if ("GENERATED".equals(longitude)) {
      longitude = String.valueOf(randomHub.getLongitude());
    }

    Hub hub = new Hub();
    hub.setName(name);
    hub.setCreatedAt(DateUtil.getTodayDateTime_ISO8601_LITE());
    hub.setShortName(displayName);
    hub.setCountry(country);
    hub.setCity(city);
    hub.setLatitude(Double.parseDouble(latitude));
    hub.setLongitude(Double.parseDouble(longitude));
    hub.setFacilityType(facilityType);
    hub.setRegion(region);
    Map<String, Hub> hubMap = new HashMap<>();
    hubMap.put(hub.getName(), hub);
    final String hubName = name;
    retryIfAssertionErrorOccurred(() ->
    {
      Hub hubResp = getHubClient().create(hubMap.get(hubName));
      hubMap.put(hubResp.getName(), hubResp);
    }, getCurrentMethodName(), 500, 5);
    hub = hubMap.get(hubName);
    hub.setFacilityTypeDisplay(facilityType);

    put(KEY_CREATED_HUB, hub);
    putInList(KEY_LIST_OF_CREATED_HUBS, hub);
    NvLogger.success(f("Created hub with id %d and name %s", hub.getId(), hub.getName()));
  }

  @Given("API Operator creates new Hub with type {string} using data below:")
  public void apiOperatorCreatesNewHubWithTypeUsingDataBelow(String hubType,
      Map<String, String> mapOfData) {
    Map<String, String> mapOfDataWithHubType = new HashMap<>(mapOfData);
    mapOfDataWithHubType.put("facilityType", hubType);
    apiOperatorCreatesNewHubUsingDataBelow(mapOfDataWithHubType);
  }

  @Given("API Operator creates {int} new Hub using data below:")
  public void apiOperatorCreatesMultipleNewHubUsingDataBelow(Integer numberOfHubs,
      Map<String, String> mapOfData) {
    for (int i = 0; i < numberOfHubs; i++) {
      apiOperatorCreatesNewHubUsingDataBelow(mapOfData);
    }
  }

  @Given("API Operator creates hubs for {string} movement")
  public void apiOperatorCreatesHubsForMovement(String scheduleType) {
    Map<String, String> mapOfData = new HashMap<>();
    mapOfData.put("name", "GENERATED");
    mapOfData.put("displayName", "GENERATED");
    mapOfData.put("city", "GENERATED");
    mapOfData.put("country", "GENERATED");
    mapOfData.put("latitude", "GENERATED");
    mapOfData.put("longitude", "GENERATED");
    List<Hub> createdHubs;
    switch (scheduleType) {
      case HUB_CD_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        break;
      case HUB_CD_ITS_ST:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(0).getId()),
            String.valueOf(createdHubs.get(1).getId()));
        break;
      case HUB_CD_ST_DIFF_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(1).getId()));
        break;
      case HUB_ST_ST_SAME_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(1).getId()));
        break;
      case HUB_ST_ST_DIFF_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(3).getId()),
            String.valueOf(createdHubs.get(1).getId()));
        break;
      case HUB_ST_ITS_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(1).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        break;
      case HUB_ST_CD_DIFF_CD:
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("STATION", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        apiOperatorCreatesNewHubWithTypeUsingDataBelow("CROSSDOCK", mapOfData);
        createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        break;
    }
  }

  @Given("API Operator assign stations to its crossdock for {string} movement")
  public void apiOperatorAssignStationsToItsCrossdockForMovementType(String scheduleType) {
    List<Hub> createdHubs = get(KEY_LIST_OF_CREATED_HUBS);
    switch (scheduleType) {
      case HUB_CD_CD:
      case HUB_CD_ST_DIFF_CD:
        break;
      case HUB_CD_ITS_ST:
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(0).getId()),
            String.valueOf(createdHubs.get(1).getId()));
        break;
      case HUB_ST_ST_SAME_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_DIFF_CD:
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(2).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        break;
      case HUB_ST_ITS_CD:
        apiOperatorCreateRelationFor(String.valueOf(createdHubs.get(1).getId()),
            String.valueOf(createdHubs.get(0).getId()));
        break;
    }
  }

  @Given("API Operator assign CrossDock {string} for Station {string}")
  public void apiOperatorCreateRelationFor(String crossDockIdAsString, String stationIdAsString) {
    Long crossDockId = Long.valueOf(resolveValue(crossDockIdAsString));
    Long stationId = Long.valueOf(resolveValue(stationIdAsString));

    CrossDockStationRelation crossDockStationRelation = getHubClient()
        .assignStationToCrossDock("sg", crossDockId, stationId);
    put(KEY_HUB_CROSSDOCK_DETAIL_ID, crossDockStationRelation.getId());
    putInList(KEY_LIST_OF_HUB_CROSSDOCK_DETAIL_ID, crossDockStationRelation.getId());
  }

  @Given("^API Operator updates Hub using data below:$")
  public void apiOperatorUpdatesHubUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);

    String id = data.get("id");
    Hub hub = findCreatedHubById(id);

    String uniqueCode = generateDateUniqueString();
    Address address = AddressFactory.getRandomAddress();

    String name = data.get("name");
    if (StringUtils.isNotBlank(name)) {
      if ("GENERATED".equals(name)) {
        name = "HUB DO NOT USE " + uniqueCode;
      }
      hub.setName(name);
    }

    String displayName = data.get("displayName");
    if (StringUtils.isNotBlank(displayName)) {
      if ("GENERATED".equals(displayName)) {
        displayName = "Hub DNS " + uniqueCode;
      }
      hub.setShortName(displayName);
    }

    String facilityType = data.get("facilityType");
    if (StringUtils.isNotBlank(facilityType)) {
      hub.setFacilityType(facilityType);
    }

    String city = data.get("city");
    if (StringUtils.isNotBlank(city)) {
      if ("GENERATED".equals(city)) {
        city = address.getCity();
      }
      hub.setCity(city);
    }

    String country = data.get("country");
    if (StringUtils.isNotBlank(country)) {
      if ("GENERATED".equals(country)) {
        country = address.getCountry();
      }
      hub.setCountry(country);
    }

    Hub randomHub = HubFactory.getRandomHub();

    String latitude = data.get("latitude");
    if (StringUtils.isNotBlank(latitude)) {
      if ("GENERATED".equals(latitude)) {
        hub.setLatitude(randomHub.getLatitude());
      } else {
        hub.setLatitude(Double.parseDouble(latitude));
      }
    }

    String longitude = data.get("longitude");
    if (StringUtils.isNotBlank(longitude)) {
      if ("GENERATED".equals(longitude)) {
        hub.setLongitude(randomHub.getLongitude());
      } else {
        hub.setLongitude(Double.parseDouble(longitude));
      }
    }

    Hub response = getHubClient().update(hub);
    hub.merge(response);
  }


  @Given("^API Operator reloads hubs cache$")
  public void apiOperatorReloadsHubsCache() {
    getHubClient().reload();
  }

  @When("^API Operator verify new Hubs are created")
  public void apiOperatorVerifyNewHubsCreated() {
    List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
    HubClient hubClient = getHubClient();
    for (Hub hub : hubs) {
      hubClient.getHubById(hub.getId());
    }
  }

  @Given("^API Operator disable created hub$")
  public void apiOperatorDisableCreatedHub() {
    Hub hub = get(KEY_CREATED_HUB);
    Hub newHub = getHubClient().disable(hub.getId());
    hub.merge(newHub);
  }

  @Given("^API Operator disable hub with ID \"(.+)\"$")
  public void apiOperatorDisableHubWithId(String hubId) {
    hubId = resolveValue(hubId);
    Hub hub = findCreatedHubById(hubId);
    Hub newHub = getHubClient().disable(hub.getId());
    hub.merge(newHub);
  }

  @Given("^API Operator activate created hub$")
  public void apiOperatorActivateCreatedHub()
      throws InstantiationException, IllegalAccessException {
    Hub hub = get(KEY_CREATED_HUB);
    Hub updateHub = hub.copy();
    updateHub.setActivate(true);
    Hub newHub = getHubClient().update(updateHub);
    hub.merge(newHub);
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

  @Given("^API Operator get information about delivery routing hub of created order$")
  public void apiOperatorGetDeliveryHubInformationForCreatedOrder() {
    Order order = get(KEY_CREATED_ORDER);
    Long zoneId = order.getLastDeliveryTransaction().getRoutingZoneId();
    assertNotNull("Zone ID", zoneId);
    Zone zone = getZoneClient().getZone(zoneId);
    put(KEY_ORDER_ZONE_ID, zoneId);
    put(KEY_ORDER_HUB_ID, zone.getHubId());
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

  private Hub findCreatedHubById(String hubId) {
    if (StringUtils.isBlank(hubId)) {
      throw new IllegalArgumentException("ID of a hub to update was not provided");
    }

    List<Hub> listOfCreatedHubs = get(KEY_LIST_OF_CREATED_HUBS);
    if (CollectionUtils.isEmpty(listOfCreatedHubs)) {
      throw new IllegalArgumentException("List of created hubs is empty");
    }

    return listOfCreatedHubs.stream()
        .filter(h -> Objects.equals(h.getId(), Long.valueOf(hubId)))
        .findFirst()
        .orElseThrow(
            () -> new IllegalArgumentException(f("Created hub with ID [%s] was not found", hubId)));
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


  @And("API Operator does the {string} scan for the shipment {string} from {string} to {string}")
  public void apiOperatorDoesTheScanForTheShipment(String inboundType, String shipmentIdAsString,
      String originHubIdAsString, String destHubIdAsString) {
    Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
    long originHubId = Long.parseLong(resolveValue(originHubIdAsString));
    long destHubId = Long.parseLong(resolveValue(destHubIdAsString));
    long hubId;

    if ("van-inbound".equalsIgnoreCase(inboundType)) {
      hubId = originHubId;
    } else {
      hubId = destHubId;
    }
    retryIfAssertionErrorOccurred(() -> {
      getHubClient().shipmentInboundScanning(inboundType, shipmentId, hubId);
    }, getCurrentMethodName(), 1000, 5);
  }

  @And("API Operator does the {string} scan from {string} to {string} for the following shipments:")
  public void apiOperatorDoesTheScanForMultipleShipments(String inboundType,
      String originHubIdAsString, String destHubIdAsString, List<String> shipmentIds) {
    for (String shipmentIdAsString : shipmentIds) {
      apiOperatorDoesTheScanForTheShipment(inboundType, shipmentIdAsString, originHubIdAsString,
          destHubIdAsString);
      pause2s();
    }
  }

  @When("^API Operator archives routes:$")
  public void operatorArchivesRoutes(List<String> routeIds) {
    routeIds = resolveValues(routeIds);
    long[] ids = new long[routeIds.size()];
    for (int i = 0; i < routeIds.size(); i++) {
      ids[i] = Long.parseLong(routeIds.get(i));
    }
    getRouteClient().archiveRoutesV2(ids);
  }

  @Given("^API Operator create zone using data below:$")
  public void apiOperatorCreateZone(Map<String, String> data) {
    data = resolveKeyValues(data);
    String hubId = data.get("hubId");
    if (StringUtils.isBlank(hubId)) {
      throw new IllegalArgumentException("hubId for zone was not provided");
    }
    String uniqueCode = generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();

    Zone zone = new Zone();
    zone.setName("ZONE-" + uniqueCode);
    zone.setShortName("Z-" + uniqueCode);
    zone.setHubId(Integer.valueOf(hubId));
    zone.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    zone.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    zone.setDescription(
        f("This zone is created by Operator V2 automation test. Please don't use this zone. Created at %s.",
            new Date()));

    zone = getZoneClient().create(zone);
    zone.setHubName(data.get("hubName"));
    put(KEY_CREATED_ZONE, zone);
    put(KEY_CREATED_ZONE_ID, zone.getId());
    getZoneClient().reloadCache();
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
