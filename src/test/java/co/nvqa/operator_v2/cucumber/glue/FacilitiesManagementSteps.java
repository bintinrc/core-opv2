package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.model.operator_v2.FacilitiesManagement;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.factory.HubFactory;
import co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;

import java.util.Map;

/**
 *
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

    private String getFromCreatedHubName(String searchHubsKeyword, FacilitiesManagement facilitiesManagement)
    {
        String result = searchHubsKeyword;

        if("GET_FROM_CREATED_HUB_NAME".equals(searchHubsKeyword))
        {
            String hubName = null;

            if(facilitiesManagement!=null)
            {
                hubName = facilitiesManagement.getName();
            }

            if(hubName!=null)
            {
                result = hubName;
            }
            else
            {
                throw new NvTestRuntimeException("Could not find created hub.");
            }
        }

        return result;
    }

    @When("^Operator create new Hub on page Hubs Administration using data below:$")
    public void operatorCreateNewHubOnPageHubsAdministrationUsingDataBelow(Map<String,String> mapOfData)
    {
        mapOfData = resolveKeyValues(mapOfData);

        String name = mapOfData.get("name");
        String displayName = mapOfData.get("displayName");
        String type = mapOfData.get("type");
        String city = mapOfData.get("city");
        String country = mapOfData.get("country");
        String latitude = mapOfData.get("latitude");
        String longitude = mapOfData.get("longitude");

        String uniqueCode = generateDateUniqueString();
        Address address = AddressFactory.getRandomAddress();

        if("GENERATED".equals(name))
        {
            name = "HUB DO NOT USE "+uniqueCode;
        }

        if("GENERATED".equals(displayName))
        {
            displayName = "Hub DNS "+uniqueCode;
        }

        if("GENERATED".equals(city))
        {
            city = address.getCity();
        }

        if("GENERATED".equals(country))
        {
            country = address.getCountry();
        }

        Hub randomHub = HubFactory.getRandomHub();

        if("GENERATED".equals(latitude))
        {
            latitude = String.valueOf(randomHub.getLatitude());
        }

        if("GENERATED".equals(longitude))
        {
            longitude = String.valueOf(randomHub.getLongitude());
        }

        FacilitiesManagement facilitiesManagement = new FacilitiesManagement();
        facilitiesManagement.setName(name);
        facilitiesManagement.setDisplayName(displayName);
        facilitiesManagement.setType(type);
        facilitiesManagement.setCity(city);
        facilitiesManagement.setCountry(country);
        facilitiesManagement.setLatitude(Double.parseDouble(latitude));
        facilitiesManagement.setLongitude(Double.parseDouble(longitude));
        facilitiesManagementPage.createNewHub(facilitiesManagement);

        put(KEY_HUBS_ADMINISTRATION, facilitiesManagement);
        putInList(KEY_LIST_OF_HUBS_ADMINISTRATION, facilitiesManagement);
    }

    @Then("^Operator verify a new Hub is created successfully on page Hubs Administration$")
    public void operatorVerifyANewHubIsCreatedSuccessfullyOnPageHubsAdministration()
    {
        FacilitiesManagement facilitiesManagement = get(KEY_HUBS_ADMINISTRATION);
        facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(facilitiesManagement);
    }

    @When("^Operator update Hub on page Hubs Administration using data below:$")
    public void operatorUpdateHubOnPageHubsAdministrationUsingDataBelow(Map<String,String> mapOfData)
    {
        FacilitiesManagement facilitiesManagement = get(KEY_HUBS_ADMINISTRATION);

        String searchHubsKeyword = mapOfData.get("searchHubsKeyword");
        String name = mapOfData.get("name");
        String displayName = mapOfData.get("displayName");
        String city = mapOfData.get("city");
        String country = mapOfData.get("country");
        String latitude = mapOfData.get("latitude");
        String longitude = mapOfData.get("longitude");

        searchHubsKeyword = getFromCreatedHubName(searchHubsKeyword, facilitiesManagement);

        if(facilitiesManagement==null)
        {
            facilitiesManagement = new FacilitiesManagement();
            put(KEY_HUBS_ADMINISTRATION, facilitiesManagement);
            putInList(KEY_LIST_OF_HUBS_ADMINISTRATION, facilitiesManagement);
        }

        String uniqueCode = generateDateUniqueString();
        Address address = AddressFactory.getRandomAddress();

        if("GENERATED".equals(name))
        {
            String temp = facilitiesManagement.getName();
            name = temp==null? "HUB DO NOT USE "+uniqueCode : temp + " [E]";
        }

        if("GENERATED".equals(displayName))
        {
            String temp = facilitiesManagement.getDisplayName();
            displayName = temp==null? "Hub DNS "+uniqueCode : temp + " [E]";
        }

        if("GENERATED".equals(city))
        {
            city = address.getCity();
        }

        if("GENERATED".equals(country))
        {
            country = address.getCountry();
        }

        Hub randomHub = HubFactory.getRandomHub();

        if("GENERATED".equals(latitude))
        {
            latitude = String.valueOf(randomHub.getLatitude());
        }

        if("GENERATED".equals(longitude))
        {
            longitude = String.valueOf(randomHub.getLongitude());
        }

        facilitiesManagement.setName(name);
        facilitiesManagement.setDisplayName(displayName);
        facilitiesManagement.setCity(city);
        facilitiesManagement.setCountry(country);
        facilitiesManagement.setLatitude(Double.parseDouble(latitude));
        facilitiesManagement.setLongitude(Double.parseDouble(longitude));

        facilitiesManagementPage.updateHub(searchHubsKeyword, facilitiesManagement);
    }

    @Then("^Operator verify Hub is updated successfully on page Hubs Administration$")
    public void operatorVerifyHubIsUpdatedSuccessfullyOnPageHubsAdministration()
    {
        FacilitiesManagement facilitiesManagement = get(KEY_HUBS_ADMINISTRATION);
        facilitiesManagementPage.verifyHubIsExistAndDataIsCorrect(facilitiesManagement);
    }

    @When("^Operator search Hub on page Hubs Administration using data below:$")
    public void operatorSearchHubOnPageHubsAdministrationUsingDataBelow(Map<String,String> mapOfData)
    {
        FacilitiesManagement facilitiesManagement = get(KEY_HUBS_ADMINISTRATION);
        String searchHubsKeyword = getFromCreatedHubName(mapOfData.get("searchHubsKeyword"), facilitiesManagement);
        FacilitiesManagement facilitiesManagementSearchResult = facilitiesManagementPage.searchHub(searchHubsKeyword);
        put(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT, facilitiesManagementSearchResult);
        put("searchHubsKeyword", searchHubsKeyword);
    }

    @Then("^Operator verify Hub is found on page Hubs Administration and contains correct info$")
    public void operatorVerifyHubIsFoundOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        String searchHubsKeyword = get("searchHubsKeyword");
        FacilitiesManagement expectedFacilitiesManagement = get(KEY_HUBS_ADMINISTRATION);
        FacilitiesManagement actualFacilitiesManagement = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

        assertNotNull(f("Search Hub with keyword = '%s' found nothing.", searchHubsKeyword), actualFacilitiesManagement);
        assertEquals("Hub Name", expectedFacilitiesManagement.getName(), actualFacilitiesManagement.getName());
        assertEquals("Display Name", expectedFacilitiesManagement.getDisplayName(), actualFacilitiesManagement.getDisplayName());
        assertThat("City", actualFacilitiesManagement.getCity(), Matchers.equalToIgnoringCase(expectedFacilitiesManagement.getCity()));
        assertThat("Country", actualFacilitiesManagement.getCountry(), Matchers.equalToIgnoringCase(expectedFacilitiesManagement.getCountry()));
        assertEquals("Latitude", expectedFacilitiesManagement.getLatitude(), actualFacilitiesManagement.getLatitude());
        assertEquals("Longitude", expectedFacilitiesManagement.getLongitude(), actualFacilitiesManagement.getLongitude());
    }

    @When("^Operator download Hub CSV file on page Hubs Administration$")
    public void operatorDownloadHubCsvFileOnPageHubsAdministration()
    {
        facilitiesManagementPage.downloadCsvFile();
    }

    @Then("^Operator verify Hub CSV file is downloaded successfully on page Hubs Administration and contains correct info$")
    public void operatorVerifyHubCsvFileIsDownloadedSuccessfullyOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        FacilitiesManagement facilitiesManagement = get(KEY_HUBS_ADMINISTRATION);
        facilitiesManagementPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(facilitiesManagement);
    }
}
