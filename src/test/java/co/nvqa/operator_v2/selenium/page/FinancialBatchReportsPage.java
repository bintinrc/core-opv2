package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class FinancialBatchReportsPage extends SimpleReactPage<FinancialBatchReportsPage> {

  private static final String FILTER_GENERATE_FILE_PATTERN = "//span[text()='%s']//preceding-sibling::span";

  @FindBy(xpath = "//input[@type='checkbox']")
  public PageElement orderLevelDetails;

  @FindBy(xpath = "//input[@placeholder='Start date']")
  public PageElement startDate;

  @FindBy(xpath = "//input[@placeholder='End date']")
  public PageElement endDate;

  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker betweenDates;

  @FindBy(xpath = "//span[text()='All Shippers']//preceding-sibling::span/input[@value='ALL']")
  public PageElement allShippersBtn;

  @FindBy(xpath = "//span[contains(text(),'Search and Select')]//preceding-sibling::div/div/div/input")
  public PageElement selectShipperTxtBox;

  @FindBy(xpath = "//button[@label='Generate Success Billings']")
  public AntButton generateReportBtn;

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div")
  public PageElement toastErrorTopText;

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']")
  public PageElement toastErrorBottomText;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;


  private static final String XPATH_ERROR = "//p[text()='%s']";
  private static final String XPATH_EMAIL_ADDRESS_TXT_BOX = "//span[text()='Enter Email Addresses']//preceding-sibling::div/div/div/input";


  public FinancialBatchReportsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectOption(String option) {
    pause2s();
    moveToElementWithXpath(f(FILTER_GENERATE_FILE_PATTERN, option));
    ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].click();",
        findElementByXpath(f(FILTER_GENERATE_FILE_PATTERN, option)));
  }

  public void setEmailAddress(String emailAddress) {
    sendKeysAndEnter(XPATH_EMAIL_ADDRESS_TXT_BOX, emailAddress);
  }

  public void verifyNoErrorsAvailable() {
    if (toastErrors.size() > 0) {
      fail(f("Error on attempt to generate email: %s", toastErrors.get(0).toastBottom.getText()));
    }
  }

  public boolean verifyErrorMsgIsVisible(String errorMsg) {
    return isElementVisible(f(XPATH_ERROR, errorMsg));
  }
}
