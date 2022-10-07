package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.page.FirstMileZonesPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_DESCRIPTION;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_HUB_NAME;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_ID;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_LATITUDE;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_NAME;
import static co.nvqa.operator_v2.selenium.page.ZonesPage.ZonesTable.COLUMN_SHORT_NAME;

@ScenarioScoped
public class FirstMileZonesSteps extends AbstractSteps {

  private FirstMileZonesPage firstMileZonesPage;

  public FirstMileZonesSteps() {
  }

  @Override
  public void init() {
    firstMileZonesPage = new FirstMileZonesPage(getWebDriver());
  }

  @When("Operator creates first mile zone using {string} hub")
  public void operatorCreatesFirstMileZoneUsingHub(String hubName) {
    operatorCreateFirstMileZone(hubName);
  }

  @When("Operator creates first mile zone with empty field in one of the mandatory field")
  public void operatorCreatesFirstMileZoneWithEmptyField() {
    firstMileZonesPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.addFmZone.click();
      page.addFmZoneDialog.waitUntilVisible();
      page.addFmZoneDialog.name.setValue("FMZONE");
      page.addFmZoneDialog.shortName.setValue("FMZONE");
      page.addFmZoneDialog.latitude.setValue("11");
      page.addFmZoneDialog.longitude.setValue("12");
    });
  }

  @Then("^Operator verifies Submit Button in First Mile Zone add dialog is Disabled$")
  public void verifiesAddSubmitButtonDisabled() {
    firstMileZonesPage.inFrame(page -> {
      Assertions.assertThat(page.addFmZoneDialog.submit.isEnabled()).as("Submit button is disabled")
          .isFalse();
    });
  }

  @Then("^Operator verifies Submit Button in First Mile Zone edit dialog is Disabled$")
  public void verifiesEditSubmitButtonDisabled() {
    firstMileZonesPage.inFrame(page -> {
      Assertions.assertThat(page.editFmZoneDialog.update.isEnabled())
          .as("Submit button is disabled")
          .isFalse();
    });
  }

  @Then("Operator verifies first mile zone details on First Mile Zones page:")
  public void operatorVerifiesFirstMileZoneDetails(Map<String, String> data) {
    Zone expected = new Zone(resolveKeyValues(data));
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.findZone(expected.getName());
      Zone actual = firstMileZonesPage.zonesTable.readEntity(1);
      if (StringUtils.equals(expected.getName(), actual.getName())) {
        put(KEY_CREATED_ZONE_ID, actual.getId());
        putInList(KEY_LIST_OF_CREATED_ZONES_ID, actual.getId());
      }
      expected.compareWithActual(actual);
    });
  }

  @When("Operator delete first mile zone")
  public void operatorDeleteTheFirstMileZone() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getName());
      firstMileZonesPage.zonesTable.clickActionButton(1, ACTION_DELETE);
      firstMileZonesPage.confirmDeleteDialog.waitUntilVisible();
      firstMileZonesPage.confirmDeleteDialog.confirm.click();
    });
  }

  @Then("^Operator verify first mile zone is deleted successfully$")
  public void operatorVerifyTheFistMileZoneIsDeletedSuccessfully() {
    Zone zone = containsKey(KEY_EDITED_ZONE) ? get(KEY_EDITED_ZONE) : get(KEY_CREATED_ZONE);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
      Assertions.assertThat(firstMileZonesPage.zonesTable.isTableEmpty())
          .as("Zone " + zone.getName() + " were deleted").isTrue();
    });
  }

  @When("Operator update first mile zone with empty field in one of the mandatory field")
  public void operatorUpdateFirstMileZoneWithEmptyField() {
    Zone zone = get(KEY_CREATED_ZONE);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getName());
      firstMileZonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
      firstMileZonesPage.editFmZoneDialog.waitUntilVisible();
      firstMileZonesPage.editFmZoneDialog.name.setValue(zone.getName() + "-EDITED");
      firstMileZonesPage.editFmZoneDialog.shortName.setValue("");
      firstMileZonesPage.editFmZoneDialog.latitude.setValue(zone.getLatitude() + 0.1);
      firstMileZonesPage.editFmZoneDialog.longitude.setValue(zone.getLongitude() + 0.1);
    });
  }

  @When("Operator update the first mile Zone")
  public void operatorUpdateFirstMileZone() {
    Zone zone = get(KEY_CREATED_ZONE);

    Zone zoneEdited = new Zone();
    zoneEdited.setName(zone.getName() + "-EDITED");
    zoneEdited.setShortName(zone.getShortName() + "-E");
    zoneEdited.setLatitude(zone.getLatitude() + 0.1);
    zoneEdited.setLongitude(zone.getLongitude() + 0.1);
    zoneEdited.setHubName(zone.getHubName());
    zoneEdited.setDescription(zone.getDescription() + " [EDITED]");

    put(KEY_EDITED_ZONE, zoneEdited);

    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getName());
      firstMileZonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
      firstMileZonesPage.editFmZoneDialog.waitUntilVisible();
      firstMileZonesPage.editFmZoneDialog.name.setValue(zoneEdited.getName());
      firstMileZonesPage.editFmZoneDialog.shortName.setValue(zoneEdited.getShortName());
      firstMileZonesPage.editFmZoneDialog.hub.selectValue(zoneEdited.getHubName());
      firstMileZonesPage.editFmZoneDialog.latitude.setValue(zoneEdited.getLatitude());
      firstMileZonesPage.editFmZoneDialog.longitude.setValue(zoneEdited.getLongitude());
      firstMileZonesPage.editFmZoneDialog.description.setValue(zoneEdited.getDescription());
      firstMileZonesPage.editFmZoneDialog.update.click();
      firstMileZonesPage.editFmZoneDialog.waitUntilInvisible();
    });
  }

  @Then("Operator check all filters on Fist Mile Zones page work fine")
  public void operatorCheckAllFiltersOnFistMileZonesPageWork() {
    Zone zone = get(KEY_CREATED_ZONE);

    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getName());
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_ID, zone.getId());
      List<String> values = firstMileZonesPage.zonesTable.readColumn(COLUMN_ID);
      assertThat("ID filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getShortName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_ID);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_SHORT_NAME, zone.getShortName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_SHORT_NAME);
      assertThat("Short Name filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getShortName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_SHORT_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_NAME);
      assertThat("Name filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_HUB_NAME, zone.getHubName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_HUB_NAME);
      assertThat("Hub Name filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getHubName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_HUB_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_LATITUDE, zone.getLatitude());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_LATITUDE);
      assertThat("Latitude/Longitude filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getHubName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_LATITUDE);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_DESCRIPTION, zone.getDescription());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_DESCRIPTION);
      assertThat("Description filter results", values,
          Matchers.everyItem(Matchers.containsString(zone.getHubName())));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_DESCRIPTION);
    });
  }

  private void operatorCreateFirstMileZone(String hubName) {
    String uniqueCode = generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();

    Zone zone = new Zone();
    zone.setName("FMZONE-" + uniqueCode);
    zone.setShortName("FMZ-" + uniqueCode);
    zone.setHubName(hubName);
    zone.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    zone.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    zone.setDescription(
        f("This FM zone is created by Operator V2 automation test. Please don't use this zone. Created at %s.",
            new Date()));

    firstMileZonesPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.addFmZone.click();
      page.addFmZoneDialog.waitUntilVisible();
      page.addFmZoneDialog.name.setValue(zone.getName());
      page.addFmZoneDialog.shortName.setValue(zone.getShortName());
      page.addFmZoneDialog.hub.selectValue(zone.getHubName());
      page.addFmZoneDialog.latitude.setValue(zone.getLatitude());
      page.addFmZoneDialog.longitude.setValue(zone.getLongitude());
      page.addFmZoneDialog.description.setValue(zone.getDescription());

      page.addFmZoneDialog.submit.click();
      page.addFmZoneDialog.waitUntilInvisible();
    });
    put(KEY_CREATED_ZONE, zone);
  }
}