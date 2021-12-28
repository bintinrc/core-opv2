package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class FinancialBatchPage extends SimpleReactPage<FinancialBatchPage> {

  private static final String SELECT_FILTER_VALUE_XPATH =
      "//div[contains(@class, 'ant-select-dropdown')]//div[@class='rc-virtual-list-holder-inner']//*[contains(text(), '%s -')]";
  private static final String ACCOUNT_BATCH_DETAILS_VALUE_XPATH = "//span[text()='%s']/parent::div/following::div[1]/span";
  private static final String DEBIT_VALUES_XPATH = "//tr[@data-row-key='%s']//td[2]";
  private static final String CREDIT_VALUES_XPATH = "//tr[@data-row-key='%s']//td[3]";
  @FindBy(xpath = "//span[text()='Shipper']//ancestor::div[@class='ant-row']//input[@role='combobox']")
  public AntSelect2 searchShipper;
  @FindBy(xpath = "//div[@class= 'ant-picker'][.//input]")
  public AntCalendarPicker searchDate;
  @FindBy(xpath = "//button[.='Search']")
  public Button searchBtn;
  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;
  @FindBy(xpath = "//span[text()='Shipper']//ancestor::div[@class='ant-row']//p")
  public PageElement errorMessageText;
  @FindBy(css = "div.toast-error")
  public List<ToastError> toastErrors;
  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div")
  public PageElement toastErrorTopText;
  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']")
  public PageElement toastErrorBottomText;
  @FindBy(xpath = "//iframe[contains(@src,'financial-batch')]")
  private PageElement pageFrame;

  public FinancialBatchPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void selectShipper(String shipper) {
    retryIfRuntimeExceptionOccurred(() -> {
      searchShipper.clear();
      searchShipper.sendKeys(shipper);
      waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, shipper), 5);
    }, "Search Shipper", 2000, 5);
    waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, shipper));
    click(f(SELECT_FILTER_VALUE_XPATH, shipper));
  }

  public void selectDate(String date) {
    searchDate.sendDate(date);
  }

  public void clickSearchBtn() {
    searchBtn.click();
  }

  public String getOverallBalance() {
    return getText(f(ACCOUNT_BATCH_DETAILS_VALUE_XPATH, "Overall Balance:"));
  }

  public String getDate() {
    return getText(f(ACCOUNT_BATCH_DETAILS_VALUE_XPATH, "Date:"));
  }

  public String getShipperName() {
    return getText(f(ACCOUNT_BATCH_DETAILS_VALUE_XPATH, "Shipper Name:"));
  }

  public String getDebitCod() {
    return getText(f(DEBIT_VALUES_XPATH, "cod"));
  }

  public String getCreditCod() {
    return getText(f(CREDIT_VALUES_XPATH, "cod"));
  }

  public String getDebitFee() {
    return getText(f(DEBIT_VALUES_XPATH, "fee"));
  }

  public String getCreditFee() {
    return getText(f(CREDIT_VALUES_XPATH, "fee"));
  }

  public String getDebitAdjustment() {
    return getText(f(DEBIT_VALUES_XPATH, "adjustment"));
  }

  public String getCreditAdjustment() {
    return getText(f(CREDIT_VALUES_XPATH, "adjustment"));
  }

  public String getDebitNettBalance() {
    return getText(f(DEBIT_VALUES_XPATH, "nett"));
  }

  public String getCreditNettBalance() {
    return getText(f(CREDIT_VALUES_XPATH, "nett"));
  }
}
