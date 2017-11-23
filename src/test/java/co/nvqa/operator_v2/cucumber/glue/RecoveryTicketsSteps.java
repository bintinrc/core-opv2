package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RecoveryTicketsSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private RecoveryTicketsPage recoveryTicketsPage;

    @Inject
    public RecoveryTicketsSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
    }

    @When("^op create new ticket on Recovery Tickets menu with this property below:$")
    public void createNewTicket(DataTable dataTable)
    {
        String trackingId = scenarioStorage.get(KEY_CREATED_ORDER_TRACKING_ID);
        Map<String,String> mapOfTicketParam = dataTable.asMap(String.class, String.class);
        recoveryTicketsPage.createTicket(trackingId, mapOfTicketParam);
        scenarioStorage.put("mapOfTicketData", mapOfTicketParam);
    }

    @Then("^verify ticket is created successfully$")
    public void verifyTicketIsCreateSuccessfully()
    {
        String trackingId = scenarioStorage.get(KEY_CREATED_ORDER_TRACKING_ID);
        boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
        Assert.assertTrue(String.format("Ticket '%s' does not created.", trackingId), isTicketCreated);
    }
}
