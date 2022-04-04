package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class FinanceCodPage extends SimpleReactPage<FinanceCodPage> {

  private static final String FILTER_GENERATE_FILE_PATTERN = "//span[text()='%s']";
  private static final String XAPTH_ERROR = "//p[text()='%s']";
  @FindBy(xpath = "//input[@placeholder='Start date']")
  public PageElement startDate;
  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker betweenDates;
  @FindBy(xpath = "//input[@type='search']")
  public PageElement emailAddressTxtBox;
  @FindBy(xpath = "//button[@label='Generate Success Billings']")
  public AntButton generateCodReportBtn;

  public FinanceCodPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectOption(String option) {
    simpleClick(f(FILTER_GENERATE_FILE_PATTERN, option));
  }

  public void setEmailAddress(String emailAddress) {
    emailAddressTxtBox.sendKeys(emailAddress);
  }

  public void verifyNoErrorsAvailable() {
    if (toastErrors.size() > 0) {
      fail(f("Error on attempt to generate email: %s", toastErrors.get(0).toastBottom.getText()));
    }
  }

  public boolean verifyErrorMsgIsVisible(String errorMsg) {
    return isElementVisible(f(XAPTH_ERROR, errorMsg));
  }
}
