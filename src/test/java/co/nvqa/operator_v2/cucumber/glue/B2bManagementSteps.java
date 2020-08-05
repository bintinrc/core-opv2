package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.selenium.page.B2bManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.util.List;

/**
 * @author Lanang Jati
 */
public class B2bManagementSteps extends AbstractSteps
{
    private B2bManagementPage b2bManagementPage;

    @Override
    public void init()
    {
        b2bManagementPage = new B2bManagementPage(getWebDriver());
    }

    @Then("QA verify b2b management page is displayed")
    public void qaVerifyBBManagementPageIsDisplayed()
    {
        b2bManagementPage.onDisplay();
    }

    @And("QA verify correct master shippers are displayed on b2b management page")
    public void qaVerifyCorrectMasterShippersAreDisplayedOnBBManagementPage()
    {
        List<Shipper> masterShipper = get(KEY_LIST_OF_B2B_MASTER_SHIPPER);
        List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipper().readAllEntities();
        boolean isExist;

        for (Shipper shipper : actualMasterShipper)
        {
            isExist = masterShipper.stream().anyMatch(s-> s.getId().equals(shipper.getId()));
            assertTrue(f("Check shipper with id %d on API", shipper.getId()), isExist);
        }
    }

    @When("Operator fill name search field with {string} on b2b management page")
    public void operatorFillNameSearchFieldWithOnBBManagementPage(String searchValue)
    {
        b2bManagementPage.getMasterShipper().searchByName(searchValue);
    }

    @When("Operator fill email search field with {string} on b2b management page")
    public void operatorFillEmailSearchFieldWithOnBBManagementPage(String searchValue)
    {
        b2bManagementPage.getMasterShipper().searchByEmail(searchValue);
    }

    @Then("QA verify master shippers with name contains {string} is displayed on b2b management page")
    public void qaVerifyMasterShippersWithNameContainsIsDisplayedOnBBManagementPage(String shipperName)
    {
        List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipper().readAllEntities();
        boolean isExist = actualMasterShipper.stream().allMatch(s-> s.getName().contains(shipperName));
        assertTrue(f("Check shippers name contain %s", shipperName), isExist);
    }

    @Then("QA verify master shippers with email contains {string} is displayed on b2b management page")
    public void qaVerifyMasterShippersWithEmailContainsIsDisplayedOnBBManagementPage(String shipperEmail)
    {
        List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipper().readAllEntities();
        boolean isExist = actualMasterShipper.stream().allMatch(s-> s.getEmail().contains(shipperEmail));
        assertTrue(f("Check shippers email contain %s", shipperEmail), isExist);
    }

    @Given("Operator clear search fields on b2b management page")
    public void operatorClearSearchFieldOnBBManagementPage()
    {
        b2bManagementPage.getMasterShipper().clearSearchFields();
    }
}
