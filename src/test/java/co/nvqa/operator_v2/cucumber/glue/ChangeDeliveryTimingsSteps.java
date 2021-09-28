package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.selenium.page.ChangeDeliveryTimingsPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class ChangeDeliveryTimingsSteps extends AbstractSteps {

  private ChangeDeliveryTimingsPage changeDeliveryTimingsPage;

  public ChangeDeliveryTimingsSteps() {
  }

  @Override
  public void init() {
    changeDeliveryTimingsPage = new ChangeDeliveryTimingsPage(getWebDriver());
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
  public void operatorUploadsTheCsvFileOnChangeDeliveryTimingsPageUsingDataBelow(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    Map<String, String> mapOfTokens = createDefaultTokens();
    Map<String, String> dataTableAsMapReplaced = replaceDataTableTokens(dataTableAsMap,
        mapOfTokens);

    String trackingId = dataTableAsMapReplaced.get("trackingId");
    String startDate = dataTableAsMapReplaced.get("startDate");
    String endDate = dataTableAsMapReplaced.get("endDate");
    String timewindowAsString = dataTableAsMapReplaced.get("timewindow");

    ChangeDeliveryTiming changeDeliveryTiming = new ChangeDeliveryTiming();
    changeDeliveryTiming.setTrackingId(trackingId);
    changeDeliveryTiming.setStartDate(startDate);
    changeDeliveryTiming.setEndDate(endDate);

    if (!isBlank(timewindowAsString)) {
      int timewindow = Integer.parseInt(timewindowAsString);
      changeDeliveryTiming.setTimewindow(timewindow);
    }

    List<ChangeDeliveryTiming> listOfChangeDeliveryTimings = new ArrayList<>();
    listOfChangeDeliveryTimings.add(changeDeliveryTiming);

    changeDeliveryTimingsPage.uploadCsvCampaignFile(listOfChangeDeliveryTimings);
    put("changeDeliveryTiming", changeDeliveryTiming);
  }

  @Then("^Operator verify the tracking ID is invalid on Change Delivery Timings page$")
  public void invalidTrackingIdVerification() {
    changeDeliveryTimingsPage.invalidTrackingIdVerification();
  }
}
