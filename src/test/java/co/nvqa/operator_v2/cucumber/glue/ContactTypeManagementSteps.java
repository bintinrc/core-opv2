package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ContactType;
import co.nvqa.operator_v2.selenium.page.ContactTypeManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ContactTypeManagementSteps extends AbstractSteps
{
    private ContactTypeManagementPage contactTypeManagementPage;

    @Inject
    public ContactTypeManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        contactTypeManagementPage = new ContactTypeManagementPage(getWebDriver());
    }

    private String getFromCreatedContactTypeName(String searchContactTypesKeyword, ContactType contactType)
    {
        String result = searchContactTypesKeyword;

        if("GET_FROM_CREATED_CONTACT_TYPE_NAME".equals(searchContactTypesKeyword))
        {
            String contactTypeName = null;

            if(contactType!=null)
            {
                contactTypeName = contactType.getName();
            }

            if(contactTypeName!=null)
            {
                result = contactTypeName;
            }
            else
            {
                throw new NvTestRuntimeException("Could not find created hub.");
            }
        }

        return result;
    }

    @When("^Operator create new Contact Type on page Contact Type Management using data below:$")
    public void operatorCreateNewContactTypeOnPageContactTypeManagementUsingDataBelow(Map<String,String> mapOfData)
    {
        String name = mapOfData.get("name");

        String uniqueCode = generateDateUniqueString();

        if("GENERATED".equals(name))
        {
            name = "CONTACT_TYPE_DO_NOT_USE_"+uniqueCode;
        }

        ContactType contactType = new ContactType();
        contactType.setName(name);
        contactTypeManagementPage.createNewContactType(contactType);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Contact Type - Name", contactType.getName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));

        put(KEY_CONTACT_TYPE, contactType);
    }

    @Then("^Operator verify a new Contact Type is created successfully on page Contact Type Management$")
    public void operatorVerifyANewHubIsCreatedSuccessfullyOnPageHubsAdministration()
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);
        contactTypeManagementPage.verifyContactTypeIsExistAndDataIsCorrect(contactType);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Contact Type - ID", String.valueOf(contactType.getId()));
        mapOfInfo.put("Contact Type - Name", contactType.getName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));
    }

    @When("^Operator update Contact Type on page Contact Type Management using data below:$")
    public void operatorUpdateContactTypeOnPageContactTypeManagementUsingDataBelow(Map<String,String> mapOfData)
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);

        String searchContactTypesKeyword = mapOfData.get("searchContactTypesKeyword");
        String name = mapOfData.get("name");

        searchContactTypesKeyword = getFromCreatedContactTypeName(searchContactTypesKeyword, contactType);

        if(contactType==null)
        {
            contactType = new ContactType();
            put(KEY_CONTACT_TYPE, contactType);
        }

        String uniqueCode = generateDateUniqueString();

        if("GENERATED".equals(name))
        {
            String temp = contactType.getName();
            name = temp==null? "CONTACT_TYPE_DO_NOT_USE_"+uniqueCode : temp + " [EDITED]";
        }

        contactType.setName(name);
        contactTypeManagementPage.updateContactType(searchContactTypesKeyword, contactType);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Search Contact Types Keyword", searchContactTypesKeyword);
        mapOfInfo.put("Contact Type - ID", String.valueOf(contactType.getId()));
        mapOfInfo.put("Contact Type - Name", contactType.getName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));
    }

    @Then("^Operator verify Contact Type is updated successfully on page Contact Type Management$")
    public void operatorVerifyContactTypeIsUpdatedSuccessfullyOnPageContactTypeManagement()
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);
        contactTypeManagementPage.verifyContactTypeIsExistAndDataIsCorrect(contactType);
    }

    @When("^Operator delete Contact Type on page Contact Type Management using data below:$")
    public void operatorDeleteContactTypeOnPageContactTypeManagementUsingDataBelow(Map<String,String> mapOfData)
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);

        String searchContactTypesKeyword = mapOfData.get("searchContactTypesKeyword");
        searchContactTypesKeyword = getFromCreatedContactTypeName(searchContactTypesKeyword, contactType);
        contactTypeManagementPage.deleteContactType(searchContactTypesKeyword);

        Map<String,String> mapOfInfo = new LinkedHashMap<>();
        mapOfInfo.put("Search Contact Types Keyword", searchContactTypesKeyword);
        mapOfInfo.put("Contact Type - ID", String.valueOf(contactType.getId()));
        mapOfInfo.put("Contact Type - Name", contactType.getName());
        writeToCurrentScenarioLogf(generateHtmlTableInfo(mapOfInfo));

        put("searchContactTypesKeyword", searchContactTypesKeyword);
    }

    @Then("^Operator verify Contact Type is deleted successfully on page Contact Type Management$")
    public void operatorVerifyContactTypeIsDeletedSuccessfullyOnPageContactTypeManagement()
    {
        String searchContactTypesKeyword = get("searchContactTypesKeyword");
        contactTypeManagementPage.verifyContactTypeIsNotExistAnymore(searchContactTypesKeyword);
    }

    @When("^Operator search Contact Type on page Contact Type Management using data below:$")
    public void operatorSearchContactTypeOnPageContactTypeManagementUsingDataBelow(Map<String,String> mapOfData)
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);
        String searchContactTypesKeyword = getFromCreatedContactTypeName(mapOfData.get("searchContactTypesKeyword"), contactType);
        ContactType contactTypeSearchResult = contactTypeManagementPage.searchContactType(searchContactTypesKeyword);
        put(KEY_CONTACT_TYPE_SEARCH_RESULT, contactTypeSearchResult);
        put("searchContactTypesKeyword", searchContactTypesKeyword);
    }

    @Then("^Operator verify Contact Type is found on page Contact Type Management and contains correct info$")
    public void operatorVerifyContactTypeIsFoundOnPageContactTypeManagementAndContainsCorrectInfo()
    {
        String searchContactTypesKeyword = get("searchContactTypesKeyword");
        ContactType expectedContactType = get(KEY_CONTACT_TYPE);
        ContactType actualContactType = get(KEY_CONTACT_TYPE_SEARCH_RESULT);

        Assert.assertNotNull(f("Search Contact Type with keyword = '%s' found nothing.", searchContactTypesKeyword), actualContactType);
        Assert.assertEquals("Contact Type", expectedContactType.getName(), actualContactType.getName());
    }

    @When("^Operator download Contact Type CSV file on page Contact Type Management$")
    public void operatorDownloadContactTypeCsvFileOnPageContactTypeManagement()
    {
        contactTypeManagementPage.downloadCsvFile();
    }

    @Then("^Operator verify Contact Type CSV file is downloaded successfully and contains correct info$")
    public void operatorVerifyContactTypeCsvFileIsDownloadedSuccessfullyAndContainsCorrectInfo()
    {
        ContactType contactType = get(KEY_CONTACT_TYPE);
        contactTypeManagementPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(contactType);
    }
}
