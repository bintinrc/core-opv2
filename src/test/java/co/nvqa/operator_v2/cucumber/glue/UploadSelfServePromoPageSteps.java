package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.page.UploadSelfServePromoPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.support.DateUtil.SDF_YYYY_MM_DD_HH_MM_SS;
import static co.nvqa.commons.util.StandardTestUtils.createFile;

public class UploadSelfServePromoPageSteps extends AbstractSteps {

  public static final String CSV_FILENAME_PATTERN = "upload_pricing_profiles.csv";
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
    put(KEY_PRICING_PROFILE, pricingProfiles.get(0));

    List<List<String>> rows = resolveListOfLists(dt.asLists());

    String sb = rows.stream().map(row -> String.join(",", row))
        .collect(Collectors.joining("\n"));
    File csvFile = createFile(CSV_FILENAME_PATTERN, sb);
    LOGGER.info("Path of the created file " + csvFile.getAbsolutePath());

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
    Pricing pricingProfileFromDb = get(KEY_PRICING_PROFILE_DETAILS);
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
    softAssertions.assertThat(DateUtil.getUTCDateTime(date).split(" ")[0])
        .as("Effective Date column is correct")
        .isEqualTo(pricingProfileFromDb.getEffectiveDate().toString().split(" ")[0]);

    softAssertions.assertAll();
  }

}
