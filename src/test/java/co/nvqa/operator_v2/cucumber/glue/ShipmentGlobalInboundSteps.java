package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.page.ShipmentGlobalInboundPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 *
 * DEPRECATED
 * @author Tristania Siagian
 */
@ScenarioScoped
public class ShipmentGlobalInboundSteps extends AbstractSteps
{
    private ShipmentGlobalInboundPage shipmentGlobalInboundPage;

    public ShipmentGlobalInboundSteps()
    {
    }

    @Override
    public void init()
    {
        shipmentGlobalInboundPage = new ShipmentGlobalInboundPage(getWebDriver());
    }

    @When("^Operator select the destination hub ([^\"]*) of the shipment$")
    public void operatorSelectTheDestinationHubOfTheShipment(String hubName)
    {
        hubName = resolveValue(hubName);
        shipmentGlobalInboundPage.waitWhilePageIsLoading();
        shipmentGlobalInboundPage.selectShipmentDestinationHub(hubName);
    }

    @When("^Operator select the destination hub ([^\"]*) of the shipment precisely$")
    public void operatorSelectTheDestinationHubOfTheShipmentPrecisely(String hubName)
    {
        hubName = resolveValue(hubName);
        shipmentGlobalInboundPage.waitWhilePageIsLoading();
        shipmentGlobalInboundPage.selectShipmentDestinationHubPrecise(hubName);
    }

    @And("Operator select the shipment type")
    public void operatorSelectTheShipmentType()
    {
        Shipments shipment = get(KEY_CREATED_SHIPMENT);
        String shipmentType = shipment.getShipment().getShipmentType();
        shipmentGlobalInboundPage.selectShipmentType(shipmentType);
    }

    @And("Operator select the created shipment by Shipment ID")
    public void operatorSelectTheCreatedShipmentByShipmentID()
    {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        shipmentGlobalInboundPage.selectShipmentId(shipmentId);
    }

    @And("Operator click the add shipment button then continue")
    public void operatorClickTheAddShipmentButtonThenContinue()
    {
        Long shipmentId = get(KEY_CREATED_SHIPMENT_ID);
        shipmentGlobalInboundPage.clickAddShipmentThenContinue(shipmentId);
    }

    @And("Operator input the scanned Tracking ID inside the shipment")
    public void operatorInputTheScannedTrackingIDInsideTheShipment()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        shipmentGlobalInboundPage.inputScannedTrackingId(trackingId, true);
    }

    @And("Operator input the Invalid Tracking ID Status inside the shipment")
    public void operatorInputTheInvalidTrackingIDStatusInsideTheShipment()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        shipmentGlobalInboundPage.inputScannedTrackingId(trackingId, false);
    }

    @And("Operator input the Invalid Tracking ID inside the shipment")
    public void operatorInputTheInvalidTrackingIDInsideTheShipment()
    {
        String trackingId = "INVALID_TR_ID";
        shipmentGlobalInboundPage.inputScannedTrackingId(trackingId, false);
    }

    @Then("Operator will get the alert of ([^\"]*) shown")
    public void operatorWillGetTheAlertOfMessageShown(String toastText)
    {
        shipmentGlobalInboundPage.checkAlert(toastText);
    }

    @And("Operator change the data of the created Tracking ID with this data:")
    public void operatorChangeTheDataOfTheCreatedTrackingIDWithThisData(Map<String, String> mapOfData)
    {
        GlobalInboundParams globalInboundParams = buildGlobalInboundParams(mapOfData);
        shipmentGlobalInboundPage.shipmentGlobalInbound(globalInboundParams);
        put(KEY_GLOBAL_INBOUND_PARAMS, globalInboundParams);
    }

    @Then("Operator verifies priority level in Shipment Global Inbound info is correct using data below:")
    public void operatorVerifiesPriorityLevelInShipmentGlobalInboundInfoIsCorrectUsingDataBelow(Map<String, String> mapOfData)
    {
        int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
        String expectedPriorityLevelColor = mapOfData.get("priorityLevelColor");

        shipmentGlobalInboundPage.verifiesPriorityLevelInfoIsCorrect(expectedPriorityLevel, expectedPriorityLevelColor);
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
}
