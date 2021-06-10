package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.sort.sort_code.SortCode;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class SortCodePage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'sort-code')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[contains(@class,'table-card-holder')]")
  private PageElement tableHolder;

  @FindBy(xpath = "//th[contains(@class,'postcode')]//input")
  public TextBox postcodeInput;

  @FindBy(xpath = "//th[contains(@class,'sort_code')]//input")
  public TextBox sortCodeInput;

  @FindBy(xpath = "//div/button[contains(@class,'block')]")
  public Button downloadCsvButton;

  private static final String TABLE_XPATH = "//div[contains(@class,'table-card-holder')]";
  private static final String UPLOAD_CSV_BUTTON_XPATH = "//button[contains(@class,'btn-primary')]";
  private static final String DOWNLOAD_CSV_BUTTON_XPATH = "//div/button[contains(@class,'block')]";
  private static final String POSTCODE_RESULT_XPATH = "//td[@class='postcode']//span";
  private static final String SORT_CODE_RESULT_XPATH = "//td[@class='sort_code']//span";
  private static final String POSTCODE_RESULT_MARK_XPATH = "//td[@class='postcode']//mark";
  private static final String SORT_CODE_RESULT_MARK_XPATH = "//td[@class='sort_code']//mark";

  private static final String CSV_FILENAME_PATTERN = "sort-codes.csv";

  public SortCodePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void checkPageIsFullyLoaded() {
    waitUntilVisibilityOfElementLocated(tableHolder.getWebElement());
  }

  public void checkPageComponents() {
    assertTrue("Sort Code Table", isElementExist(TABLE_XPATH));
    assertTrue("Upload CSV Button", isElementExist(UPLOAD_CSV_BUTTON_XPATH));
    assertTrue("Download CSV Button", isElementExist(DOWNLOAD_CSV_BUTTON_XPATH));
  }

  public void verifiesSortCodeDetailsAreRight(SortCode sortCode) {
    String actualPostcode = "";
    String actualSortCode = "";

    if (isElementExistFast(POSTCODE_RESULT_XPATH)) {
      actualPostcode = getText(POSTCODE_RESULT_XPATH);
    } else {
      actualPostcode = getText(POSTCODE_RESULT_MARK_XPATH);
    }

    if (isElementExistFast(SORT_CODE_RESULT_XPATH)) {
      actualSortCode = getText(SORT_CODE_RESULT_XPATH);
    } else {
      actualSortCode = getText(SORT_CODE_RESULT_MARK_XPATH);
    }

    assertEquals("Postcode : ", sortCode.getPostcode(), actualPostcode);
    assertEquals("Sort Code : ", sortCode.getSortCode(), actualSortCode);
  }

  public void verifiesDownloadedCsvDetailsAreRight(SortCode sortCode) {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        sortCode.getPostcode() + "," + sortCode.getSortCode());
  }
}
