package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import co.nvqa.operator_v2.selenium.page.ZonesSelectedPolygonsPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Date;
import java.util.List;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_HUB_NAME;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_ID;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_NAME;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_SHORT_NAME;

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

    zonesPage.waitUntilPageLoaded();
    zonesPage.addZone.click();
    zonesPage.addZoneDialog.waitUntilVisible();
    zonesPage.addZoneDialog.name.setValue(zone.getName());
    zonesPage.addZoneDialog.shortName.setValue(zone.getShortName());
    zonesPage.addZoneDialog.hub.searchAndSelectValue(zone.getHubName());
    zonesPage.addZoneDialog.latitude.setValue(zone.getLatitude());
    zonesPage.addZoneDialog.longitude.setValue(zone.getLongitude());
    zonesPage.addZoneDialog.description.setValue(zone.getDescription());
    zonesPage.addZoneDialog.submit.clickAndWaitUntilDone();
    zonesPage.addZoneDialog.waitUntilInvisible();
    zonesPage.waitUntilInvisibilityOfToast("Zone created successfully", true);

    put(KEY_CREATED_ZONE, zone);
  }

  @Then("^Operator verify the new Zone is created successfully$")
  public void operatorVerifyTheNewZoneIsCreatedSuccessfully() {
    Zone expected = get(KEY_CREATED_ZONE);
    zonesPage.findZone(expected);
    Zone actual = zonesPage.zonesTable.readEntity(1);
    expected.compareWithActual(actual);
    put(KEY_CREATED_ZONE_ID, actual.getId());
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

    zonesPage.waitUntilPageLoaded();
    zonesPage.findZone(zone);
    zonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
    zonesPage.editZoneDialog.waitUntilVisible();
    zonesPage.editZoneDialog.name.setValue(zoneEdited.getName());
    zonesPage.editZoneDialog.shortName.setValue(zoneEdited.getShortName());
    zonesPage.editZoneDialog.hub.searchAndSelectValue(zoneEdited.getHubName());
    zonesPage.editZoneDialog.latitude.setValue(zoneEdited.getLatitude());
    zonesPage.editZoneDialog.longitude.setValue(zoneEdited.getLongitude());
    zonesPage.editZoneDialog.description.setValue(zoneEdited.getDescription());
    zonesPage.editZoneDialog.update.clickAndWaitUntilDone();
    zonesPage.editZoneDialog.waitUntilInvisible();
  }

  @Then("^Operator verify the new Zone is updated successfully$")
  public void operatorVerifyTheNewZoneIsUpdatedSuccessfully() {
    Zone expected = get("zoneEdited");
    zonesPage.findZone(expected);
    Zone actual = zonesPage.zonesTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("^Operator delete the new Zone$")
  public void operatorDeleteTheNewZone() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.waitUntilPageLoaded();
    zonesPage.findZone(zone);
    zonesPage.zonesTable.clickActionButton(1, ACTION_DELETE);
    zonesPage.confirmDeleteDialog.waitUntilVisible();
    zonesPage.confirmDeleteDialog.confirmDelete();
  }

  @Then("^Operator verify the new Zone is deleted successfully$")
  public void operatorVerifyTheNewZoneIsDeletedSuccessfully() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.clickRefreshCache();
    zonesPage.refreshPage();
    zonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
    assertTrue("Zone " + zone.getName() + " were deleted", zonesPage.zonesTable.isTableEmpty());
  }

  @Then("^Operator check all filters on Zones page work fine$")
  public void operatorCheckAllFiltersOnZonesPageWork() {
    Zone zone = get(KEY_CREATED_ZONE);

    zonesPage.zonesTable.filterByColumn(COLUMN_SHORT_NAME, zone.getShortName());
    List<String> values = zonesPage.zonesTable.readColumn(COLUMN_SHORT_NAME);
    assertThat("Short Name filter results", values,
        Matchers.everyItem(Matchers.containsString(zone.getShortName())));

    zonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
    values = zonesPage.zonesTable.readColumn(COLUMN_NAME);
    assertThat("Name filter results", values,
        Matchers.everyItem(Matchers.containsString(zone.getName())));

    zonesPage.zonesTable.filterByColumn(COLUMN_HUB_NAME, zone.getHubName());
    values = zonesPage.zonesTable.readColumn(COLUMN_HUB_NAME);
    assertThat("Hub Name filter results", values,
        Matchers.everyItem(Matchers.containsString(zone.getHubName())));
  }

  @When("^Operator download Zone CSV file$")
  public void operatorDownloadZoneCsvFile() {
    zonesPage.downloadCsvFile.click();
  }

  @Then("^Operator verify Zone CSV file is downloaded successfully$")
  public void operatorVerifyZoneCsvFileIsDownloadSuccessfully() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.verifyCsvFileDownloadedSuccessfully(zone);
  }

  @Then("^Operator click View Selected Polygons for zone id \"([^\"]*)\"$")
  public void operatorClickViewSelectedPolygonsForZone(String zoneId) {
    zonesPage.zonesTable.filterByColumn(COLUMN_ID, resolveValue(zoneId));
    zonesPage.zonesTable.selectRow(1);
    zonesPage.viewSelectedPolygons.click();
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