package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.GlobalInboundPage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class GlobalInboundSteps extends AbstractSteps
{
    private GlobalInboundPage globalInboundPage;

    @Inject
    public GlobalInboundSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
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
            }
        }

        return result;
    }

    @When("^Operator global inbounds parcel using data below:$")
    public void operatorGlobalInboundsParcelUsingThisDataBelow(Map<String, String> mapOfData)
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

        globalInboundPage.globalInbound(globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }
}
