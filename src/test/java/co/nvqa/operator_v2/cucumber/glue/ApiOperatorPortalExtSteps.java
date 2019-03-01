package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.route.MilkrunGroup;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.JsonUtils;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.ReservationGroup;
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

import static co.nvqa.operator_v2.cucumber.glue.ReservationPresetManagementSteps.KEY_CREATED_RESERVATION_GROUP;

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
    public void apiOperatorCreateNewDPPartnerWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = new DpPartner(data);
        put(KEY_DP_PARTNER, dpPartner);
        Map<String, Object> responseBody = getDPClient().createPartner(toJsonSnakeCase(dpPartner));
        dpPartner.setId(Long.parseLong(responseBody.get("id").toString()));
        dpPartner.setDpmsPartnerId(Long.parseLong(responseBody.get("dpms_partner_id").toString()));
    }

    @When("^API Operator add new DP for the created DP Partner with the following attributes:$")
    public void operatorAddNewDPForTheDPPartnerWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
        mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
        String json = replaceTokens(data.get("requestBody"), mapOfDynamicVariable);
        Dp dp = new Dp();
        dp.fromJson(JsonUtils.getDefaultSnakeCaseMapper(), json);
        Map<String, Object> responseBody = getDPClient().createDp(dpPartner.getId(), json);
        dp.setId(Long.parseLong(responseBody.get("id").toString()));
        dp.setDpmsId(Long.parseLong(responseBody.get("dpms_id").toString()));
        put(KEY_DISTRIBUTION_POINT, dp);
    }

    @When("^API Operator add new DP User for the created DP with the following attributes:$")
    public void operatorAddDPUserForTheCreatedDPWithTheFollowingAttributes(Map<String, String> data)
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

    @When("^API Operator create new Driver on Driver Strength page using data below:$")
    public void apiOperatorCreateNewDriverOnDriverStrengthPageUsingDataBelow(Map<String, String> mapOfData)
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
        ReservationGroup reservationGroup = get(KEY_CREATED_RESERVATION_GROUP);
        List<MilkrunGroup> milkrunGroups = getRouteClient().getMilkrunGroups(new Date());
        MilkrunGroup group = milkrunGroups.stream()
                .filter(milkrunGroup -> StringUtils.equals(milkrunGroup.getName(), reservationGroup.getName()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Could not find milkrun group with name [" + reservationGroup.getName() + "]"));
        reservationGroup.setId(group.getId());
        put(KEY_CREATED_RESERVATION_GROUP_ID, reservationGroup.getId());
    }
}
