package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.selenium.page.RecoveryTicketsPage;
import com.nv.qa.support.ScenarioStorage;
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
public class RecoveryTicketsStep extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private RecoveryTicketsPage recoveryTicketsPage;

    @Inject
    public RecoveryTicketsStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        recoveryTicketsPage = new RecoveryTicketsPage(getDriver());
    }

    @When("^op create new ticket on Recovery Tickets menu with this property below:$")
    public void createNewTicket(DataTable dataTable)
    {
        Map<String,String> mapOfTicketParam = dataTable.asMap(String.class, String.class);
        String trackingId = String.format("RECOV%d", System.currentTimeMillis());
        scenarioStorage.put("trackingId", trackingId);
        scenarioStorage.put("mapOfTicketData", mapOfTicketParam);
        recoveryTicketsPage.createTicket(trackingId, mapOfTicketParam);
    }

    @Then("^verify ticket is created successfully$")
    public void verifyTicketIsCreateSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
        Assert.assertTrue(String.format("Ticket '%s' does not created.", trackingId), isTicketCreated);
    }
}
