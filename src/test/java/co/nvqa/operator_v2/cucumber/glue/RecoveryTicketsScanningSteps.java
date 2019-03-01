package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RecoveryTicketsScanning;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsPage;
import co.nvqa.operator_v2.selenium.page.RecoveryTicketsScanningPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class RecoveryTicketsScanningSteps extends AbstractSteps {
    private RecoveryTicketsScanningPage recoveryTicketsScanningPage;
    private RecoveryTicketsPage recoveryTicketsPage;

    public RecoveryTicketsScanningSteps() {
    }

    @Override
    public void init() {
        recoveryTicketsScanningPage = new RecoveryTicketsScanningPage(getWebDriver());
        recoveryTicketsPage = new RecoveryTicketsPage(getWebDriver());
    }

    @When("^Operator fills all the field on Recovery Tickets Scanning Page and clicks on enter with data bellow:$")
    public void fillTheField(Map<String,String> dataTableAsMap) {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

        Map<String,String> mapOfTokens = new HashMap<>();
        mapOfTokens.put("tracking_id", trackingId);

        String recoveryTicketsScanningRequestJson = replaceTokens(dataTableAsMap.get("recoveryTicketsScanning"), mapOfTokens);
        RecoveryTicketsScanning recoveryTicketsScanning = fromJsonCamelCase(recoveryTicketsScanningRequestJson, RecoveryTicketsScanning.class);

        recoveryTicketsScanningPage.fillTheField(trackingId, recoveryTicketsScanning);
        put("recoveryTicketsScanning", recoveryTicketsScanning);
    }

    @Then("^Operator verifies the details of the ticket on Recovery Tickets Scanning Page is correct$")
    public void verifyDetailsTicket() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        recoveryTicketsScanningPage.verifyDetailsTicket(trackingId);
    }

    @When("^Operator clicks on Create Ticket Button on Recovery Tickets Scanning Page$")
    public void clickCreateTicketButton() {
        recoveryTicketsScanningPage.clickCreateTicketButton();
    }

    @And("^Operator clicks on Load Selection Button on Recovery Tickets Page and enters the Tracking ID$")
    public void enterTrackingId() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        recoveryTicketsPage.removeFilterTicketSubType();
        recoveryTicketsPage.enterTrackingId(trackingId);
    }

    @Then("^Operator verifies the created ticket on Recovery Tickets Page is made$")
    public void verifyTicketIsMade() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        recoveryTicketsPage.verifyTicketIsMade(trackingId);
    }

    @When("^Operator fills all the field on Recovery Tickets Scanning Page with invalid tracking ID and clicks on enter with data bellow:$")
    public void fillInvalidData(Map<String,String> dataTableAsMap) {
        String uniqueCode = generateDateUniqueString();
        String trackingId = "DUMMY"+uniqueCode;

        Map<String,String> mapOfTokens = new HashMap<>();
        mapOfTokens.put("tracking_id", trackingId);

        String recoveryTicketsScanningRequestJson = replaceTokens(dataTableAsMap.get("recoveryTicketsScanning"), mapOfTokens);
        RecoveryTicketsScanning recoveryTicketsScanning = fromJsonCamelCase(recoveryTicketsScanningRequestJson, RecoveryTicketsScanning.class);

        recoveryTicketsScanningPage.fillTheField(trackingId, recoveryTicketsScanning);

        put("recoveryTicketsScanning", recoveryTicketsScanning);
        put(KEY_CREATED_ORDER_TRACKING_ID, trackingId);
    }

    @Then("^Operator verifies the dialogue shown on Recovery Ticket Scanning Page and clicks on cancel button$")
    public void verifyDialogueAndCancel() {
        recoveryTicketsScanningPage.verifyDialogueAndCancel();
    }

    @And("^Operator verifies the ticket is not made on Recovery Ticket Scanning Page$")
    public void verifyTicketIsNotMade() {
        recoveryTicketsScanningPage.verifyTicketIsNotMade();
    }

    @Then("^Operator verifies the dialogue shown on Recovery Ticket Scanning Page and clicks on save button$")
    public void verifyDialogueAndSave() {
        recoveryTicketsScanningPage.verifyDialogueAndSave();
    }
}
