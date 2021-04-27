package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.CsvUtils;
import co.nvqa.commons.util.StandardTestConstants;
import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

public class LoyaltyCreationPage extends OperatorV2SimplePage {

  private static final String IFRAME_XPATH = "//iframe[contains(@src,'loyalty-creation')]";
  private static final String BUTTON_UPLOAD_XPATH = "//button[@for='csv_uploads']";
  private static final String UPLOAD_CSV_XPATH = "//input[@id='csv_uploads']";
  private static final String BUTTON_UPLOAD_CONFIRMATION_XPATH = "//button[descendant::*[text()='Yes, Create']]";
  private static final String RESULT_TEXT_XPATH = "//span[contains(@class, 'BulkCreate__MessageText')]/descendant::*[contains(text(),\"%s\")]";
  private static final String CSV_LOYALTY_NAME = "loyalty.csv";
  private static final String CSV_LOYALTY_HEADER = "shipper_id,email,shipper_name,onboarded_date,phone_number,parent_shipper_id";

  public LoyaltyCreationPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void uploadLoyaltyShipper(Shipper shipper, boolean isUseExistingCsv) {
    String filePath = f("%s/%s", StandardTestConstants.TEMP_DIR, CSV_LOYALTY_NAME);
    File csvFile;
    if (isUseExistingCsv) {
      csvFile = new File(filePath);
    }
     else {
       csvFile = createLoyaltyCsv(filePath, shipper);
    }
    uploadFile(csvFile.getAbsolutePath());
  }

  private File createLoyaltyCsv(String filePath, Shipper shipper) {
    List<String[]> content = new ArrayList<>();
    String[] header = CSV_LOYALTY_HEADER.split(",");
    content.add(header);
    if (shipper != null) {
      content.add(convertShipperForLoyalty(shipper, null));
    }

    CsvUtils.createFile(filePath, content);

    return new File(filePath);
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
        phoneNUmber = "8" + StringUtils.right(uniqueNumber, 7);
        break;
    }

    return phoneNUmber;
  }

  public boolean isResultMessageDisplayed(String msg) {
    String xpath = f(RESULT_TEXT_XPATH, msg);
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilVisibilityOfElementLocated(xpath);
    boolean isExist = isElementExist(xpath);
    getWebDriver().switchTo().parentFrame();
    return isExist;
  }

  public void clickUploadConfirmation() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilVisibilityOfElementLocated(BUTTON_UPLOAD_CONFIRMATION_XPATH);
    findElementByXpath(BUTTON_UPLOAD_CONFIRMATION_XPATH).click();
    getWebDriver().switchTo().parentFrame();
  }

  private String[] convertShipperForLoyalty(Shipper shipper, String parentShipperId) {
    return new String[]{String.valueOf(shipper.getLegacyId()),shipper.getEmail(),
        shipper.getName(), DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.format(Calendar.getInstance().getTime()),
        generatePhoneNumber(), (parentShipperId == null) ? "" : parentShipperId};
  }

  private void uploadFile(String filePath) {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilElementIsClickable(BUTTON_UPLOAD_XPATH);
    findElementByXpath(UPLOAD_CSV_XPATH).sendKeys(filePath);
    getWebDriver().switchTo().parentFrame();
  }
}
