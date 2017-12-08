package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Zone;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
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
    private ZonesPage zonesPage;

    @Inject
    public ZonesSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        zonesPage = new ZonesPage(getWebDriver());
    }

    @When("^Operator create new Zone using Hub \"([^\"]*)\"$")
    public void operatorCreateZone(String hubName)
    {
        String uniqueCode = generateDateUniqueString();
        long uniqueCoordinate = System.currentTimeMillis();

        Zone zone = new Zone();
        zone.setName("ZONE-"+uniqueCode);
        zone.setShortName("Z-"+uniqueCode);
        zone.setHubName(hubName);
        zone.setLatitude(Double.parseDouble("1."+uniqueCoordinate));
        zone.setLongitude(Double.parseDouble("103."+uniqueCoordinate));
        zone.setDescription(String.format("This zone is created by Operator V2 automation test. Created at %s.", new Date()));

        zonesPage.addZone(zone);
        getScenarioStorage().put("zone", zone);
    }

    @Then("^Operator verify the new Zone is created successfully$")
    public void operatorVerifyTheNewZoneIsCreatedSuccessfully()
    {
        Zone zone = getScenarioStorage().get("zone");
        zonesPage.verifyNewZoneIsCreatedSuccessfully(zone);
    }

    @When("^Operator update the new Zone$")
    public void operatorUpdateTheNewZone()
    {
        Zone zone = getScenarioStorage().get("zone");

        Zone zoneEdited = new Zone();
        zoneEdited.setName(zone.getName()+"-EDITED");
        zoneEdited.setShortName(zone.getShortName()+"-E");
        zoneEdited.setLatitude(zone.getLatitude()+0.1);
        zoneEdited.setLongitude(zone.getLongitude()+0.1);
        zoneEdited.setHubName(zone.getHubName());
        zoneEdited.setDescription(zone.getDescription()+" [EDITED]");

        getScenarioStorage().put("zoneEdited", zoneEdited);
        zonesPage.editZone(zone, zoneEdited);
    }

    @Then("^Operator verify the new Zone is updated successfully$")
    public void operatorVerifyTheNewZoneIsUpdatedSuccessfully()
    {
        Zone zoneEdited = getScenarioStorage().get("zoneEdited");
        zonesPage.verifyZoneIsUpdatedSuccessfully(zoneEdited);
    }

    @When("^Operator delete the new Zone$")
    public void operatorDeleteTheNewZone()
    {
        Zone zone = getScenarioStorage().containsKey("zoneEdited") ? getScenarioStorage().get("zoneEdited") : getScenarioStorage().get("zone");
        zonesPage.deleteZone(zone);
    }

    @Then("^Operator verify the new Zone is deleted successfully$")
    public void operatorVerifyTheNewZoneIsDeletedSuccessfully()
    {
        Zone zone = getScenarioStorage().containsKey("zoneEdited") ? getScenarioStorage().get("zoneEdited") : getScenarioStorage().get("zone");
        zonesPage.verifyZoneIsDeletedSuccessfully(zone);
    }

    @Then("^Operator check all filters on Zones page work fine$")
    public void operatorCheckAllFiltersOnZonesPageWork()
    {
        Zone zone = getScenarioStorage().get("zone");
        zonesPage.verifyAllFiltersWorkFine(zone);
    }

    @When("^Operator download Zone CSV file$")
    public void operatorDownloadZoneCsvFile()
    {
        Zone zone = getScenarioStorage().get("zone");
        zonesPage.downloadCsvFile(zone);
    }

    @Then("^Operator verify Zone CSV file is downloaded successfully$")
    public void operatorVerifyZoneCsvFileIsDownloadSuccessfully()
    {
        Zone zone = getScenarioStorage().get("zone");
        zonesPage.verifyCsvFileDownloadedSuccessfully(zone);
    }
}
