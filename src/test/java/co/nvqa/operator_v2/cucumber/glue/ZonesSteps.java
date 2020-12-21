package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Zone;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import co.nvqa.operator_v2.selenium.page.ZonesSelectedPolygonsPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Date;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ZonesSteps extends AbstractSteps {

  private ZonesPage zonesPage;
  private ZonesSelectedPolygonsPage zonesSelectedPolygonsPage;

  public ZonesSteps() {
  }

  @Override
  public void init() {
    zonesPage = new ZonesPage(getWebDriver());
    zonesSelectedPolygonsPage = new ZonesSelectedPolygonsPage(getWebDriver());
  }

  @When("^Operator create new Zone using Hub \"([^\"]*)\"$")
  public void operatorCreateZone(String hubName) {
    String uniqueCode = generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();

    Zone zone = new Zone();
    zone.setName("ZONE-" + uniqueCode);
    zone.setShortName("Z-" + uniqueCode);
    zone.setHubName(hubName);
    zone.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    zone.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    zone.setDescription(
        f("This zone is created by Operator V2 automation test. Please don't use this zone. Created at %s.",
            new Date()));

    zonesPage.addZone(zone);
    put(KEY_CREATED_ZONE, zone);
  }

  @Then("^Operator verify the new Zone is created successfully$")
  public void operatorVerifyTheNewZoneIsCreatedSuccessfully() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.verifyNewZoneIsCreatedSuccessfully(zone);
    long createdZoneId = Long
        .parseLong(zonesPage.getTextOnTable(1, zonesPage.COLUMN_CLASS_DATA_ID));
    put(KEY_CREATED_ZONE_ID, createdZoneId);
  }

  @When("^Operator update the new Zone$")
  public void operatorUpdateTheNewZone() {
    Zone zone = get(KEY_CREATED_ZONE);

    Zone zoneEdited = new Zone();
    zoneEdited.setName(zone.getName() + "-EDITED");
    zoneEdited.setShortName(zone.getShortName() + "-E");
    zoneEdited.setLatitude(zone.getLatitude() + 0.1);
    zoneEdited.setLongitude(zone.getLongitude() + 0.1);
    zoneEdited.setHubName(zone.getHubName());
    zoneEdited.setDescription(zone.getDescription() + " [EDITED]");

    put("zoneEdited", zoneEdited);
    zonesPage.editZone(zone, zoneEdited);
  }

  @Then("^Operator verify the new Zone is updated successfully$")
  public void operatorVerifyTheNewZoneIsUpdatedSuccessfully() {
    Zone zoneEdited = get("zoneEdited");
    zonesPage.verifyZoneIsUpdatedSuccessfully(zoneEdited);
  }

  @When("^Operator delete the new Zone$")
  public void operatorDeleteTheNewZone() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.deleteZone(zone);
  }

  @Then("^Operator verify the new Zone is deleted successfully$")
  public void operatorVerifyTheNewZoneIsDeletedSuccessfully() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.verifyZoneIsDeletedSuccessfully(zone);
  }

  @Then("^Operator check all filters on Zones page work fine$")
  public void operatorCheckAllFiltersOnZonesPageWork() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.verifyAllFiltersWorkFine(zone);
  }

  @When("^Operator download Zone CSV file$")
  public void operatorDownloadZoneCsvFile() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.downloadCsvFile(zone);
  }

  @Then("^Operator verify Zone CSV file is downloaded successfully$")
  public void operatorVerifyZoneCsvFileIsDownloadSuccessfully() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.verifyCsvFileDownloadedSuccessfully(zone);
  }

  @Then("^Operator click View Selected Polygons for zone \"([^\"]*)\"$")
  public void operatorClickViewSelectedPolygonsForZone(String zoneName) {
    zonesPage.viewSelectedPolygonsOfZone(zoneName);
  }

  @Then("^Operator add new \"([^\"]*)\" zone on View Selected Polygons page$")
  public void operatorAddNewZoneOnViewSelectedPolygonsPage(String zoneName) {
    zonesSelectedPolygonsPage.addZone(zoneName);
  }

  @And("^Operator remove zone \"([^\"]*)\" if it is added on View Selected Polygons page$")
  public void operatorRemoveZoneIfItIsAddedOnViewSelectedPolygonsPage(String zoneName) {
    zonesSelectedPolygonsPage.removeZoneIfAdded(zoneName);
  }

  @Then("^Operator verify zone \"([^\"]*)\" is selected on View Selected Polygons page$")
  public void operatorVerifyZoneIsSelectedOnViewSelectedPolygonsPage(String zoneName) {
    zonesSelectedPolygonsPage.verifySelectedZone(zoneName);
  }

  @Then("^Operator verify count of selected zones is (\\d+) on View Selected Polygons page$")
  public void operatorVerifyCountOfSelectedZonesIsOnViewSelectedPolygonsPage(int countOfZones) {
    zonesSelectedPolygonsPage.verifyCountOfSelectedZones(countOfZones);
  }
}
