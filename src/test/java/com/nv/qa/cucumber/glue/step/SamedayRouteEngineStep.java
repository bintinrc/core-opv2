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
        String fleetType1OperatingHoursFrom = mapOfData.get("fleetType1OperatingHoursFrom");
        String fleetType1OperatingHoursTo = mapOfData.get("fleetType1OperatingHoursTo");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectFleetType1OperatingHoursFrom(fleetType1OperatingHoursFrom);
        samedayRouteEnginePage.selectFleetType1OperatingHoursTo(fleetType1OperatingHoursTo);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
        samedayRouteEnginePage.selectDriverOnRouteSettingsPage("OpV2No.1");
        takesScreenshot();
        samedayRouteEnginePage.clickCreate1RoutesButton();
        pause5s();
    }
}
