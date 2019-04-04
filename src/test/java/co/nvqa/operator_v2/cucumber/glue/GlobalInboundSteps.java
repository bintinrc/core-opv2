package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.GlobalInboundPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class GlobalInboundSteps extends AbstractSteps
{
    private GlobalInboundPage globalInboundPage;

    public GlobalInboundSteps()
    {
    }

    @Override
    public void init()
    {
        globalInboundPage = new GlobalInboundPage(getWebDriver());
    }

    private Double parseDoubleOrNull(String str)
    {
        Double result = null;

        if(str!=null)
        {
            try
            {
                result = Double.parseDouble(str);
            }
            catch(NumberFormatException ex)
            {
                NvLogger.warnf("Failed to parse String to Double. Cause: %s", ex.getMessage());
            }
        }

        return result;
    }

    private GlobalInboundParams buildGlobalInboundParams(Map<String, String> mapOfData)
    {
        String hubName = mapOfData.get("hubName");
        String deviceId = mapOfData.get("deviceId");
        String trackingId = mapOfData.get("trackingId");
        String overrideSize = mapOfData.get("overrideSize");

        Double overrideWeight = parseDoubleOrNull(mapOfData.get("overrideWeight"));
        Double overrideDimHeight = parseDoubleOrNull(mapOfData.get("overrideDimHeight"));
        Double overrideDimWidth = parseDoubleOrNull(mapOfData.get("overrideDimWidth"));
        Double overrideDimLength = parseDoubleOrNull(mapOfData.get("overrideDimLength"));

        if("GET_FROM_CREATED_ORDER".equalsIgnoreCase(trackingId))
        {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }

        GlobalInboundParams globalInboundParams = new GlobalInboundParams();
        globalInboundParams.setHubName(hubName);
        globalInboundParams.setDeviceId(deviceId);
        globalInboundParams.setTrackingId(trackingId);
        globalInboundParams.setOverrideSize(overrideSize);
        globalInboundParams.setOverrideWeight(overrideWeight);
        globalInboundParams.setOverrideDimHeight(overrideDimHeight);
        globalInboundParams.setOverrideDimWidth(overrideDimWidth);
        globalInboundParams.setOverrideDimLength(overrideDimLength);
        return globalInboundParams;
    }

    @When("^Operator global inbounds parcel using data below:$")
    public void operatorGlobalInboundsParcelUsingThisDataBelow(Map<String, String> mapOfData)
    {
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        globalInboundPage.successfulGlobalInbound(globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @When("^Operator global inbounds parcel using data below and check alert:$")
    public void operatorGlobalInboundsParcelUsingThisDataBelowAndCheckAlert(Map<String, String> mapOfData)
    {
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        String toastText = mapOfData.get("toastText");
        String rackInfo = mapOfData.get("rackInfo");
        String rackColor = mapOfData.get("rackColor");
        String weightWarning = mapOfData.get("weightWarning");
        globalInboundPage.globalInboundAndCheckAlert(globalInboundParams, toastText, rackInfo, rackColor, weightWarning);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @When("^Operator verifies priority level info is correct using data below:$")
    public void operatorVerifiesPriorityLevelInfoIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
        String expectedPriorityLevelColorAsHex = mapOfData.get("priorityLevelColorAsHex");
        globalInboundPage.verifiesPriorityLevelInfoIsCorrect(expectedPriorityLevel, expectedPriorityLevelColorAsHex);
    }
}
