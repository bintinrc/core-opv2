package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.SamedayRouteEnginePage;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import com.nv.qa.model.order_creation.v2.Order;

import java.io.IOException;
import java.util.Map;
import java.util.Optional;

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
        String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity")).orElse("10");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
        samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
        samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
        samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);
        samedayRouteEnginePage.selectFleetType1BreakDurationStart(fleetType1BreakingDurationStart);
        samedayRouteEnginePage.selectFleetType1BreakDurationEnd(fleetType1BreakingDurationEnd);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
    }

    @When("^op 'Run Route Engine' without break on Same-Day Route Engine menu using data below:$")
    public void runRouteEngineWithoutBreak(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String hubName = mapOfData.get("hub");
        String routingAlgorithm = mapOfData.get("routingAlgorithm");
        String fleetType1OperatingHoursStart = mapOfData.get("fleetType1OperatingHoursStart");
        String fleetType1OperatingHoursEnd = mapOfData.get("fleetType1OperatingHoursEnd");
        String fleetType1BreakingDurationStart = mapOfData.get("fleetType1BreakingDurationStart");
        String fleetType1BreakingDurationEnd = mapOfData.get("fleetType1BreakingDurationEnd");
        String fleetType1Capacity = Optional.ofNullable(mapOfData.get("fleetType1Capacity")).orElse("10");

        String routeGroupName = scenarioStorage.get("routeGroupName");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectRoutingAlgorithm(routingAlgorithm);
        samedayRouteEnginePage.setFleetType1Capacity(fleetType1Capacity);
        samedayRouteEnginePage.selectFleetType1OperatingHoursStart(fleetType1OperatingHoursStart);
        samedayRouteEnginePage.selectFleetType1OperatingHoursEnd(fleetType1OperatingHoursEnd);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
    }

    @Then("^op create the suggested route")
    public void createRoute(){
        samedayRouteEnginePage.selectDriverOnRouteSettingsPage("OpV2No.1");
        takesScreenshot();
        samedayRouteEnginePage.clickCreate1RoutesButton();
        takesScreenshot();
    }

    @Then("^op open same day route engine waypoint detail dialog")
    public void openWaypointDetailsDeialog(){
        samedayRouteEnginePage.openWaypointDetail();
    }

    @Then("^op download same day route engine waypoint detail dialog")
    public void downloadWaypointDetail(){
        try {
            Order order = (Order) scenarioStorage.get("order");
            samedayRouteEnginePage.downloadCsvOnWaypointDetails(order.getTracking_id());
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
