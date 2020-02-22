package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.ChangeDeliveryTimingsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class ChangeDeliveryTimingsSteps extends AbstractSteps {

    private ChangeDeliveryTimingsPage changeDeliveryTimingsPage;
    private AllOrdersPage allOrdersPage;

    public ChangeDeliveryTimingsSteps() {
    }

    @Override
    public void init() {
        changeDeliveryTimingsPage = new ChangeDeliveryTimingsPage(getWebDriver());
        allOrdersPage = new AllOrdersPage(getWebDriver());
    }

    @When("^Operator click on Download Button for Sample CSV File of Change Delivery Timings' sample$")
    public void operatorClickOnDownloadSampleCSVFile() {
        changeDeliveryTimingsPage.downloadSampleCSVFile();
    }

    @Then("^Operator verify CSV file of Change Delivery Timings' sample$")
    public void verifyTheCSVFileSample() {
        changeDeliveryTimingsPage.csvSampleDownloadSuccessful();
    }

    @Then("^Operator uploads the CSV file on Change Delivery Timings page using data below:$")
    public void operatorUploadsTheCsvFileOnChangeDeliveryTimingsPageUsingDataBelow(Map<String,String> dataTableAsMap) {
        dataTableAsMap = resolveKeyValues(dataTableAsMap);
        Map<String,String> mapOfTokens = createDefaultTokens();
        Map<String,String> dataTableAsMapReplaced = replaceDataTableTokens(dataTableAsMap, mapOfTokens);

        String trackingId = dataTableAsMapReplaced.get("trackingId");
        String startDate = dataTableAsMapReplaced.get("startDate");
        String endDate = dataTableAsMapReplaced.get("endDate");
        String timewindowAsString = dataTableAsMapReplaced.get("timewindow");

        ChangeDeliveryTiming changeDeliveryTiming = new ChangeDeliveryTiming();
        changeDeliveryTiming.setTrackingId(trackingId);
        changeDeliveryTiming.setStartDate(startDate);
        changeDeliveryTiming.setEndDate(endDate);

        if(!isBlank(timewindowAsString)) {
            int timewindow = Integer.parseInt(timewindowAsString);
            changeDeliveryTiming.setTimewindow(timewindow);
        }

        List<ChangeDeliveryTiming> listOfChangeDeliveryTimings = new ArrayList<>();
        listOfChangeDeliveryTimings.add(changeDeliveryTiming);

        changeDeliveryTimingsPage.uploadCsvCampaignFile(listOfChangeDeliveryTimings);
        put("changeDeliveryTiming", changeDeliveryTiming);
    }

    @Then("^Operator verify that the Delivery Time Updated on Change Delivery Timings page$")
    public void verifyDeliveryTimeUpdate() {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        changeDeliveryTimingsPage.verifyDeliveryTimeChanged(trackingId);
    }

    @Then("^Operator verify that the Delivery Time is updated on All Orders page$")
    public void operatorVerifyThatTheDeliveryTimeIsUpdatedOnAllOrdersPage() {
        ChangeDeliveryTiming changeDeliveryTiming = get("changeDeliveryTiming");
        allOrdersPage.verifyDeliveryTimingIsUpdatedSuccessfully(changeDeliveryTiming);
    }

    @Then("^Operator verify the tracking ID is invalid on Change Delivery Timings page$")
    public void invalidTrackingIdVerification() {
        changeDeliveryTimingsPage.invalidTrackingIdVerification();
    }

    @Then("^Operator verify the state order of the Tracking ID is invalid on Change Delivery Timings page$")
    public void invalidStateOrderVerification() {
        changeDeliveryTimingsPage.invalidStateOrderVerification();
    }

    @Then("^Operator verify the start and end date is not indicated correctly on Change Delivery Timings page$")
    public void dateNotIndicateCorrectlyVerification() {
        changeDeliveryTimingsPage.dateIndicatedIncorectlyVerification();
    }

    @Then("^Operator verify that start date is later than end date on Change Delivery Timings page$")
    public void startDateLaterVerification() {
        changeDeliveryTimingsPage.startDateLaterVerification();
    }
}
