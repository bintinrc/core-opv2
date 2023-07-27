package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.event.Events;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectDriverDropOffConfirmedStatus;
import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.selenium.page.DpTaggingPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DpTaggingSteps extends AbstractSteps {

  private DpTaggingPage dpTaggingPage;

  public DpTaggingSteps() {
  }

  @Override
  public void init() {
    dpTaggingPage = new DpTaggingPage(getWebDriver());
  }

  @When("Operator tags single order to DP with DPMS ID = {string}")
  public void operatorTagsSingleOrderToDpWithId(String dpIdAsString) {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    long dpId = Long.parseLong(dpIdAsString);

    DpTagging dpTagging = new DpTagging();
    dpTagging.setTrackingId(trackingId);
    dpTagging.setDpId(dpId);

    List<DpTagging> listOfDpTagging = new ArrayList<>();
    listOfDpTagging.add(dpTagging);

    dpTaggingPage.inFrame(() -> {
      dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
      dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
      dpTaggingPage.selectDateToNextDay();
      dpTaggingPage.checkAndAssignAll(false);
      takesScreenshot();
      pause5s();
      put("listOfDpTagging", listOfDpTagging);
      put(KEY_DISTRIBUTION_POINT_ID, dpId);
    });
  }
  @When("Operator tags single order to DP with DPMS ID = {string} and tracking id = {string}")
  public void operatorTagsSingleOrderToDpWithId(String dpIdAsString,String tracking) {
    String trackingId = resolveValue(tracking);
    long dpId = Long.parseLong(dpIdAsString);

    DpTagging dpTagging = new DpTagging();
    dpTagging.setTrackingId(trackingId);
    dpTagging.setDpId(dpId);

    List<DpTagging> listOfDpTagging = new ArrayList<>();
    listOfDpTagging.add(dpTagging);

    dpTaggingPage.inFrame(() -> {
      dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
      dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
      dpTaggingPage.selectDateToNextDay();
      dpTaggingPage.checkAndAssignAll(false);
      takesScreenshot();
      pause5s();
      put("listOfDpTagging", listOfDpTagging);
      put(KEY_DISTRIBUTION_POINT_ID, dpId);
    });
  }

  @When("Operator untags created orders from DP with DPMS ID = {string} on DP Tagging page")
  public void operatorUntagsSingleOrder(String dpIdAsString) {
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    long dpId = Long.parseLong(dpIdAsString);

    List<DpTagging> listOfDpTagging = trackingIds.stream().map(trackingId ->
    {
      DpTagging dpTagging = new DpTagging();
      dpTagging.setTrackingId(trackingId);
      dpTagging.setDpId(dpId);
      return dpTagging;
    }).collect(Collectors.toList());

    dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
    dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
    dpTaggingPage.untagAll();
    takesScreenshot();
    if (listOfDpTagging.size() == 1) {
      dpTaggingPage.verifyTaggingToast("1 order(s) untagged successfully");
    } else {
      dpTaggingPage.verifyTaggingToast("DP untagging performed successfully");
    }
  }

  @When("Operator tags multiple orders to DP with DPMS ID = {string}")
  public void operatorTagsMultipleOrdersToDpWithId(String dpIdAsString) {
    final List<String> listOfTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    long dpId = Long.parseLong(dpIdAsString);

    List<DpTagging> listOfDpTagging = new ArrayList<>();

    for (String trackingId : listOfTrackingId) {
      DpTagging dpTagging = new DpTagging();
      dpTagging.setTrackingId(trackingId);
      dpTagging.setDpId(dpId);
      listOfDpTagging.add(dpTagging);
    }

    dpTaggingPage.uploadDpTaggingCsv(listOfDpTagging);
    dpTaggingPage.verifyDpTaggingCsvIsUploadedSuccessfully(listOfDpTagging);
    dpTaggingPage.selectMultiDateToNextDay(listOfTrackingId.size());
    dpTaggingPage.checkAndAssignAll(true);
    takesScreenshot();
    put("listOfDpTagging", listOfDpTagging);
    put(KEY_DISTRIBUTION_POINT_ID, dpId);
  }

  @When("Operator uploads invalid DP Tagging CSV")
  public void operatorUploadsInvalidDpTaggingCsv() {
    dpTaggingPage.uploadInvalidDpTaggingCsv();
  }

  @When("Operator wait for DP tagging page to load")
  public void operatorWaitsForDpTaggingToLoad() {
    dpTaggingPage.inFrame(() -> dpTaggingPage.waitUntilLoaded());
  }

  @When("Operator verify invalid DP Tagging CSV is not uploaded successfully")
  public void operatorVerifyInvalidDpTaggingCsvIsNotUploadedSuccessfully() {
    dpTaggingPage.verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully();
    takesScreenshot();
  }

  @When("Operator verifies that all the details for Confirmed Status are right")
  public void operatorVerifiesThatAllTheDetailsForConfirmedStatusAreRight() {
    DatabaseCheckingNinjaCollectConfirmed dbCheckingResult = get(
        KEY_DATABASE_CHECKING_NINJA_COLLECT_CONFIRMED);
    DpDetailsResponse dpDetails = get(KEY_DP_DETAILS);
    String barcode = get(KEY_CREATED_ORDER_TRACKING_ID);
    Events orderEvent = get(KEY_ORDER_EVENTS);
    dpTaggingPage
        .verifiesDetailsRightConfirmedOptTag(dbCheckingResult, dpDetails, orderEvent, barcode);
    takesScreenshot();
  }

  @Then("Operator verifies that all the details for ninja collect driver drop off confirmed status are right")
  public void OperatorVerifiesThatAllTheDetailsForNinjaCollectDriverDropOffConfirmedStatusAreRight() {
    pause5s();
    DatabaseCheckingNinjaCollectDriverDropOffConfirmedStatus dbCheckingResult = get(
        KEY_DATABASE_CHECKING_NINJA_COLLECT_DRIVER_DROP_OFF_CONFIRMED);
    String barcode = get(KEY_CREATED_ORDER_TRACKING_ID);

    dpTaggingPage
        .verifiesDetailsForDriverDropOffConfirmedStatus(dbCheckingResult, barcode);
    takesScreenshot();
  }

  @When("^Operator click on Download Button for Sample CSV File of DP tagging")
  public void operatorClickOnDownloadSampleCSVFile() {
    dpTaggingPage.inFrame(() -> dpTaggingPage.downloadSampleCsv.click());
  }

  @Then("^sample CSV file on DP Tagging page is downloaded successfully$")
  public void operatorVerifySampleCsvFileIsDownloadedSuccessfully() {
    retryIfAssertionErrorOccurred(() -> {
      dpTaggingPage.verifyFileDownloadedSuccessfully("sample-tag-order-to-dp.csv",
              "NVSGPAOV4001002003004");
    }, "verify csv file downloaded successfully");

  }

}
