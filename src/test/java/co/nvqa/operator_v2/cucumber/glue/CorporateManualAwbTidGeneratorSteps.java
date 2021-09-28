package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.CsvUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.CorporateManualAwbTidGeneratorPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import org.hamcrest.Matchers;

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
    assertEquals("Quantity", String.valueOf(quantity),
        corporateManualAwbTidGeneratorPage.quantity.getValue());
  }

  @And("Operator clicks Generate button on Corporate Manual AWB TID Generator page")
  public void operatorClicksGenerate() {
    corporateManualAwbTidGeneratorPage.generate.click();
  }

  @And("Operator verifies {string} error message on Corporate Manual AWB TID Generator page")
  public void operatorVerifyErrorMessage(String expected) {
    assertTrue("Error message is displayed",
        corporateManualAwbTidGeneratorPage.errorLabel.waitUntilVisible(5));
    assertEquals("Error message text", resolveValue(expected),
        corporateManualAwbTidGeneratorPage.errorLabel.getNormalizedText());
  }

  @And("Operator verifies Corporate Manual AWB Tracking ID file contains {int} records")
  public void verifyDownloadedFile(int count) throws IOException {
    String fileName = corporateManualAwbTidGeneratorPage
        .getLatestDownloadedFilename("trackingids.csv");
    List<String[]> data = CsvUtils.readAll(Paths.get(
        StandardTestConstants.TEMP_DIR, fileName).toString());
    assertEquals("Number of rows", count + 1, data.size());
    assertThat("File headers", data.get(0), Matchers.arrayContaining("Tracking Id", "Expiry Date"));
    for (int i = 1; i < data.size(); i++) {
      assertThat("Row " + i + " Tracking ID", data.get(i)[0],
          Matchers.matchesPattern("[A-Z0-9]{16}"));
      assertThat("Row " + i + " Expiry Date", data.get(i)[1], Matchers.matchesPattern(
          "\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}\\+[0-2]\\d:\\d\\d"));
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
