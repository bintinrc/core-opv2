package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.shipper.Pricing;
import co.nvqa.operator_v2.selenium.page.UploadSelfServePromoPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.support.DateUtil.SDF_YYYY_MM_DD_HH_MM_SS;

public class UploadSelfServePromoPageSteps extends AbstractSteps {

  public static final String CSV_FILENAME_PATTERN = "automation_upload_pricing_profiles.csv";
  public static final String PRICING_PROFILE_ERRORS_CSV_FILENAME_PATTERN = "upload_pricing_profile_errors";
  public static final String PRICING_PROFILE_ERROR_UPLOAD_PRICING_PROFILE_CSV_FILENAME_PATTERN = "pricing_profile_errors";
  private static final Logger LOGGER = LoggerFactory.getLogger(UploadSelfServePromoPageSteps.class);
  private UploadSelfServePromoPage uploadSelfServePromoPage;


  public UploadSelfServePromoPageSteps() {
  }

  @Override
  public void init() {
    uploadSelfServePromoPage = new UploadSelfServePromoPage(getWebDriver());
  }


  @Given("Operator clicks Upload Pricing Profile with CSV button on the Upload Self Serve Promo Page")
  public void operatorClicksUploadPricingProfileWithCSVButtonOnTheUploadSelfServePromoPage() {
    uploadSelfServePromoPage.inFrame(() -> {
      uploadSelfServePromoPage.clickUploadCsvButton();
      uploadSelfServePromoPage.verifyUploadBulkPricingProfileDialogIsDisplayed();
    });
  }

  @And("Operator uploads csv file with below data:")
  public void operatorUploadsCsvFileWithBelowData(DataTable dt) {
    List<Pricing> pricingProfiles = resolveDataTableToList(dt, Pricing.class);
    if (Objects.nonNull(pricingProfiles)) {
      put(KEY_PRICING_PROFILE, pricingProfiles.get(0));
      put(KEY_LIST_OF_PRICING_PROFILES, pricingProfiles);
    }

    File csvFile = getCsvFile(dt);
    uploadSelfServePromoPage.inFrame(() ->
        uploadSelfServePromoPage.uploadBulkPricingProfileDialog.uploadFile(csvFile)
    );
  }

  @NotNull
  private File getCsvFile(DataTable dt) {
    List<List<String>> rows = resolveListOfLists(dt.asLists());
    String sb = rows.stream().map(row -> String.join(",", row))
        .collect(Collectors.joining("\n"));
    File csvFile = StandardTestUtils.createFile(CSV_FILENAME_PATTERN, sb);
    LOGGER.info("Path of the created file " + csvFile.getAbsolutePath());
    return csvFile;
  }


  @And("Operator successfully uploads csv file with below data:")
  public void operatorSuccessUploadsCsvFileWithBelowData(DataTable dt) {
    List<Pricing> pricingProfiles = resolveDataTableToList(dt, Pricing.class);
    put(KEY_PRICING_PROFILE, pricingProfiles.get(0));
    put(KEY_LIST_OF_PRICING_PROFILES, pricingProfiles);

    File csvFile = getCsvFile(dt);

    uploadSelfServePromoPage.inFrame(() -> {
      uploadSelfServePromoPage.uploadBulkPricingProfileDialog.uploadFile(csvFile);
      String validateNotificationText = uploadSelfServePromoPage.getNotificationMessageText();
      Assertions.assertThat(validateNotificationText).as("Success Notification is visible")
          .isEqualTo("Validate file successfully");
      uploadSelfServePromoPage.antNotificationMessage.waitUntilInvisible();

      uploadSelfServePromoPage.uploadBulkPricingProfileDialog.submitButton.click();
      String successNotificationText = uploadSelfServePromoPage.getNotificationMessageText();
      Assertions.assertThat(successNotificationText).as("Success Notification is visible")
          .isEqualTo("CSV file uploaded successfully");
    });
  }

  @And("Operator verifies the pricing profile and shipper discount details in CSV are correct")
  public void OperatorVerifiesThePricingProfileAndShipperDiscountDetailsAreCorrect2() {
    Pricing pricingProfile = get(KEY_PRICING_PROFILE);
    Pricing pricingProfileFromDb = StandardTestUtils.copyProperties(new Pricing(),
        get(KEY_PRICING_PROFILE_DETAILS));
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(pricingProfileFromDb.getComments()).as("Comments column is correct")
        .isEqualTo("via bulk upload [by qa@ninjavan.co]");
    softAssertions.assertThat(pricingProfile.getScriptId()).as("Script ID column is correct")
        .isEqualTo(pricingProfileFromDb.getScriptId());
    softAssertions.assertThat(pricingProfile.getDiscount()).as("Discount column is correct")
        .isEqualTo(pricingProfileFromDb.getDiscount());
    softAssertions.assertThat(pricingProfile.getType()).as("Type column is correct")
        .isEqualToIgnoringCase(pricingProfileFromDb.getType());

    Date effectiveDateCsv = pricingProfile.getEffectiveDate();
    String date = SDF_YYYY_MM_DD_HH_MM_SS.format(effectiveDateCsv);
    softAssertions.assertThat(effectiveDateCsv)
        .as("Effective Date column is correct")
        .isEqualTo(pricingProfileFromDb.getEffectiveDate());

    softAssertions.assertAll();
  }

