package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.InvoiceDisputeDetails;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class InvoiceDisputesPage extends SimpleReactPage<InvoiceDisputesPage> {

  @FindBy(xpath = "//div[@name ='shipperId'][.//input[@id='rc_select_1']]")
  public AntSelect searchByShipper;

  @FindBy(xpath = "//div[@name ='caseStatus'][.//input[@id='rc_select_0']]")
  public AntSelect caseStatus;

  @FindBy(css = "div.ant-picker-range")
  public AntDateRangePicker betweenDates;

  @FindBy(xpath = "//input[@name = 'invoiceId']")
  public PageElement invoiceId;

  @FindBy(xpath = "//span[text()='Load selection']//parent::button")
  public PageElement loadSelectionButton;

  @FindBy(xpath = "//span[text()='Showing']//span")
  public PageElement resultCount;
  @FindBy(xpath = "//iframe[contains(@src,'invoice-disputes')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//tr[@class='ant-table-row ant-table-row-level-0']//descendant::button")
  private Button actionButton;

  private static final String XPATH_CASE_ROW = "//td[text()='%s']//parent::tr/td";


  public InvoiceDisputesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void searchForTheShipper(String shipperName) {
    searchByShipper.selectValue(shipperName);
  }

  public void selectCaseStatus(String status) {
    caseStatus.selectValue(status);
  }

  public void enterInvoiceId(String id) {
    invoiceId.sendKeys(id);
  }

  public void clickLoadSelection() {
    loadSelectionButton.click();
  }

  public InvoiceDisputeDetails getInvoiceDisputeDetails(String caseId) {
    InvoiceDisputeDetails invoiceDisputeDetails = new InvoiceDisputeDetails();
    List<WebElement> elements = webDriver.findElements(By.xpath(f(XPATH_CASE_ROW, caseId)));
    invoiceDisputeDetails.setCaseNumber(elements.get(0).getText());
    invoiceDisputeDetails.setNumberOfTIDs(elements.get(1).getText());
    invoiceDisputeDetails.setDisputeFiledDate(elements.get(2).getText());
    invoiceDisputeDetails.setShipperId(elements.get(3).getText());
    invoiceDisputeDetails.setInvoiceId(elements.get(4).getText());
    invoiceDisputeDetails.setCaseStatus(elements.get(5).getText());
    return invoiceDisputeDetails;
  }

  public String getInvoiceDisputesCount() {
    return resultCount.getText().split("of")[1].split("results")[0].trim();
  }

  public void clickActionButton() {
    actionButton.click();
  }

}