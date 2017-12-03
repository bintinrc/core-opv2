package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AgedParcelManagementPage;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AgedParcelManagementSteps extends AbstractSteps
{
    private AgedParcelManagementPage agedParcelManagementPage;

    @Inject
    public AgedParcelManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        agedParcelManagementPage = new AgedParcelManagementPage(getWebDriver());
    }

    @When("^operator load selection on page Aged Parcel Management$")
    public void operatorLoadSelectionOnPageAgedParcelManagement()
    {
        pause2s();
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.loadSelection(trackingId, -1);
    }

    @Then("^Operator verify the aged parcel order is listed on Aged Parcels list$")
    public void operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelsList()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipperName = TestConstants.SHIPPER_V2_NAME;
        agedParcelManagementPage.verifyAgedParcelOrderIsListed(trackingId, shipperName);
    }

    @When("^Operator download CSV file of aged parcel on Aged Parcels list$")
    public void operatorDownloadCsvFileOfAgedParcelOnAgedParcelsList()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully$")
    public void operatorVerifyCsvFileOfAgedParcelOnAgedParcelsListDownloadedSuccessfully()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule aged parcel on next day$")
    public void operatorRescheduleAgedParcelOnNextDay()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rescheduleNextDay(trackingId);
    }

    @When("^Operator reschedule aged parcel on next 2 days$")
    public void operatorRescheduleAgedParcelOnNext2Days()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rescheduleNext2Days(trackingId);
    }

    @When("^Operator RTS aged parcel on next day$")
    public void operatorRtsAgedParcelOnNextDay()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rtsSingleOrderNextDay(trackingId);
    }

    @When("^Operator RTS selected aged parcel on next day$")
    public void operatorRtsSelectedAgedParcelOnNextDay()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rtsSelectedOrderNextDay(trackingId);
    }
}
