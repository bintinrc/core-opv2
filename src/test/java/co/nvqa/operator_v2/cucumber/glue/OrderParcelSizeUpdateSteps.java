package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.OrderParcelSizeUpdatePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.io.FileUtils;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class OrderParcelSizeUpdateSteps extends AbstractSteps {

  private OrderParcelSizeUpdatePage page;

  public OrderParcelSizeUpdateSteps() {
  }

  @Override
  public void init() {
    page = new OrderParcelSizeUpdatePage(getWebDriver());
  }

  @When("Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsv() {
    page.inFrame(() -> {
      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvDialog.waitUntilVisible();
      page.findOrdersWithCsvDialog.downloadSample.click();
      page.findOrdersWithCsvDialog.cancel.click();
    });
  }

  @Then("sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvIsDownloadedSuccessfully() {
    page.verifyFileDownloadedSuccessfully("parcel-size-update.csv.csv",
        "NVSGNINJA000000001,SMALL\n"
            + "NVSGNINJA000000002,MEDIUM\n"
            + "NVSGNINJA000000003,LARGE\n"
            + "NVSGNINJA000000004,EXTRALARGE\n"
            + "NVSGNINJA000000005,XXLARGE\n"
            + "NVSGNINJA000000006,XSMALL");
  }

  @When("Operator upload Multiple Order Parcel Size update CSV on Order Parcel Size Update page:")
  public void multiOrderParcelSizeUpdateUploadCsvFile(List<Map<String, String>> map) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvDialog.waitUntilVisible();
      List<String> rows = resolveListOfMaps(map).stream()
          .map(e -> "\"" + e.get("trackingId") + "\",\"" + e.get("size") + "\"")
          .collect(Collectors.toList());
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-multi-order-update_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.writeLines(file, rows);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.findOrdersWithCsvDialog.uploadFile(file);
    });
  }

  @When("Operator clicks Upload button on Order Parcel Size Update page")
  public void clickUploadButton() {
    page.inFrame(() -> page.upload.click());
  }
}