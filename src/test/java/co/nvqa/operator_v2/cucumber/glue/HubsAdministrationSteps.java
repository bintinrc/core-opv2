package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.HubsAdministration;
import co.nvqa.operator_v2.selenium.page.HubsAdministrationPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

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

    @When("^hubs administration download button is clicked$")
    public void hubAdministrationDownloadButtonIsClicked()
    {
        hubsAdministrationPage.downloadCsvFile();
    }

    @Then("^hubs administration file should exist$")
    public void hubsAdministrationFileShouldExist()
    {
        hubsAdministrationPage.verifyCsvFileDownloadedSuccessfully();
    }

    @When("^hubs administration add button is clicked$")
    public void hubsAdministrationAddButtonIsClicked()
    {
        hubsAdministrationPage.clickButtonAddHub();
    }

    @When("^hubs administration enter default value$")
    public void hubsAdministrationEnterDefaultValue()
    {
        String uniqueCode = generateDateUniqueString();
        String uniqueCoordinate = String.valueOf(System.currentTimeMillis()).substring(4);

        HubsAdministration hubsAdministration = new HubsAdministration();
        hubsAdministration.setName("HUB "+uniqueCode);
        hubsAdministration.setLatitude(Double.parseDouble("1."+uniqueCoordinate));
        hubsAdministration.setLongitude(Double.parseDouble("103."+uniqueCoordinate));
        hubsAdministrationPage.fillTheForm(hubsAdministration);

        put("hubsAdministration", hubsAdministration);
    }

    @When("^hubs administration edit button is clicked$")
    public void hubsAdministrationEditButtonIsClicked()
    {
        HubsAdministration hubsAdministration = get("hubsAdministration");

        HubsAdministration hubsAdministrationEdited = new HubsAdministration();
        hubsAdministrationEdited.setName(hubsAdministration.getName()+" [EDITED]");
        hubsAdministrationEdited.setLatitude(hubsAdministration.getLatitude()+0.01);
        hubsAdministrationEdited.setLongitude(hubsAdministration.getLongitude()+0.01);
        hubsAdministrationPage.editHub(hubsAdministration, hubsAdministrationEdited);

        put("hubsAdministrationEdited", hubsAdministrationEdited);
    }

    @Then("^hubs administration verify result ([^\"]*)$")
    public void hubsAdministrationVerifyResult(String type)
    {
        HubsAdministration hubsAdministration = null;

        if("add".equalsIgnoreCase(type))
        {
            hubsAdministration = get("hubsAdministration");
        }
        else if("edit".equalsIgnoreCase(type))
        {
            hubsAdministration = get("hubsAdministrationEdited");
        }

        hubsAdministrationPage.verifyHubIsExistAndDataIsCorrect(hubsAdministration);
    }

    @When("^hubs administration searching for hub$")
    public void hubsAdministrationSearchingForHub()
    {
        HubsAdministration hubsAdministration = get("hubsAdministration");
        hubsAdministrationPage.verifyHubIsExistAndDataIsCorrect(hubsAdministration);
    }
}
