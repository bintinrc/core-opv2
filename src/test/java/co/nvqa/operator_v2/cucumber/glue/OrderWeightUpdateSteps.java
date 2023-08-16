package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.page.OrderWeightUpdatePage;
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
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OrderWeightUpdateSteps extends AbstractSteps {

  private OrderWeightUpdatePage page;

  public static final String KEY_ORDER_WEIGHT = "KEY_ORDER_WEIGHT";

  public OrderWeightUpdateSteps() {
  }

  @Override
  public void init() {
    page = new OrderWeightUpdatePage(getWebDriver());
  }

  @When("Operator upload Order Weight update CSV on Order Weight Update page:")
  public void OrderWeightUpdateUploadCsvFile(List<Map<String, String>> map) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvDialog.waitUntilVisible();
      List<String> rows = resolveListOfMaps(map).stream()
          .map(e -> "\"" + e.get("trackingId") + "\",\"" + e.get("weight") + "\"")
          .collect(Collectors.toList());
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-order-update_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.writeLines(file, rows);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.findOrdersWithCsvDialog.uploadFile(file);
    });
  }

  @When("Operator verify table records on Order Weight Update page:")
  public void verifyTableRecords(List<Map<String, String>> rows) {
    page.inFrame(() -> {
      var actual = page.weighUpdateTable.readAllEntities();
      rows.forEach(row -> {
        var expected = new OrderWeightUpdatePage.WeighUpdateRecord(resolveKeyValues(row));
        DataEntity.assertListContains(actual, expected, "Weight update record");
      });
    });
  }

  @Then("Operator click Upload button on Order Weight Update page")
  public void OrderWeightUpdate() {
    page.inFrame(() -> page.upload.click());
  }

  @When("Operator download sample CSV file for 'Find Orders with CSV' on Order Weight Update page")
  public void operatorDownloadSampleCsvFileForFindOrdersWithCsv() {
    page.inFrame(() -> {
      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvDialog.waitUntilVisible();
      page.findOrdersWithCsvDialog.downloadSample.click();
      page.findOrdersWithCsvDialog.cancel.click();
    });
  }

  @Then("Operator verify sample CSV file is downloaded successfully on Order Weight Update page")
  public void operatorVerifySampleCsvFileForFindOrdersWithCsvIsDownloadedSuccessfully() {
    page.verifyFileDownloadedSuccessfully("weight-update.csv.csv",
        "NVSGNINJA000000001,20.0\n"
            + "NVSGNINJA000000002,5.2\n"
            + "NVSGNINJA000000003,1.4");
  }
}