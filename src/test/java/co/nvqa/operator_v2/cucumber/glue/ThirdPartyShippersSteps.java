package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ThirdPartyShipper;
import co.nvqa.operator_v2.selenium.page.ThirdPartyShippersPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ThirdPartyShippersSteps extends AbstractSteps
{
    private ThirdPartyShippersPage thirdPartyShippersPage;

    public ThirdPartyShippersSteps()
    {
    }

    @Override
    public void init()
    {
        thirdPartyShippersPage = new ThirdPartyShippersPage(getWebDriver());
    }

    private String generateThirdPartyShipperCode()
    {
        return f("T-%s", StringUtils.left(String.valueOf(System.currentTimeMillis()), 8)); // Maximum character is 10.
    }

    @When("^Operator create new Third Party Shippers$")
    public void operatorCreateNewThirdPartyShippers()
    {
        String uniqueString = generateDateUniqueString();
        String name = f("TPS-%s", uniqueString);
        String code = generateThirdPartyShipperCode();
        String url = f("https://www.tps%s.co", uniqueString);

        ThirdPartyShipper thirdPartyShipper = new ThirdPartyShipper();
        thirdPartyShipper.setName(name);
        thirdPartyShipper.setCode(code);
        thirdPartyShipper.setUrl(url);
        thirdPartyShippersPage.addThirdPartyShipper(thirdPartyShipper);

        put("thirdPartyShipper", thirdPartyShipper);
    }

    @Then("^Operator verify the new Third Party Shipper is created successfully$")
    public void operatorVerifyTheNewThirdPartyShipperIsCreatedSuccessfully()
    {
        ThirdPartyShipper thirdPartyShipper = get("thirdPartyShipper");
        thirdPartyShippersPage.verifyThirdPartyShipperIsCreatedSuccessfully(thirdPartyShipper);
    }

    @When("^Operator update the new Third Party Shipper$")
    public void operatorUpdateTheNewThirdPartyShipper()
    {
        ThirdPartyShipper thirdPartyShipper = get("thirdPartyShipper");

        ThirdPartyShipper thirdPartyShipperEdited = new ThirdPartyShipper();
        thirdPartyShipperEdited.setId(thirdPartyShipper.getId());
        thirdPartyShipperEdited.setName(thirdPartyShipper.getName()+" [EDITED]");
        thirdPartyShipperEdited.setCode(generateThirdPartyShipperCode());
        thirdPartyShipperEdited.setUrl(thirdPartyShipper.getUrl()+".sg");

        thirdPartyShippersPage.editThirdPartyShipper(thirdPartyShipper, thirdPartyShipperEdited);
        put("thirdPartyShipperEdited", thirdPartyShipperEdited);
    }

    @Then("^Operator verify the new Third Party Shipper is updated successfully$")
    public void operatorVerifyTheNewThirdPartyShipperIsUpdatedSuccessfully()
    {
        ThirdPartyShipper thirdPartyShipperEdited = get("thirdPartyShipperEdited");
        thirdPartyShippersPage.verifyThirdPartyShipperIsUpdatedSuccessfully(thirdPartyShipperEdited);
    }

    @When("^Operator delete the new Third Party Shipper$")
    public void operatorDeleteTheNewThirdPartyShipper()
    {
        ThirdPartyShipper thirdPartyShipper = containsKey("thirdPartyShipperEdited") ? get("thirdPartyShipperEdited") : get("thirdPartyShipper");
        thirdPartyShippersPage.deleteThirdPartyShipper(thirdPartyShipper);
    }

    @Then("^Operator verify the new Third Party Shipper is deleted successfully$")
    public void operatorVerifyTheNewThirdPartyShipperIsDeletedSuccessfully()
    {
        ThirdPartyShipper thirdPartyShipper = containsKey("thirdPartyShipperEdited") ? get("thirdPartyShipperEdited") : get("thirdPartyShipper");
        thirdPartyShippersPage.verifyThirdPartyShipperIsDeletedSuccessfully(thirdPartyShipper);
    }

    @Then("^Operator check all filters on Third Party Shippers page work fine$")
    public void operatorCheckAllFiltersOnThirdPartyShippersPageWork()
    {
        ThirdPartyShipper thirdPartyShipper = get("thirdPartyShipper");
        thirdPartyShippersPage.verifyAllFiltersWorkFine(thirdPartyShipper);
    }

    @When("^Operator download Third Party Shippers CSV file$")
    public void operatorDownloadThirdPartyShippersCsvFile()
    {
        thirdPartyShippersPage.downloadCsvFile();
    }

    @When("^Operator verify Third Party Shippers CSV file downloaded successfully$")
    public void operatorVerifyThirdPartyShippersCsvFileDownloadedSuccessfully()
    {
        ThirdPartyShipper thirdPartyShipper = get("thirdPartyShipper");
        thirdPartyShippersPage.verifyCsvFileDownloadedSuccessfully(thirdPartyShipper);
    }
}
