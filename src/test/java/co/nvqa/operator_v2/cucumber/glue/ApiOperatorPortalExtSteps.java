package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.CreateDriverV2Request;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.support.JsonHelper;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.commons.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
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
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager>
{
    @Inject
    public ApiOperatorPortalExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }

        tagName = TagManagementSteps.EDITED_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }
    }

    @Given("^API Operator retrieve routes using data below:$")
    public void apiOperatorRetrieveRoutesUsingDataBelow(Map<String,String> mapOfData)
    {
        String value = mapOfData.getOrDefault("from", "TODAY");
        Date fromDate = null;

        if("TODAY".equalsIgnoreCase(value))
        {
            Calendar fromCal = Calendar.getInstance();
            fromCal.setTime(getNextDate(-1));
            fromCal.set(Calendar.HOUR_OF_DAY, 16);
            fromCal.set(Calendar.MINUTE, 0);
            fromCal.set(Calendar.SECOND, 0);
            fromDate = fromCal.getTime();
        }
        else if(StringUtils.isNotBlank(value))
        {
            fromDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        value = mapOfData.getOrDefault("to", "TODAY");
        Date toDate = null;

        if("TODAY".equalsIgnoreCase(value))
        {
            Calendar toCal = Calendar.getInstance();
            toCal.setTime(new Date());
            toCal.set(Calendar.HOUR_OF_DAY, 15);
            toCal.set(Calendar.MINUTE, 59);
            toCal.set(Calendar.SECOND, 59);
            toDate = toCal.getTime();
        }
        else if (StringUtils.isNotBlank(value))
        {
            toDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        List<Integer> tags = null;
        value = mapOfData.get("tagIds");

        if(StringUtils.isNotBlank(value))
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
        Map<String, Object> responseBody = getDPClient().createPartner(JsonHelper.toJson(JsonHelper.getDefaultSnakeCaseMapper(),dpPartner));
        dpPartner.setId(Long.parseLong(responseBody.get("id").toString()));
        dpPartner.setDpmsPartnerId(Long.parseLong(responseBody.get("dpms_partner_id").toString()));
    }

    @When("^API Operator add new DP for the created DP Partner with the following attributes:$")
    public void operatorAddNewDPForTheDPPartnerWithTheFollowingAttributes(Map<String, String> data)
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);
        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
        mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
        String json = replaceParam(data.get("requestBody"), mapOfDynamicVariable);
        Dp dp = new Dp();
        dp.fromJson(JsonHelper.getDefaultSnakeCaseMapper(), json);
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
        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("unique_string", TestUtils.generateDateUniqueString());
        mapOfDynamicVariable.put("generated_phone_no", TestUtils.generatePhoneNumber());
        String json = replaceParam(data.get("requestBody"), mapOfDynamicVariable);
        DpUser dpUser = new DpUser();
        dpUser.fromJson(JsonHelper.getDefaultCamelCaseMapper(), json);
        Map<String, Object> responseBody = getDpmsClient().createUser(dpPartner.getDpmsPartnerId(), dp.getDpmsId(), json);
        dpUser.setId(Long.parseLong(responseBody.get("id").toString()));
        put(KEY_DP_USER, dpUser);
    }

    @When("^API Operator create new Driver on Driver Strength page using data below:$")
    public void apiOperatorCreateNewDriverOnDriverStrengthPageUsingDataBelow(Map<String, String> mapOfData)
    {
        String driverCreateRequestTemplate = mapOfData.get("driverCreateRequest");
        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("RANDOM_FIRST_NAME", TestUtils.generateFirstName());
        mapOfDynamicVariable.put("RANDOM_LAST_NAME", TestUtils.generateLastName());
        mapOfDynamicVariable.put("TIMESTAMP", DateUtil.getTimestamp());
        String driverCreateRequestJson = StandardTestUtils.replaceParam(driverCreateRequestTemplate, mapOfDynamicVariable);

        CreateDriverV2Request driverCreateRequest = JsonHelper.fromJson(JsonHelper.getDefaultCamelCaseMapper(), driverCreateRequestJson, CreateDriverV2Request.class);
        driverCreateRequest = getDriverClient().createDriver(driverCreateRequest);
        DriverInfo driverInfo = new DriverInfo();
        driverInfo.fromDriver(driverCreateRequest.getDriver());
        put(KEY_CREATED_DRIVER, driverInfo);
        put(KEY_CREATED_DRIVER_UUID, driverInfo.getUuid());
    }
}
