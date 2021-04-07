package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class InvoicedOrdersSearchPage extends OperatorV2SimplePage {

  public static final String CSV_FILENAME_PATTERN = "sample_csv";

  @FindBy(xpath = "//label[@class='ant-radio-button-wrapper ant-radio-button-wrapper-checked']//span[text()='Upload CSV']")
  public WebElement uploadCsvButton;


  @FindBy(xpath = "//span[text()='Enter Tracking ID(s)']")
  public WebElement trackingIDsButton;

  public InvoicedOrdersSearchPage(WebDriver webDriver) {
    super(webDriver);
  }


}