  @Given("Operator clicks Download Sample CSV Template button on the Upload Self Serve Promo Page")
  public void operatorClicksDownloadSampleCSVTemplateButtonOnTheUploadSelfServePromoPage() {
    uploadSelfServePromoPage.inFrame(() ->
        uploadSelfServePromoPage.downloadSampleCsvButton());
  }


  @Then("Operator verify Sample CSV file on Upload Self Serve Promo Page is downloaded successfully with below data")
  public void operatorVerifySampleCSVFileOnUploadSelfServePromoPageIsDownloadedSuccessfullyWithBelowData(
      String expectedString) {
    uploadSelfServePromoPage.verifyCsvFileDownloadedSuccessfully(expectedString);
  }

  @Then("Operator verifies toast message {string} in Upload Self Serve Promo Page")
  public void operatorVerifiesToastMessageInUploadSelfServePromoPage(String expectedToastMsg) {
    uploadSelfServePromoPage.inFrame(() -> {
      String validateNotificationText = uploadSelfServePromoPage.getNotificationMessageText();
      Assertions.assertThat(validateNotificationText).as("Expected Toast Msg is visible")
          .isEqualTo(expectedToastMsg);
    });
  }

  @Then("Operator clicks submit button on the Upload Self Serve Promo Page")
  public void operatorClicksSubmitButtonOnTheUploadSelfServePromoPage() {
    uploadSelfServePromoPage.inFrame(() ->
        uploadSelfServePromoPage.uploadBulkPricingProfileDialog.submitButton.click()
    );
  }

  @Then("Operator verifies that error toast is displayed on Upload Self Serve Promo Page:")
  public void operatorVerifiesThatErrorToastDisplayedOnUploadSelfServePromoPage(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String errorTitle = mapOfData.get("top");
    String errorMessage = mapOfData.get("bottom");
    boolean isErrorFound = false;
    if (Objects.nonNull(errorTitle) && Objects.nonNull(errorMessage)) {
      isErrorFound = uploadSelfServePromoPage.toastErrors.stream().anyMatch(toastError ->
          StringUtils.equalsIgnoreCase(toastError.toastTop.getText(), errorTitle)
              && StringUtils
              .containsIgnoreCase(toastError.toastBottom.getText(), errorMessage));
    } else if (Objects.nonNull(errorTitle)) {
      isErrorFound = uploadSelfServePromoPage.toastErrors.stream().anyMatch(toastError ->
          StringUtils.equalsIgnoreCase(toastError.toastTop.getText(), errorTitle));
    }

    Assertions.assertThat(isErrorFound).as("Error message is exist").isTrue();
  }

  @Then("Operator clicks Download Errors CSV on Upload Self Serve Promo Page")
  public void operatorClicksDownloadErrorsCSVOnUploadSelfServePromoPage() {
    uploadSelfServePromoPage.inFrame(() ->
        uploadSelfServePromoPage.uploadBulkPricingProfileDialog.clickDownloadErrorsCsvButton()
    );
  }

  @Then("Operator clicks Download Error Upload Pricing Profile CSV on Upload Self Serve Promo Page")
  public void operatorClicksDownloadErrorUploadPricingProfileCSVOnUploadSelfServePromoPage() {
    uploadSelfServePromoPage.inFrame(() ->
        uploadSelfServePromoPage.clickDownloadErrorUploadPricingProfileCsvButton()
    );
  }

  @Then("Operator verify Download Errors CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:")
  public void operatorVerifyDownloadErrorsCSVFileOnUploadSelfServePromoPageIsDownloadedSuccessfullyWithBelowData(
      DataTable dt) {
    List<List<String>> rows = resolveListOfLists(dt.asLists());
    String sb = rows.stream().map(row -> String.join(",", row))
        .collect(Collectors.joining("\n"));

    uploadSelfServePromoPage.verifyDownloadErrorsCsvFileDownloadedSuccessfully(sb,
        PRICING_PROFILE_ERRORS_CSV_FILENAME_PATTERN);
  }

  @Then("Operator verify Download Error Upload Pricing Profile CSV file on Upload Self Serve Promo Page is downloaded successfully with below data:")
  public void operatorVerifyDownloadErrorUPPCSVFileOnUploadSelfServePromoPageIsDownloadedSuccessfullyWithBelowData(
      DataTable dt) {
    List<List<String>> rows = resolveListOfLists(dt.asLists());
    String sb = rows.stream().map(row -> String.join(",", row)).collect(Collectors.joining("\n"));

    uploadSelfServePromoPage.verifyDownloadErrorsCsvFileDownloadedSuccessfully(sb,
        PRICING_PROFILE_ERROR_UPLOAD_PRICING_PROFILE_CSV_FILENAME_PATTERN);
  }

  @Then("Operator verify Download Errors CSV file on Upload Self Serve Promo Page contains {string}")
  public void operatorVerifyDownloadErrorsCSVFileOnUploadSelfServePromoPageContains(
      String expectedErrorMsg) {
    uploadSelfServePromoPage.verifyDownloadErrorsCsvFileDownloadedSuccessfully(expectedErrorMsg,
        PRICING_PROFILE_ERRORS_CSV_FILENAME_PATTERN);
  }

  @And("Operator verifies operator is in login page")
  public void operatorVerifiesOperatorIsInLoginPage() {
    String currentUrl = getWebDriver().getCurrentUrl();
    Assertions.assertThat(currentUrl).as("Operator is directed to login page")
        .isEqualTo(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
  }
}