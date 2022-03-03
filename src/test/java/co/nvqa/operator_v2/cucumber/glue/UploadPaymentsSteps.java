package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.UploadPaymentsPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.util.StandardTestUtils.createFile;

public class UploadPaymentsSteps extends AbstractSteps {

  public static final String FILE_PATH = String.format("%s/%s", StandardTestConstants.TEMP_DIR,
      "Payment");
  public static final String CSV_FILENAME_PATTERN = "upload_payment.csv";
  private static final Logger LOGGER = LoggerFactory.getLogger(UploadPaymentsSteps.class);
  private UploadPaymentsPage uploadPaymentsPage;

  public UploadPaymentsSteps() {
  }

  @Override
  public void init() {
    uploadPaymentsPage = new UploadPaymentsPage(getWebDriver());
  }


  @When("Operator upload CSV on Upload Payments page using data below:")
  public void operatorUploadCSVOnUploadPaymentsPageUsingDataBelow(DataTable dt) {
    String sb = dt.asLists().stream().map(row -> String.join(",", row))
        .collect(Collectors.joining("\n"));
    File csvFile = createFile(CSV_FILENAME_PATTERN, sb);
    uploadPaymentsPage.switchTo();
    uploadPaymentsPage.uploadFile(csvFile);
    LOGGER.info("Path of the created file " + csvFile.getAbsolutePath());
  }

  @Then("Operator verifies csv file is successfully uploaded on the Upload Payments page")
  public void operatorVerifiesCsvFileIsSuccessfullyUploadedOnTheUploadPaymentsPage() {
    Assertions.assertThat(uploadPaymentsPage.getUploadedFileName())
        .as("Uploaded file name is correct")
        .isEqualTo(CSV_FILENAME_PATTERN);
    Assertions.assertThat(uploadPaymentsPage.getUploadStatusMessage())
        .as("Uploaded file name is correct")
        .contains("uploaded successfully.");
  }
}
