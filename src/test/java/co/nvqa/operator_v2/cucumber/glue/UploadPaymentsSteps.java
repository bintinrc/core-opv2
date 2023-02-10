package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.UploadPaymentsPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UploadPaymentsSteps extends AbstractSteps {

  public static final String FILE_PATH = String.format("%s/%s", StandardTestConstants.TEMP_DIR,
      "Payment");
  public static final String CSV_FILENAME_PATTERN = "upload_payment.csv";
  public static final String UPLOAD_PAYMENT_ERROR_CSV_FILENAME_PATTERN = "upload_payments_error";
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
    List<List<String>> rows = resolveListOfLists(dt.asLists());
    String sb = rows.stream().map(row -> String.join(",", row))
        .collect(Collectors.joining("\n"));
    File csvFile = StandardTestUtils.createFile(CSV_FILENAME_PATTERN, sb);
    uploadPaymentsPage.switchTo();
    uploadPaymentsPage.uploadFile(csvFile);
    LOGGER.info("Path of the created file " + csvFile.getAbsolutePath());
  }

  @Then("Operator verifies csv file is successfully uploaded on the Upload Payments page")
  public void operatorVerifiesCsvFileIsSuccessfullyUploadedOnTheUploadPaymentsPage() {
    Assertions.assertThat(uploadPaymentsPage.getUploadedFileName())
        .as("Uploaded file name is correct").isEqualTo(CSV_FILENAME_PATTERN);
    Assertions.assertThat(uploadPaymentsPage.getUploadStatusMessage())
        .as("Uploaded file name is correct").contains("uploaded successfully.");
  }

  @Then("Operator verifies csv file is not successfully uploaded on the Upload Payments page")
  public void operatorVerifiesCsvFileIsNotSuccessfullyUploadedOnTheUploadPaymentsPage() {
    String actualErrorMsg = uploadPaymentsPage.getToastTopText();
    String expectedToastText = CSV_FILENAME_PATTERN
        + " file upload failed. Please refer to the auto-downloaded error csv file.";
    Assertions.assertThat(actualErrorMsg).as("Check error message").isEqualTo(expectedToastText);
  }

  @Then("Operator verify Download Error Upload Payment CSV file on Upload Payments Page is downloaded successfully with below data:")
  public void operatorVerifyDownloadErrorUPPCSVFileOnUploadSelfServePromoPageIsDownloadedSuccessfullyWithBelowData(
      DataTable dt) {
    List<List<String>> rows = resolveListOfLists(dt.asLists());
    String sb = rows.stream().map(row -> String.join(",", row)).collect(Collectors.joining("\n"));

    uploadPaymentsPage.verifyDownloadErrorsCsvFileDownloadedSuccessfully(sb,
        UPLOAD_PAYMENT_ERROR_CSV_FILENAME_PATTERN);
  }
}
