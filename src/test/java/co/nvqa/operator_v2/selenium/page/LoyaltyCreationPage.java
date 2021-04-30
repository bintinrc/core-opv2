package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.CsvUtils;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.function.Consumer;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class LoyaltyCreationPage extends OperatorV2SimplePage {

  private static final String RESULT_TEXT_XPATH = "//span[contains(@class, 'BulkCreate__MessageText')]/descendant::*[contains(text(),\"%s\")]";
  private static final String CSV_LOYALTY_NAME = "loyalty.csv";
  private static final String CSV_LOYALTY_HEADER = "shipper_id,email,shipper_name,onboarded_date,phone_number,parent_shipper_id";
  public static final String FILE_PATH = String.format("%s/%s", StandardTestConstants.TEMP_DIR, CSV_LOYALTY_NAME);
  public static final String CSV_FILENAME_PATTERN = "template.csv";

  @FindBy(xpath = "//button[descendant::text()='Download Template']")
  public Button downloadTemplateButton;

  @FindBy(xpath = "//button[@for='csv_uploads']")
  public Button uploadButton;

  @FindBy(xpath = "//input[@id='csv_uploads']")
  public FileInput uploadInput;

  @FindBy(xpath = "//button[descendant::*[text()='Yes, Create']]")
  public Button uploadConfirmationButton;

  @FindBy(xpath = "//iframe[contains(@src,'loyalty-creation')]")
  public Button iframe;

  public LoyaltyCreationPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void inFrame(Consumer<LoyaltyCreationPage> consumer) {
    getWebDriver().switchTo().defaultContent();
    iframe.waitUntilVisible();
    getWebDriver().switchTo().frame(iframe.getWebElement());
    try {
      consumer.accept(this);
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  public void uploadLoyaltyShipper() {
    File csvFile = new File(FILE_PATH);
    uploadFile(csvFile.getAbsolutePath());
  }

  public File addDataToLoyaltyCsv(Shipper shipper, boolean isGenerateContact, String shipperParentId) {
    File file = new File(FILE_PATH);
    if (file.exists()) {
      return updateLoyaltyCsv(shipper, isGenerateContact, shipperParentId);
    } else {
      return createLoyaltyCsv(shipper, isGenerateContact, shipperParentId);
    }
  }

  public File createLoyaltyCsvHeaderOnly() {
    String[] header = CSV_LOYALTY_HEADER.split(",");
    CsvUtils.createFile(FILE_PATH, Collections.singletonList(header));

    return new File(FILE_PATH);
  }

  public File createLoyaltyCsv(Shipper shipper, boolean isGenerateContact, String shipperParentId) {
    List<String[]> content = new ArrayList<>();
    String[] header = CSV_LOYALTY_HEADER.split(",");
    content.add(header);
    content.add(convertShipperForLoyalty(shipper, shipperParentId, isGenerateContact));

    CsvUtils.createFile(FILE_PATH, content);

    return new File(FILE_PATH);
  }

  private File updateLoyaltyCsv(Shipper shipper, boolean isGenerateContact, String shipperParentId) {
    List<String[]> content = new ArrayList<>(CsvUtils.readAll(FILE_PATH));
    content.add(convertShipperForLoyalty(shipper, shipperParentId, isGenerateContact));
    CsvUtils.writeNext(content, FILE_PATH);

    return new File(FILE_PATH);
  }

  private String[] convertShipperForLoyalty(Shipper shipper, String parentShipperId,
      boolean isGenerateContact) {
    return new String[]{String.valueOf(shipper.getLegacyId()), shipper.getEmail(),
        shipper.getName(),
        DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.format(Calendar.getInstance().getTime()),
        isGenerateContact ? generatePhoneNumber() : shipper.getContact(),
        (parentShipperId == null) ? "" : parentShipperId};
  }

  public String generatePhoneNumber() {
    String uniqueNumber = String.valueOf(System.currentTimeMillis() / 1000);
    String phoneNUmber = null;
    switch (StandardTestConstants.COUNTRY_CODE.toUpperCase()) {
      case "ID":
        phoneNUmber = "812" + StringUtils.right(uniqueNumber, 6);
        break;
      case "SG":
      default:
        phoneNUmber = "98" + StringUtils.right(uniqueNumber, 6);
        break;
    }

    return phoneNUmber;
  }

  public boolean isResultMessageDisplayed(String msg) {
    try {
      inFrame(page -> {
        String xpath = f(RESULT_TEXT_XPATH, msg);
        assertTrue(isElementExist(xpath));
      });
      return true;
    } catch (AssertionError error) {
      return false;
    }
  }

  public void clickUploadConfirmation() {
    inFrame(page -> {
      waitUntilVisibilityOfElementLocated(page.uploadConfirmationButton.getWebElement());
      page.uploadConfirmationButton.click();
    });
  }

  private void uploadFile(String filePath) {
    inFrame(page -> {
      waitUntilVisibilityOfElementLocated(page.uploadButton.getWebElement());
      page.uploadInput.setValue(filePath);
    });
  }

  public void verifyCsvFileDownloadedSuccessfully(String expectedBody) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedBody);
  }
}
