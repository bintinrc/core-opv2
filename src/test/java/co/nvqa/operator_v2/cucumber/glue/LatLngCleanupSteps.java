package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.WaypointDetails;
import co.nvqa.operator_v2.selenium.page.LatLngCleanupPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class LatLngCleanupSteps extends AbstractSteps
{
    public static final String KEY_WAYPOINT_DETAILS = "KEY_WAYPOINT_DETAILS";
    private LatLngCleanupPage latLngCleanupPage;

    @Inject
    public LatLngCleanupSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        latLngCleanupPage = new LatLngCleanupPage(getWebDriver());
    }

    @And("^Operator edit created delivery waypoint on Lat/Lng Cleanup page using data below:$")
    public void operatorEditCreatedDeliveryWaypointUsingDataBelow(Map<String, String> mapOfData)
    {
        Long waypointId = get(KEY_DELIVERY_WAYPOINT_ID);
        WaypointDetails newWaypointDetails = new WaypointDetails();
        newWaypointDetails.fromMap(mapOfData);
        newWaypointDetails.setId(waypointId);
        put(KEY_WAYPOINT_DETAILS, newWaypointDetails);
        latLngCleanupPage.editWaypointDetails(waypointId, newWaypointDetails);
    }

    @Then("^Operator verify waypoint details on Lat/Lng Cleanup page$")
    public void operatorVerifyWaypointDetailsOnLatLngCleanupPage()
    {
        WaypointDetails expectedWaypointDetails = get(KEY_WAYPOINT_DETAILS);
        latLngCleanupPage.validateWaypointDetails(expectedWaypointDetails.getId(), expectedWaypointDetails);
    }
}