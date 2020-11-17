package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.platform.commons.util.StringUtils;

import java.util.Map;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class FacilitiesManagementSteps extends AbstractSteps
{
    private FacilitiesManagementPage facilitiesManagementPage;

    public FacilitiesManagementSteps()
    {
    }

    @Override
    public void init()
    {
        facilitiesManagementPage = new FacilitiesManagementPage(getWebDriver());
    }

    @When("^Operator create new Hub on page Hubs Administration using data below:$")
    public void operatorCreateNewHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data)
    {
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

        if ("GENERATED".equals(name))
        {
            name = "HUB DO NOT USE " + uniqueCode;
        }

        if ("GENERATED".equals(displayName))
        {
            displayName = "Hub DNS " + uniqueCode;
        }

        if ("GENERATED".equals(city))
        {
            city = address.getCity();
        }

        if ("GENERATED".equals(country))
        {
            country = address.getCountry();
        }

        Hub randomHub = HubFactory.getRandomHub();

        if ("GENERATED".equals(latitude))
        {
            latitude = String.valueOf(randomHub.getLatitude());
        }

        if ("GENERATED".equals(longitude))
        {
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

        if ("YES".equals(sortHub))
        {
            hub.setSortHub(true);
        } else {
            hub.setSortHub(null);
        }

        put(KEY_CREATED_HUB, hub);
        putInList(KEY_LIST_OF_CREATED_HUBS, hub);

        facilitiesManagementPage.createNewHub(hub);
    }

    @Then("^Operator verify a new Hub is created successfully on Facilities Management page$")
    public void operatorVerifyANewHubIsCreatedSuccessfullyOnPageHubsAdministration()
    {
        Hub hub = get(KEY_CREATED_HUB);

        retryIfAssertionErrorOccurred(() ->
        {
            navigateRefresh();
            pause2s();
            facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(hub);
        }, "Unable to find the hub, retrying...");
    }

    @When("^Operator update Hub on page Hubs Administration using data below:$")
    public void operatorUpdateHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data)
    {
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

        if (hub == null)
        {
            hub = new Hub();
            put(KEY_CREATED_HUB, hub);
            putInList(KEY_LIST_OF_CREATED_HUBS, hub);
        }

        Address address = AddressFactory.getRandomAddress();

        if ("GENERATED".equals(city))
        {
            city = address.getCity();
        }

        if ("GENERATED".equals(country))
        {
            country = address.getCountry();
        }

        Hub randomHub = HubFactory.getRandomHub();

        if ("GENERATED".equals(latitude))
        {
            latitude = String.valueOf(randomHub.getLatitude());
        }

        if ("GENERATED".equals(longitude))
        {
            longitude = String.valueOf(randomHub.getLongitude());
        }

        if (StringUtils.isNotBlank(facilityType))
        {
            hub.setFacilityType(facilityType);
        }
        if (StringUtils.isNotBlank(name))
        {
            hub.setName(name);
        }
        if (StringUtils.isNotBlank(displayName))
        {
            hub.setShortName(displayName);
        }
        if (StringUtils.isNotBlank(city))
        {
            hub.setCity(city);
        }
        if (StringUtils.isNotBlank(country))
        {
            hub.setCountry(country);
        }
        if (StringUtils.isNotBlank(latitude))
        {
            hub.setLatitude(Double.parseDouble(latitude));
        }
        if (StringUtils.isNotBlank(longitude))
        {
            hub.setLongitude(Double.parseDouble(longitude));
        }
        if ("YES".equals(sortHub))
        {
            hub.setSortHub(true);
        } else {
            hub.setSortHub(null);
        }

        facilitiesManagementPage.updateHub(searchHubsKeyword, hub);
    }

    @Then("^Operator verify Hub is updated successfully on Facilities Management page$")
    public void operatorVerifyHubIsUpdatedSuccessfullyOnPageHubsAdministration()
    {
        Hub hub = get(KEY_CREATED_HUB);

        retryIfAssertionErrorOccurred(() ->
        {
            navigateRefresh();
            pause2s();
            facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(hub);
        }, "Unable to find the hub, retrying...");
    }

    @When("^Operator search Hub on page Hubs Administration using data below:$")
    public void operatorSearchHubOnPageHubsAdministrationUsingDataBelow(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        String searchHubsKeyword = data.get("searchHubsKeyword");
        Hub facilitiesManagementSearchResult = facilitiesManagementPage.searchHub(searchHubsKeyword);
        put(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT, facilitiesManagementSearchResult);
        put("searchHubsKeyword", searchHubsKeyword);
    }

    @Then("^Operator verify Hub is found on Facilities Management page and contains correct info$")
    public void operatorVerifyHubIsFoundOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        String searchHubsKeyword = get("searchHubsKeyword");
        Hub expectedHub = get(KEY_CREATED_HUB);
        Hub actualHub = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

        assertNotNull(f("Search Hub with keyword = '%s' found nothing.", searchHubsKeyword), actualHub);
        assertEquals("Hub Name", expectedHub.getName(), actualHub.getName());
        assertEquals("Display Name", expectedHub.getShortName(), actualHub.getShortName());
        assertThat("City", expectedHub.getCity(), Matchers.equalToIgnoringCase(actualHub.getCity()));
        assertThat("Country", expectedHub.getCountry(), Matchers.equalToIgnoringCase(actualHub.getCountry()));
        assertEquals("Latitude", expectedHub.getLatitude(), actualHub.getLatitude());
        assertEquals("Longitude", expectedHub.getLongitude(), actualHub.getLongitude());
    }

    @When("^Operator download Hub CSV file on Facilities Management page$")
    public void operatorDownloadHubCsvFileOnPageHubsAdministration()
    {
        facilitiesManagementPage.downloadCsvFile.clickAndWaitUntilDone();
    }

    @Then("^Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info$")
    public void operatorVerifyHubCsvFileIsDownloadedSuccessfullyOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        Hub hub = get(KEY_CREATED_HUB);
        facilitiesManagementPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(hub);
    }

    @When("^Operator refresh hubs cache on Facilities Management page$")
    public void operatorRefreshHubsCacheOnFacilitiesManagementPage()
    {
        facilitiesManagementPage.refresh.click();
        facilitiesManagementPage.waitUntilInvisibilityOfToast("Hub cache refreshed!", true);
    }

    @When("^Operator disable created hub on Facilities Management page$")
    public void operatorDisableCreatedHub()
    {
        Hub hub = get(KEY_CREATED_HUB);
        facilitiesManagementPage.disableHub(hub.getName());
        hub.setActive(false);
    }

    @When("^Operator activate created hub on Facilities Management page$")
    public void operatorActivateCreatedHub()
    {
        Hub hub = get(KEY_CREATED_HUB);
        facilitiesManagementPage.activateHub(hub.getName());
        hub.setActive(true);
    }
}
