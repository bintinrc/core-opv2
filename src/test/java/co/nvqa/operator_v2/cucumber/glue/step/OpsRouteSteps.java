package co.nvqa.operator_v2.cucumber.glue.step;

import co.nvqa.operator_v2.selenium.page.OpsRoutePage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Random;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OpsRouteSteps extends AbstractSteps
{
    private static final int EDITED_ROW_NUMBER = 1;
    private OpsRoutePage opsRoutePage;
    private String newRouteId;

    @Inject
    public OpsRouteSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        opsRoutePage = new OpsRoutePage(getDriver());
    }

    @When("^op click edit button on table at Ops Route menu$")
    public void editOpsRoute()
    {
        /**
         * Generate random number.
         */
        Random random = new Random();
        int randomNumber = random.nextInt(99999);
        newRouteId = String.valueOf(randomNumber);
        opsRoutePage.editOpsRoute(EDITED_ROW_NUMBER, newRouteId);
    }

    @Then("^ops route id must be changed$")
    public void verifyEditOpsRouteSuccess()
    {
        String actualRouteId = opsRoutePage.getRouteIdAtRow(EDITED_ROW_NUMBER);
        Assert.assertEquals(newRouteId, actualRouteId);
    }
}
