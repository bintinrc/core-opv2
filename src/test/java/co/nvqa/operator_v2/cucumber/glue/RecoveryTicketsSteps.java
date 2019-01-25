package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RecoveryTicket;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RecoveryTicketsSteps extends AbstractSteps
{
    private RecoveryTicketsPage recoveryTicketsPage;

    public RecoveryTicketsSteps()
    {
    }

    @Override
    public void init()
    {
        recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
    }

    @When("^Operator create new ticket on page Recovery Tickets using data below:$")
    public void createNewTicket(Map<String,String> mapOfData)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        String entrySource = mapOfData.get("entrySource");
        String investigatingDepartment = mapOfData.get("investigatingDepartment");
        String investigatingHub = mapOfData.get("investigatingHub");
        String ticketType = mapOfData.get("ticketType");
        String ticketSubType = mapOfData.get("ticketSubType");
        String parcelLocation = mapOfData.get("parcelLocation");
        String liability = mapOfData.get("liability");
        String damageDescription = mapOfData.get("damageDescription");
        String orderOutcomeDamaged = mapOfData.get("orderOutcomeDamaged");
        String orderOutcomeMissing = mapOfData.get("orderOutcomeMissing");
        String custZendeskId = mapOfData.get("custZendeskId");
        String shipperZendeskId = mapOfData.get("shipperZendeskId");
        String ticketNotes = mapOfData.get("ticketNotes");
        String parcelDescription = mapOfData.get("parcelDescription");

        if("GENERATED".equals(damageDescription))
        {
            damageDescription = f("This damage description is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(ticketNotes))
        {
            ticketNotes = f("This ticket notes is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        if("GENERATED".equals(parcelDescription))
        {
            parcelDescription = f("This parcel description is created by automation at %s.", CREATED_DATE_SDF.format(new Date()));
        }

        RecoveryTicket recoveryTicket = new RecoveryTicket();
        recoveryTicket.setTrackingId(trackingId);
        recoveryTicket.setEntrySource(entrySource);
        recoveryTicket.setInvestigatingDepartment(investigatingDepartment);
        recoveryTicket.setInvestigatingHub(investigatingHub);
        recoveryTicket.setTicketType(ticketType);
        recoveryTicket.setTicketSubType(ticketSubType);
        recoveryTicket.setParcelLocation(parcelLocation);
        recoveryTicket.setLiability(liability);
        recoveryTicket.setDamageDescription(damageDescription);
        recoveryTicket.setOrderOutcomeDamaged(orderOutcomeDamaged);
        recoveryTicket.setOrderOutcomeMissing(orderOutcomeMissing);
        recoveryTicket.setCustZendeskId(custZendeskId);
        recoveryTicket.setShipperZendeskId(shipperZendeskId);
        recoveryTicket.setTicketNotes(ticketNotes);
        recoveryTicket.setParcelDescription(parcelDescription);

        recoveryTicketsPage.createTicket(recoveryTicket);
        put("recoveryTicket", recoveryTicket);
    }

    @Then("^Operator verify ticket is created successfully on page Recovery Tickets$")
    public void verifyTicketIsCreateSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        boolean isTicketCreated = recoveryTicketsPage.verifyTicketIsExist(trackingId);
        Assert.assertTrue(f("Ticket '%s' does not created.", trackingId), isTicketCreated);
    }
}
