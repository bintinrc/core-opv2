package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.NinjaPackTrackingIdGeneratorPage;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import org.hamcrest.Matchers;

@ScenarioScoped
public class NinjaPackTrackingIdGeneratorSteps extends AbstractSteps {

  private NinjaPackTrackingIdGeneratorPage ninjaPackTrackingIdGeneratorPage;

  public static final String KEY_LIST_OF_NINJA_PACK_TRAKING_ID = "KEY_LIST_OF_NINJA_PACK_TRAKING_ID";

  public NinjaPackTrackingIdGeneratorSteps() {
  }

  @Override
  public void init() {
    ninjaPackTrackingIdGeneratorPage = new NinjaPackTrackingIdGeneratorPage(getWebDriver());
  }

  @And("Operator enters {int} quantity on Ninja Pack Tracking ID Generator page")
  public void operatorEntersQuantity(int quantity) {
    ninjaPackTrackingIdGeneratorPage.quantity.setValue(quantity);
  }

  @And("Operator clicks Generate button on Ninja Pack Tracking ID Generator page")
  public void operatorClicksGenerate() {
    ninjaPackTrackingIdGeneratorPage.generate.clickAndWaitUntilDone();
  }

  @And("Operator verifies quantity is {int} in Review Ninja Pack ID generator selection dialog")
  public void operatorVerifiesQuantity(int expected) {
    ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.waitUntilVisible();
    assertEquals("Quantity", String.valueOf(expected),
        ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.quantity
            .getText());
  }

  @And("Operator clicks Confirm button in Review Ninja Pack ID generator selection dialog")
  public void operatorClicksConfirm() {
    ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.waitUntilVisible();
    ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.confirm.click();
    ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.waitUntilInvisible();
  }

  @And("Operator verifies Ninja Pack tracking ID file contains {int} records")
  public void verifyDownloadedFile(int count) throws IOException {
    String fileName = ninjaPackTrackingIdGeneratorPage
        .getLatestDownloadedFilename("ninja_pack_tracking_id_");
    List<List<String>> data = ninjaPackTrackingIdGeneratorPage.readXls(Paths.get(
        StandardTestConstants.TEMP_DIR, fileName).toString());
    assertEquals("Number of rows", count + 1, data.size());
    assertThat("File headers", data.get(0), Matchers.contains("Tracking ID", "Expiry Date."));
    for (int i = 1; i < data.size(); i++) {
      assertThat("Row " + i + " Tracking ID", data.get(i).get(0),
          Matchers.matchesPattern("[A-Z0-9]{16}"));
      assertThat("Row " + i + " Expiry Date", data.get(i).get(1), Matchers.matchesPattern(
          "\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}\\+[0-2]\\d:\\d\\d"));
    }
  }

  @And("Operator saves generated Ninja Pack Tracking IDs from file")
  public void saveTrackingIds() throws IOException {
    String fileName = ninjaPackTrackingIdGeneratorPage
        .getLatestDownloadedFilename("ninja_pack_tracking_id_");
    List<List<String>> data = ninjaPackTrackingIdGeneratorPage.readXls(Paths.get(
        StandardTestConstants.TEMP_DIR, fileName).toString());
    for (int i = 1; i < data.size(); i++) {
      putInList(KEY_LIST_OF_NINJA_PACK_TRAKING_ID, data.get(i).get(0));
    }
  }
}
