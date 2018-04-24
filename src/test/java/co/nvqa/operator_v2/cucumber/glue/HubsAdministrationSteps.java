package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.operator_v2.HubsAdministration;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.HubsAdministrationPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class HubsAdministrationSteps extends AbstractSteps
{
    private HubsAdministrationPage hubsAdministrationPage;

    @Inject
    public HubsAdministrationSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        hubsAdministrationPage = new HubsAdministrationPage(getWebDriver());
    }

    private String getFromCreatedHubName(String searchHubsKeyword, HubsAdministration hubsAdministration)
    {
        String result = searchHubsKeyword;

        if("GET_FROM_CREATED_HUB_NAME".equals(searchHubsKeyword))
        {
            String hubName = null;

            if(hubsAdministration!=null)
            {
                hubName = hubsAdministration.getName();
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
        String name = mapOfData.get("name");
        String displayName = mapOfData.get("displayName");
        String city = mapOfData.get("city");
        String country = mapOfData.get("country");
        String latitude = mapOfData.get("latitude");
        String longitude = mapOfData.get("longitude");

        String uniqueCode = generateDateUniqueString();
        String uniqueCoordinate = uniqueCode.substring(6);
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

        if("GENERATED".equals(latitude))
        {
            latitude = "1."+uniqueCoordinate;
        }

        if("GENERATED".equals(longitude))
        {
            longitude = "103."+uniqueCoordinate;
        }

        HubsAdministration hubsAdministration = new HubsAdministration();
        hubsAdministration.setName(name);
        hubsAdministration.setDisplayName(displayName);
        hubsAdministration.setCity(city);
        hubsAdministration.setCountry(country);
        hubsAdministration.setLatitude(Double.parseDouble(latitude));
        hubsAdministration.setLongitude(Double.parseDouble(longitude));
        hubsAdministrationPage.createNewHub(hubsAdministration);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Hub Name", hubsAdministration.getName());
        mapOfInfo.put("Hub Display Name", hubsAdministration.getDisplayName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));

        put(KEY_HUBS_ADMINISTRATION, hubsAdministration);
        putInList(KEY_LIST_OF_HUBS_ADMINISTRATION, hubsAdministration);
    }

    @Then("^Operator verify a new Hub is created successfully on page Hubs Administration$")
    public void operatorVerifyANewHubIsCreatedSuccessfullyOnPageHubsAdministration()
    {
        HubsAdministration hubsAdministration = get(KEY_HUBS_ADMINISTRATION);
        hubsAdministrationPage.verifyHubIsExistAndDataIsCorrect(hubsAdministration);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Hub ID", String.valueOf(hubsAdministration.getId()));
        mapOfInfo.put("Hub Name", hubsAdministration.getName());
        mapOfInfo.put("Hub Display Name", hubsAdministration.getDisplayName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));
    }

    @When("^Operator update Hub on page Hubs Administration using data below:$")
    public void operatorUpdateHubOnPageHubsAdministrationUsingDataBelow(Map<String,String> mapOfData)
    {
        HubsAdministration hubsAdministration = get(KEY_HUBS_ADMINISTRATION);

        String searchHubsKeyword = mapOfData.get("searchHubsKeyword");
        String name = mapOfData.get("name");
        String displayName = mapOfData.get("displayName");
        String city = mapOfData.get("city");
        String country = mapOfData.get("country");
        String latitude = mapOfData.get("latitude");
        String longitude = mapOfData.get("longitude");

        searchHubsKeyword = getFromCreatedHubName(searchHubsKeyword, hubsAdministration);

        if(hubsAdministration==null)
        {
            hubsAdministration = new HubsAdministration();
            put(KEY_HUBS_ADMINISTRATION, hubsAdministration);
            putInList(KEY_LIST_OF_HUBS_ADMINISTRATION, hubsAdministration);
        }

        String uniqueCode = generateDateUniqueString();
        String uniqueCoordinate = uniqueCode.substring(6);
        Address address = AddressFactory.getRandomAddress();

        if("GENERATED".equals(name))
        {
            String temp = hubsAdministration.getName();
            name = temp==null? "HUB DO NOT USE "+uniqueCode : temp + " [E]";
        }

        if("GENERATED".equals(displayName))
        {
            String temp = hubsAdministration.getDisplayName();
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

        if("GENERATED".equals(latitude))
        {
            latitude = "1."+uniqueCoordinate;
        }

        if("GENERATED".equals(longitude))
        {
            longitude = "103."+uniqueCoordinate;
        }

        hubsAdministration.setName(name);
        hubsAdministration.setDisplayName(displayName);
        hubsAdministration.setCity(city);
        hubsAdministration.setCountry(country);
        hubsAdministration.setLatitude(Double.parseDouble(latitude));
        hubsAdministration.setLongitude(Double.parseDouble(longitude));

        hubsAdministrationPage.updateHub(searchHubsKeyword, hubsAdministration);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Hub ID", String.valueOf(hubsAdministration.getId()));
        mapOfInfo.put("Hub Name", hubsAdministration.getName());
        mapOfInfo.put("Hub Display Name", hubsAdministration.getDisplayName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));
    }

    @Then("^Operator verify Hub is updated successfully on page Hubs Administration$")
    public void operatorVerifyHubIsUpdatedSuccessfullyOnPageHubsAdministration()
    {
        HubsAdministration hubsAdministration = get(KEY_HUBS_ADMINISTRATION);
        hubsAdministrationPage.verifyHubIsExistAndDataIsCorrect(hubsAdministration);
    }

    @When("^Operator search Hub on page Hubs Administration using data below:$")
    public void operatorSearchHubOnPageHubsAdministrationUsingDataBelow(Map<String,String> mapOfData)
    {
        HubsAdministration hubsAdministration = get(KEY_HUBS_ADMINISTRATION);
        String searchHubsKeyword = getFromCreatedHubName(mapOfData.get("searchHubsKeyword"), hubsAdministration);
        HubsAdministration hubsAdministrationSearchResult = hubsAdministrationPage.searchHub(searchHubsKeyword);
        put(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT, hubsAdministrationSearchResult);
        put("searchHubsKeyword", searchHubsKeyword);
    }

    @Then("^Operator verify Hub is found on page Hubs Administration and contains correct info$")
    public void operatorVerifyHubIsFoundOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        String searchHubsKeyword = get("searchHubsKeyword");
        HubsAdministration expectedHubsAdministration = get(KEY_HUBS_ADMINISTRATION);
        HubsAdministration actualHubsAdministration = get(KEY_HUBS_ADMINISTRATION_SEARCH_RESULT);

        Assert.assertNotNull(String.format("Search Hub with keyword = '%s' found nothing.", searchHubsKeyword), actualHubsAdministration);
        Assert.assertEquals("Hub Name", expectedHubsAdministration.getName(), actualHubsAdministration.getName());
        Assert.assertEquals("Display Name", expectedHubsAdministration.getDisplayName(), actualHubsAdministration.getDisplayName());
        Assert.assertThat("City", actualHubsAdministration.getCity(), Matchers.equalToIgnoringCase(expectedHubsAdministration.getCity()));
        Assert.assertThat("Country", actualHubsAdministration.getCountry(), Matchers.equalToIgnoringCase(expectedHubsAdministration.getCountry()));
        Assert.assertEquals("Latitude", expectedHubsAdministration.getLatitude(), actualHubsAdministration.getLatitude());
        Assert.assertEquals("Longitude", expectedHubsAdministration.getLongitude(), actualHubsAdministration.getLongitude());
    }

    @When("^Operator download Hub CSV file on page Hubs Administration$")
    public void operatorDownloadHubCsvFileOnPageHubsAdministration()
    {
        hubsAdministrationPage.downloadCsvFile();
    }

    @Then("^Operator verify Hub CSV file is downloaded successfully on page Hubs Administration and contains correct info$")
    public void operatorVerifyHubCsvFileIsDownloadedSuccessfullyOnPageHubsAdministrationAndContainsCorrectInfo()
    {
        HubsAdministration hubsAdministration = get(KEY_HUBS_ADMINISTRATION);
        hubsAdministrationPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(hubsAdministration);
    }
}
