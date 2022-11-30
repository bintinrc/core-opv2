package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.CsvUtils;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.CorporateManualAwbTidGeneratorPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.nio.file.Paths;
import java.util.List;
import org.assertj.core.api.Assertions;

@ScenarioScoped
public class CorporateManualAwbTidGeneratorSteps extends AbstractSteps {

  private CorporateManualAwbTidGeneratorPage corporateManualAwbTidGeneratorPage;

  public static final String KEY_LIST_CORPORATE_MANUAL_AWB_TRACKING_ID = "KEY_LIST_CORPORATE_MANUAL_AWB_TRACKING_ID";

  public CorporateManualAwbTidGeneratorSteps() {
  }

  @Override
  public void init() {
    corporateManualAwbTidGeneratorPage = new CorporateManualAwbTidGeneratorPage(getWebDriver());
  }

  @When("Corporate Manual AWB TID Generator page is loaded")
  public void pageIsLoaded() {
    corporateManualAwbTidGeneratorPage.switchTo();
    corporateManualAwbTidGeneratorPage.waitUntilLoaded();
  }

  @And("Operator enters {int} quantity on Corporate Manual AWB TID Generator page")
  public void operatorEntersQuantity(int quantity) {
    corporateManualAwbTidGeneratorPage.quantity.setValue(quantity);
    corporateManualAwbTidGeneratorPage.quantityLabel.click();
  }

  @And("Operator verifies quantity is {int} on Corporate Manual AWB TID Generator page")
  public void operatorVerifiesQuantity(int quantity) {
    Assertions.assertThat(corporateManualAwbTidGeneratorPage.quantity.getValue()).as("Quantity")
        .isEqualTo(String.valueOf(quantity));
  }

  @And("Operator clicks Generate button on Corporate Manual AWB TID Generator page")
  public void operatorClicksGenerate() {
    corporateManualAwbTidGeneratorPage.generate.click();
  }

  @And("Operator verifies {string} error message on Corporate Manual AWB TID Generator page")
  public void operatorVerifyErrorMessage(String expected) {
    Assertions.assertThat(corporateManualAwbTidGeneratorPage.errorLabel.waitUntilVisible(5))
        .as("Error message is displayed").isTrue();
    Assertions.assertThat(corporateManualAwbTidGeneratorPage.errorLabel.getNormalizedText())
        .as("Error message text").isEqualTo(resolveValue(expected));
  }

  @And("Operator verifies Corporate Manual AWB Tracking ID file contains {int} records")
  public void verifyDownloadedFile(int count) {
    String fileName = corporateManualAwbTidGeneratorPage
        .getLatestDownloadedFilename("trackingids.csv");
    List<String[]> data = CsvUtils.readAll(Paths.get(
        StandardTestConstants.TEMP_DIR, fileName).toString());
    Assertions.assertThat(data.size()).as("Number of rows").isEqualTo(count + 1);
    Assertions.assertThat(data.get(0)).as("File headers").contains("Tracking Id", "Expiry Date");
    for (int i = 1; i < data.size(); i++) {
      Assertions.assertThat(data.get(i)[0]).as("Row " + i + " Tracking ID")
          .containsPattern("[A-Z0-9]{16}");
      Assertions.assertThat(data.get(i)[1]).as("Row " + i + " Expiry Date")
          .containsPattern(
              "\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}\\+[0-2]\\d:\\d\\d");
    }
  }

  @And("Operator saves generated Corporate Manual AWB Tracking IDs from file")
  public void saveTrackingIds() {
    String fileName = corporateManualAwbTidGeneratorPage
        .getLatestDownloadedFilename("trackingids.csv");
    List<String[]> data = CsvUtils.readAll(Paths.get(
        StandardTestConstants.TEMP_DIR, fileName).toString());
    for (int i = 1; i < data.size(); i++) {
      putInList(KEY_LIST_CORPORATE_MANUAL_AWB_TRACKING_ID, data.get(i)[0]);
    }
  }
}
