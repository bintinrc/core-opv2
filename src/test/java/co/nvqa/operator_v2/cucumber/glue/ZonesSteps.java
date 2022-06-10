package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.commons.util.NvAssertions;
import co.nvqa.operator_v2.selenium.page.ZonesPage;
import co.nvqa.operator_v2.selenium.page.ZonesSelectedPolygonsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
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

  private static final String RTS = "RTS";
  private static final String NORMAL = "normal";

  public ZonesSteps() {
  }

  @Override
  public void init() {
    zonesPage = new ZonesPage(getWebDriver());
    zonesSelectedPolygonsPage = new ZonesSelectedPolygonsPage(getWebDriver());
  }

  @When("Operator create new Zone using Hub {string}")
  public void operatorCreateZone(String hubName) {
    operatorCreateNewZone(hubName, false);
  }

  @When("Operator creates {string} zone using {string} hub")
  public void operatorCreatesZoneUsingHub(String zoneType, String hubName) {
    if (RTS.equalsIgnoreCase(zoneType)) {
      operatorCreateNewZone(hubName, true);
    } else if (NORMAL.equalsIgnoreCase(zoneType)) {
      operatorCreateNewZone(hubName, false);
    }
  }

  @Then("Operator verify the new Zone is created successfully")
  public void operatorVerifyTheNewZoneIsCreatedSuccessfully() {
    zonesPage.inFrame(page -> {
      Zone expected = get(KEY_CREATED_ZONE);
      zonesPage.findZone(expected);
      Zone actual = zonesPage.zonesTable.readEntity(1);
      expected.compareWithActual(actual);
      put(KEY_CREATED_ZONE_ID, actual.getId());
      putInList(KEY_LIST_OF_CREATED_ZONES_ID, actual.getId());
      takesScreenshot();
    });
  }

  @Then("Operator verifies that the newly created {string} zone's details are right")
  public void operatorVerifiesThatTheNewlyCreatedZoneSDetailsAreRight(String zoneType) {
    operatorVerifyTheNewZoneIsCreatedSuccessfully();
    zonesPage.inFrame(page -> {
      String actualRtsValue = zonesPage.zonesTable.readEntity(1).getType();
      if (RTS.equalsIgnoreCase(zoneType)) {
        assertEquals("Zone Type is right", RTS, actualRtsValue);
      } else if (NORMAL.equalsIgnoreCase(zoneType)) {
        assertEquals("Zone Type is right", "STANDARD", actualRtsValue);
      }
      takesScreenshot();
    });
  }

  @When("Operator update the new Zone")
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

    zonesPage.inFrame(page -> {
      zonesPage.waitUntilPageLoaded();
      zonesPage.findZone(zone);
      zonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
      zonesPage.editZoneDialog.waitUntilVisible();
      zonesPage.editZoneDialog.name.setValue(zoneEdited.getName());
      zonesPage.editZoneDialog.shortName.setValue(zoneEdited.getShortName());
      zonesPage.editZoneDialog.hub.selectValue(zoneEdited.getHubName());
      zonesPage.editZoneDialog.latitude.setValue(zoneEdited.getLatitude());
      zonesPage.editZoneDialog.longitude.setValue(zoneEdited.getLongitude());
      zonesPage.editZoneDialog.description.setValue(zoneEdited.getDescription());
      zonesPage.editZoneDialog.update.click();
      zonesPage.editZoneDialog.waitUntilInvisible();
    });
  }

  @When("Operator changes the newly created Zone to be {string} zone")
  public void operatorChangesTheNewlyCreatedZoneToBeZone(String zoneType) {
    Zone zone = get(KEY_CREATED_ZONE);

    Zone zoneEdited = new Zone();
    zoneEdited.setLatitude(zone.getLatitude());
    zoneEdited.setLongitude(zone.getLongitude());
    zoneEdited.setHubName(zone.getHubName());
    zoneEdited.setDescription(zone.getDescription());

    zonesPage.inFrame(page -> {
      zonesPage.waitUntilPageLoaded();
      zonesPage.findZone(zone);
      zonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
      zonesPage.editZoneDialog.waitUntilVisible();
      zonesPage.editZoneDialog.rts.click();
      zonesPage.editZoneDialog.update.click();
      zonesPage.editZoneDialog.waitUntilInvisible();

      if (RTS.equalsIgnoreCase(zoneType)) {
        zoneEdited.setName("RTS-" + zone.getName());
        zoneEdited.setShortName("RTS-" + zone.getShortName());
      } else if (NORMAL.equalsIgnoreCase(zoneType)) {
        zoneEdited.setName(zone.getName().substring(4));
        zoneEdited.setShortName(zone.getShortName().substring(4));
      }
    });
    put(KEY_CREATED_ZONE, zoneEdited);
  }

  @Then("Operator verify the new Zone is updated successfully")
  public void operatorVerifyTheNewZoneIsUpdatedSuccessfully() {
    Zone expected = get("zoneEdited");
    zonesPage.inFrame(page -> {
      zonesPage.findZone(expected);
      Zone actual = zonesPage.zonesTable.readEntity(1);
      expected.compareWithActual(actual);
      takesScreenshot();
    });
  }

  @When("Operator delete the new Zone")
  public void operatorDeleteTheNewZone() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.inFrame(page -> {
      zonesPage.waitUntilPageLoaded();
      zonesPage.findZone(zone);
      zonesPage.zonesTable.clickActionButton(1, ACTION_DELETE);
      zonesPage.confirmDeleteDialog.waitUntilVisible();
      zonesPage.confirmDeleteDialog.confirm.click();
    });
  }

  @Then("^Operator verify the new Zone is deleted successfully$")
  public void operatorVerifyTheNewZoneIsDeletedSuccessfully() {
    Zone zone = containsKey("zoneEdited") ? get("zoneEdited") : get(KEY_CREATED_ZONE);
    zonesPage.inFrame(page -> {
      zonesPage.clickRefreshCache();
      zonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
      Assertions.assertThat(zonesPage.zonesTable.isTableEmpty())
          .as("Zone " + zone.getName() + " were deleted").isTrue();
      takesScreenshot();
    });
  }

  @Then("Operator check all filters on Zones page work fine")
  public void operatorCheckAllFiltersOnZonesPageWork() {
    Zone zone = get(KEY_CREATED_ZONE);

    zonesPage.inFrame(page -> {
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
      takesScreenshot();
    });
  }

  @When("Operator download Zone CSV file")
  public void operatorDownloadZoneCsvFile() {
    zonesPage.inFrame(page -> {
      zonesPage.downloadCsvFile.click();
    });
  }

  @Then("Operator verify Zone CSV file is downloaded successfully")
  public void operatorVerifyZoneCsvFileIsDownloadSuccessfully() {
    Zone zone = get(KEY_CREATED_ZONE);
    zonesPage.inFrame(page -> {
      zonesPage.verifyCsvFileDownloadedSuccessfully(zone);
      takesScreenshot();
    });
  }

  @Then("^Operator click View Selected Polygons for zone id \"([^\"]*)\"$")
  public void operatorClickViewSelectedPolygonsForZone(String zoneId) {
    zonesPage.inFrame(page -> {
      zonesPage.zonesTable.filterByColumn(COLUMN_ID, resolveValue(zoneId));
      zonesPage.zonesTable.selectRow(1);
      zonesPage.viewSelectedPolygons.click();
      zonesSelectedPolygonsPage.waitUntilPageLoaded();
    });
  }

  @Then("^Operator add new \"([^\"]*)\" zone on View Selected Polygons page$")
  public void operatorAddNewZoneOnViewSelectedPolygonsPage(String zoneName) {
    zonesSelectedPolygonsPage.inFrame(() -> {
      zonesSelectedPolygonsPage.findZonesInput.setValue(zoneName);
      zonesSelectedPolygonsPage.zoneSelectionRows.stream()
          .filter(row -> StringUtils.equals(row.name.getText(), zoneName))
          .findFirst()
          .ifPresent(row -> row.checkbox.check());
    });
  }

  @And("^Operator remove all selected zones on View Selected Polygons page$")
  public void operatorRemoveAllSelectedZonesOnViewSelectedPolygonsPage() {
    zonesSelectedPolygonsPage.inFrame(() -> zonesSelectedPolygonsPage.zonesPanel.clearAll.click());
  }

  @Then("^Operator verify zone \"([^\"]*)\" is selected on View Selected Polygons page$")
  public void operatorVerifyZoneIsSelectedOnViewSelectedPolygonsPage(String zoneName) {
    String finalZoneName = resolveValue(zoneName);
    zonesSelectedPolygonsPage.inFrame(() ->
        zonesSelectedPolygonsPage.zonesPanel.zones.stream()
            .filter(zone -> StringUtils.equals(zone.name.getText(), finalZoneName))
            .findFirst()
            .orElseThrow(() -> new AssertionError(
                "Zone " + finalZoneName + " was not found in selected zones"))
    );
  }

  @Then("^Operator verify count of selected zones is (\\d+) on View Selected Polygons page$")
  public void operatorVerifyCountOfSelectedZonesIsOnViewSelectedPolygonsPage(int countOfZones) {
    zonesSelectedPolygonsPage.inFrame(() ->
        assertEquals("Count of selected zones",
            countOfZones, zonesSelectedPolygonsPage.zonesPanel.zones.size())
    );
  }

  private void operatorCreateNewZone(String hubName, boolean isRts) {
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

    zonesPage.inFrame(page -> {
      page.waitUntilPageLoaded();
      page.addZone.click();
      page.addZoneDialog.waitUntilVisible();
      page.addZoneDialog.name.setValue(zone.getName());
      page.addZoneDialog.shortName.setValue(zone.getShortName());
      page.addZoneDialog.hub.selectValue(zone.getHubName());
      page.addZoneDialog.latitude.setValue(zone.getLatitude());
      page.addZoneDialog.longitude.setValue(zone.getLongitude());
      page.addZoneDialog.description.setValue(zone.getDescription());

      if (isRts) {
        page.addZoneDialog.rts.click();
        zone.setName("RTS-" + zone.getName());
        zone.setShortName("RTS-" + zone.getShortName());
      }

      page.addZoneDialog.submit.click();
      page.addZoneDialog.waitUntilInvisible();
    });
    put(KEY_CREATED_ZONE, zone);
  }

  /* ======================= Bulk Edit Zone Polygon ======================= */

  @And("Zones page is loaded")
  public void zonesPageIsLoaded() {
    zonesPage.waitUntilPageLoaded();
    zonesPage.pageFrame.waitUntilVisible();
    zonesPage.switchTo();
    zonesPage.bulkEditPolygons.waitUntilVisible();
  }

  @When("Operator clicks Bulk Edit Polygons button")
  public void operatorClicksBulkEditPolygonsButton() {
    zonesPage.bulkEditPolygons.waitUntilClickable();
    zonesPage.bulkEditPolygons.click();
  }

  @Then("Operator make sure Bulk Edit Polygons dialog shows up")
  public void operatorMakeSureBulkEditPolygonsDialogShowsUp() {
    zonesPage.bulkEditPolygonsDialog.waitUntilVisible();
    Assertions.assertThat(zonesPage.bulkEditPolygonsDialog.isDisplayed())
        .as("Bulk Edit Polygons dialog shows up")
        .isTrue();
  }

  @When("Operator successfully upload a KML file {string}")
  public void operatorSuccessfullyUploadAKMLFile(String fileName) {
    // Retry mechanism in case the KML file is not correctly read (a.k.a. vertex = 0)
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      if (zonesSelectedPolygonsPage.sideToolbar.isDisplayed()) {
        NvAssertions.LOGGER.info("Some elements are missing is Zone Drawing page, going back...");
        backToPreviousPage();
      } else {
        NvAssertions.LOGGER.info("Refreshing on main page...");
        zonesPage.refreshPage_v1();
      }
      zonesPageIsLoaded();
      operatorClicksBulkEditPolygonsButton();
      operatorMakeSureBulkEditPolygonsDialogShowsUp();
      operatorUploadAKMLFile(fileName);
      operatorMakeSureIsRedirectedToZoneDrawingPage();
      operatorMakeSureKMLFileIsReadCorrectly();
    }, "Retrying until KML file is read correctly");
  }

  @When("Operator upload a KML file {string}")
  public void operatorUploadAKMLFile(String fileName) {
    final String kmlFileName = "kml/" + fileName;
    final ClassLoader classLoader = getClass().getClassLoader();
    File kmlFile = new File(
        Objects.requireNonNull(classLoader.getResource(kmlFileName)).getFile());

    zonesPage.uploadKmlFile(kmlFile);
  }

  @Then("Operator make sure is redirected to Zone Drawing page")
  public void operatorMakeSureIsRedirectedToZoneDrawingPage() {
    zonesSelectedPolygonsPage.waitUntilPageLoaded();
    zonesSelectedPolygonsPage.switchTo();
    zonesSelectedPolygonsPage.sideToolbar.waitUntilVisible();
    zonesSelectedPolygonsPage.saveZoneDrawingButton.waitUntilClickable();
    Assertions.assertThat(
            zonesSelectedPolygonsPage.zoneDrawingHeader.isDisplayed() &&
                zonesSelectedPolygonsPage.saveZoneDrawingButton.isDisplayed()
        )
        .as("Zone Drawing page is loaded")
        .isTrue();
  }

  @And("Operator make sure KML file is read correctly")
  public void operatorMakeSureKMLFileIsReadCorrectly() {
    Assertions.assertThat(zonesSelectedPolygonsPage.isKmlFileReadCorrectly())
        .as("KML file is read CORRECTLY")
        .isTrue();
  }

  @Then("Operator make sure zones from KML file are listed correctly")
  public void operatorMakeSureZonesFromKMLFileAreListedCorrectly(
      Map<String, String> dataTableAsMap) {
    Map<String, String> inputMap = resolveKeyValues(dataTableAsMap);

    String zonesAsJson = inputMap.get("zones");
    List<Map<String, Object>> zoneList = fromJsonToList(zonesAsJson, Object.class).stream()
        .map(o -> convertValueToMap(o, String.class, Object.class))
        .collect(Collectors.toList());

    List<Long> ids = zoneList.stream()
        .map(z -> convertValue(z.get("id"), Long.class)).collect(Collectors.toList());
    List<String> names = zoneList.stream()
        .map(z -> convertValue(z.get("name"), String.class)).collect(Collectors.toList());

    Assertions.assertThat(zonesSelectedPolygonsPage.hasZonesListed(ids, names))
        .as("All zones are listed correctly")
        .isTrue();

    List<Object> zonesAsObject = zoneList.stream()
        .map(zone -> convertValue(zone, Object.class))
        .collect(Collectors.toList());
    Map<String, Object> inputMapAsObject = new HashMap<>();
    inputMapAsObject.put("zones", zonesAsObject);

    put(KEY_ZONE_POLYGONS_AS_JSON, inputMapAsObject);
    put(KEY_LIST_OF_SUCCESSFUL_KML_ZONES, convertValue(zonesAsObject, Object.class));
    put(KEY_LIST_OF_ZONES_POLYGON_ZONE_NAMES, names);
  }

  @And("Operator clicks save button in zone drawing page")
  public void operatorClicksSaveButtonInZoneDrawingPage() {
    List<String> names = get(KEY_LIST_OF_ZONES_POLYGON_ZONE_NAMES, new ArrayList<>());
    zonesSelectedPolygonsPage.saveZoneDrawingButton.waitUntilClickable();
    zonesSelectedPolygonsPage.saveZoneDrawingButton.click();
    zonesSelectedPolygonsPage.saveConfirmationDialog.waitUntilVisible();
    Assertions.assertThat(zonesSelectedPolygonsPage.saveConfirmationDialog.isDisplayed())
        .as("Save confirmation dialog shows up")
        .isTrue();
    Assertions.assertThat(zonesSelectedPolygonsPage.hasZonesListedInSaveConfirmationDialog(names))
        .as("All zones are listed in save confirmation dialog")
        .isTrue();
    zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.waitUntilClickable();
    zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.click();
  }

  @Then("Operator make sure error popup on zones page shows up: {string}")
  public void operatorMakeSureErrorPopupOnZonesPageShowsUp(String message) {
    Assertions.assertThat(zonesPage.isNotificationShowUp(message))
        .as(String.format("Error notification shows up: %s", message))
        .isTrue();
  }

  @Then("Operator make sure dialog shows error: {string}")
  public void operatorMakeSureDialogShowsError(String errorTitle) {
    Assertions.assertThat(
            zonesPage.isElementExist(String.format(ZonesPage.BULK_ZONE_UPDATE_ERROR_TITLE, errorTitle)))
        .as(String.format("Update dialog shows correct error title: %s", errorTitle))
        .isTrue();
  }
}