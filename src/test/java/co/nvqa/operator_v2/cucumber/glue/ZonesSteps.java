package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Zone;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ZonesSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private ZonesPage zonesPage;

    @Inject
    public ZonesSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        zonesPage = new ZonesPage(getWebDriver());
    }

    @When("^Operator create new Zone using Hub \"([^\"]*)\"$")
    public void operatorCreateZone(String hubName)
    {
        String uniqueCode = String.valueOf(System.currentTimeMillis()).substring(0, 7);

        Zone zone = new Zone();
        zone.setName("ZONE-"+uniqueCode);
        zone.setShortName("Z-"+uniqueCode);
        zone.setHubName(hubName);
        zone.setLatitude(Double.parseDouble("1."+uniqueCode));
        zone.setLongitude(Double.parseDouble("103."+uniqueCode));
        zone.setDescription(String.format("This zone is created by Operator V2 automation test. Created at %s.", new Date()));

        zonesPage.addZone(zone);
        scenarioStorage.put("zone", zone);
    }
}
