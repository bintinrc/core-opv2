package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OrderParcelSizeUpdatePage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.io.File;
import java.util.List;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class OrderParcelSizeUpdateSteps extends AbstractSteps {

  private OrderParcelSizeUpdatePage orderParcelSizeUpdatePage;

  public static final String KEY_ORDERS_SIZE = "KEY_ORDERS_SIZE";

  public OrderParcelSizeUpdateSteps() {
  }

  @Override
  public void init() {
    orderParcelSizeUpdatePage = new OrderParcelSizeUpdatePage(getWebDriver());
  }

  @When("^Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page$")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsv() {
    orderParcelSizeUpdatePage.findOrdersWithCsv.click();
    orderParcelSizeUpdatePage.findOrdersWithCsvDialog.waitUntilVisible();
    orderParcelSizeUpdatePage.findOrdersWithCsvDialog.downloadSample.click();
    orderParcelSizeUpdatePage.findOrdersWithCsvDialog.cancel.click();
  }

  @Then("^sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvIsDownloadedSuccessfully() {
    orderParcelSizeUpdatePage.verifyFileDownloadedSuccessfully("find-orders-with-csv.csv",
        "NVSGNINJA000000001,SMALL\n"
            + "NVSGNINJA000000002,MEDIUM\n"
            + "NVSGNINJA000000003,LARGE\n"
            + "NVSGNINJA000000004,EXTRALARGE\n"
            + "NVSGNINJA000000005,XXLARGE\n"
            + "NVSGNINJA000000006,XSMALL");
  }

  @When("^Operator Multiple Order Parcel Size update CSV Upload on Order Parcel Size Update page$")
  public void multiOrderParcelSizeUpdateUploadCsvFile(List<String> listSize) {
    List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    if (listOfCreatedTrackingId == null || listOfCreatedTrackingId.isEmpty()) {
      throw new RuntimeException("List of created Tracking ID should not be null or empty.");
    }
    put(KEY_ORDERS_SIZE, listSize);
    orderParcelSizeUpdatePage.findOrdersWithCsv.click();
    File createOrderUpdateCsv = orderParcelSizeUpdatePage
        .buildMultiCreateOrderUpdateCsv(listOfCreatedTrackingId, listSize);
    orderParcelSizeUpdatePage.findOrdersWithCsvDialog.uploadFile(createOrderUpdateCsv);
    pause5s();
    orderParcelSizeUpdatePage.findOrdersWithCsvDialog.upload.clickAndWaitUntilDone();
    orderParcelSizeUpdatePage.waitUntilInvisibilityOfToast("Order weight update success", true);
  }
}