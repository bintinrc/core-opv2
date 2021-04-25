package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OrderWeightUpdatePage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OrderWeightUpdateSteps extends AbstractSteps {

  private OrderWeightUpdatePage orderWeightUpdatePage;

  public static final String KEY_ORDER_WEIGHT = "KEY_ORDER_WEIGHT";

  public OrderWeightUpdateSteps() {
  }

  @Override
  public void init() {
    orderWeightUpdatePage = new OrderWeightUpdatePage(getWebDriver());
  }

  @When("^Operator Order Weight update CSV Upload on Order Weight Update V2 page$")
  public void OrderWeightUpdateUploadCsvFile(Map<String, String> map) {
    put(KEY_ORDER_WEIGHT, map.get("new-weight-in-double-format"));
    String OrderTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    orderWeightUpdatePage.uploadOrderUpdateCsv(OrderTrackingId, map);
    pause5s();
  }

  @Then("^Operator Order Weight update on Order Weight Update V2 page$")
  public void OrderWeightUpdate() {
    pause2s();
    orderWeightUpdatePage.upload.click();
    orderWeightUpdatePage.waitUntilInvisibilityOfToast("Order weight update success", true);
  }

  @When("^Operator Multiple Order Weight update CSV Upload on Order Weight Update V2 page$")
  public void multiOrderWeightUpdateUploadCsvFile(List<String> listWeight) {
    List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    if (listOfCreatedTrackingId == null || listOfCreatedTrackingId.isEmpty()) {
      throw new RuntimeException("List of created Tracking ID should not be null or empty.");
    }
    put("orderMultiweight", listWeight);
    orderWeightUpdatePage.uploadMultiOrderUpdateCsv(listOfCreatedTrackingId, listWeight);
    pause5s();
  }

  @When("^Operator download sample CSV file for 'Find Orders with CSV' on Order Weight Update page$")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsv() {
    orderWeightUpdatePage.findOrdersWithCsv.click();
    orderWeightUpdatePage.findOrdersWithCsvDialog.waitUntilVisible();
    orderWeightUpdatePage.findOrdersWithCsvDialog.downloadSample.click();
    orderWeightUpdatePage.findOrdersWithCsvDialog.cancel.click();
  }

  @Then("^sample CSV file for 'Find Orders with CSV' on Order Weight Update page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvIsDownloadedSuccessfully() {
    orderWeightUpdatePage.verifyFileDownloadedSuccessfully("find-orders-with-csv.csv",
        "NVSGNINJA000000001,20.0\n"
            + "NVSGNINJA000000002,5.2\n"
            + "NVSGNINJA000000003,1.4");
  }
}