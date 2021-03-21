package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import org.hamcrest.Matchers;
import org.junit.platform.commons.util.StringUtils;

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

    String uniqueCode = generateDateUniqueString();
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

    if ("YES".equals(sortHub)) {
      hub.setSortHub(true);
    } else {
      hub.setSortHub(null);
    }

    put(KEY_CREATED_HUB, hub);
    putInList(KEY_LIST_OF_CREATED_HUBS, hub);

    facilitiesManagementPage.createNewHub(hub);
  }

  @Then("^Operator verify a new Hub is created successfully on Facilities Management page$")
  public void operatorVerifyANewHubIsCreatedSuccessfullyOnPageHubsAdministration() {
    Hub hub = get(KEY_CREATED_HUB);

    retryIfAssertionErrorOccurred(() ->
    {
      navigateRefresh();
      pause2s();
      facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(hub);
    }, "Unable to find the hub, retrying...");
  }

  @When("^Operator update Hub on page Hubs Administration using data below:$")
  public void operatorUpdateHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    Hub hub = get(KEY_CREATED_HUB);

    String facilityType = data.get("facilityType");
    String searchHubsKeyword = data.get("searchHubsKeyword");
    String name = data.get("name");
    String displayName = data.get("displayName");
    String city = data.get("city");
    String country = data.get("country");
    String latitude = data.get("latitude");
    String longitude = data.get("longitude");
    String sortHub = data.get("sortHub");

    if (hub == null) {
      hub = new Hub();
      put(KEY_CREATED_HUB, hub);
      putInList(KEY_LIST_OF_CREATED_HUBS, hub);
    }

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
    if ("YES".equals(sortHub)) {
      hub.setSortHub(true);
    } else {
      hub.setSortHub(null);
    }

    facilitiesManagementPage.updateHub(searchHubsKeyword, hub);
  }

  @Then("^Operator verify Hub is updated successfully on Facilities Management page$")
  public void operatorVerifyHubIsUpdatedSuccessfullyOnPageHubsAdministration() {
    Hub hub = get(KEY_CREATED_HUB);

    retryIfAssertionErrorOccurred(() ->
    {
      navigateRefresh();
      pause2s();
      facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(hub);
    }, "Unable to find the hub, retrying...");
  }

  @When("^Operator search Hub on page Hubs Administration using data below:$")
  public void operatorSearchHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data) {
    data = resolveKeyValues(data);
    String searchHubsKeyword = data.get("searchHubsKeyword");

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        Hub facilitiesManagementSearchResult = facilitiesManagementPage
            .searchHub(searchHubsKeyword);
        put(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT, facilitiesManagementSearchResult);
        put("searchHubsKeyword", searchHubsKeyword);
      } catch (Exception ex) {
        navigateRefresh();
        pause2s();
        throw ex;
      }
    }, "Unable to find the hub, retrying...", 1000, 10);
  }

  @Then("^Operator verify Hub is found on Facilities Management page and contains correct info$")
  public void operatorVerifyHubIsFoundOnPageHubsAdministrationAndContainsCorrectInfo() {
    String searchHubsKeyword = get("searchHubsKeyword");
    Hub expectedHub = get(KEY_CREATED_HUB);
    Hub actualHub = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

    assertNotNull(f("Search Hub with keyword = '%s' found nothing.", searchHubsKeyword), actualHub);
    assertEquals("Hub Name", expectedHub.getName(), actualHub.getName());
    assertEquals("Display Name", expectedHub.getShortName(), actualHub.getShortName());
    assertThat("City", expectedHub.getCity(), Matchers.equalToIgnoringCase(actualHub.getCity()));
    assertThat("Country", expectedHub.getCountry(),
        Matchers.equalToIgnoringCase(actualHub.getCountry()));
    assertEquals("Latitude", expectedHub.getLatitude(), actualHub.getLatitude());
    assertEquals("Longitude", expectedHub.getLongitude(), actualHub.getLongitude());
  }

  @When("^Operator download Hub CSV file on Facilities Management page$")
  public void operatorDownloadHubCsvFileOnPageHubsAdministration() {
    facilitiesManagementPage.downloadCsvFile.clickAndWaitUntilDone();
  }

  @Then("^Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info$")
  public void operatorVerifyHubCsvFileIsDownloadedSuccessfullyOnPageHubsAdministrationAndContainsCorrectInfo() {
    Hub hub = get(KEY_CREATED_HUB);
    facilitiesManagementPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(hub);
  }

  @When("^Operator refresh hubs cache on Facilities Management page$")
  public void operatorRefreshHubsCacheOnFacilitiesManagementPage() {
    facilitiesManagementPage.refresh.click();
    facilitiesManagementPage.waitUntilInvisibilityOfToast("Hub cache refreshed!", true);
  }

  @When("^Operator disable created hub on Facilities Management page$")
  public void operatorDisableCreatedHub() {
    Hub hub = get(KEY_CREATED_HUB);

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        facilitiesManagementPage.disableHub(hub.getName());
        hub.setActive(false);
      } catch (Exception ex) {
        navigateRefresh();
        pause2s();
        throw ex;
      }
    }, "Unable to find the hub, retrying...");
  }

  @When("Operator disable hub with name {string} on Facilities Management page")
  public void operatorDisableCreatedHub(String hubName) {
    Hub hub = new Hub();
    hub.setName(resolveValue(hubName));

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        facilitiesManagementPage.disableHub(hub.getName());
        hub.setActive(false);
      } catch (Exception ex) {
        navigateRefresh();
        pause2s();
        throw ex;
      }
    }, "Unable to find the hub, retrying...");
  }

  @When("^Operator activate created hub on Facilities Management page$")
  public void operatorActivateCreatedHub() {
    Hub hub = get(KEY_CREATED_HUB);
    facilitiesManagementPage.activateHub(hub.getName());
    hub.setActive(true);
  }

  @When("Operator activate hub with name {string} on Facilities Management page")
  public void operatorActivateCreatedHub(String hubName) {
    Hub hub = new Hub();
    hub.setName(resolveValue(hubName));

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      try {
        facilitiesManagementPage.activateHub(hub.getName());
        hub.setActive(true);
      } catch (Exception ex) {
        navigateRefresh();
        pause2s();
        throw ex;
      }
    }, "Unable to find the hub, retrying...");
  }

  @Then("Operator verify Hub {string}")
  public void operatorVerifyHubDataByColumn(String columnName) {
    Hub expectedHub = get(KEY_CREATED_HUB);
    Hub actualHub = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

    if ("facility type".equals(columnName)) {
      assertEquals("Facility Type Display", expectedHub.getFacilityTypeDisplay(),
          actualHub.getFacilityTypeDisplay());
    }
    if ("status".equals(columnName)) {
      assertEquals("Status", expectedHub.getActive(), actualHub.getActive());
    }
    if ("lat/long".equals(columnName)) {
      assertEquals("Hub latitude", expectedHub.getLatitude(),
          actualHub.getLatitude());
      assertEquals("Hub longitude", expectedHub.getLongitude(),
          actualHub.getLongitude());
    }
    if ("facility type and lat/long".equals(columnName)) {
      assertEquals("Facility Type Display", expectedHub.getFacilityTypeDisplay(),
          actualHub.getFacilityTypeDisplay());
      assertEquals("Hub latitude", expectedHub.getLatitude(),
          actualHub.getLatitude());
      assertEquals("Hub longitude", expectedHub.getLongitude(),
          actualHub.getLongitude());
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
