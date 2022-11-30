package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.NinjaPackTrackingIdGeneratorPage;
import io.cucumber.java.en.And;
import io.cucumber.guice.ScenarioScoped;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import org.assertj.core.api.Assertions;

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
    Assertions.assertThat(
        ninjaPackTrackingIdGeneratorPage.reviewNinjaPackIdGeneratorSelectionDialog.quantity
            .getText()).as("Quantity").isEqualTo(String.valueOf(expected));
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
    Assertions.assertThat(data.size()).as("Number of rows").isEqualTo(count + 1);
    Assertions.assertThat(data.get(0)).as("File headers").contains("Tracking ID", "Expiry Date.");
    for (int i = 1; i < data.size(); i++) {
      Assertions.assertThat(data.get(i).get(0)).as("Row " + i + " Tracking ID")
          .containsPattern("[A-Z0-9]{16}");
      Assertions.assertThat(data.get(i).get(1)).as("Row " + i + " Expiry Date")
          .containsPattern("\\d{4}-[01]\\d-[0-3]\\dT[0-2]\\d:[0-5]\\d:[0-5]\\d\\.\\d{3}\\+[0-2]\\d:\\d\\d");
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
