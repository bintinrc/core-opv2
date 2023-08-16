package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commonsort.constants.SortScenarioStorageKeys;
import co.nvqa.commonsort.model.addressing.Zone;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.FirstMileZonesPage;
import co.nvqa.operator_v2.selenium.page.ZonesSelectedPolygonsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
  private ZonesSelectedPolygonsPage zonesSelectedPolygonsPage;

  private static final Logger LOGGER = LoggerFactory.getLogger(FirstMileZonesSteps.class);

  public FirstMileZonesSteps() {
  }

  @Override
  public void init() {
    firstMileZonesPage = new FirstMileZonesPage(getWebDriver());
    zonesSelectedPolygonsPage = new ZonesSelectedPolygonsPage(getWebDriver());
  }

  @When("Operator loads First Mile Zone Page")
  public void operator_loads_first_mile_zone_page() {
    firstMileZonesPage.loadFirstMileZonePage();
  }

  @And("Operator clicks on the {string} button on First Mile Zone Page")
  @SuppressWarnings("unchecked")
  public void Operator_clicks_on_the_button(String buttonText) {
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.clickButton();
      takesScreenshot();
    });
  }

  @And("Operator clicks on the save changes button on First Mile Zone Page")
  @SuppressWarnings("unchecked")
  public void Operator_clicks_on_save_changes_button() {
    firstMileZonesPage.inFrame(page -> {
      page.editDriverZoneModal.clickOnSaveChangesButton();
      pause5s();
      takesScreenshot();
    });
  }

  @And("Operator verify success message toast is displayed")
  @SuppressWarnings("unchecked")
  public void Operator_verify_success_message() {
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.validateInvalidFileErrorMessageIsShown();
      takesScreenshot();
    });
  }

  @Then("Operator verifies the Table on Edit Driver Zone Modal")
  public void operatorVerifiesTableOnEditDriverZoneModalPage() {
      firstMileZonesPage.inFrame(page -> {
        Assertions.assertThat(page.editDriverZoneModal.getModalTitle("Edit Driver Zones")).
            as("Title is correct").isEqualToIgnoringCase("Edit Driver Zones");
        Assertions.assertThat(page.editDriverZoneModal.getHubText("Hubs")).
            as("Hubs is correct").isEqualToIgnoringCase("Hubs");
        Assertions.assertThat(page.editDriverZoneModal.getButton("close-modal-button")).
            as("Close button is Displayed").isTrue();
        Assertions.assertThat(page.editDriverZoneModal.getButton("save-changes-button")).
            as("Save Changes button is correct").isTrue();
      });
    }

  @Then("Operator verifies the Table of Zone on Edit Driver Zone Modal")
  public void operatorVerifiesTableOfZoneOnEditDriverZoneModalPage() {
    firstMileZonesPage.inFrame(page -> {
      Zone zone = get(KEY_CREATED_ZONE);
      Assertions.assertThat(page.editDriverZoneModal.verifyZoneTableValues("editDriver-name")).
          as("Zone Name is correct").isEqualToIgnoringCase(zone.getName());
      Assertions.assertThat(page.editDriverZoneModal.verifyZoneTableValues("editDriver-shortName")).
          as("Zone Short Name is correct").isEqualToIgnoringCase(zone.getShortName());
      Assertions.assertThat(page.editDriverZoneModal.verifyZoneTableValues("editDriver-hubName")).
          as("Zone Hub is correct").isEqualToIgnoringCase(zone.getHubName());
    });
  }

  @And("Operator search for hub on Edit Driver Zone Modal")
  @SuppressWarnings("unchecked")
  public void Operator_search_for_hub() {
    firstMileZonesPage.inFrame(page -> {
      Zone hubName = get(KEY_CREATED_ZONE);
      page.editDriverZoneModal.hub.selectValue(hubName.getHubName());
      page.editDriverZoneModal.hub.click();
      pause5s();
      takesScreenshot();
    });
  }

  @And("Operator search for zone on Edit Driver Zone Modal")
  @SuppressWarnings("unchecked")
  public void Operator_search_for_zone() {
    firstMileZonesPage.inFrame(page -> {
      Zone zone = get(KEY_CREATED_ZONE);
      page.editDriverZoneModal.getZoneByName(zone.getName());
      pause5s();
      takesScreenshot();
    });
  }

  @And("Operator search for driver {string} on Edit Driver Zone Modal")
  @SuppressWarnings("unchecked")
  public void Operator_search_for_driver(String driver) {
    firstMileZonesPage.inFrame(page -> {
      page.editDriverZoneModal.driver.selectValue(driver);
      takesScreenshot();
    });
  }

  @When("Operator creates first mile zone using {string} hub")
  public void operatorCreatesFirstMileZoneUsingHub(String hubName) {
    firstMileZonesPage.waitUntilPageLoaded();
    operatorCreateFirstMileZone(hubName);
    pause5s();
  }

  @When("Operator creates first mile zone with empty field in one of the mandatory field")
  public void operatorCreatesFirstMileZoneWithEmptyField() {
    firstMileZonesPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.addFmZone.click();
      page.addFmZoneDialog.waitUntilVisible();
      page.addFmZoneDialog.name.setValue("FMZONE");
      page.addFmZoneDialog.shortName.setValue("FMZ");
      page.addFmZoneDialog.latitude.setValue("11");
      page.addFmZoneDialog.longitude.setValue("12");
    });
  }

  @Then("^Operator verifies Submit Button in First Mile Zone add dialog is Disabled$")
  public void verifiesAddSubmitButtonDisabled() {
    firstMileZonesPage.inFrame(
        page -> Assertions.assertThat(page.addFmZoneDialog.submit.isEnabled())
            .as("Submit button is disabled")
            .isFalse());
  }

  @Then("^Operator verifies Submit Button in First Mile Zone edit dialog is Disabled$")
  public void verifiesEditSubmitButtonDisabled() {
    firstMileZonesPage.inFrame(
        page -> Assertions.assertThat(page.editFmZoneDialog.update.isEnabled())
            .as("Submit button is disabled")
            .isFalse());
  }

  @Then("Operator verifies first mile zone details on First Mile Zones page:")
  public void operatorVerifiesFirstMileZoneDetails(Map<String, String> data) {
    Zone expected = new Zone(resolveKeyValues(data));
    firstMileZonesPage.waitWhilePageIsLoading();
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.findZone(expected.getShortName());
      Zone actual = firstMileZonesPage.zonesTable.readEntity(1);
      if (StringUtils.equals(expected.getName(), actual.getName())) {
        put(SortScenarioStorageKeys.KEY_SORT_CREATED_FIRST_MILE_ZONE_ID, actual.getId());
      }
      expected.compareWithActual(actual);
    });
  }

  @When("Operator delete first mile zone with {string} short name")
  public void operatorDeleteTheFirstMileZone(String zoneName) {
    String shortName = resolveValue(zoneName);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(shortName);
      firstMileZonesPage.zonesTable.clickActionButton(1, ACTION_DELETE);
      firstMileZonesPage.confirmDeleteDialog.waitUntilVisible();
      firstMileZonesPage.confirmDeleteDialog.confirm.click();
    });
  }

  @Then("Operator verify first mile zone with {string} short name is deleted successfully")
  public void operatorVerifyFirstMileZoneIsDeletedSuccessfully(String zoneName) {
    String shortName = resolveValue(zoneName);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_SHORT_NAME, shortName);
      Assertions.assertThat(firstMileZonesPage.zonesTable.isTableEmpty())
          .as("Zone " + shortName + " were deleted").isTrue();
    });
  }

  @When("Operator update {string} first mile zone with empty field in one of the mandatory field")
  public void operatorUpdateFirstMileZoneWithEmptyField(String zoneName) {
    String shortName = resolveValue(zoneName);
    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(shortName);
      firstMileZonesPage.zonesTable.clickActionButton(1, ACTION_EDIT);
      firstMileZonesPage.editFmZoneDialog.waitUntilVisible();
      firstMileZonesPage.editFmZoneDialog.name.setValue("EDITED");
      firstMileZonesPage.editFmZoneDialog.shortName.setValue("");
      firstMileZonesPage.editFmZoneDialog.latitude.setValue(0.1);
      firstMileZonesPage.editFmZoneDialog.longitude.setValue(0.1);
    });
  }

  @When("Operator update the first mile Zone")
  public void operatorUpdateFirstMileZone(Map<String, String> data) {
    Zone zone = new Zone(resolveKeyValues(data));
    Zone zoneEdited = new Zone();
    zoneEdited.setName(zone.getName() + "-EDITED");
    zoneEdited.setShortName(zone.getShortName() + "-E");
    zoneEdited.setLatitude(zone.getLatitude() + 0.1);
    zoneEdited.setLongitude(zone.getLongitude() + 0.1);
    zoneEdited.setHubName(zone.getHubName());
    zoneEdited.setDescription(zone.getDescription() + " [EDITED]");

    put(SortScenarioStorageKeys.KEY_SORT_EDITED_FIRST_MILE_ZONE, zoneEdited);

    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getShortName());
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
  public void operatorCheckAllFiltersOnFistMileZonesPageWork(Map<String,String>data) {
    Zone zone = new Zone (resolveKeyValues(data));

    firstMileZonesPage.inFrame(page -> {
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.findZone(zone.getShortName());
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_SHORT_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_ID, zone.getId());
      List<String> values = firstMileZonesPage.zonesTable.readColumn(COLUMN_ID);
      Assertions.assertThat(values).as("ID filter results")
          .allMatch(value -> value.contains(zone.getShortName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_ID);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_SHORT_NAME, zone.getShortName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_SHORT_NAME);
      Assertions.assertThat(values).as("Short Name filter results")
          .allMatch(value -> value.contains(zone.getShortName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_SHORT_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_NAME, zone.getName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_NAME);
      Assertions.assertThat(values).as("Name filter results")
          .allMatch(value -> value.contains(zone.getName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_HUB_NAME, zone.getHubName());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_HUB_NAME);
      Assertions.assertThat(values).as("Hub Name filter results")
          .allMatch(value -> value.contains(zone.getHubName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_HUB_NAME);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_LATITUDE, zone.getLatitude());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_LATITUDE);
      Assertions.assertThat(values).as("Latitude/Longitude filter results")
          .allMatch(value -> value.contains(zone.getHubName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_LATITUDE);

      firstMileZonesPage.zonesTable.filterByColumn(COLUMN_DESCRIPTION, zone.getDescription());
      values = firstMileZonesPage.zonesTable.readColumn(COLUMN_DESCRIPTION);
      Assertions.assertThat(values).as("Description filter results")
          .allMatch(value -> value.contains(zone.getHubName()));
      firstMileZonesPage.zonesTable.clearColumnFilter(COLUMN_DESCRIPTION);
    });
  }

  private void operatorCreateFirstMileZone(String hubName) {
    String uniqueCode = StandardTestUtils.generateDateUniqueString();
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
    put(SortScenarioStorageKeys.KEY_SORT_CREATED_FIRST_MILE_ZONE, zone);
  }

  @And("Operator click View Selected Polygons for First Mile Zones name {string}")
  public void operatorClickViewSelectedPolygonsForFirstMileZonesName(String zoneShortName) {
    doWithRetry(()->{
      firstMileZonesPage.waitUntilLoaded();
      firstMileZonesPage.inFrame(page -> {
        firstMileZonesPage.zonesTable.filterByColumn(COLUMN_SHORT_NAME, resolveValue(zoneShortName));
        firstMileZonesPage.zonesTable.selectRow(1);
        firstMileZonesPage.viewSelectedPolygons.click();
      });},"Click View Selected Polygons Zone Name");
  }

  @And("Operator click Zones in First Mile Zones drawing page")
  public void operatorClickZonesInFirstMileZonesDrawingPage() {
    zonesSelectedPolygonsPage.waitUntilPageLoaded();
    zonesSelectedPolygonsPage.inFrame(
        () -> zonesSelectedPolygonsPage.zonesPanel.zones.get(0).click());
  }

  @And("Operator click Create Polygon in First Mile Zones drawing page")
  public void operatorClickCreatePolygonInFirstMileZonesDrawingPage() {
    zonesSelectedPolygonsPage.switchTo();
    zonesSelectedPolygonsPage.createZonePolygon.click();
  }

  @And("Operator click Set Coordinates in First Mile Zones drawing page")
  public void operatorClickSetCoordinatesInFirstMileZonesDrawingPage(Map<String, String> data) {
    String latitude = data.get("latitude");
    String longitude = data.get("longitude");
    zonesSelectedPolygonsPage.setCoordinate.click();
    zonesSelectedPolygonsPage.setZoneCoordinateDialog.latitude.clear();
    zonesSelectedPolygonsPage.setZoneCoordinateDialog.latitude.setValue(latitude);
    zonesSelectedPolygonsPage.setZoneCoordinateDialog.longitude.clear();
    zonesSelectedPolygonsPage.setZoneCoordinateDialog.longitude.setValue(longitude);
    zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.click();
    zonesSelectedPolygonsPage.saveZoneDrawingButton.waitUntilClickable();
    zonesSelectedPolygonsPage.saveZoneDrawingButton.click();
    zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.click();
    pause3s();
  }

  @When("Operator clicks Bulk Edit Polygons button in First Mile Zones Page")
  public void operatorClicksBulkEditPolygonsButtonInFirstMileZonesPage() {
    firstMileZonesPage.waitUntilPageLoaded();
    firstMileZonesPage.switchTo();
    firstMileZonesPage.bulkEditPolygons.waitUntilClickable();
    firstMileZonesPage.bulkEditPolygons.click();
  }

  private File getKmlFile(String resourcePath) {
    final ClassLoader classLoader = getClass().getClassLoader();
    return new File(Objects.requireNonNull(classLoader.getResource(resourcePath)).getFile());
  }

  @And("Operator upload a KML file {string} in First Mile Zones")
  public void operatorUploadAKMLFileInFirstMileZones(String fileName) {
    final String kmlFileName = "kml/" + fileName;
    File file = getKmlFile(kmlFileName);
    firstMileZonesPage.uploadKmlFileInput.sendKeys(file);
    firstMileZonesPage.selectKmlFile.click();
    firstMileZonesPage.loadingIcon.waitUntilInvisible();
  }

  @And("Operator clicks save button in first mile zone drawing page")
  public void operatorClicksSaveButtonInFirstMileZoneDrawingPage() {
    zonesSelectedPolygonsPage.inFrame(
        page -> {
          zonesSelectedPolygonsPage.saveZoneDrawingButton.waitUntilClickable();
          zonesSelectedPolygonsPage.saveZoneDrawingButton.click();
          zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.waitUntilVisible();
          zonesSelectedPolygonsPage.saveConfirmationDialogSaveButton.click();
        });
  }

  @Then("Operator verifies that error react notification displayed in First Mile Zones Page:")
  public void operatorVerifiesThatErrorReactNotificationDisplayedInFirstMileZonesPage(
      Map<String, String> data) {
    firstMileZonesPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean.parseBoolean(
          finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        toastInfo = firstMileZonesPage.noticeNotifications.stream().filter(toast -> {
          String actualTop = toast.message.getNormalizedText();
          LOGGER.info("Found notification: " + actualTop);
          String value = finalData.get("top");
          if (StringUtils.isNotBlank(value)) {
            if (value.startsWith("^")) {
              if (!actualTop.matches(value)) {
                return false;
              }
            } else {
              if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                return false;
              }
            }
          }
          value = finalData.get("bottom");
          if (StringUtils.isNotBlank(value)) {
            String actual = toast.description.getNormalizedText();
            if (value.startsWith("^")) {
              return actual.matches(value);
            } else {
              return StringUtils.equalsIgnoreCase(value, actual);
            }
          }
          return true;
        }).findFirst().orElse(null);
      } while (toastInfo == null && new Date().getTime() - start < 20000);
      Assertions.assertThat(toastInfo != null).as("Toast " + finalData + " is displayed").isTrue();
      if (toastInfo != null && waitUntilInvisible) {
        toastInfo.waitUntilInvisible();
      }
    });
  }

  @Then("Make sure First Mile Zone updated with correct vertex count {string}")
  public void makeSureFirstMileZoneUpdatedWithCorrectVertexCount(String vertexcount) {
    zonesSelectedPolygonsPage.switchTo();
    String actual = zonesSelectedPolygonsPage.vertexcount.getText();
    Assertions.assertThat(actual.equalsIgnoreCase(vertexcount))
        .as("Count is Correct")
        .isTrue();
  }

  @And("Operator make sure is redirected to First Mile Zone Drawing page")
  public void operatorMakeSureIsRedirectedToFirstMileZoneDrawingPage() {
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

  @Then("Operator verifies first mile zone polygon details:")
  public void operatorVerifiesFirstMileZonePolygonDetails(List<Map<String, String>> data) {
    List<String> expected = new ArrayList<>();
    List<String> actual = new ArrayList<>();
    for (Map<String, String> entry : data) {
      expected.add(resolveValue(entry.get("expected")));
      actual.add(resolveValue(entry.get("actual")));
    }
    Assertions.assertThat(actual).as("First Mile Zone Details is Correct").isEqualTo(expected);
  }

  @When("Operator search first mile zone by {string} short name")
  public void operatorSearchFirstMileZoneByShortName(String zoneShortName) {
    String shortName = resolveValue(zoneShortName);

  }
}