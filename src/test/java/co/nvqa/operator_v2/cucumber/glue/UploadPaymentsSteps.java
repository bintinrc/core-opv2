package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.util.CsvUtils;
import co.nvqa.operator_v2.model.UploadPaymentsErrorCSV;
import co.nvqa.operator_v2.selenium.page.UploadPaymentsPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
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
    Assertions.assertThat(uploadPaymentsPage.getAntTopTextV2())
        .as("Uploaded file name is correct")
        .isEqualTo("Uploaded successfully - " + CSV_FILENAME_PATTERN);
    Assertions.assertThat(uploadPaymentsPage.getAntDescription())
        .as("Uploaded file name is correct").contains("The transactions are being processed.");
  }

  @Then("Operator - verifies csv file is not successfully uploaded on the Upload Payments page")
  public void operatorVerifiesCsvFileIsNotSuccessfullyUploadedOnTheUploadPaymentsPage() {
    String actualErrorMsg = uploadPaymentsPage.getUploadPaymentErrorToastTopText();
    String expectedToastText = CSV_FILENAME_PATTERN
        + " file upload failed.";
    String actualErrorDescription = uploadPaymentsPage.getUploadPaymentErrorToastDescription();
    String expectedErrorDescription = "Please refer to the auto-downloaded error csv file.";
    Assertions.assertThat(actualErrorMsg).as("Error message is correct")
        .isEqualTo(expectedToastText);
    Assertions.assertThat(actualErrorDescription).as("Error description is correct")
        .isEqualTo(expectedErrorDescription);
  }

  @Then("Operator - verify Error Upload Payment CSV file is downloaded successfully on Upload Payments Page with below data:")
  public void operatorVerifyErrorUPPCSVFileIsDownloadedSuccessfullyOnUploadSelfServePromoPageWithBelowData(
      Map<String, String> dataTableAsMap) {
    dataTableAsMap = resolveKeyValues(dataTableAsMap);
    String pathname =
        StandardTestConstants.TEMP_DIR + uploadPaymentsPage.getLatestDownloadedFilename(
            UPLOAD_PAYMENT_ERROR_CSV_FILENAME_PATTERN);
    File file = new File(pathname);
    UploadPaymentsErrorCSV entry = null;
    try {
      BufferedReader br = new BufferedReader(
          new InputStreamReader(new FileInputStream(file)));
      entry = CsvUtils.convertToObjectsWithFieldAsNull(
          br, UploadPaymentsErrorCSV.class).get(0);
    } catch (IOException ex) {
      LOGGER.debug("File '{}' failed to read. Cause: {}.", file.getAbsolutePath(),
          ex.getMessage());
    }
    SoftAssertions softAssertions = new SoftAssertions();
    if (dataTableAsMap.containsKey("message")) {
      softAssertions.assertThat(Objects.requireNonNull(entry).getMessage())
          .as("message column is correct").isEqualTo(dataTableAsMap.get("message"));
    }
    softAssertions.assertAll();
  }
}
