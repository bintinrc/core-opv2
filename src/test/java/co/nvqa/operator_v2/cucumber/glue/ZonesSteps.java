package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Zone;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
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
        String uniqueCode = String.valueOf(System.currentTimeMillis());

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

    @Then("^Operator verify the new Zone is created successfully$")
    public void operatorVerifyTheNewZoneIsCreatedSuccessfully()
    {
        Zone zone = scenarioStorage.get("zone");
        zonesPage.verifyNewZoneIsCreatedSuccessfully(zone);
    }

    @When("^Operator update the new Zone$")
    public void operatorUpdateTheNewZone()
    {
        Zone zone = scenarioStorage.get("zone");

        Zone zoneEdited = new Zone();
        zoneEdited.setName(zone.getName()+"-EDITED");
        zoneEdited.setShortName(zone.getShortName()+"-E");
        zoneEdited.setLatitude(zone.getLatitude()+0.1);
        zoneEdited.setLongitude(zone.getLongitude()+0.1);
        zoneEdited.setHubName(zone.getHubName());
        zoneEdited.setDescription(zone.getDescription()+" [EDITED]");

        scenarioStorage.put("zoneEdited", zoneEdited);
        zonesPage.editZone(zone, zoneEdited);
    }

    @Then("^Operator verify the new Zone is updated successfully$")
    public void operatorVerifyTheNewZoneIsUpdatedSuccessfully()
    {
        Zone zoneEdited = scenarioStorage.get("zoneEdited");
        zonesPage.verifyZoneIsUpdatedSuccessfully(zoneEdited);
    }

    @When("^Operator delete the new Zone$")
    public void operatorDeleteTheNewZone()
    {
        Zone zone = scenarioStorage.containsKey("zoneEdited") ? scenarioStorage.get("zoneEdited") : scenarioStorage.get("zone");
        zonesPage.deleteZone(zone);
    }

    @Then("^Operator verify the new Zone is deleted successfully$")
    public void operatorVerifyTheNewZoneIsDeletedSuccessfully()
    {
        Zone zone = scenarioStorage.containsKey("zoneEdited") ? scenarioStorage.get("zoneEdited") : scenarioStorage.get("zone");
        zonesPage.verifyZoneIsDeletedSuccessfully(zone);
    }

    @Then("^Operator check all filters on Zones page work fine$")
    public void operatorCheckAllFiltersOnZonesPageWork()
    {
        Zone zone = scenarioStorage.get("zone");
        zonesPage.verifyAllFiltersWorkFine(zone);
    }

    @When("^Operator download Zone CSV file$")
    public void operatorDownloadZoneCsvFile()
    {
        Zone zone = scenarioStorage.get("zone");
        zonesPage.downloadCsvFile(zone);
    }

    @Then("^Operator verify Zone CSV file is downloaded successfully$")
    public void operatorVerifyZoneCsvFileIsDownloadSuccessfully()
    {
        Zone zone = scenarioStorage.get("zone");
        zonesPage.verifyCsvFileDownloadedSuccessfully(zone);
    }
}
