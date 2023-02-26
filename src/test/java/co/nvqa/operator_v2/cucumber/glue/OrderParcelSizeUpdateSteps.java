package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OrderParcelSizeUpdatePage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class OrderParcelSizeUpdateSteps extends AbstractSteps {

  private OrderParcelSizeUpdatePage page;

  public static final String KEY_ORDERS_SIZE = "KEY_ORDERS_SIZE";

  public OrderParcelSizeUpdateSteps() {
  }

  @Override
  public void init() {
    page = new OrderParcelSizeUpdatePage(getWebDriver());
  }

  @When("^Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page$")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsv() {
    page.inFrame(() -> {
      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvDialog.waitUntilVisible();
      page.findOrdersWithCsvDialog.downloadSample.click();
      page.findOrdersWithCsvDialog.cancel.click();
    });
  }

  @Then("^sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvIsDownloadedSuccessfully() {
    page.verifyFileDownloadedSuccessfully("parcel-size-update.csv.csv",
        "NVSGNINJA000000001,SMALL\n"
            + "NVSGNINJA000000002,MEDIUM\n"
            + "NVSGNINJA000000003,LARGE\n"
            + "NVSGNINJA000000004,EXTRALARGE\n"
            + "NVSGNINJA000000005,XXLARGE\n"
            + "NVSGNINJA000000006,XSMALL");
  }

  @When("^Operator upload Multiple Order Parcel Size update CSV on Order Parcel Size Update page$")
  public void multiOrderParcelSizeUpdateUploadCsvFile(List<String> listSize) {
    List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_TRACKING_IDS);

    if (listOfCreatedTrackingId == null || listOfCreatedTrackingId.isEmpty()) {
      throw new RuntimeException("List of created Tracking ID should not be null or empty.");
    }
    put(KEY_ORDERS_SIZE, listSize);
    page.inFrame(() -> {
      page.findOrdersWithCsv.click();
      File createOrderUpdateCsv = page
          .buildMultiCreateOrderUpdateCsv(listOfCreatedTrackingId, listSize);
      page.findOrdersWithCsvDialog.uploadFile(createOrderUpdateCsv);
    });
  }

  @When("^Operator clicks Upload button on Order Parcel Size Update page$")
  public void clickUploadButton() {
    page.inFrame(() -> page.upload.click());
  }
}