package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.JsonUtils;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.*;
import co.nvqa.commons.model.core.filter_preset.ShipperPickupFilterTemplate;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.core.setaside.SetAsideRequest;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.driver.DriverFilter;
import co.nvqa.commons.model.sort.nodes.Node;
import co.nvqa.commons.model.sort.nodes.Node.NodeType;
import co.nvqa.operator_v2.model.ContactType;
import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.model.*;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ApiOperatorPortalExtSteps.class);

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

    @After("@DeleteVehicleTypes")
    public void deleteVehicleTypes() {
        VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
        if (vehicleType != null) {
            if (vehicleType.getId() != null) {
                try {
                    getVehicleTypeClient().delete(vehicleType.getId());
                } catch (Throwable ex) {
                    LOGGER.warn(f("Could not delete Vehicle Type [%s]", ex.getMessage()));
                }
            } else {
                LOGGER.warn(
                        f("Could not delete Vehicle Type [%s] - id was not defined", vehicleType.getName()));
            }
        }
    }

    @After("@DeleteAddress")
    public void deleteAddress() {
        Addressing addressing = get(KEY_CREATED_ADDRESSING);

        if (addressing != null) {
            try {
                List<co.nvqa.commons.model.addressing.Address> addresses = getAddressingClient()
                        .searchAddresses(StandardTestConstants.NV_SYSTEM_ID, addressing.getBuildingNo());
                if (CollectionUtils.isNotEmpty(addresses)) {
                    getAddressingClient().deleteAddress(addresses.get(0).getId());
                }
            } catch (Throwable ex) {
                LOGGER.warn("Could not delete created address");
            }
        }
    }

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
            Long presetId = get(KEY_ROUTES_FILTERS_PRESET_ID);
            if (presetId != null) {
                getShipperPickupFilterTemplatesClient()
                        .deleteRoutesFilterTemplate(presetId);
            }
        } catch (Throwable ex) {
            LOGGER.warn("Could not delete Filter Preset", ex);
        }
    }

    @After("@DeleteThirdPartyShippers")
    public void deleteThirdPartyShippers() {
        ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
        if (thirdPartyShipper != null) {
            if (thirdPartyShipper.getId() != null) {
                try {
                    getThirdPartyShippersClient().delete(thirdPartyShipper.getId());
                } catch (Throwable ex) {
                    LOGGER.warn(f("Could not delete Third Party Shipper [%s]", ex.getMessage()));
                }
            } else {
                LOGGER.warn(f("Could not delete Third Party Shipper [%s] - id was not defined",
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
                    LOGGER.warn(f("Could not delete Driver Contact Type [%s]", ex.getMessage()));
                }
            } else {
                LOGGER.warn(f("Could not delete Driver Contact Type [%s] - id was not defined",
                        contactType.getName()));
            }
        }
    }

    @Given("API Operator create new DP Partner with the following attributes:")
    public void apiOperatorCreateNewDpPartnerWithTheFollowingAttributes(Map<String, String> data) {
        DpPartner dpPartner = new DpPartner(data);
        Map<String, Object> responseBody = getDpClient().createPartner(toJsonSnakeCase(dpPartner));
        dpPartner.setId(Long.parseLong(responseBody.get("id").toString()));
        dpPartner.setDpmsPartnerId(Long.parseLong(responseBody.get("dpms_partner_id").toString()));
        put(KEY_DP_PARTNER, dpPartner);
    }

    @When("API Operator add new DP for the created DP Partner with the following attributes:")
    public void operatorAddNewDpForTheDpPartnerWithTheFollowingAttributes(Map<String, String> data) {
        Partner dpPartner = get(KEY_DP_PARTNER);
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
        put(KEY_NEWLY_CREATED_DP_ID, dp.getId());
    }

    @When("API Operator add new DP User for the created DP with the following attributes:")
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

    @When("API Operator create {int} new Driver using data below:")
    public void apiOperatorCreateMultiNewDriverUsingDataBelow(Integer numberOdDrivers,
                                                              Map<String, String> mapOfData) {
        for (int i = 0; i < numberOdDrivers; i++) {
            apiOperatorCreateNewDriverUsingDataBelow(mapOfData);
        }
    }

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

    @Given("^API Operator retrieve information about Bulk Order with ID \"(.+)\"$")
    public void apiOperatorRetrieveBulkOrderIdInfo(long bulkId) {
        BulkOrderInfo bulkOrderInfo = getOrderClient().retrieveBulkOrderInfo(bulkId);
        put(KEY_CREATED_BULK_ORDER_INFO, bulkOrderInfo);
    }

    @Given("API Operator enable Set Aside using data below:")
    public void apiOperatorEnableSetAside(Map<String, String> data) {
        data = resolveKeyValues(data);
        SetAsideRequest request = new SetAsideRequest();
        request.fromMap(data);
        getSetAsideClient().enable(request);
    }

    @Given("API Operator retrieve information about Bulk Order")
    public void apiOperatorRetrieveBatchOrderIdInfo() {
        BatchOrderInfo batchOrderInfo = getOrderClient()
                .retrieveBatchOrderInfo(Long.parseLong(get(KEY_CREATED_BATCH_ORDER_ID)));
        put(KEY_CREATED_BATCH_ORDER_INFO, batchOrderInfo);
    }

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

    @Given("API Operator creates new Orders Filter Template using data below:")
    public void apiOperatorCreatesOrdersFilterTemplate(Map<String, String> data) {
        data = resolveKeyValues(data);
        ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
        shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
                .createOrdersFilerTemplate(shipperPickupFilterTemplate);
        put(KEY_ALL_ORDERS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
        put(KEY_ALL_ORDERS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
    }

    @Given("API Operator creates new Routes Filter Template using data below:")
    public void apiOperatorCreatesRoutesFilterTemplate(Map<String, String> data) {
        data = resolveKeyValues(data);
        ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
        shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
                .createRoutesFilerTemplate(shipperPickupFilterTemplate);
        put(KEY_ROUTES_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
        put(KEY_ROUTES_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
    }

    @Given("API Operator creates new Route Groups Filter Template using data below:")
    public void apiOperatorCreatesRouteGroupsFilterTemplate(Map<String, String> data) {
        data = resolveKeyValues(data);
        ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
        shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
                .createRouteGroupsFilerTemplate(shipperPickupFilterTemplate);
        put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
        put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
    }

    @Given("API Operator creates new Shipments Filter Template using data below:")
    public void apiOperatorCreatesShipmentsFilterTemplate(Map<String, String> data) {
        data = resolveKeyValues(data);
        ShipperPickupFilterTemplate shipperPickupFilterTemplate = new ShipperPickupFilterTemplate(data);
        shipperPickupFilterTemplate = getShipperPickupFilterTemplatesClient()
                .createShipmentsFilerTemplate(shipperPickupFilterTemplate);
        put(KEY_SHIPMENTS_FILTERS_PRESET_ID, shipperPickupFilterTemplate.getId());
        put(KEY_SHIPMENTS_FILTERS_PRESET_NAME, shipperPickupFilterTemplate.getName());
    }

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
