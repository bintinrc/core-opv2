package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ChangeDeliveryTimings;
import co.nvqa.operator_v2.model.Timeslot;
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

    @Inject
    public ChangeDeliveryTimingsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        changeDeliveryTimingsPage = new ChangeDeliveryTimingsPage(getWebDriver());
    }

    @When("^Operator click on Download Sample CSV File Button$")
    public void operatorClickOnDownloadSampleCSVFile() {
        changeDeliveryTimingsPage.downloadSampleCSVFile();
    }

    @Then("^verify the csv file sample$")
    public void verifyTheCSVFileSample() {
        changeDeliveryTimingsPage.csvSampleDownloadSuccessful();
    }

    @Then("^Operator uploads the CSV file$")
    public void operatorUploadsCSVFile(List<ChangeDeliveryTimings> data) {
        //assume only 1 row
        put("trackingID", data.get(0).getTracking_id());
        put("start_date", data.get(0).getStart_date());
        put("end_date", data.get(0).getEnd_date());
        Timeslot tslot = new Timeslot(data.get(0).getTimewindow());
        put("start_time", tslot.getStartTime());
        put("end_time", tslot.getEndTime());
        put("timewindow", data.get(0).getTimewindow());
        changeDeliveryTimingsPage.uploadCsvCampaignFile(data);
    }

    @Then("^Operator verify that the Delivery Time Updated$")
    public void verifyDeliveryTimeUpdate() {
        String trackingID = get("trackingID");
        changeDeliveryTimingsPage.verifyDeliveryTimeChanged(trackingID);
    }

    @When("^Operator entering the tracking ID")
    public void enterTrackingID() {
        String trackingID = get("trackingID");
        changeDeliveryTimingsPage.enterTrackingID(trackingID);
    }

    @Then("^Operator switch tab and verify the delivery time$")
    public void switchTab() {
        String start_date = ((String)get("start_date")).concat(" ").concat(get("start_time")).trim();
        String end_date = ((String)get("end_date")).concat(" ").concat(get("end_time")).trim();
        boolean isTimewindowNull = get("isTimewindowNull", false);
        changeDeliveryTimingsPage.switchTab();
        changeDeliveryTimingsPage.verifyDateRange(start_date, end_date, isTimewindowNull);
        changeDeliveryTimingsPage.closeTab();
    }

    @Then("^Operator verify the tracking ID is invalid$")
    public void invalidTrackingIDVerification() {
        changeDeliveryTimingsPage.invalidTrackingIDVerif();
    }

    @Then("^Operator verify the state order of the Tracking ID is invalid$")
    public void invalidStateOrderVerification() {
        changeDeliveryTimingsPage.invalidStateOrderVerif();
    }

    @Then("^Operator verify the start and end date is not indicated correctly$")
    public void dateNotIndicateCorrectlyVerification() {
        changeDeliveryTimingsPage.dateIndicatedIncorectlyVerif();
    }

    @Then("^Operator verify that start date is later than end date$")
    public void startDateLaterVerification() {
        changeDeliveryTimingsPage.startDateLaterVerif();
    }

    @Then("^Operator verify system using current date$")
    public void dateIsEmpty() {
        String start_date = ((String)get("start_date")).concat(" ").concat(get("start_time")).trim();
        String end_date = ((String)get("end_date")).concat(" ").concat(get("end_time")).trim();
        boolean isDateNull = get("isTimewindowNull", false);
        changeDeliveryTimingsPage.dateEmpty(start_date, end_date, isDateNull);
    }

}
