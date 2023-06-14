package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.junit.platform.commons.util.StringUtils;

import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.COLUMN_NAME;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class FacilitiesManagementSteps extends AbstractSteps {

  private FacilitiesManagementPage facilitiesManagementPage;
  private static final String HUB_CD_CD = "CD->CD";
  private static final String HUB_CD_ITS_ST = "CD->its ST";
  private static final String HUB_CD_ST_DIFF_CD = "CD->ST under another CD";
  private static final String HUB_ST_ST_SAME_CD = "ST->ST under same CD";
  private static final String HUB_ST_ST_DIFF_CD = "ST->ST under diff CD";
  private static final String HUB_ST_ITS_CD = "ST->its CD";
  private static final String HUB_ST_CD_DIFF_CD = "ST->another CD";

  public FacilitiesManagementSteps() {
  }

  @Override
  public void init() {
    facilitiesManagementPage = new FacilitiesManagementPage(getWebDriver());
  }

  @When("^Operator create new Hub on page Hubs Administration using data below:$")
  public void operatorCreateNewHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data) {
    facilitiesManagementPage.switchTo();
    data = resolveKeyValues(data);

    String name = data.get("name");
    String displayName = data.get("displayName");
    String city = data.get("city");
    String country = data.get("country");
    String latitude = data.get("latitude");
    String longitude = data.get("longitude");
    String facilityType = data.get("facilityType");
    String region = data.get("region");
    String sortHub = data.get("sortHub");

    String uniqueCode = StandardTestUtils.generateDateUniqueString();
    Address address = AddressFactory.getRandomAddress();

    if ("GENERATED".equals(name)) {
      name = "HUB DO NOT USE " + uniqueCode;
    }

    if ("GENERATED".equals(displayName)) {
      displayName = "Hub DNS " + uniqueCode;
    }

    if ("GENERATED".equals(city)) {
      city = address.getCity();
    }

    if ("GENERATED".equals(country)) {
      country = address.getCountry();
    }

    Hub randomHub = HubFactory.getRandomHub();

    if ("GENERATED".equals(latitude)) {
      latitude = String.valueOf(randomHub.getLatitude());
    }

    if ("GENERATED".equals(longitude)) {
      longitude = String.valueOf(randomHub.getLongitude());
    }

    Hub hub = new Hub();
    hub.setName(name);
    hub.setShortName(displayName);
    hub.setCountry(country);
    hub.setCity(city);
    hub.setLatitude(Double.parseDouble(latitude));
    hub.setLongitude(Double.parseDouble(longitude));
    hub.setFacilityType(facilityType);
    hub.setRegion(region);
    hub.setSortHub(sortHub);

    put(KEY_CREATED_HUB, hub);
    putInList(KEY_LIST_OF_CREATED_HUBS, hub);

    facilitiesManagementPage.inFrame(page -> page.createNewHub(hub));
  }

  @Then("^Operator verify hub parameters on Facilities Management page:$")
  public void verifyHubParameters(Map<String, String> data) {
    Hub expected = new Hub(resolveKeyValues(data));
    facilitiesManagementPage.inFrame(page -> {
      page.hubsTable.filterByColumn(COLUMN_NAME, expected.getName());
      Assertions.assertThat(page.hubsTable.isEmpty())
          .as("Hub with name [%s] was found", expected.getName()).isFalse();
      Hub actual = page.hubsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("^Operator update Hub on page Hubs Administration using data below:$")
  public void operatorUpdateHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    Hub hub;
    if (get(KEY_CREATED_HUB) != null) {
      hub = get(KEY_CREATED_HUB);
    } else {
      hub = new Hub();
      put(KEY_CREATED_HUB, hub);
      putInList(KEY_LIST_OF_CREATED_HUBS, hub);
    }

    String facilityType = data.get("facilityType");
    String searchHubsKeyword = data.get("searchHubsKeyword");
    String name = data.get("name");
    String displayName = data.get("displayName");
    String city = data.get("city");
    String country = data.get("country");
    String latitude = data.get("latitude");
    String longitude = data.get("longitude");
    String sortHub = data.get("sortHub");

    Address address = AddressFactory.getRandomAddress();

    if ("GENERATED".equals(city)) {
      city = address.getCity();
    }

    if ("GENERATED".equals(country)) {
      country = address.getCountry();
    }

    Hub randomHub = HubFactory.getRandomHub();

    if ("GENERATED".equals(latitude)) {
      latitude = String.valueOf(randomHub.getLatitude());
    }

    if ("GENERATED".equals(longitude)) {
      longitude = String.valueOf(randomHub.getLongitude());
    }

    if (StringUtils.isNotBlank(facilityType)) {
      hub.setFacilityType(facilityType);
    }
    if (StringUtils.isNotBlank(name)) {
      hub.setName(name);
    }
    if (StringUtils.isNotBlank(displayName)) {
      hub.setShortName(displayName);
    }
    if (StringUtils.isNotBlank(city)) {
      hub.setCity(city);
    }
    if (StringUtils.isNotBlank(country)) {
      hub.setCountry(country);
    }
    if (StringUtils.isNotBlank(latitude)) {
      hub.setLatitude(Double.parseDouble(latitude));
    }
    if (StringUtils.isNotBlank(longitude)) {
      hub.setLongitude(Double.parseDouble(longitude));
    }
    hub.setSortHub(sortHub);

    facilitiesManagementPage.inFrame(
        page -> facilitiesManagementPage.updateHub(searchHubsKeyword, hub));
  }

  @When("^Operator search Hub on page Hubs Administration using data below:$")
  public void operatorSearchHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    String searchHubsKeyword = data.get("searchHubsKeyword");
    Hub facilitiesManagementSearchResult = facilitiesManagementPage.searchHub(searchHubsKeyword);
    put(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT, facilitiesManagementSearchResult);
    put("searchHubsKeyword", searchHubsKeyword);
  }

  @When("^Operator download Hub CSV file on Facilities Management page$")
  public void operatorDownloadHubCsvFileOnPageHubsAdministration() {
    facilitiesManagementPage.inFrame(page -> page.downloadCsvFile.click());
  }

  @Then("^Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info$")
  public void operatorVerifyHubCsvFileIsDownloadedSuccessfullyOnPageHubsAdministrationAndContainsCorrectInfo() {
    Hub hub = get(KEY_CREATED_HUB);
    facilitiesManagementPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(hub);
  }

  @When("^Operator refresh hubs cache on Facilities Management page$")
  public void operatorRefreshHubsCacheOnFacilitiesManagementPage() {
    facilitiesManagementPage.inFrame(page -> {
      facilitiesManagementPage.refresh.click();
      facilitiesManagementPage.waitUntilVisibilityOfNotification("Hub Cache Refreshed");
      pause2s();
    });
  }

  @When("^Operator disable created hub on Facilities Management page$")
  public void operatorDisableCreatedHub() {
    Hub hub = get(KEY_CREATED_HUB);
    facilitiesManagementPage.inFrame(page -> page.disableHub(hub.getName()));
    hub.setActive(false);
  }

  @When("Operator disable hub with name {string} on Facilities Management page")
  public void operatorDisableCreatedHub(String hubName) {
    Hub hub = new Hub();
    hub.setName(resolveValue(hubName));

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      try {
        facilitiesManagementPage.disableHub(hub.getName());
        hub.setActive(false);
      } catch (Exception ex) {
        navigateRefresh();
        throw ex;
      }
    }, "Unable to find the hub, retrying...");
  }

  @When("^Operator activate created hub on Facilities Management page$")
  public void operatorActivateCreatedHub() {
    Hub hub = get(KEY_CREATED_HUB);
    facilitiesManagementPage.inFrame(page -> page.activateHub(hub.getName()));
    hub.setActive(true);
  }

  @When("Operator activate hub with name {string} on Facilities Management page")
  public void operatorActivateCreatedHub(String hubName) {
    Hub hub = new Hub();
    hub.setName(resolveValue(hubName));

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      try {
        facilitiesManagementPage.activateHub(hub.getName());
        hub.setActive(true);
      } catch (Exception ex) {
        navigateRefresh();
        throw ex;
      }
    }, "Unable to find the hub, retrying...");
  }

  @Then("Operator verify Hub {string}")
  public void operatorVerifyHubDataByColumn(String columnName) {
    Hub expectedHub = get(KEY_CREATED_HUB);
    Hub actualHub = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

    if ("facility type".equals(columnName)) {
     Assertions.assertThat(          actualHub.getFacilityTypeDisplay()).as("Facility Type Display").isEqualTo(expectedHub.getFacilityTypeDisplay());
    }
    if ("status".equals(columnName)) {
     Assertions.assertThat(actualHub.getActive()).as("Status").isEqualTo(expectedHub.getActive());
    }
    if ("lat/long".equals(columnName)) {
     Assertions.assertThat(actualHub.getLatitude()).as("Hub latitude").isEqualTo(expectedHub.getLatitude());
     Assertions.assertThat(actualHub.getLongitude()).as("Hub longitude").isEqualTo(expectedHub.getLongitude());
    }
    if ("facility type and lat/long".equals(columnName)) {
     Assertions.assertThat(          actualHub.getFacilityTypeDisplay()).as("Facility Type Display").isEqualTo(expectedHub.getFacilityTypeDisplay());
     Assertions.assertThat(actualHub.getLatitude()).as("Hub latitude").isEqualTo(expectedHub.getLatitude());
     Assertions.assertThat(actualHub.getLongitude()).as("Hub longitude").isEqualTo(expectedHub.getLongitude());
    }
  }

  @When("Operator update Hub column {string} with data:")
  public void operatorUpdateHubWithData(String columnName, Map<String, String> mapOfData) {
    Hub hub = get(KEY_CREATED_HUB);
    String beforeType = hub.getFacilityType();
    if ("facility type".equals(columnName)) {
      hub.setFacilityType(mapOfData.get("facilityType"));
    }
    if ("lat/long".equals(columnName)) {
      Double latitude = Double.valueOf(resolveValue(mapOfData.get("latitude")));
      Double longitude = Double.valueOf(resolveValue(mapOfData.get("longitude")));
      hub.setLatitude(latitude);
      hub.setLongitude(longitude);
    }
    if ("facility type and lat/long".equals(columnName)) {
      Double latitude = Double.valueOf(mapOfData.get("latitude"));
      Double longitude = Double.valueOf(mapOfData.get("longitude"));
      hub.setLatitude(latitude);
      hub.setLongitude(longitude);
      hub.setFacilityType(mapOfData.get("facilityType"));
    }
    facilitiesManagementPage.updateHubByColumn(hub, columnName, beforeType);
  }

  @And("Operator update hub column facility type for first hub into type {string}")
  public void operatorRevertHubColumnFacilityTypeForHubWithType(String updatedFacilityType) {
    List<Hub> hub = get(KEY_LIST_OF_CREATED_HUBS);
    String beforeType = hub.get(0).getFacilityType();
    hub.get(0).setFacilityType(updatedFacilityType);
    facilitiesManagementPage.updateHubByColumn(hub.get(0), "facility type", beforeType);
  }

  @And("Operator update hub column longitude latitude for first hub into {string} and {string}")
  public void operatorUpdateLongitudeLatitudeForHub(String longitude, String latitude) {
    List<Hub> hubs = get(KEY_LIST_OF_CREATED_HUBS);
    Hub hub = hubs.get(0);
    String beforeType = hub.getFacilityType();
    Hub updateHub = new Hub();
    updateHub.setName(hub.getName());
    updateHub.setLatitude(Double.valueOf(resolveValue(latitude)));
    updateHub.setLongitude(Double.valueOf(resolveValue(longitude)));
    facilitiesManagementPage.updateHubByColumn(updateHub, "lat/long", beforeType);
  }

  @When("Operator revert hub column facility type for first hub for type {string}")
  public void operatorRevertHubColumnFacilityTypeForFirstHubForType(String movementType) {
    List<Hub> hub = get(KEY_LIST_OF_CREATED_HUBS);
    String beforeType = hub.get(0).getFacilityType();
    switch (movementType) {
      case HUB_CD_CD:
      case HUB_CD_ITS_ST:
      case HUB_CD_ST_DIFF_CD:
        hub.get(0).setFacilityType("crossdock hub");
        break;
      case HUB_ST_ITS_CD:
      case HUB_ST_CD_DIFF_CD:
      case HUB_ST_ST_SAME_CD:
      case HUB_ST_ST_DIFF_CD:
        hub.get(0).setFacilityType("station");
        break;
    }
    facilitiesManagementPage.updateHubByColumn(hub.get(0), "facility type", beforeType);
    pause5s();
  }
}