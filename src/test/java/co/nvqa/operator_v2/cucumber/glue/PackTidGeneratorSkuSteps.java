package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PackTidGeneratorSkuPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.cucumber.glue.NinjaPackTrackingIdGeneratorSteps.KEY_LIST_OF_NINJA_PACK_TRAKING_ID;

public class PackTidGeneratorSkuSteps extends AbstractSteps {

  private PackTidGeneratorSkuPage packTidGeneratorSkuPage;

  @Override
  public void init() {
    packTidGeneratorSkuPage = new PackTidGeneratorSkuPage(getWebDriver());
  }

  @When("Operator select {string} for product SKU in Pack TID Generator SKU page")
  public void operatorSelectForProductSKUInPackTIDGeneratorSkuPage(String productSkuName) {
    packTidGeneratorSkuPage.selectProductSku(productSkuName);
  }

  @When("Operator fill quantity with {int} in Pack TID Generator SKU page")
  public void operatorFillQuantityWithInPackTIDGeneratorSKUPage(int quantity) {
    packTidGeneratorSkuPage.fillQuantity(quantity);
  }

  @When("Operator click Generate tracking ids button in Pack TID Generator SKU page")
  public void operatorClickGenerateTrackingIdsButtonInPackTIDGeneratorSKUPage() {
    packTidGeneratorSkuPage.clickGenerateButton();
  }

  @Then("Operator verifies Ninja Pack tracking ID SKU file contains {int} records")
  public void verifyDownloadedFile(int count) throws IOException {
    List<String> data = packTidGeneratorSkuPage.readGeneratedCsvFile();
    int expectedLine = count + 1;
    Assertions.assertThat(data.size()).as(f("Number of lines is %d", expectedLine))
        .isEqualTo(expectedLine);
    Assertions.assertThat(data.get(0)).as("Header contains Tracking Id and Expiry Date")
        .contains("Tracking Id", "Expiry Date");
    data.remove(0);
    for (String line : data) {
      Assertions.assertThat(line).as("Generated Tracking Id exist")
          .containsPattern(Pattern.compile("[A-Z0-9]{16}"));
      Assertions.assertThat(line).as("Expiry Date is exist")
          .containsPattern(Pattern.compile(
              "\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}\\+[0-2]\\d:\\d\\d"
          ));
    }
  }

  @And("Operator saves generated Ninja Pack SKU Tracking IDs from file")
  public void saveTrackingIds() {
    List<String> data = packTidGeneratorSkuPage.readGeneratedCsvFile();
    data.remove(0);
    for (String line: data) {
      List<String> columns = Arrays.asList(line.split(",").clone());
      putInList(KEY_LIST_OF_NINJA_PACK_TRAKING_ID, columns.get(0).trim());
    }
  }
}
