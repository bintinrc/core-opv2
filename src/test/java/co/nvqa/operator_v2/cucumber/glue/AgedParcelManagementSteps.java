package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AgedParcelManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
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

    @When("^Operator load selection on page Aged Parcel Management$")
    public void operatorLoadSelectionOnPageAgedParcelManagement()
    {
        pause2s();
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipperName = getShipperOfCreatedOrder().getName();
        agedParcelManagementPage.loadSelection(shipperName, trackingId, -1);
    }

    @When("^Operator apply filter parameters and load selection on Aged Parcel Management$")
    public void operatorLoadSelectionOnPageAgedParcelManagement(Map<String,String> dataTableAsMap)
    {
        String shipperName = dataTableAsMap.getOrDefault("shipperName", getShipperOfCreatedOrder().getName());
        Integer agedDays = dataTableAsMap.containsKey("agedDays") ? Integer.parseInt(dataTableAsMap.get("agedDays")) : null;
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.loadSelection(shipperName, trackingId, agedDays);
    }

    @Then("^Operator verify the aged parcel order is listed on Aged Parcels list$")
    public void operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelsList()
    {
        operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelsListWithFollowingParameters(Collections.emptyMap());
    }

    @Then("^Operator verify the aged parcel order is listed on Aged Parcels list with following parameters$")
    public void operatorVerifyTheAgedParcelOrderIsListedOnAgedParcelsListWithFollowingParameters(Map<String,String> dataTableAsMap)
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String shipperName = dataTableAsMap.getOrDefault("shipperName", getShipperOfCreatedOrder().getName());
        String daysSinceInbound = dataTableAsMap.get("daysSinceInbound");
        agedParcelManagementPage.verifyAgedParcelOrderIsListed(trackingId, shipperName, daysSinceInbound);
    }

    @When("^Operator download CSV file of aged parcel on Aged Parcels list$")
    public void operatorDownloadCsvFileOfAgedParcelOnAgedParcelsList()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of aged parcel on Aged Parcels list downloaded successfully$")
    public void operatorVerifyCsvFileOfAgedParcelOnAgedParcelsListDownloadedSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule aged parcel on next day$")
    public void operatorRescheduleAgedParcelOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rescheduleNextDay(trackingId);
    }

    @When("^Operator reschedule aged parcel on next 2 days$")
    public void operatorRescheduleAgedParcelOnNext2Days()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rescheduleNext2Days(trackingId);
    }

    @When("^Operator reschedule multiple aged parcels on next 2 days$")
    public void operatorRescheduleMultipleAgedParcelsOnNext2Days()
    {
        List<String> trackingIds= get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rescheduleNext2Days(trackingIds);
    }

    @When("^Operator RTS aged parcel on next day$")
    public void operatorRtsAgedParcelOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rtsSingleOrderNextDay(trackingId);
    }

    @When("^Operator RTS selected aged parcel on next day$")
    public void operatorRtsSelectedAgedParcelOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rtsSelectedOrderNextDay(trackingId);
    }

    @When("^Operator RTS multiple aged parcels on next 2 days$")
    public void operatorRtsMultipleAgedParcelsOnNext2Days()
    {
        List<String> trackingIds= get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        agedParcelManagementPage.rtsSelectedOrderNext2Days(trackingIds);
    }
}
