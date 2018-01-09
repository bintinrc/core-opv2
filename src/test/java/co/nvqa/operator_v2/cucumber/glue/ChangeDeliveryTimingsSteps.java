package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ChangeDeliveryTimings;
import co.nvqa.operator_v2.model.Timeslot;
import co.nvqa.operator_v2.selenium.page.AllOrdersPage;
import co.nvqa.operator_v2.selenium.page.ChangeDeliveryTimingsPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import javax.inject.Inject;
import java.util.List;

/**
 * @author Tristania Siagian
 */

@ScenarioScoped
public class ChangeDeliveryTimingsSteps extends AbstractSteps {

    private ChangeDeliveryTimingsPage changeDeliveryTimingsPage;
    private AllOrdersPage allOrdersPage;

    @Inject
    public ChangeDeliveryTimingsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
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

    @Then("^Operator uploads the CSV file of Change Delivery Timings page$")
    public void operatorUploadsCSVFile(List<ChangeDeliveryTimings> data) {
        //assume only 1 row
        put("trackingID", data.get(0).getTracking_id());
        put("start_date", data.get(0).getStart_date());
        put("end_date", data.get(0).getEnd_date());
        if (data.get(0).getTimewindow() != null ) {
            Timeslot tslot = new Timeslot(data.get(0).getTimewindow());
            put("start_time", tslot.getStartTime());
            put("end_time", tslot.getEndTime());
            put("timewindow", data.get(0).getTimewindow());
            if (data.get(0).getEnd_date().equalsIgnoreCase("") && data.get(0).getStart_date().equalsIgnoreCase("")) {
                put("isDateEmpty", true);
            }
        } else {
            put("isTimewindowNull", true);
        }
        changeDeliveryTimingsPage.uploadCsvCampaignFile(data);
    }

    @Then("^Operator verify that the Delivery Time Updated on Change Delivery Timings page$")
    public void verifyDeliveryTimeUpdate() {
        String trackingID = get("trackingID");
        changeDeliveryTimingsPage.verifyDeliveryTimeChanged(trackingID);
    }

    @When("^Operator entering the tracking ID")
    public void enterTrackingID() {
        String trackingId = get("trackingID");
        allOrdersPage.enterTrackingId(trackingId);
    }

    @Then("^Operator switch tab and verify the delivery time$")
    public void switchTab() {
        pause2s();
        String start_date = ((String) get("start_date")).concat(" ")
                .concat(get("start_time") != null ? get("start_time") : "").trim();
        String end_date = ((String) get("end_date")).concat(" ")
                .concat(get("end_time") != null ? get("end_time") : "").trim();
        boolean isTimewindowNull = get("isTimewindowNull", false);
        changeDeliveryTimingsPage.switchTab();
        changeDeliveryTimingsPage.verifyDateRange(start_date, end_date, isTimewindowNull);
        pause2s();
        changeDeliveryTimingsPage.closeTab();
    }

    @Then("^Operator verify the tracking ID is invalid on Change Delivery Timings page$")
    public void invalidTrackingIDVerification() {
        changeDeliveryTimingsPage.invalidTrackingIDVerif();
    }

    @Then("^Operator verify the state order of the Tracking ID is invalid on Change Delivery Timings page$")
    public void invalidStateOrderVerification() {
        changeDeliveryTimingsPage.invalidStateOrderVerif();
    }

    @Then("^Operator verify the start and end date is not indicated correctly on Change Delivery Timings page$")
    public void dateNotIndicateCorrectlyVerification() {
        changeDeliveryTimingsPage.dateIndicatedIncorectlyVerif();
    }

    @Then("^Operator verify that start date is later than end date on Change Delivery Timings page$")
    public void startDateLaterVerification() {
        changeDeliveryTimingsPage.startDateLaterVerif();
    }

    @Then("^Operator verify system using current date$")
    public void dateIsEmpty() {
        String start_date = ((String) get("start_date")).concat(" ").concat(get("start_time")!=null ?get("start_time"): "").trim();
        String end_date = ((String) get("end_date")).concat(" ").concat(get("end_time")!=null ?get("end_time"): "").trim();
        boolean isDateEmpty = get("isDateEmpty", false);
        changeDeliveryTimingsPage.switchTab();
        changeDeliveryTimingsPage.dateEmpty(start_date, end_date, isDateEmpty);
        pause2s();
        changeDeliveryTimingsPage.closeTab();
    }

}
