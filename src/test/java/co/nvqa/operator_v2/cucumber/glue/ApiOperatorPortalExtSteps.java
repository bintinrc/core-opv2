package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.BatchOrderInfo;
import co.nvqa.commons.model.core.BulkOrderInfo;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.ThirdPartyShippers;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.core.setaside.SetAsideRequest;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.JsonUtils;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.model.ContactType;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.ReservationGroup;
import co.nvqa.operator_v2.model.ThirdPartyShipper;
import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.After;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager>
{
    public ApiOperatorPortalExtSteps()
    {
    }

    @Override
    public void init()
    {
    }

    @Given("^Operator V2 cleaning Tag Management by calling API endpoint directly$")
    public void cleaningTagManagement()
    {
        Order order1 = new Order();
        order1.setId(1L);
        order1.setComments("No");

        Order order2 = new Order();
        order2.setId(1L);
        order2.setComments("Yes");

        String tagName = TagManagementSteps.DEFAULT_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        } catch (RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }

        tagName = TagManagementSteps.EDITED_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        } catch (RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }
    }

    @Given("^API Operator retrieve routes using data below:$")
    public void apiOperatorRetrieveRoutesUsingDataBelow(Map<String, String> mapOfData)
    {
        String value = mapOfData.getOrDefault("from", "TODAY");
        Date fromDate = null;

        if ("TODAY".equalsIgnoreCase(value))
        {
            Calendar fromCal = Calendar.getInstance();
            fromCal.setTime(getNextDate(-1));
            fromCal.set(Calendar.HOUR_OF_DAY, 16);
            fromCal.set(Calendar.MINUTE, 0);
            fromCal.set(Calendar.SECOND, 0);
            fromDate = fromCal.getTime();
        } else if (StringUtils.isNotBlank(value))
        {
            fromDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        value = mapOfData.getOrDefault("to", "TODAY");
        Date toDate = null;

        if ("TODAY".equalsIgnoreCase(value))
        {
            Calendar toCal = Calendar.getInstance();
            toCal.setTime(new Date());
            toCal.set(Calendar.HOUR_OF_DAY, 15);
            toCal.set(Calendar.MINUTE, 59);
            toCal.set(Calendar.SECOND, 59);
            toDate = toCal.getTime();
        } else if (StringUtils.isNotBlank(value))
        {
            toDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        List<Integer> tags = null;
        value = mapOfData.get("tagIds");

        if (StringUtils.isNotBlank(value))
        {
            tags = Arrays.stream(value.split(",")).map(tag -> Integer.parseInt(tag.trim())).collect(Collectors.toList());
        }

        Route[] routes = getRouteClient().findPendingRoutesByTagsAndDates(fromDate, toDate, tags);
        put(KEY_LIST_OF_FOUND_ROUTES, Arrays.asList(routes));
    }

    @Given("^API Operator create new DP Partner with the following attributes:$")
    public void apiOperatorCreateNewDpPartnerWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = new DpPartner(data);
        Map<String, Object> responseBody = getDpClient().createPartner(toJsonSnakeCase(dpPartner));
        dpPartner.setId(Long.parseLong(responseBody.get("id").toString()));
        dpPartner.setDpmsPartnerId(Long.parseLong(responseBody.get("dpms_partner_id").toString()));
        put(KEY_DP_PARTNER, dpPartner);
    }

    @When("^API Operator add new DP for the created DP Partner with the following attributes:$")
    public void operatorAddNewDpForTheDpPartnerWithTheFollowingAttributes(Map<String, String> data)
    {
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
    public void operatorAddDpUserForTheCreatedDpWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        Dp dp = get(KEY_DISTRIBUTION_POINT);
        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
        mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
        String json = replaceTokens(data.get("requestBody"), mapOfDynamicVariable);
        DpUser dpUser = new DpUser();
        dpUser.fromJson(JsonUtils.getDefaultCamelCaseMapper(), json);
        Map<String, Object> responseBody = getDpmsClient().createUser(dpPartner.getDpmsPartnerId(), dp.getDpmsId(), json);
        dpUser.setId(Long.parseLong(responseBody.get("id").toString()));
        put(KEY_DP_USER, dpUser);
    }

    @When("^API Operator create new Driver using data below:$")
    public void apiOperatorCreateNewDriverUsingDataBelow(Map<String, String> mapOfData)
    {
        String dateUniqueString = TestUtils.generateDateUniqueString();

        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("RANDOM_FIRST_NAME", "Driver-" + dateUniqueString);
        mapOfDynamicVariable.put("RANDOM_LAST_NAME", "Rider-" + dateUniqueString);
        mapOfDynamicVariable.put("TIMESTAMP", dateUniqueString);
        mapOfDynamicVariable.put("RANDOM_LATITUDE", String.valueOf(HubFactory.getRandomHub().getLatitude()));
        mapOfDynamicVariable.put("RANDOM_LONGITUDE", String.valueOf(HubFactory.getRandomHub().getLongitude()));

        String driverCreateRequestTemplate = mapOfData.get("driverCreateRequest");
        String driverCreateRequestJson = replaceTokens(driverCreateRequestTemplate, mapOfDynamicVariable);

        CreateDriverV2Request driverCreateRequest = fromJsonCamelCase(driverCreateRequestJson, CreateDriverV2Request.class);
        driverCreateRequest = getDriverClient().createDriver(driverCreateRequest);
        DriverInfo driverInfo = new DriverInfo();
        driverInfo.fromDriver(driverCreateRequest.getDriver());

        put(KEY_CREATED_DRIVER, driverInfo);
        put(KEY_CREATED_DRIVER_ID, driverInfo.getId());
        put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
    }

    @After("@DeleteFilersPreset")
    public void deleteFiltersPreset()
    {
        Long presetId = get(ShipmentManagementSteps.KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID);
        if (presetId != null)
        {
            getTemplatesClient().deleteTemplate(presetId);
        }
    }

    @And("^API Operator get created Reservation Group params$")
    public void apiOperatorGetCreatedReservationGroupParams()
    {
        ReservationGroup reservationGroup = get(ReservationPresetManagementSteps.KEY_CREATED_RESERVATION_GROUP);
        List<MilkrunGroup> milkrunGroups = getRouteClient().getMilkrunGroups(new Date());
        MilkrunGroup group = milkrunGroups.stream()
                .filter(milkrunGroup -> StringUtils.equals(milkrunGroup.getName(), reservationGroup.getName()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Could not find milkrun group with name [" + reservationGroup.getName() + "]"));
        reservationGroup.setId(group.getId());
        put(KEY_CREATED_RESERVATION_GROUP_ID, reservationGroup.getId());
    }

    @Given("^API Operator verify order info after Return PP transaction added to route$")
    public void apiOperatorVerifyOrderInfoAfterReturnPpTransactionAddedToRoute()
    {
        Order order = get(KEY_CREATED_ORDER);
        Long orderId = order.getId();
        pause2s();
        String methodInfo = f("%s - [Order ID = %d]", getCurrentMethodName(), orderId);
        Order latestOrderInfo = retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> getOrderClient().getOrder(orderId), methodInfo);
        assertEquals(f("Granular Status - [Tracking ID = %s]", latestOrderInfo.getTrackingId()), "VAN_ENROUTE_TO_PICKUP", latestOrderInfo.getGranularStatus());
        assertEquals(f("Status - [Tracking ID = %s]", latestOrderInfo.getTrackingId()), "TRANSIT", latestOrderInfo.getStatus());
    }

    @Given("^API Operator creates new Hub using data below:$")
    public void apiOperatorCreatesNewHubUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);

        String name = data.get("name");
        String displayName = data.get("displayName");
        String facilityType = data.get("facilityType");
        String city = data.get("city");
        String country = data.get("country");
        String latitude = data.get("latitude");
        String longitude = data.get("longitude");

        String uniqueCode = generateDateUniqueString();
        Address address = AddressFactory.getRandomAddress();

        if ("GENERATED".equals(name))
        {
            name = "HUB DO NOT USE " + uniqueCode;
        }

        if ("GENERATED".equals(displayName))
        {
            displayName = "Hub DNS " + uniqueCode;
        }

        if ("GENERATED".equals(city))
        {
            city = address.getCity();
        }

        if ("GENERATED".equals(country))
        {
            country = address.getCountry();
        }

        Hub randomHub = HubFactory.getRandomHub();

        if ("GENERATED".equals(latitude))
        {
            latitude = String.valueOf(randomHub.getLatitude());
        }

        if ("GENERATED".equals(longitude))
        {
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
        hub = getHubClient().create(hub);

        put(KEY_CREATED_HUB, hub);
        putInList(KEY_LIST_OF_CREATED_HUBS, hub);
    }

    @Given("^API Operator disable created hub$")
    public void apiOperatorDisableCreatedHub()
    {
        Hub hub = get(KEY_CREATED_HUB);
        Hub newHub = getHubClient().disable(hub.getId());
        hub.merge(newHub);
    }

    @Given("^API Operator activate created hub$")
    public void apiOperatorActivateCreatedHub() throws InstantiationException, IllegalAccessException
    {
        Hub hub = get(KEY_CREATED_HUB);
        Hub updateHub = hub.copy();
        updateHub.setActivate(true);
        Hub newHub = getHubClient().update(updateHub);
        hub.merge(newHub);
    }

    @Given("^API Operator gets data of created Third Party shipper$")
    public void apiOperatorGetsDataOfCreatedThirdPartyShipper()
    {
        ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
        List<ThirdPartyShippers> thirdPartyShippers = getThirdPartyShippersClient().getAll();
        ThirdPartyShippers apiData = thirdPartyShippers.stream()
                .filter(shipper -> StringUtils.equals(shipper.getName(), thirdPartyShipper.getName()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException(f("Third Party Shipper with name [%s] was not found", thirdPartyShipper.getName())));
        thirdPartyShipper.setId(apiData.getId());
    }

    @After("@DeleteThirdPartyShippers")
    public void deleteThirdPartyShippers()
    {
        ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
        if (thirdPartyShipper != null)
        {
            if (thirdPartyShipper.getId() != null)
            {
                try
                {
                    getThirdPartyShippersClient().delete(thirdPartyShipper.getId());
                } catch (Throwable ex)
                {
                    NvLogger.warn(f("Could not delete Third Party Shipper [%s]", ex.getMessage()));
                }
            } else
            {
                NvLogger.warn(f("Could not delete Third Party Shipper [%s] - id was not defined", thirdPartyShipper.getName()));
            }
        }
    }

    @After("@DeleteContactTypes")
    public void deleteContactTypes()
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);
        if (contactType != null)
        {
            if (contactType.getId() != null)
            {
                try
                {
                    getContactTypeClient().delete(contactType.getId());
                } catch (Throwable ex)
                {
                    NvLogger.warn(f("Could not delete Driver Contact Type [%s]", ex.getMessage()));
                }
            } else
            {
                NvLogger.warn(f("Could not delete Driver Contact Type [%s] - id was not defined", contactType.getName()));
            }
        }
    }

    @Given("^API Operator gets data of created Vehicle Type$")
    public void apiOperatorGetsDataOfCreatedVehicleType()
    {
        VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
        List<co.nvqa.commons.model.core.VehicleType> vehicleTypes = getVehicleTypeClient().getAllVehicleType().getData().getVehicleTypes();
        co.nvqa.commons.model.core.VehicleType apiData = vehicleTypes.stream()
                .filter(type -> StringUtils.equals(type.getName(), vehicleType.getName()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException(f("Vehicle Type with name [%s] was not found", vehicleType.getName())));
        vehicleType.setId(Long.valueOf(apiData.getId()));
    }

    @After("@DeleteVehicleTypes")
    public void deleteVehicleTypes()
    {
        VehicleType vehicleType = get(KEY_CREATED_VEHICLE_TYPE);
        if (vehicleType != null)
        {
            if (vehicleType.getId() != null)
            {
                try
                {
                    getVehicleTypeClient().delete(vehicleType.getId());
                } catch (Throwable ex)
                {
                    NvLogger.warn(f("Could not delete Vehicle Type [%s]", ex.getMessage()));
                }
            } else
            {
                NvLogger.warn(f("Could not delete Vehicle Type [%s] - id was not defined", vehicleType.getName()));
            }
        }
    }

    @Given("^API Operator retrieve information about Bulk Order with ID \"(.+)\"$")
    public void apiOperatorRetrieveBulkOrderIdInfo(long bulkId)
    {
        BulkOrderInfo bulkOrderInfo = getOrderClient().retrieveBulkOrderInfo(bulkId);
        put(KEY_CREATED_BULK_ORDER_INFO, bulkOrderInfo);
    }

    @Given("^API Operator get information about delivery routing hub of created order$")
    public void apiOperatorGetDeliveryHubInformationForCreatedOrder()
    {
        Order order = get(KEY_CREATED_ORDER);
        Long zoneId = order.getLastDeliveryTransaction().getRoutingZoneId();
        Zone zone = getZoneClient().getZone(zoneId);
        put(KEY_ORDER_ZONE_ID, zoneId);
        put(KEY_ORDER_HUB_ID, zone.getHubId());
    }

    @Given("^API Operator enable Set Aside using data below:$")
    public void apiOperatorEnableSetAside(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        SetAsideRequest request = new SetAsideRequest();
        request.fromMap(data);
        getSetAsideClient().enable(request);
    }

    @Given("^API Operator retrieve information about Bulk Order$")
    public void apiOperatorRetrieveBatchOrderIdInfo()
    {
        BatchOrderInfo batchOrderInfo = getOrderClient().retrieveBatchOrderInfo(Long.parseLong(get(KEY_CREATED_BATCH_ORDER_ID)));
        put(KEY_CREATED_BATCH_ORDER_INFO, batchOrderInfo);
    }
}
