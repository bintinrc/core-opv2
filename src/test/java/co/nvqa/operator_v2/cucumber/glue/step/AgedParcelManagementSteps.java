package co.nvqa.operator_v2.cucumber.glue.step;

import co.nvqa.operator_v2.selenium.page.AgedParcelManagementPage;
import co.nvqa.operator_v2.support.ScenarioStorage;
import co.nvqa.operator_v2.support.TestConstants;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AgedParcelManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private AgedParcelManagementPage agedParcelManagementPage;

    @Inject
    public AgedParcelManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        agedParcelManagementPage = new AgedParcelManagementPage(getDriver());
    }

    @When("^operator load selection on page Aged Parcel Management$")
    public void operatorLoadSelectionOnPageAgedParcelManagement()
    {
        pause2s();
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.loadSelection(trackingId, -1);
    }

    @Then("^Operator verify the aged parcel order is listed on Aged Parcels list$")
    public void operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelsList()
    {
        String trackingId = scenarioStorage.get("trackingId");
        String shipperName = TestConstants.SHIPPER_V2_NAME;
        agedParcelManagementPage.verifyAgedParcelOrderIsListed(trackingId, shipperName);
    }

    @When("^Operator download CSV file of aged parcel on Aged Parcels list$")
    public void operatorDownloadCsvFileOfAgedParcelOnAgedParcelsList()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully$")
    public void operatorVerifyCsvFileOfAgedParcelOnAgedParcelsListDownloadedSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule aged parcel on next day$")
    public void operatorRescheduleAgedParcelOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.rescheduleNextDay(trackingId);
    }

    @When("^Operator reschedule aged parcel on next 2 days$")
    public void operatorRescheduleAgedParcelOnNext2Days()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.rescheduleNext2Days(trackingId);
    }

    @When("^Operator RTS aged parcel on next day$")
    public void operatorRtsAgedParcelOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.rtsSingleOrderNextDay(trackingId);
    }

    @When("^Operator RTS selected aged parcel on next day$")
    public void operatorRtsSelectedAgedParcelOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        agedParcelManagementPage.rtsSelectedOrderNextDay(trackingId);
    }
}
