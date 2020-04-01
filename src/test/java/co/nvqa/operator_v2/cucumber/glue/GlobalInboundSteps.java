package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.GlobalInboundPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.List;
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

        if (str != null)
        {
            try
            {
                result = Double.parseDouble(str);
            } catch (NumberFormatException ex)
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

        if ("GET_FROM_CREATED_ORDER".equalsIgnoreCase(trackingId))
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
        mapOfData = resolveKeyValues(mapOfData);
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        globalInboundPage.successfulGlobalInbound(globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @When("^Operator global inbounds parcel using data below and check alert:$")
    public void operatorGlobalInboundsParcelUsingThisDataBelowAndCheckAlert(Map<String, String> mapOfData)
    {
        pause1s();
        mapOfData = resolveKeyValues(mapOfData);
        Order order = get(KEY_CREATED_ORDER);
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        String toastText = mapOfData.get("toastText");
        String rackInfo = mapOfData.get("rackInfo");
        String rackColor = mapOfData.get("rackColor");
        String weightWarning = mapOfData.get("weightWarning");
        String destinationHub = mapOfData.get("destinationHub");
        String rackSector = mapOfData.get("rackSector");
        if ("GET_FROM_CREATED_ORDER".equalsIgnoreCase(destinationHub))
        {
            destinationHub = order.getDestinationHub();
        }
        if ("GET_FROM_CREATED_ORDER".equalsIgnoreCase(rackSector))
        {
            rackSector = order.getRackSector();
        }
        globalInboundPage.globalInboundAndCheckAlert(globalInboundParams, toastText, rackInfo, rackColor, weightWarning, rackSector, destinationHub);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @When("^Operator verifies priority level info is correct using data below:$")
    public void operatorVerifiesPriorityLevelInfoIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
        String expectedPriorityLevelColorAsHex = mapOfData.get("priorityLevelColorAsHex");
        globalInboundPage.verifiesPriorityLevelInfoIsCorrect(expectedPriorityLevel, expectedPriorityLevelColorAsHex);
    }

    @Then("Operator global inbound and verify the ticket's type of {string} shown in the Global Inbound Page with data:")
    public void operatorVerifyTheTicketSTypeShownInTheGlobalInboundPage(String ticketType, Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);

        globalInboundPage.verifyPetsGlobalInbound(globalInboundParams, ticketType);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @Then("Operator verify info on Global Inbound page using data below:")
    public void operatorVerifyInfoOnGlobalInboundPageUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        if (data.containsKey("destinationHub"))
        {
            String expected = data.get("destinationHub");
            String actual = globalInboundPage.destinationHub.getText();
            actual = StringUtils.normalizeSpace(StringUtils.remove(actual, "Hub:"));
            Assert.assertThat("Destination Hub", actual, Matchers.equalToIgnoringCase(expected));
        }

        if (data.containsKey("rackInfo"))
        {
            String expected = data.get("rackInfo");
            String actual = globalInboundPage.rackInfo.getText();
            actual = StringUtils.normalizeSpace(actual);
            Assert.assertThat("Rack Info", actual, Matchers.equalToIgnoringCase(expected));
        }

        if (data.containsKey("setAsideGroup"))
        {
            String expected = data.get("setAsideGroup");
            String actual = globalInboundPage.setAsideGroup.getText();
            actual = StringUtils.normalizeSpace(actual);
            Assert.assertThat("Set Aside Group", actual, Matchers.equalToIgnoringCase(expected));
        }

        if (data.containsKey("setAsideRackSector"))
        {
            String expected = data.get("setAsideRackSector");
            String actual = globalInboundPage.setAsideRackSector.getText();
            actual = StringUtils.normalizeSpace(StringUtils.remove(actual, "Rack Sector:"));
            Assert.assertThat("Set Aside Rack Sector", actual, Matchers.equalToIgnoringCase(expected));
        }
    }

    @Then("Ninja Collect Operator verifies that all the details for Confirmed Status via {string} are right")
    public void ninjaCollectOperatorVerifiesThatAllTheDetailsForConfirmedStatusViaAreRightAndIsFollowedByStatus(String source)
    {
        DatabaseCheckingNinjaCollectConfirmed dbCheckingResult = get(KEY_DATABASE_CHECKING_NINJA_COLLECT_CONFIRMED);
        DpDetailsResponse dpDetails = get(KEY_DP_DETAILS);
        String barcode = get(KEY_CREATED_ORDER_TRACKING_ID);
        globalInboundPage.verifiesDetailsAreRightForGlobalInbound(dbCheckingResult, dpDetails, barcode, source);
    }

    @Then("Operator verifies tags on Global Inbound page")
    public void operatorVerifiesTagsOnGlobalInboundPage(List<String> expectedOrderTags)
    {
        globalInboundPage.verifiesTagsOnOrder(expectedOrderTags);
    }

    @Then("Operator global inbounds {string} ticket using data below:")
    public void operatorGlobalInboundsTicketUsingDataBelow(String recoveryTicketType, Map<String, String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        globalInboundPage.unSuccessfulGlobalInbound(recoveryTicketType, globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }
}
