package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.SamedayRouteEnginePage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SamedayRouteEngineStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private SamedayRouteEnginePage samedayRouteEnginePage;

    @Inject
    public SamedayRouteEngineStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        samedayRouteEnginePage = new SamedayRouteEnginePage(getDriver());
    }

    @When("^op 'Run Route Engine' on Same-Day Route Engine menu using data below:$")
    public void runRouteEngine(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String hubName = mapOfData.get("hub");
        String routingAlgorithm = mapOfData.get("routingAlgorithm");
        String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
        String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
        String fleetType1BreakingDurationStart = mapOfData.get("fleetType1BreakingDurationStart");
        String fleetType1BreakingDurationEnd = mapOfData.get("fleetType1BreakingDurationEnd");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
        samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
        samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);
        samedayRouteEnginePage.selectFleetType1BreakDurationStart(fleetType1BreakingDurationStart);
        samedayRouteEnginePage.selectFleetType1BreakDurationEnd(fleetType1BreakingDurationEnd);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
        samedayRouteEnginePage.selectDriverOnRouteSettingsPage("OpV2No.1");
        takesScreenshot();
        samedayRouteEnginePage.clickCreate1RoutesButton();
        takesScreenshot();
    }
}
