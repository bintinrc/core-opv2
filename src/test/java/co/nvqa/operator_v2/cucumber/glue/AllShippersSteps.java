package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AllShippersSteps extends AbstractSteps
{
    private AllShippersPage allShippersPage;

    @Inject
    public AllShippersSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        allShippersPage = new AllShippersPage(getWebDriver());
    }

    @When("^Operator create new Shipper V4$")
    public void operatorCreateNewShipperV4()
    {
        allShippersPage.createNewShipperV4();
    }
}
